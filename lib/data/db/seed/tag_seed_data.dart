/// 기본 태그 사전. `docs/specs/01_journal_entry.md` 7번을 그대로 옮긴 것이다.
///
/// 명세 표기와의 대응:
/// - 명세의 `*` 표시 = [TagSeed.ambiguous] 목록. 나머지는 [TagSeed.sure].
/// - 명세의 `/ 제외:` = [TagSeed.exclusions].
///
/// **명세를 고치면 이 파일도 함께 고쳐야 한다.** 시드는 최초 1회만 돌기 때문에
/// 이미 설치된 앱에 항목을 추가하려면 마이그레이션이 따로 필요하다.
library;

import '../enums.dart';

/// 시드할 태그 하나. DB가 아니라 코드에 두는 순수 데이터다.
class TagSeed {
  const TagSeed({
    required this.name,
    required this.category,
    this.parentName,
    this.sure = const [],
    this.ambiguous = const [],
    this.exclusions = const [],
  });

  final String name;
  final TagCategory category;

  /// 부모 태그의 **이름**. id는 시드를 넣을 때 이름으로 찾아 연결한다.
  final String? parentName;

  /// confidence = sure 인 인식 표현. 매칭되면 태그가 confirmed로 붙는다.
  final List<String> sure;

  /// confidence = ambiguous 인 인식 표현(명세의 `*`). suggested로 붙는다.
  final List<String> ambiguous;

  /// 제외 단어. 이 태그의 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다.
  final List<String> exclusions;
}

/// 전체 시드 목록. 부모 태그가 자식보다 먼저 와야 할 필요는 없다
/// (이름으로 두 번에 걸쳐 연결한다).
///
/// **같은 표현이 여러 태그에 중복 등록될 수 있다.** 예: "스핀서브"는 #서브와
/// #킥 양쪽에 있다. 명세 6번 3-1 규칙(완전히 같은 표현이 여러 태그에 있으면
/// 모두 붙인다)이 이걸 전제로 한다.
const tagSeeds = <TagSeed>[
  // ---------------------------------------------------------------- technique
  TagSeed(
    name: '서브',
    category: TagCategory.technique,
    // '킥서브'와 '스핀서브'는 #킥에도 똑같은 문자열로 등록돼 있다.
    // 명세 6번 3-1 규칙으로 둘 다 붙는다. 이게 없으면 #킥이 구간을 독차지해서
    // #서브가 차단된다.
    //
    // 반대로 '플랫서브'/'슬라이스서브' 같은 복합어는 넣지 않는다. 상대 태그가
    // 같은 문자열을 갖고 있지 않으면 3-1이 걸리지 않고, 긴 표현 우선 규칙 때문에
    // 그 안의 '플랫'/'슬라이스'를 삼켜버린다. 짧은 '서브' 표현만으로도
    // "플랫서브"처럼 붙여 쓴 입력에 #서브가 정상적으로 붙는다.
    sure: ['서브', '퍼스트', '세컨', '킥서브', '스핀서브'],
    // "서브 리턴 때 ..." 같은 메모에 #서브가 붙지 않게 한다.
    exclusions: ['서브 리턴', '서브리턴', '서브 리시브', '서브리시브'],
  ),
  TagSeed(
    name: '더블폴트',
    category: TagCategory.technique,
    sure: ['더블폴트', '더블 폴트', '더폴', '더블폴드', '더플폴트'],
  ),
  TagSeed(name: '리턴', category: TagCategory.technique, sure: ['리턴', '리시브']),
  TagSeed(
    name: '포핸드',
    category: TagCategory.technique,
    sure: ['포핸드', '포 스트로크'],
    ambiguous: ['포로 받', '포로'],
  ),
  TagSeed(
    name: '백핸드',
    category: TagCategory.technique,
    sure: ['백핸드', '백 스트로크', '투핸드'],
    ambiguous: ['백으로'],
    exclusions: ['백스텝'],
  ),
  TagSeed(
    name: '발리',
    category: TagCategory.technique,
    sure: ['발리', '하이발리', '스윙발리', '터치 발리', '맞발리'],
  ),
  TagSeed(
    name: '포발리',
    category: TagCategory.technique,
    parentName: '발리',
    sure: ['포발리'],
  ),
  TagSeed(
    name: '백발리',
    category: TagCategory.technique,
    parentName: '발리',
    sure: ['백발리'],
  ),
  TagSeed(name: '스매시', category: TagCategory.technique, sure: ['스매시', '스매싱']),
  TagSeed(name: '로브', category: TagCategory.technique, sure: ['로브']),

  // 구질 계열. 자식이 매칭되면 자식만 붙고, 부모(#구질)로 조회하면 함께 잡힌다.
  TagSeed(name: '구질', category: TagCategory.technique, sure: ['구질']),
  TagSeed(
    name: '탑스핀',
    category: TagCategory.technique,
    parentName: '구질',
    sure: ['탑스핀', '톱스핀'],
  ),
  TagSeed(
    name: '플랫',
    category: TagCategory.technique,
    parentName: '구질',
    sure: ['플랫'],
  ),
  TagSeed(
    name: '슬라이스',
    category: TagCategory.technique,
    parentName: '구질',
    sure: ['슬라이스', '백스핀', '언더스핀'],
  ),
  TagSeed(
    name: '킥',
    category: TagCategory.technique,
    parentName: '구질',
    // '킥서브', '스핀서브'는 #서브에도 똑같이 등록돼 있다(둘 다 붙어야 한다).
    sure: ['킥', '킥서브', '스핀서브'],
  ),

  // --------------------------------------------------------------------- form
  TagSeed(name: '토스', category: TagCategory.form, sure: ['토스']),

  // 유닛턴 계열.
  TagSeed(
    name: '유닛턴',
    category: TagCategory.form,
    // '왼쪽 어깨' / '어깨 회전'은 body의 '어깨'와 겹친다. 긴 표현 우선 규칙으로
    // 여기가 먼저 매칭돼야 한다. (명세 7번 마지막 주의 사항)
    //
    // '왼쪽 어깨' 계열은 ambiguous다. "왼쪽 어깨 아픔"처럼 부상 메모일 수도
    // 있어서 #유닛턴을 자동 확정하지 않고 suggested로만 붙인다.
    sure: ['유닛턴', '코일링', '어깨 회전', '어깨회전', '몸통 회전'],
    ambiguous: ['왼쪽 어깨', '왼어깨', '왼 어깨', '몸통', '턱밑'],
  ),
  TagSeed(
    name: '왼팔사용',
    category: TagCategory.form,
    parentName: '유닛턴',
    sure: ['왼팔', '왼팔 뻗기', '왼손'],
  ),
  TagSeed(
    name: '상체프레임',
    category: TagCategory.form,
    parentName: '유닛턴',
    sure: ['상체 프레임', '상체프레임', '등근육', '등 근육'],
    ambiguous: ['광배 써', '광배로', '프레임'],
    // "프레임에 맞았다"는 라켓 프레임 샷 얘기라 상체 프레임과 무관하다.
    exclusions: ['프레임에 맞', '프레임 샷'],
  ),
  TagSeed(
    name: '몸열림',
    category: TagCategory.form,
    parentName: '유닛턴',
    sure: ['몸이 열', '상체가 열', '어깨가 열'],
    ambiguous: ['가슴 벌'],
  ),

  TagSeed(
    name: '공보기',
    category: TagCategory.form,
    sure: ['공 끝까지', '임팩트', '타점', '바운드 직후', '바운드 지점', '바운드 예상 지점'],
    ambiguous: ['공을 못', '공 못'],
  ),
  TagSeed(
    name: '그립',
    category: TagCategory.form,
    sure: ['그립', '그립 압력', '손 힘', '세미웨스턴', '세미 웨스턴', '인덱스너클', '힐패드', '검지'],
    ambiguous: ['손바닥으로'],
  ),
  TagSeed(
    name: '힘조절',
    category: TagCategory.form,
    sure: ['힘 빼', '힘빼'],
    ambiguous: ['힘이 들어', '힘 빡', '뻥'],
  ),
  TagSeed(
    name: '팔꿈치',
    category: TagCategory.form,
    sure: ['팔꿈치', '팔꿈치 각도', '팔꿈치 각'],
  ),
  TagSeed(
    name: '손목',
    category: TagCategory.form,
    sure: ['손목', '손목 신전', '손목 각', '손목 각도'],
  ),
  TagSeed(name: '라켓드롭', category: TagCategory.form, sure: ['라켓드롭', '라켓 드롭']),
  TagSeed(
    name: '하체로딩',
    category: TagCategory.form,
    sure: ['하체 로딩', '하체로딩', '힙힌지', '고관절'],
    // '무릎 굽'이 body의 '무릎'보다 길어서 먼저 매칭된다. 기술 얘기를
    // 부상 태그로 보내지 않으려는 의도다.
    ambiguous: ['무릎 굽', '더 앉'],
  ),
  TagSeed(
    name: '피니시',
    category: TagCategory.form,
    sure: ['피니시', '팔로스루', '팔로우스루', '스윙 끝까지'],
    ambiguous: ['끝까지 뻗'],
  ),
  TagSeed(
    name: '밸런스',
    category: TagCategory.form,
    sure: ['하체 밸런스', '밸런스', '왼다리 중심', '왼쪽 엉덩이 힘'],
    ambiguous: ['중심'],
  ),

  // ----------------------------------------------------------------- footwork
  TagSeed(
    name: '스플릿',
    category: TagCategory.footwork,
    sure: ['스플릿', '스플릿 스텝', '스플릿스텝'],
  ),
  TagSeed(
    name: '발',
    category: TagCategory.footwork,
    sure: ['잔발'],
    ambiguous: ['발이 안', '발 안'],
  ),
  TagSeed(
    name: '물러나기',
    category: TagCategory.footwork,
    sure: ['백스텝', '물러나'],
    ambiguous: ['뒤로 가'],
  ),

  // ---------------------------------------------------------------- situation
  TagSeed(name: '전위', category: TagCategory.situation, sure: ['전위']),
  TagSeed(name: '후위', category: TagCategory.situation, sure: ['후위']),
  TagSeed(
    name: '다운더라인',
    category: TagCategory.situation,
    sure: ['다운더라인', '다운 더 라인'],
  ),
  TagSeed(name: '포칭', category: TagCategory.situation, sure: ['포칭']),
  TagSeed(name: '찬스볼', category: TagCategory.situation, sure: ['찬스볼']),
  TagSeed(
    name: '짧은공',
    category: TagCategory.situation,
    sure: ['짧은 공', '짧은공'],
    ambiguous: ['짧은 게', '짧게'],
  ),
  TagSeed(
    name: '높은공',
    category: TagCategory.situation,
    ambiguous: ['높이 뜨', '높이 튀', '뜨는 공'],
  ),
  TagSeed(
    name: '빠른공',
    category: TagCategory.situation,
    sure: ['빠른 공', '빠른공'],
    ambiguous: ['센 공', '파워'],
  ),
  TagSeed(name: '몸쪽', category: TagCategory.situation, sure: ['몸쪽']),
  TagSeed(
    name: '판단',
    category: TagCategory.situation,
    sure: ['뇌정지', '안 읽', '못 읽'],
    ambiguous: ['판단'],
  ),

  // --------------------------------------------------------------------- body
  TagSeed(name: '발목', category: TagCategory.body, sure: ['발목']),
  TagSeed(name: '아킬레스건', category: TagCategory.body, sure: ['아킬레스']),
  TagSeed(name: '무릎', category: TagCategory.body, sure: ['무릎']),
  TagSeed(name: '엉덩이·허리', category: TagCategory.body, sure: ['엉덩이', '허리']),
  TagSeed(
    name: '어깨·광배',
    category: TagCategory.body,
    sure: ['광배', '어깨 통증'],
    ambiguous: ['어깨'],
  ),
  TagSeed(name: '근육통', category: TagCategory.body, sure: ['근육통']),
  TagSeed(name: '질병', category: TagCategory.body, sure: ['대상포진', '감기', '임파선']),

  // ---------------------------------------------------------- conditionFactor
  TagSeed(name: '생리', category: TagCategory.conditionFactor, sure: ['생리']),
  TagSeed(
    name: '수면',
    category: TagCategory.conditionFactor,
    sure: ['수면'],
    // '잠 '의 **뒤 공백은 의도적이다.** "잠깐", "잠수"처럼 '잠'으로 시작하는
    // 다른 말에 걸리지 않게 하려는 표현이라 그대로 저장한다.
    // 다만 명세 6번의 "공백 제거 버전에서도 찾는다" 규칙과 충돌하므로,
    // 태그 엔진(3단계)에서 공백이 있던 표현을 공백 제거 버전에 쓰지 않도록
    // 처리해야 한다.
    ambiguous: ['잠을', '잠 '],
  ),
  TagSeed(
    name: '식사',
    category: TagCategory.conditionFactor,
    sure: ['식사', '과식'],
    ambiguous: ['배고', '먹고'],
  ),
  TagSeed(
    name: '음주',
    category: TagCategory.conditionFactor,
    sure: ['음주', '맥주'],
    ambiguous: ['술'],
  ),
  TagSeed(
    name: '피로누적',
    category: TagCategory.conditionFactor,
    sure: ['피로', '피곤'],
  ),
  TagSeed(
    name: '더위',
    category: TagCategory.conditionFactor,
    sure: ['더위', '찜통'],
    ambiguous: ['더워', '더운'],
  ),
  TagSeed(
    name: '눈부심',
    category: TagCategory.conditionFactor,
    sure: ['눈뽕'],
    ambiguous: ['눈부'],
  ),
  TagSeed(name: '집중력', category: TagCategory.conditionFactor, sure: ['집중']),
  TagSeed(
    name: '파트너멘탈',
    category: TagCategory.conditionFactor,
    ambiguous: ['파트너'],
  ),
];
