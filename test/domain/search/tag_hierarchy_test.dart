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

  test('조상은 부모의 부모까지 모으고 자신은 뺀다', () {
    final hierarchy = TagHierarchy(const [
      SearchTag(id: 1, name: '샷', category: TagCategory.technique),
      SearchTag(
        id: 2,
        name: '발리',
        category: TagCategory.technique,
        parentTagId: 1,
      ),
      SearchTag(
        id: 3,
        name: '백발리',
        category: TagCategory.technique,
        parentTagId: 2,
      ),
    ]);

    expect(hierarchy.ancestorsOf(3), {1, 2});
    expect(hierarchy.ancestorsOf(1), isEmpty);
  });

  test('자식 없는 태그를 한 줄에 모으고, 부모 줄 아래에 자식 줄이 온다', () {
    const tags = [
      SearchTag(id: 1, name: '서브', category: TagCategory.technique),
      SearchTag(
        id: 2,
        name: '포발리',
        category: TagCategory.technique,
        parentTagId: 4,
      ),
      SearchTag(
        id: 3,
        name: '백발리',
        category: TagCategory.technique,
        parentTagId: 4,
      ),
      SearchTag(id: 4, name: '발리', category: TagCategory.technique),
      SearchTag(id: 5, name: '리턴', category: TagCategory.technique),
    ];

    final rows = TagHierarchy(tags).chipRows(tags);

    expect(
      rows.map(
        (row) => '${row.depth}:${row.tags.map((t) => t.name).join(',')}',
      ),
      ['0:리턴,서브', '0:발리', '1:백발리,포발리'],
    );
  });

  test('부모가 목록에 없으면 최상위로 놓는다', () {
    const parent = SearchTag(
      id: 1,
      name: '발리',
      category: TagCategory.technique,
      isArchived: true,
    );
    const child = SearchTag(
      id: 2,
      name: '백발리',
      category: TagCategory.technique,
      parentTagId: 1,
    );

    final rows = TagHierarchy(const [parent, child]).chipRows(const [child]);

    expect(rows.single.depth, 0);
    expect(rows.single.tags, [child]);
  });
}
