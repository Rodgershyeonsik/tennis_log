import 'dart:js_interop';
import 'dart:typed_data';

@JS('fetch')
external JSPromise<_Response> _fetch(JSString url);

extension type _Response._(JSObject _) implements JSObject {
  external bool get ok;
  external JSPromise<JSArrayBuffer> arrayBuffer();
}

/// SQLite 파일의 처음 16바이트.
const _sqliteHeader = 'SQLite format 3\u0000';

/// `web/dev_seed.sqlite`를 읽는다. 없으면 null이다.
///
/// 개발 서버는 없는 경로에 `index.html`을 돌려줄 수 있어서, 응답이 성공이어도
/// SQLite 헤더로 한 번 더 확인한다.
Future<Uint8List?> loadDevSeed() async {
  try {
    final response = await _fetch('dev_seed.sqlite'.toJS).toDart;
    if (!response.ok) return null;

    final bytes = (await response.arrayBuffer().toDart).toDart.asUint8List();
    if (bytes.length < _sqliteHeader.length) return null;
    final header = String.fromCharCodes(bytes, 0, _sqliteHeader.length);
    return header == _sqliteHeader ? bytes : null;
  } catch (_) {
    return null;
  }
}
