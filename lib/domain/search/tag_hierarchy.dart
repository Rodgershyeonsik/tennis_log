import 'search_models.dart';

/// 태그의 부모·자식 관계.
class TagHierarchy {
  TagHierarchy(List<SearchTag> tags)
    : _tagsById = {for (final tag in tags) tag.id: tag},
      _childrenByParent = _groupByParent(tags);

  final Map<int, SearchTag> _tagsById;
  final Map<int, List<SearchTag>> _childrenByParent;

  static Map<int, List<SearchTag>> _groupByParent(List<SearchTag> tags) {
    final children = <int, List<SearchTag>>{};
    for (final tag in tags) {
      final parentId = tag.parentTagId;
      if (parentId != null) {
        children.putIfAbsent(parentId, () => []).add(tag);
      }
    }
    return children;
  }

  Iterable<SearchTag> get tags => _tagsById.values;

  /// 부모가 없는 태그들.
  Iterable<SearchTag> get roots {
    return tags.where((tag) => tag.parentTagId == null);
  }

  SearchTag? tagOf(int tagId) => _tagsById[tagId];

  List<SearchTag> childrenOf(int tagId) {
    return _childrenByParent[tagId] ?? const [];
  }

  /// [tagId] 자신과 모든 자손의 id.
  Set<int> withDescendants(int tagId) {
    final ids = <int>{};
    final pending = [tagId];
    while (pending.isNotEmpty) {
      final id = pending.removeLast();
      if (!ids.add(id)) continue;
      pending.addAll(childrenOf(id).map((child) => child.id));
    }
    return ids;
  }

  /// [tagId]의 모든 조상 id. 자신은 빠진다.
  Set<int> ancestorsOf(int tagId) {
    final ids = <int>{};
    var parentId = tagOf(tagId)?.parentTagId;
    while (parentId != null && ids.add(parentId)) {
      parentId = tagOf(parentId)?.parentTagId;
    }
    return ids;
  }

  /// [tags]를 칩 줄로 묶는다. 같은 단계의 자식 없는 태그는 한 줄에 먼저 모으고,
  /// 자식이 있는 태그는 한 줄을 따로 차지하며 바로 아래에 자식 줄이 온다.
  /// 줄 안은 이름 순이다.
  ///
  /// 부모가 [tags]에 없는 태그는 최상위로 놓는다.
  List<({int depth, List<SearchTag> tags})> chipRows(Iterable<SearchTag> tags) {
    final ids = {for (final tag in tags) tag.id};
    final rows = <({int depth, List<SearchTag> tags})>[];

    List<SearchTag> childrenIn(SearchTag tag) {
      return childrenOf(tag.id).where((c) => ids.contains(c.id)).toList();
    }

    void addRows(Iterable<SearchTag> siblings, int depth) {
      final sorted = siblings.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
      final leaves = sorted.where((tag) => childrenIn(tag).isEmpty).toList();
      if (leaves.isNotEmpty) rows.add((depth: depth, tags: leaves));

      for (final tag in sorted) {
        final children = childrenIn(tag);
        if (children.isEmpty) continue;
        rows.add((depth: depth, tags: [tag]));
        addRows(children, depth + 1);
      }
    }

    addRows(tags.where((tag) => !ids.contains(tag.parentTagId)), 0);
    return rows;
  }
}
