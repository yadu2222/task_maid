import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper(); // 無名のコンストラクタを追加

  static const _databaseName = "MyDatabase.db"; // DB名
  static const _databaseVersion = 1; // スキーマのバージョン指定

  // static String table = 'my_table'; // テーブル名
  static String columnId = '_id'; // カラム名：ID
  static String columnName = 'name'; // カラム名:Name
  static String columnAge = 'age'; // カラム名：age

  static String userid = 'userid';
  static String userName = 'userName';
  static String account = 'account';

  // table名まとめ
  static List<String> tableNames = ["userAccount", "rooms", "tasks", "messages"];

  // DatabaseHelper クラスを定義
  DatabaseHelper._privateConstructor();
  // DatabaseHelper._privateConstructor() コンストラクタを使用して生成されたインスタンスを返すように定義
  // DatabaseHelper クラスのインスタンスは、常に同じものであるという保証
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Databaseクラス型のstatic変数_databaseを宣言
  // クラスはインスタンス化しない
  static Database? _database;

  // databaseメソッド定義
  // 非同期処理
  Future<Database?> get database async {
    // _databaseがNULLか判定
    // NULLの場合、_initDatabaseを呼び出しデータベースの初期化し、_databaseに返す
    // NULLでない場合、そのまま_database変数を返す
    // これにより、データベースを初期化する処理は、最初にデータベースを参照するときにのみ実行されるようになります。
    // このような実装を「遅延初期化 (lazy initialization)」と呼びます。
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // データベース接続
  _initDatabase() async {
    // アプリケーションのドキュメントディレクトリのパスを取得
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // 取得パスを基に、データベースのパスを生成
    String path = join(documentsDirectory.path, _databaseName);
    // データベース接続
    return await openDatabase(path,
        version: _databaseVersion,
        // テーブル作成メソッドの呼び出し
        onCreate: _onCreate);
  }

  // テーブル作成
  // 引数:dbの名前
  // 引数:スキーマーのversion
  // スキーマーのバージョンはテーブル変更時にバージョンを上げる（テーブル・カラム追加・変更・削除など）
  Future<void> _onCreate(Database db, int version) async {
    // ユーザーのアカウントを管理するためのテーブル
    await db.execute('''
    CREATE TABLE userAccount (
      userid INTEGER PRIMARY KEY,
      mail TEXT,
      name TEXT,
      tasks  text,
      rooms text
    )
  ''');

    // ルームを管理するためのテーブル
    await db.execute('''
    CREATE TABLE rooms (
      roomid TEXT PRIMARY KEY,
      roomName TEXT NOT NULL,
      leader TEXT,
      workers TEXT,
      tasks TEXT
    )
  ''');

    // タスクを管理するためのテーブル
    await db.execute('''
    CREATE TABLE tasks (
      taskid INTEGER,
      limitTime text NOT NULL,
      leaders integer,
      worker integer,
      contents text PRIMARY KEY,
      roomid text,
      status integer
    )
  ''');

    // メッセージを管理するためのテーブル
    await db.execute('''
  CREATE TABLE msgchats (
    msgid integer,
    roomid text,
    time text PRIMARY KEY,
    sender text,
    level integer,
    status integer,
    message text ,
    quote integer
  )
''');
  }

  // 登録処理
  // 引数：table名、追加するmap
  static Future<int> insert(String tableName, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(tableName, row);
  }

  // 照会処理
  // 引数：table名
  static Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database? db = await instance.database;
    return await db!.rawQuery("select * from ${tableName}");
  }

  // その2
  // 毎回全部落とすより差分もらってくるほうがええんとちゃますののやつ
  static Future<List<Map<String, dynamic>>> queryRow(String key) async {
    Database? db = await instance.database;
    return await db!.rawQuery("select * from msgchats where '${key}' == 'message'");
  }

  // その3
  // idでの検索に返してくれるやつ
   static Future<List<Map<String, dynamic>>> queryRowRoom(String key) async {
    Database? db = await instance.database;
    return await db!.rawQuery("select * from msgchats where '${key}' == 'roomid'");
  }

  // その3
  // idでの検索に返してくれるやつ
  static Future<List<Map<String, dynamic>>> queryworer(String key) async {
    Database? db = await instance.database;
    return await db!.rawQuery("select * from msgchats where '${key}' == 'roomid'");
  }


  // レコード数を確認t
  // 引数：table名
  static Future<int?> queryRowCount(String tableName) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // 更新処理
  // 引数：table名、更新後のmap、検索キー
  static Future<int> update(String tableName, String colum, Map<String, dynamic> row, int id) async {
    Database? db = await instance.database;
    return await db!.update(tableName, row, where: '$colum = ?', whereArgs: [id]);
  }

  // 削除処理
  // 引数：table名、更新後のmap、検索キー
  static Future<int> delete(String tableName, String colum, int id) async {
    Database? db = await instance.database;
    return await db!.delete(tableName, where: '$colum = ?', whereArgs: [id]);
  }
}
