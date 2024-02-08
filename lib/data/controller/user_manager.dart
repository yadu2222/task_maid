import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/user_class.dart';
import '../database_helper.dart';

class UserManager {
  static List<User> _userInfo = [];

  static final UserManager _instance = UserManager._internal();
  UserManager._internal();

  factory UserManager() {
    return _instance;
  }

  User getUser() {
    return _userInfo[0];
  }

  String getId() {
    return _userInfo[0].userId;
  }

  String getName(String id) {
    String result = "; ;";
    for (User check in _userInfo) {
      if (check.userId == id) {
        result = check.name;
      }
    }
    return result;
  }

  void load() async {
    List loadList = await DatabaseHelper.queryAllRows("users");
    List tasks = [];
    List rooms = [];

    for (Map Data in loadList) {
      String userId = Data['user_id'];
      String mail = Data["mail"];
      String name = Data["name"];
      String sid = Data["sid"];

      try {
        tasks = jsonDecode(Data["tasks"]);
      } catch (e) {
        tasks = [];
      }
      try {
        rooms = jsonDecode(Data["rooms"]);
      } catch (e) {
        rooms = [];
      }
      _userInfo.add(User(userId, mail, name, sid, tasks, rooms));
    }

    print("ろーどしたよ");
  }
}
