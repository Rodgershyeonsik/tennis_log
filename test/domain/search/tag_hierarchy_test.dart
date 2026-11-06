import 'package:flutter_test/flutter_test.dart';
import 'package:tennis_log/data/db/enums.dart';
import 'package:tennis_log/domain/search/search_models.dart';
import 'package:tennis_log/domain/search/tag_hierarchy.dart';

void main() {
  SearchTag tag(int id, {int? parent}) {
    return SearchTag(
      id: id,
      name: '태그$id',
      category: TagCategory.technique,
      parentTagId: parent,
    );
  }

  final hierarchy = TagHierarchy([
    tag(1),
    tag(2, parent: 1),
    tag(3, parent: 1),
    tag(4, parent: 3),
    tag(5),
  ]);

  test('자식의 자식까지 모두 포함한다', () {
    expect(hierarchy.withDescendants(1), {1, 2, 3, 4});
  });

  test('자식이 없으면 자신만 돌려준다', () {
    expect(hierarchy.withDescendants(5), {5});
  });

  test('자식을 고르면 부모는 포함하지 않는다', () {
    expect(hierarchy.withDescendants(3), {3, 4});
  });

  test('최상위는 부모가 없는 태그다', () {
    expect(hierarchy.roots.map((t) => t.id), [1, 5]);
  });
}
