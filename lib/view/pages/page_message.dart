import 'package:flutter/material.dart';
import 'package:task_maid/view/pages/page_home.dart';
import '../design_system/constant.dart';
import 'page_messages.dart';
import '../parts/Molecules.dart';

// 各情報のクラス
import '../../data/controller/door.dart';
import '../../data/models/task_class.dart';
import '../../data/models/msg_class.dart';
import '../../data/models/room_class.dart';

import '../../data/controller/room_manager.dart';
import '../../data/controller/task_manager.dart';
class PageMail extends StatefulWidget {
  const PageMail({Key? key}) : super(key: key);

  @override
  _PageMail createState() => _PageMail();
}

class _PageMail extends State<PageMail> {
  dbroomGet() async {
   //  items.rooms = await DatabaseHelper.queryAllRows('rooms');
  }

  RoomManager _roomManager = RoomManager();
  
  

  // トークルームの繰り返し処理
  Widget _messages() {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: _roomManager.count(),
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return _roomManager.findByindex(index).subRoom == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    // ページ遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PageMails(
                                mainRoom: _roomManager.findByindex(index),
                              )),
                    ).then((value) {
                      //戻ってきたら再描画
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: _screenSizeWidth * 0.8,
                    height: _screenSizeHeight * 0.075,
                    padding: EdgeInsets.only(top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025, left: _screenSizeWidth * 0.045),
                    decoration: BoxDecoration(
                      color: Constant.glay,
                      borderRadius: BorderRadius.circular(5), // 角丸
                    ),
                    child: Row(
                      children: [
                        Column(children: [
                          // 最終送信日時とかも入れたいね

                          // 最新を入れたいのでソートを行わないといけない
                          // 名前の表示
                          Container(
                            width: _screenSizeWidth * 0.7,
                            alignment: Alignment.topLeft,
                            child: CustomText(text: _roomManager.findByindex(index).roomName, fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                          ),
                          Container(
                              width: _screenSizeWidth * 0.7,
                              child:
                                  // 部屋の名前表示
                                  // 建設予定
                                  CustomText(text: '建設予定', fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay))
                        ])
                      ],
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dbroomGet();
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    

    return Scaffold(
        body: Center(
            child: Container(
      width: _screenSizeWidth,
      height: _screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // バー部分
            molecules.PageTitle(context, 'メッセージ', 1, PageHome()),
            Container(width: _screenSizeWidth * 0.95, height: _screenSizeHeight * 0.85, child: _messages())
          ],
        ),
      ),
    )));
  }
}

class PageMails extends StatefulWidget {
  final Room mainRoom;
  const PageMails({Key? key, required this.mainRoom}) : super(key: key);

  @override
  _PageMails createState() => _PageMails(mainRoom: mainRoom);
}

class _PageMails extends State<PageMails> {
  // ひらいたメインルームに属する部屋をすべて取得


  Room mainRoom;
  _PageMails({required this.mainRoom});

  List msgList = [];

  msgListGet(String room_id) async {
    // msgList = await DatabaseHelper.serachRows('msg_chats', 1, ['room_id'], [room_id], 'msg_datetime');
    print(msgList);
    setState(() {});
  }

  // 最新メッセージ表示用メソッド
  Future<String> newMsg(String room_id) async {
    String result = '';
    await msgListGet(room_id);

    if (msgList.isNotEmpty) {
      result = await msgList[msgList.length - 1]['msg'];
    }
    return result.toString();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // mainRoomid = widget.mainRoomid;
    // dbroomGet();
  }

  // トークルームの繰り返し処理
  Widget _messages() {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: mainRoom.subRoomData.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(
          color: Constant.glay,
          elevation: 0,
          child: InkWell(
            onTap: () {
              // ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageMassages(
                          messageRoom: mainRoom.subRoomData[index]
                        )),
              ).then((value) {
                //戻ってきたら再描画
                setState(() {});
              });
            },
            child: Container(
              width: _screenSizeWidth * 0.8,
              height: _screenSizeHeight * 0.075,
              padding: EdgeInsets.only(top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025, left: _screenSizeWidth * 0.045),
              decoration: BoxDecoration(
                color: Constant.glay,
                borderRadius: BorderRadius.circular(5), // 角丸
              ),
              child: Row(
                children: [
                  Column(children: [
                    // 最終送信日時とかも入れたいね

                    // 最新を入れたいのでソートを行わないといけない
                    // 名前の表示
                    Container(
                      width: _screenSizeWidth * 0.7,
                      alignment: Alignment.topLeft,
                      child: CustomText(text: mainRoom.subRoomData[index].roomName, fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                    ),
                    Container(
                        width: _screenSizeWidth * 0.7,
                        child:
                            // 部屋の名前表示
                            // 建設予定
                            CustomText(text: '建設予定', fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay))
                  ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // これなに？？
  @override
  Widget build(BuildContext context) {
    
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      width: _screenSizeWidth,
      height: _screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // バー部分
            molecules.PageTitle(context, mainRoom.roomName, 0, PageHome()),
            Container(width: _screenSizeWidth * 0.95, height: _screenSizeHeight * 0.85, child: _messages())
          ],
        ),
      ),
    )));
  }
}
