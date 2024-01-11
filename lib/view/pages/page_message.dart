import 'package:flutter/material.dart';
import 'package:task_maid/view/pages/page_home.dart';
import '../constant.dart';
import '../items.dart';
import 'page_messages.dart';
import '../molecules.dart';
import '../../database_helper.dart';

class PageMail extends StatefulWidget {
  const PageMail({Key? key}) : super(key: key);

  @override
  _PageMail createState() => _PageMail();
}

class _PageMail extends State<PageMail> {
  dbroomGet() async {
    items.rooms = await DatabaseHelper.queryAllRows('rooms');
  }

  // トークルームの繰り返し処理
  Widget _messages() {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.rooms.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return items.rooms[index]['bool_sub_room'] == 0
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
                                mainRoomid: items.rooms[index]['main_room_id'],
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
                            child: CustomText(text: items.rooms[index]['room_name'], fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
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
            molecules.PageTitle(context, 'メッセージ',1,PageHome()),
            Container(width: _screenSizeWidth * 0.95, height: _screenSizeHeight * 0.85, child: _messages())
          ],
        ),
      ),
    )));
  }
}

class PageMails extends StatefulWidget {
  final String mainRoomid;
  const PageMails({Key? key, required this.mainRoomid}) : super(key: key);

  @override
  _PageMails createState() => _PageMails(mainRoomid: mainRoomid);
}

class _PageMails extends State<PageMails> {
  // ひらいたメインルームに属する部屋をすべて取得
  List nowRoomSet = [];
  String mainRoomName = '';
  dbroomGet() async {
    nowRoomSet = await DatabaseHelper.serachRows('rooms', 1, ['main_room_id'], [mainRoomid], 'room_id');
    mainRoomName = nowRoomSet[0]['room_name'];
    setState(() {});
  }

  String mainRoomid;
  _PageMails({required this.mainRoomid});

  List msgList = [];

  msgListGet(String room_id) async {
    msgList = await DatabaseHelper.serachRows('msg_chats', 1, ['room_id'], [room_id], 'msg_datetime');
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
    mainRoomid = widget.mainRoomid;
    dbroomGet();
  }

  // トークルームの繰り返し処理
  Widget _messages() {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: nowRoomSet.length,
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
                          messenger: items.rooms[index],
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
                      child: CustomText(text: nowRoomSet[index]['room_name'], fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
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
            molecules.PageTitle(context, mainRoomName,0,PageHome()),
            Container(width: _screenSizeWidth * 0.95, height: _screenSizeHeight * 0.85, child: _messages())
          ],
        ),
      ),
    )));
  }
}
