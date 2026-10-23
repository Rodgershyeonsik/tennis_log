import '../../data/db/enums.dart';
import 'auto_tag_result.dart';
import 'tag_dictionary.dart';

/// 메모 텍스트에 붙을 태그와 추천 평가를 계산하는 **순수 엔진**.
///
/// DB도 UI도 모른다. 입력은 [TagDictionary] 하나뿐이라 테스트에서 사전을 직접
/// 만들어 돌릴 수 있다. 명세는 `docs/specs/01_journal_entry.md` 6번.
///
/// 사전은 생성자에서 한 번 전처리해 두므로, 세션 하나를 저장할 때 인스턴스를
/// 하나 만들어 메모 여러 줄에 재사용하는 게 좋다.
class AutoTagger {
  AutoTagger(TagDictionary dictionary)
    : _groups = _buildGroups(dictionary),
      _exclusionsByTag = {
        for (final entry in dictionary.entries)
          if (entry.exclusions.isNotEmpty)
            entry.tagId: [
              for (final word in entry.exclusions)
                if (_normalizeAlias(word).trim().isNotEmpty)
                  _normalizeAlias(word),
            ],
      },
      _parentByTag = {
        for (final entry in dictionary.entries)
          if (entry.parentTagId != null) entry.tagId: entry.parentTagId!,
      };

  /// 인식 표현 묶음. **긴 표현부터** 검사하려고 길이 내림차순으로 정렬돼 있다.
  final List<_AliasGroup> _groups;

  /// tagId → 그 태그의 제외 단어(정규화된 것).
  final Map<int, List<String>> _exclusionsByTag;

  /// tagId → 부모 tagId. 자식이 매칭되면 부모를 떼는 데 쓴다.
  final Map<int, int> _parentByTag;

  MemoAnalysis analyze(String content) {
    final haystack = _Haystack(content);
    if (haystack.normalized.isEmpty) return const MemoAnalysis(tags: []);

    final statusByTag = <int, MemoTagStatus>{};

    // 이미 태그가 붙은 구간. 더 짧은 표현이 이 안에 **완전히 포함**되면 버린다.
    // 부분적으로만 겹치는 건 버리지 않는다. 예: "손 힘이 들어감"의 '손 힘'(#그립)과
    // '힘이 들어'(#힘조절)는 일부만 겹치므로 둘 다 붙는다.
    final occupied = <_Span>[];

    for (final group in _groups) {
      for (final span in haystack.find(group.needle)) {
        if (occupied.any((taken) => taken.contains(span))) continue;

        // 같은 문자열이 여러 태그에 등록돼 있으면 그 구간을 함께 쓴다(명세 3-1).
        // 예: '스핀서브'는 #서브와 #킥 양쪽에 있어 둘 다 붙는다.
        var accepted = false;
        for (final tag in group.tags) {
          if (_isExcluded(haystack, tag.tagId, span)) continue;
          accepted = true;
          statusByTag[tag.tagId] = _strongest(
            statusByTag[tag.tagId],
            tag.status,
          );
        }

        // 그룹의 모든 태그가 제외돼 무시된 매칭은 구간을 점유하지 않는다.
        // 점유해 버리면 그 안의 다른 태그 표현까지 막혀서, 제외 단어가 엉뚱한
        // 태그를 지운다.
        // 예: "슬라이스 서브 리시브 ..."에서 #서브는 빠지지만 #리턴은 붙어야 한다.
        if (accepted) occupied.add(span);
      }
    }

    _dropMatchedParents(statusByTag);

    final tags = [
      for (final entry in statusByTag.entries)
        SuggestedTag(tagId: entry.key, status: entry.value),
    ]..sort((a, b) => a.tagId.compareTo(b.tagId));

    return MemoAnalysis(
      tags: tags,
      evaluation: _suggestEvaluation(haystack.normalized),
    );
  }

  /// 매칭 구간이 그 태그의 제외 단어 출현 범위와 **겹치면** 제외한다.
  ///
  /// 일부만 겹쳐도 제외한다. "스핀서브 리턴 어렵다"의 '스핀서브'(0–3)는 제외 단어
  /// '서브 리턴'(2–6)과 일부만 겹치는데, 그래도 #서브는 붙이지 않는다(리턴 메모라
  /// 내 서브 기술 얘기가 아니다).
  ///
  /// **제외는 태그별이다.** 같은 '스핀서브' 구간을 공유하는 #킥은 제외 단어가
  /// 없으므로 그대로 붙는다 — 상대 서브의 구질은 리턴 약점을 집계할 때 쓴다.
  bool _isExcluded(_Haystack haystack, int tagId, _Span span) {
    final words = _exclusionsByTag[tagId];
    if (words == null) return false;

    for (final word in words) {
      for (final excluded in haystack.find(word)) {
        if (excluded.overlaps(span)) return true;
      }
    }
    return false;
  }

  /// 자식 태그가 매칭되면 자식만 남긴다(부모는 조회할 때 포함된다).
  ///
  /// 현재 사전에서는 부모 표현이 자식 표현에 포함돼 있어("발리" ⊂ "백발리")
  /// 구간 차단 규칙이 먼저 걸러내므로 실제로 발동하지 않는다. 사전이 바뀌면
  /// 필요해지므로 규칙은 그대로 둔다.
  void _dropMatchedParents(Map<int, MemoTagStatus> statusByTag) {
    final matched = statusByTag.keys.toList();
    for (final tagId in matched) {
      final parentId = _parentByTag[tagId];
      if (parentId != null) statusByTag.remove(parentId);
    }
  }

  MemoEvaluation? _suggestEvaluation(String normalized) {
    bool hasAny(List<String> keywords) => keywords.any(normalized.contains);

    // question이 섞여 있으면 질문으로 본다.
    if (hasAny(_questionKeywords)) return MemoEvaluation.question;

    final good = hasAny(_goodKeywords);
    final bad = hasAny(_badKeywords);

    // 좋고 나쁨이 한 줄에 같이 있으면 판단을 보류한다.
    // 예: "서브는 잘됨 근데 리턴은 안됨"
    if (good && bad) return null;
    if (good) return MemoEvaluation.good;
    if (bad) return MemoEvaluation.bad;
    return null;
  }

  static List<_AliasGroup> _buildGroups(TagDictionary dictionary) {
    // 완전히 같은 문자열의 표현은 태그가 달라도 한 묶음으로 모은다(명세 3-1).
    final tagsByNeedle = <String, List<_AliasTag>>{};

    for (final entry in dictionary.entries) {
      for (final alias in entry.aliases) {
        final needle = _normalizeAlias(alias.alias);
        if (needle.trim().isEmpty) continue;

        final status = alias.confidence == AliasConfidence.sure
            ? MemoTagStatus.confirmed
            : MemoTagStatus.suggested;

        final tags = tagsByNeedle.putIfAbsent(needle, () => []);
        final existing = tags.indexWhere((t) => t.tagId == entry.tagId);
        if (existing >= 0) {
          tags[existing] = _AliasTag(
            entry.tagId,
            _strongest(tags[existing].status, status),
          );
        } else {
          tags.add(_AliasTag(entry.tagId, status));
        }
      }
    }

    return [
      for (final entry in tagsByNeedle.entries)
        _AliasGroup(entry.key, entry.value),
    ]..sort((a, b) {
      // 긴 표현 우선. 길이가 같으면 결과가 흔들리지 않게 사전순으로 고정한다.
      final byLength = b.needle.length.compareTo(a.needle.length);
      return byLength != 0 ? byLength : a.needle.compareTo(b.needle);
    });
  }

  /// 같은 태그가 sure와 ambiguous 표현에 모두 걸리면 confirmed가 이긴다.
  /// 예: "어깨 통증"(sure)과 "어깨"(ambiguous)가 각각 다른 위치에서 매칭된 경우.
  static MemoTagStatus _strongest(MemoTagStatus? a, MemoTagStatus b) {
    if (a == MemoTagStatus.confirmed || b == MemoTagStatus.confirmed) {
      return MemoTagStatus.confirmed;
    }
    return b;
  }
}

/// 평가 추천 키워드. 태그 사전과 달리 DB에 두지 않고 상수로 박아 둔다(명세 6번).
const _goodKeywords = ['짱', '굿', '개굿', '잘 됨', '잘됨'];
const _badKeywords = ['안됨', '안 됨', 'ㅠ', 'ㅠㅠ'];
const _questionKeywords = ['?'];

/// 소문자로 바꾸고 연속 공백을 하나로 줄인다. **앞뒤 공백은 남긴다.**
///
/// #수면의 표현 `'잠 '`처럼 뒤 공백이 의도적인 표현이 있다("잠깐", "잠수"에
/// 걸리지 않게 하려는 것). trim하면 `'잠'`이 되어 오탐이 터진다.
String _normalizeAlias(String value) =>
    value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

/// 검사 대상 텍스트. 원본과 공백 제거 버전을 같은 좌표계에서 다룬다.
class _Haystack {
  _Haystack(String raw) : normalized = _normalizeAlias(raw).trim() {
    final buffer = StringBuffer();
    for (var i = 0; i < normalized.length; i++) {
      if (normalized[i] == ' ') continue;
      buffer.write(normalized[i]);
      _strippedToNormalized.add(i);
    }
    _stripped = buffer.toString();
  }

  final String normalized;

  /// 공백을 모두 뺀 버전. "포 스트로크"를 "포스트로크"로도 찾기 위한 것.
  late final String _stripped;

  /// 공백 제거 버전의 i번째 글자가 [normalized]의 몇 번째인지.
  /// 공백 제거 버전에서 찾은 구간을 원본 좌표로 되돌리는 데 쓴다.
  final List<int> _strippedToNormalized = [];

  final Map<String, List<_Span>> _cache = {};

  /// [needle]이 나타나는 구간 전부. 좌표는 항상 [normalized] 기준이다.
  List<_Span> find(String needle) {
    return _cache.putIfAbsent(needle, () {
      final spans = <_Span>[];
      void add(_Span span) {
        if (!spans.contains(span)) spans.add(span);
      }

      for (
        var i = normalized.indexOf(needle);
        i >= 0;
        i = normalized.indexOf(needle, i + 1)
      ) {
        add(_Span(i, i + needle.length - 1));
      }

      // **앞뒤에 공백이 있는 표현은 공백 제거 버전에서 찾지 않는다.**
      // 그 공백이 표현의 일부(단어 경계 역할)이기 때문이다.
      final hasOuterSpace = needle.trim().length != needle.length;
      if (!hasOuterSpace && needle.trim().isNotEmpty) {
        final strippedNeedle = needle.replaceAll(' ', '');
        for (
          var i = _stripped.indexOf(strippedNeedle);
          i >= 0;
          i = _stripped.indexOf(strippedNeedle, i + 1)
        ) {
          add(
            _Span(
              _strippedToNormalized[i],
              _strippedToNormalized[i + strippedNeedle.length - 1],
            ),
          );
        }
      }

      spans.sort((a, b) => a.start.compareTo(b.start));
      return spans;
    });
  }
}

/// 텍스트의 한 구간. 양끝 포함.
class _Span {
  const _Span(this.start, this.end);

  final int start;
  final int end;

  /// [other]를 완전히 포함하는지. 구간 차단(명세 3번)에 쓴다.
  bool contains(_Span other) => start <= other.start && other.end <= end;

  /// [other]와 한 글자라도 겹치는지. 제외 단어 판정(명세 4번)에 쓴다.
  bool overlaps(_Span other) => start <= other.end && other.start <= end;

  @override
  bool operator ==(Object other) =>
      other is _Span && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}

/// 같은 문자열의 인식 표현 하나와, 그 표현을 등록한 태그들.
class _AliasGroup {
  const _AliasGroup(this.needle, this.tags);

  final String needle;
  final List<_AliasTag> tags;
}

class _AliasTag {
  const _AliasTag(this.tagId, this.status);

  final int tagId;
  final MemoTagStatus status;
}
