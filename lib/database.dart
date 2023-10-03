import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._();

  DatabaseHelper._();

  // データベースを返す非同期メソッド
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  // データベースを初期化する非同期メソッド
  Future<Database> initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // データベースが作成されたときにテーブルを作成する
        await db.execute('''
          CREATE TABLE my_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER
          )
        ''');
      },
    );
  }

  // データを挿入する非同期メソッド
  Future<int> insert(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('my_table', row);
  }

  // すべてのデータをクエリする非同期メソッド
  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await instance.database;
    return await db.query('my_table');
  }

  // データを更新する非同期メソッド
  Future<int> update(Map<String, dynamic> row) async {
    final db = await instance.database;
    final id = row['id'];
    return await db.update('my_table', row, where: 'id = ?', whereArgs: [id]);
  }

  // データを削除する非同期メソッド
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }

  
}
