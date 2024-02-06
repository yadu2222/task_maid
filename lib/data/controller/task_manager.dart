import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_class.dart';
import 'package:task_maid/data/database_helper.dart';
import '../models/room_class.dart';
import 'room_manager.dart';
import 'dart:math';

// 通信
import '../component_communication.dart';
import 'package:http/http.dart' as http; // http

class TaskManager extends ChangeNotifier {
  // タスクリスト
  List<Task> _taskList = [];
  Task dummy = Task('000', 'dummy', 'おわらん', 0, "", '12345', '1234');

  // taskManagerのインスタンス
  static final TaskManager _instance = TaskManager._internal();

  final RoomManager _roomManager = RoomManager();

  List<Task> getTaskList() {
    return _taskList;
  }

  // プライベートなコンストラクタ
  TaskManager._internal();
  // 自分自身を生成
  factory TaskManager() {
    return _instance;
  }

  // タスクの件数を取得する
  int count() {
    return _taskList.length;
  }

  // 指定したインデックスのタスクを取得する
  Task findByIndex(int index) {
    return _taskList[index];
  }

  // タスクを検索して返却
  Task findByid(String id) {
    Task result = dummy;
    print(_taskList.length);
    for (Task task in _taskList) {
      if (id == task.taskid) {
        print(task.contents);
        result = task;
        return result;
      }
    }
    return result;
  }

  // ルームに合わせてタスクリストを生成
  List<Task> findByRoomid(String roomid) {
    List<Task> result = [];
    for (Task task in _taskList) {
      if (roomid == task.roomid) {
        result.add(task);
      }
    }
    return result;
  }

  // 選択した形式で期日を返す
  String getDateTime(Task task, int type) {
    final formatType_1 = DateFormat('yyyy.MM.dd HH:mm');
    final formatType_2 = DateFormat('yyyy/MM/dd');
    final formatType_3 = DateFormat('HH:mm');
    final formatType_4 = DateFormat('MM月dd日HH時mm分');
    final formatType_5 = DateFormat('MM.dd.HH時mm分');

    List formatType = [formatType_1, formatType_2, formatType_3, formatType_4, formatType_5];
    DateTime nn = DateTime.parse(task.taskLimit);
    return formatType[type].format(nn);
  }

  // タスクを追加する
  void add(String title, String contents, String taskLimit, String worker, String roomid) {
    var random = Random();
    var taskid = random.nextInt(100000);

    String dummyID = "888888";
    // var dateTime = getDateTime();
    var task = Task(dummyID, title, contents, 0, taskLimit, worker, roomid);
    save(task, 0, "/post_ins_new_record");
  }

  // タスクを更新する
  void update(Task task, String contents, int status, String taskLimit, String worker) {
    task.contents = contents;
    task.status = status;
    task.taskLimit = taskLimit;
    task.worker = worker;
    save(task, 1, "/post_upd");
  }

  // タスクを削除
  // 退室処理
  void deleat(List<dynamic> deleatRooms) {
    // 引数のリストの部屋を削除
    for (String deleatRoomid in deleatRooms) {
      _taskList.removeWhere((value) => value.roomid == deleatRoomid);
      for (Task task in _taskList) {
        if (task.roomid == deleatRoomid) {
          save(task, 2, "/post_upd", deleatRoomid);
        }
      }
    }
  }

  // タスクリストをdbに保存する
  void save(Task task, int saveType, String httpRoute, [String? deleteId]) async {
    Map<String, dynamic> saveTask = task.toJson();

    switch (saveType) {
      // insert
      case 0:
        http.Response response = await HttpToServer.httpReq("POST", httpRoute, {
          "tableName": "tasks",
          "pKey": "task_id",
          "pKeyValue": "uuid-1",
          "recordData": {"task_id": "uuid-1", "task_limit": task.taskLimit, "leaders": [], "worker": task.worker, "contents": task.contents, "room_id": task.roomid}
        });

        // レスポンスをStringに変換しidを取得
        Map resultData = jsonDecode(response.body);
        String result = resultData["server_response_data"].toString();
        task.taskid = result;
        saveTask["task_id"] = result;
        // リストに追加
        _taskList.add(task);
        await DatabaseHelper.insert('tasks', saveTask);
        break;

      // update
      case 1:
        http.Response response = await HttpToServer.httpReq("POST", httpRoute, {
          "tableName": "tasks",
          "pKey": "task_id",
          "pKeyValue": task.taskid,
          "recordData": {"task_id": task.taskid, "task_limit": task.taskLimit,"leaders":[], "worker": task.worker, "contents": task.contents, "room_id": task.roomid}
        });
        await DatabaseHelper.update('tasks', 'task_id', saveTask, task.taskid.toString());
        print(jsonDecode(response.body)["server_response_message"]);
        break;

      // delete
      case 2:
        if (deleteId != null) {
          // 部屋から自分を消す処理
          Room room = _roomManager.findByroomid(deleteId);
          room.workers.removeWhere((value) => value == "12345");

          http.Response response = await HttpToServer.httpReq("POST", httpRoute, {
            "tableName": "tasks",
            "pKey": "task_id",
            "pKeyValue": task.taskid,
            "recordData": {"task_id": task.taskid, "task_limit": task.taskLimit,"leaders":[],"worker": null, "contents": task.contents, "room_id": task.roomid}
          });
          // アプリ内で保持しているタスクリストから削除
          await DatabaseHelper.delete('tasks', 'task_id', task.taskid);
        }
        break;
    }

    _roomManager.load();
    notifyListeners();
  }

  // タスクを読み込む
  void load() async {
    // dbから落とす
    _taskList.clear();
    List loadList = await DatabaseHelper.queryAllRows('tasks');
    // _taskList = loadList.forEach((task) => _taskList.add(task.fromJson(task)));

    for (Map task in loadList) {
      String taskid = task['task_id'];
      String title = task['title'];
      String contents = task['contents'];
      int status = task['status_progress'];
      String taskLimit = task['task_limit'];
      String worker = task['worker'];
      String roomid = task['room_id'];
      _taskList.add(Task(taskid, title, contents, status, taskLimit, worker, roomid));
    }

    notifyListeners();
  }
}
