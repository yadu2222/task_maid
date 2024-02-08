import 'dart:convert';

class User {
  String userId;
  String mail;
  String name;
  String sid;
  List tasks;
  List rooms;

  User(this.userId, this.mail, this.name, this.sid, this.tasks, this.rooms);

  Map<String, dynamic> toJson() {
    return {
      "user_id":userId,
      "mail":mail,
      "name":name,
      "sid":sid,
      "tasks":jsonEncode(tasks),
      "rooms":jsonEncode(rooms)
    };
  }
}
