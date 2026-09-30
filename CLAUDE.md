# tennis_log

테니스 게임일지 앱. 게임 후 기록을 쌓고, 기술·상황별로 조회·집계해서 플레이 스타일과 약점을 파악하고 레슨·전술에 활용하는 것이 목적이다.

이 문서는 **모든 작업에 공통으로 적용되는 규칙과 현재 데이터 모델**이다. 기능별 요구사항은 `docs/specs/` 아래의 명세 문서에 있다.

## 작업 방식

- 기능 명세를 받으면 바로 코드를 쓰지 말고, 먼저 **구현 계획(변경할 파일, 테이블 변경, 화면, 작업 순서)을 요약해서 보여주고 확인을 받은 뒤** 진행한다.
- 명세의 구현 단계 순서대로 진행하고, 각 단계가 끝날 때마다 무엇을 만들었는지와 확인 방법을 짧게 알린다.
- **명세에 없는 기존 기능은 수정하지 않는다.** 수정이 필요해 보이면 먼저 물어본다.
- 새 패키지가 필요하면 **추가하기 전에 이유와 함께 먼저 물어본다.**
- 패키지 API는 버전에 따라 다를 수 있으므로, 설정이나 문법이 확실하지 않으면 해당 패키지의 공식 문서를 확인한다.
- 데이터 모델을 바꾸면 **이 문서의 "데이터 모델" 섹션도 함께 갱신**하고, 기능이 완성되면 "구현 현황" 섹션을 갱신한다.

## 플랫폼과 환경

- 실사용은 **Android**, 개발 중에는 **웹(Chrome) 빌드**로 확인한다. 두 플랫폼 모두에서 동작해야 한다.
- 데이터는 **로컬 저장만** 한다. 서버, 로그인, 동기화 없음.
- 웹 개발 중 데이터와 Android 실기기 데이터는 서로 별개다.
- UI 문구는 모두 **한국어**.
- 날짜 표시는 `intl` 없이 직접 포맷한다. 예: `9/29 (화)`, `18:00`.

## 기술 스택

| 패키지 | 용도 |
|---|---|
| `flutter_riverpod` 3.x + `riverpod_annotation` 4.x + `riverpod_generator` | 상태 관리. 코드 생성 방식(`@riverpod`) 사용 |
| `go_router` | 라우팅 |
| `drift` + `drift_flutter` (+ `drift_dev`) | 로컬 SQLite DB. Android와 웹 모두 지원 |
| `freezed` 4.x (+ `freezed_annotation`) | 화면 상태 등 불변 모델 |
| `json_serializable` (+ `json_annotation`) | 현재 미사용. 추후 백업/내보내기용 |
| `build_runner` | drift, freezed, riverpod 코드 생성 |

주의:
- `riverpod_generator`는 설치된 `riverpod_annotation`과 호환되는 버전을 사용한다. (최초 설치 시 누락되어 있었음)
- **freezed 4.x 문법**을 따른다. (3.x와 클래스 선언 방식이 다르다)
- **drift 웹 설정**: `drift_flutter`의 웹 옵션을 사용하고, 웹에 필요한 파일(sqlite3 wasm, drift worker)을 `web/` 폴더에 둔다. drift 공식 문서의 웹 설정 가이드를 따른다.
- 생성 코드(`*.g.dart`, `*.freezed.dart`)는 `dart run build_runner build`로 만든다.

## 폴더 구조

```
lib/
  main.dart
  app/            라우터, 테마
  core/db/        drift DB, 테이블, 시드, 마이그레이션
  features/
    home/
    journal/
      data/          리포지토리
      domain/        자동 태그 엔진, 도메인 모델
      presentation/  화면, 하단 시트, 위젯, 상태(notifier)
    (새 기능은 같은 구조로 features/ 아래에 추가)
test/
docs/specs/       기능별 명세
```

## 코드 작성 원칙

- 화면 상태는 freezed 모델 + Riverpod Notifier로 관리하고, **위젯에 DB 접근 코드를 두지 않는다.** DB 접근은 리포지토리를 통한다.
- 하단 시트, 칩 그룹, 분할 버튼, 스테퍼 등 반복되는 UI는 재사용 위젯으로 분리한다.
- 터치 영역은 최소 48dp, 모바일 세로 화면 기준으로 레이아웃한다. 웹에서도 좁은 폭(약 400px)에서 확인한다.
- 키보드가 올라와도 입력칸과 주요 버튼이 가려지지 않게 한다.
- UI와 무관한 로직(자동 태그 등)은 순수 Dart 클래스로 만들고 단위 테스트를 작성한다.
- Material 3 기반.

## 데이터 모델 (drift)

enum 값은 drift의 텍스트 enum으로 저장한다. 스키마를 바꿀 때는 drift의 `schemaVersion`을 올리고 **마이그레이션을 작성해서 기존 데이터를 보존**한다.

**places (장소)**: 장소 하나 = 코트 하나. 시설 단위 그룹은 두지 않는다.
- id, name (유일), surface (hard / artificialGrass / clay / other), isIndoor (bool), createdAt, lastUsedAt
- 같은 시설의 실내/야외 코트는 "귀뚜라미 실내", "귀뚜라미 야외"처럼 별개 장소로 등록한다.

**sessions (일지 세션)**
- id
- sessionType: game / lesson / practice (기본값 game)
- date (날짜)
- startMinutes, endMinutes: 자정 기준 분(int, nullable). 예: 18:00 → 1080. 범위 06:00~24:00
- placeId (nullable)
- **surfaceSnapshot, isIndoorSnapshot, placeNameSnapshot**: 저장 시점의 장소 정보 복사본. 장소 정보가 나중에 수정돼도 과거 일지는 유지되고, **집계는 이 값으로 한다.**
- conditionScore: 1~3 (nullable, 1=별로 2=쏘쏘 3=굿)
- lastMealBucket: within1h / h1to2 / h2to3 / over3 (nullable). 세션 시작 기준 몇 시간 전
- cueId (nullable), cueApplied: yes / partial / no (nullable). 큐를 게임 중 의식적으로 적용했는지
- status: draft / complete (메모가 1개 이상이면 complete)
- tagReviewed (bool): 태그·평가 확인 단계 완료 여부
- createdAt, updatedAt

**cues (큐)**
- id, text (유일. 정규화: 앞뒤 공백 제거, 연속 공백 하나로. 같은 텍스트는 재사용), createdAt, lastUsedAt
- Dart 쪽 getter 이름만 `cueText`다. drift의 `text()` 빌더와 이름이 겹쳐서 SQL 컬럼명(`text`)만 맞췄다.
- 사용 횟수와 최근 적용 결과는 sessions에서 계산한다.

**games (게임)**: 세션에 여러 개
- id, sessionId (세션 삭제 시 함께 삭제)
- format: womenDoubles(여복) / menDoubles(남복) / mixedDoubles(혼복) / openDoubles(잡복) / singles(단식)
- myScore, opponentScore (둘 다 nullable, 스코어 모름 허용), orderIndex

**memos (메모)**: 메모 한 줄 = 한 행. **조회·집계의 기본 단위.**
- id, sessionId (세션 삭제 시 함께 삭제), content, orderIndex, createdAt, updatedAt
- evaluation: good / bad / question (nullable)
- evaluationStatus: suggested / confirmed (nullable. evaluation이 null이면 null)
- lastTaggedContent: 자동 태그·평가 추천을 마지막으로 돌린 시점의 내용

**tags (태그)**
- id, name (유일), category: technique / form / footwork / situation / body / conditionFactor
- parentTagId (nullable. 예: 백발리의 부모는 발리. 부모 태그로 조회하면 자식도 포함)
- isArchived, createdAt
- 메모와 태그는 **이름이 아니라 id로 연결**한다.

**tagAliases (태그 인식 표현)**
- id, tagId, alias, confidence: sure / ambiguous
- (tagId, alias) 유일. 시드를 여러 번 돌려도 중복되지 않게 한다. alias 단독으로는 유일하지 않다(한 표현이 여러 태그에 걸릴 수 있다).

**tagExclusions (제외 단어)**
- id, tagId, word. 해당 태그의 표현이 이 단어 안에 포함돼 있으면 태그를 붙이지 않는다. (tagId, word) 유일.

**memoTags (메모-태그 연결)**
- memoId, tagId (복합 기본키)
- source: auto / manual
- status: confirmed / suggested / rejected
- rejected는 사용자가 지운 자동 태그를 기억하는 상태. 다시 저장해도 같은 태그를 붙이지 않으며, 화면에는 표시하지 않는다.

### DB 저장 규칙

- **DateTime은 ISO-8601 텍스트로 저장한다** (`DriftDatabaseOptions(storeDateTimeAsText: true)`). `sessions.date`가 날짜 전용 값인데 유닉스 초로 저장하면 타임존에 따라 날짜가 하루 밀려 읽힐 수 있다. `sessions.date`는 로컬 자정으로 정규화해서 넣는다. **이 설정은 기존 데이터와 호환되지 않으므로 나중에 바꾸면 안 된다.**
- enum은 drift의 텍스트 enum이라 **DB에 각 값의 `name` 문자열이 그대로 들어간다.** 값 이름 변경·삭제는 마이그레이션에서 기존 행을 UPDATE해야 한다. 값 추가는 안전하다.
- **외래키 제약은 `beforeOpen`에서 `PRAGMA foreign_keys = ON`으로 켠다.** SQLite는 기본이 꺼짐이고 커넥션마다 켜야 한다. 안 켜면 아래 cascade가 전부 동작하지 않는다.
- **삭제 규칙**: 부모가 사라지면 자식이 의미를 잃는 "소유" 관계면 cascade, 부모와 자식이 독립적으로 존재하는 "참조" 관계면 걸지 않는다(=부모 삭제가 거부된다).
  - cascade: `games.sessionId`, `memos.sessionId`, `memoTags.memoId`, `memoTags.tagId`, `tagAliases.tagId`, `tagExclusions.tagId`
  - cascade 없음: `sessions.placeId`, `sessions.cueId`, `tags.parentTagId`. 장소·큐·태그 삭제는 아직 만들지 않았다. 장소 삭제를 만들 때는 `SET NULL`로 바꾼다 — 스냅샷이 있으니 placeId만 비워도 과거 일지 표시는 그대로다.
- **CHECK 제약**: `sessions.startMinutes`/`endMinutes`는 360~1440, `conditionScore`는 1~3. 종료가 시작보다 이른 값은 **DB가 막지 않는다** — 자동 저장은 필수값 검사 없이 저장해야 하므로 검증은 화면에서 한다.

### 웹(Chrome) DB

- `web/sqlite3.wasm`과 `web/drift_worker.js`를 저장소에 커밋해 두었다. **drift 버전을 올릴 때 이 두 파일도 같은 버전의 릴리스에서 다시 받아야 한다.** (`https://github.com/simolus3/drift/releases/download/drift-<버전>/`)
- drift는 브라우저 기능에 따라 OPFS → IndexedDB 순으로 저장 방식을 고르고, 아무것도 못 쓰면 **에러 없이 `inMemory`로 떨어져 새로고침 시 데이터가 사라진다.** 어떤 방식이 선택됐는지 디버그 빌드에서 콘솔에 `[drift] 웹 저장 방식: ...`으로 남긴다.
- OPFS를 쓰려면 `Cross-Origin-Opener-Policy`/`Cross-Origin-Embedder-Policy` 헤더가 필요한데 `flutter run`에는 헤더 설정 옵션이 없다. 개발 중에는 shared worker + IndexedDB로 동작하며, 이것도 새로고침 후 유지된다.

## 라우트

| 경로 | 화면 |
|---|---|
| `/` | 메인 |
| `/journal/new` | 새 일지 작성 (1단계) |
| `/journal/:id` | 기존 일지 이어쓰기 (1단계) |
| `/journal/:id/tags` | 태그·평가 확인 (2단계) |

## 구현 현황

| 명세 | 상태 |
|---|---|
| `docs/specs/01_journal_entry.md` 일지 작성 MVP | 진행 중 — 1단계(프로젝트 기반), 2단계 중 테이블·DB·웹 설정 완료. 다음: 시드·리포지토리 |

## 향후 계획 (지금 구현하지 않음, 구조는 확장 가능하게)

- 검색/조회, 통계 화면
- 태그 관리 페이지 (이름 변경, 삭제, 동의어 편집)
- 레슨/볼머신 연습 세션 기록
- 사용자 수정으로부터 태그 사전 학습
