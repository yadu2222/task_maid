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
  static List<String> tableNames = [
    "userAccount",
    "rooms",
    "tasks",
    "messages"
  ];

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
    CREATE TABLE users (
      user_id TEXT PRIMARY KEY,
      mail TEXT PRIMARY KEY,
      name TEXT,
      tasks  text,
      rooms text
    )
  ''');

    // ルームを管理するためのテーブル
    await db.execute('''
    CREATE TABLE rooms (
      room_id TEXT ,
      room_name TEXT PRIMARY KEY,
      leaders TEXT,
      workers TEXT,
      tasks TEXT,
      room_number TEXT,
      sub_rooms TEXT
    )
  ''');

    // サブルームを管理するためのテーブル
    await db.execute('''
    CREATE TABLE sub_rooms (
      room_id TEXT PRIMARY KEY ,
      room_name TEXT PRIMARY KEY,
      leader TEXT,
      workers TEXT,
      tasks TEXT,
      main_room_id TEXT
    )
  ''');

    // タスクを管理するためのテーブル
    await db.execute('''
    CREATE TABLE tasks (
      task_id TEXT,
      task_limit TEXT NOT NULL,
      status_progress integer,
      leaders TEXT,
      worker TEXT,
      room_id text,
      contents TEXT,
    )
  ''');

    // メッセージを管理するためのテーブル
    await db.execute('''
    CREATE TABLE msg_chats (
      msg_id integer,
      msg_datetime TEXT PRIMARY KEY,
      sender TEXT,
      room_id TEXT,
      level integer,
      status_addition integer,
      stamp_id integer,
      quote_id TEXT,
      msg TEXT
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
  static Future<List<Map<String, dynamic>>> queryAllRows(
      String tableName) async {
    Database? db = await instance.database;
    print(await db!.rawQuery("select * from ${tableName}"));
    return await db.rawQuery("select * from ${tableName}");
  }

  // その2
  // 毎回全部落とすより差分もらってくるほうがええんとちゃいますののやつ
  static Future<List<Map<String, dynamic>>> queryRow(String key) async {
    Database? db = await instance.database;
    return await db!
        .rawQuery("select * from msgchats where '${key}' == 'message'");
  }

  // その3
  // idでの検索に返してくれるやつ
  static Future<List<Map<String, dynamic>>> queryRowRoom(String key) async {
    Database? db = await instance.database;
    return await db!
        .rawQuery("select * from msgchats where '${key}' == 'time'");
  }

  // その3
  // idでの検索に返してくれるやつ
  static Future<List<Map<String, dynamic>>> queryRowtask(String key) async {
    Database? db = await instance.database;
    return await db!.query('tasks', where: 'roomid = ?', whereArgs: ['${key}']);
  }

  static Future<bool> firstdb() async {
    Database? db = await instance.database;
    List result = await db!.rawQuery("select * from rooms");
    // 取得した結果が空でないかを確認し、存在する場合はtrueを、存在しない場合はfalseを返す
    print(result.isNotEmpty);
    return result.isNotEmpty;
  }

  // その4
  // idでの検索に返してくれるやつ
  static Future<List<Map<String, dynamic>>> selectRoom(String key) async {
    Database? db = await instance.database;
    print(key);
    print(await db!.query('rooms', where: 'roomid = ?', whereArgs: ['${key}']));
    return await db!.query('rooms', where: 'roomid = ?', whereArgs: ['${key}']);
  }

  // その5
  // idでの検索に返してくれるやつ
  static Future<List<Map<String, dynamic>>> selectSubRoom(String key) async {
    Database? db = await instance.database;
    print(key);
    print(await db!
        .query('subRooms', where: 'mainRoomid = ?', whereArgs: ['${key}']));
    return await db!
        .query('subRooms', where: 'mainRoomid = ?', whereArgs: ['${key}']);
  }

  // レコード数を確認
  // 引数：table名
  static Future<int?> queryRowCount(String tableName) async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(
        await db!.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // 更新処理
  // 引数：table名、更新後のmap、検索キー
  static Future<int> update(String tableName, String colum,
      Map<String, dynamic> row, String key) async {
    Database? db = await instance.database;
    return await db!
        .update(tableName, row, where: '$colum = ?', whereArgs: ['$key']);
  }

  // 削除処理
  // 引数：table名、更新後のmap、検索キー
  static Future<int> delete(String tableName, String colum, int id) async {
    Database? db = await instance.database;
    return await db!.delete(tableName, where: '$colum = ?', whereArgs: [id]);
  }
}
