import 'package:intl/intl.dart';
import 'dart:convert';
import 'task.dart';
import 'package:task_maid/database_helper.dart';


class taskList {

  /// Todoリスト
  List<Task> _list = [];

  // ストアのインスタンス
  static final taskList _instance = taskList._internal();

  // プライベートなコンストラクタ
  taskList._internal();

  // 自分自身を生成
  factory taskList() {
    return _instance;
  }

  /// タスクの件数を取得する
  int count() {
    return _list.length;
  }

  /// 指定したインデックスのタスクを取得する
  Task findByIndex(int index) {
    return _list[index];
  }

  // 選択した形式で期日を返す
  String getDateTime(Task task,int type) {
    final formatType_1 = DateFormat('yyyy.MM.dd HH:mm');
    final formatType_2 = DateFormat('yyyy/MM/dd');
    final formatType_3 = DateFormat('HH:mm');
    final formatType_4 = DateFormat('MM月dd日HH時mm分');
    final formatType_5 = DateFormat('MM.dd.HH時mm分');

    List formatType = [formatType_1, formatType_2, formatType_3, formatType_4,formatType_5];
    DateTime nn = DateTime.parse(task.taskLimit);
    return formatType[type].format(nn);
  }

  /// タスクを追加する
  void add(String title, String contents, int status, String taskLimit, String worker, String roomid) {
    var taskid = count() == 0 ? 1 : int.parse(_list.last.taskid) + 1;
    // var dateTime = getDateTime();
    var task = Task(taskid.toString(), title, contents, status, taskLimit, worker, roomid);
    // リストに追加
    _list.add(task);
    save(task, true);
  }

  /// タスクを更新する
  void update(Task task, String contents, int status, String taskLimit, String worker) {
    task.contents = contents;
    task.status = status;
    task.taskLimit = taskLimit;
    task.worker = worker;
    save(task, false);
  }

  /// タスクリストを保存する
  void save(Task task, saveType) async {
    Map<String, dynamic> saveTask = task.toJson();
    // trueでinsert
    // falseでupdate
    saveType ? DatabaseHelper.insert('tasks', saveTask) : DatabaseHelper.update('tasks', 'task_id', saveTask, task.taskid.toString());
  }

  // タスクを読み込む
  void load() async {
    // var prefs = await SharedPreferences.getInstance();
    // SharedPreferencesはプリミティブ型とString型リストしか扱えないため、以下の変換を行っている
    // StrigList形式 → JSON形式 → Map形式 → TodoList形式
    // var loadTargetList = prefs.getStringList(_saveKey) ?? [];

    // _list = loadTargetList.map((a) => Task.fromJson(json.decode(a))).toList();

    // dbから落とす
    List loadList = await DatabaseHelper.queryAllRows('tasks');
    // _list = loadList.forEach((task) => _list.add(task.fromJson(task)));

    for (Map task in loadList) {
      String taskid = task['task_id'];
      String title = task['title'];
      String contents = task['contents'];
      int status = task['status_progress'];
      String taskLimit = task['task_limit'];
      String worker = task['worker'];
      String roomid = task['room_id'];

      _list.add(Task(taskid, title, contents, status, taskLimit, worker, roomid));
    }
  }
}
