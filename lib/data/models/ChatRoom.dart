import 'Room.dart';
import 'Room_manager.dart';
import 'Msg_manager.dart';

class ChatRoom {
  Room room;
  MsgManager msgList;
  ChatRoom(this.room, this.msgList);
}


