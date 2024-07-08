import 'package:intl/intl.dart';

class DateUtils {
  // 日付を変換して返す
  static String dateFormat(String dateTime, int type) {
    // 各種フォーマットを定義
    final formatType1 = DateFormat('yyyy.MM.dd HH:mm');
    final formatType2 = DateFormat('yyyy/MM/dd');
    final formatType3 = DateFormat('HH:mm');
    final formatType4 = DateFormat('MM月dd日HH時mm分');
    final formatType5 = DateFormat('MM.dd.HH時mm分');
    final formatType6 = DateFormat('MM/dd');

    // デバッグ用の出力
    print(dateTime);

    // フォーマットリストを配列に格納
    List<DateFormat> formatTypes = [
      formatType1,
      formatType2,
      formatType3,
      formatType4,
      formatType5,
      formatType6,
    ];

    // 日付をパース
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      // 指定されたフォーマットに変換して返す
      return formatTypes[type].format(parsedDate);
    } catch (e) {
      // エラーハンドリング: パースに失敗した場合、デフォルトの日付文字列を返す
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }
}
