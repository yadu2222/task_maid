class Urls {
  // base URL
  static const String protocol = 'http://';
  static const String host = '127.0.0.1';
  static const String port = '8080';
  static const String baseUrl = '$protocol$host:$port';
  static const String version = '/v1'; // version

  // test
  static const String test = '$version/test/cfmreq'; // GET接続確認

  // ここにURLを追加していく

}
