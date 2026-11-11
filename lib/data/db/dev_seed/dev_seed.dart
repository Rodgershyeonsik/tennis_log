/// 개발용 웹 DB의 첫 내용. 웹에서만 `web/dev_seed.sqlite`를 읽는다.
library;

export 'dev_seed_stub.dart' if (dart.library.js_interop) 'dev_seed_web.dart';
