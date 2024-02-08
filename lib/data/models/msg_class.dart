class MSG {
  // メッセージのid 通し番号
  int msgid;
  // 送信時刻
  String msgDatetime;
  // 受け取りびと
  String receiver;
  // 送信者
  String senderid;
  // 部屋のid
  String roomid;
  // おこれべる
  int level;
  // メッセージの種類
  int statusAddition;
  // 使用中のスタンプ
  int stampid;
  // 引用しているタスク
  String quoteid;
  // 本文
  String msg;

  MSG(this.msgid, this.msgDatetime, this.senderid, this.roomid, this.level, this.statusAddition, this.stampid, this.quoteid, this.msg,this.receiver);

  // Mapに変換する
  Map<String, dynamic> toJson() {
    return {
      'msg_id': msgid,
      'msg_datetime': msgDatetime.toString(),
      'sender': senderid,
      'room_id': roomid,
      'level': level,
      'status_addition': statusAddition,
      'stamp_id': stampid,
      'quote_id': quoteid,
      'msg': msg,
      'receiver':receiver
    };
  }
}
