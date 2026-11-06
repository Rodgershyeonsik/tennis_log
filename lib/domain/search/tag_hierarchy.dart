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
}
