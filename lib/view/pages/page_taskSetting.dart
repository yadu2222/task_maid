import 'dart:convert';
import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import '../Molecules.dart';
import 'package:task_maid/database_helper.dart';
import 'page_task.dart';

// ページのひな型
class page_taskSetting extends StatefulWidget {
  // どこの部屋のタスクを参照したいのか引数でもらう
  final List nowRoomInfo;
  const page_taskSetting({required this.nowRoomInfo, Key? key}) : super(key: key);

  @override
  _page_taskSetting createState() => _page_taskSetting(nowRoomInfo: nowRoomInfo);
}

class _page_taskSetting extends State<page_taskSetting> {
  // 参照したい部屋の情報を引数でもらう
  List nowRoomInfo;
  _page_taskSetting({required this.nowRoomInfo});

  List nowRoomTaskList = [];
  List decodedWorkers = [];
  List decodedRooms = [];
  List selectButton = [true];
  // 引数を元に必要な情報を参照する
  infoGet() async {
    nowRoomTaskList = await DatabaseHelper.queryRowtask(nowRoomInfo[0]['room_id']);
    decodedWorkers = decodeJsonList(nowRoomInfo[0]['workers']);
    decodedRooms = decodeJsonList(nowRoomInfo[0]['sub_rooms']);

    // 初期化
    selectButton = [];
    for (int i = 0; i < decodedRooms.length + 1; i++) {
      if (i == 0) {
        selectButton.add(true);
      } else {
        selectButton.add(false);
      }
    }

    print(selectButton);

    setState(() {});
  }

  // JSON文字列をデコードしてListを取得する関数
  List<dynamic> decodeJsonList(String jsonString) {
    return jsonDecode(jsonString);
  }

  // ルームリスト
  Widget selectRoomList() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenSizeWidth * 0.9,
      height: screenSizeHeight * 0.065,
      child: ListView.builder(
        // リストの向きを横向きにする
        scrollDirection: Axis.horizontal,
        // indexの作成 widgetが表示される数
        itemCount: decodedRooms.length + 1,
        itemBuilder: (context, index) {
          // 繰り返し描画されるwidget
          return Card(color: Constant.glay.withAlpha(0), elevation: 0, child: roomCard(decodedRooms, index));
        },
      ),
    );
  }

  // - ルームリストで繰り返し表示するひながた
  Widget roomCard(List roomList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    String selectRoomid;

    return InkWell(
        onTap: () async {
          // 押したボタンに合わせてタスクを再検索

          selectButton[index] = !selectButton[index];
          if (index == 0) {
            selectRoomid = nowRoomInfo[0]['room_id'];
          } else {
            selectRoomid = roomList[index - 1]['sub_room'];
          }
          nowRoomTaskList = await DatabaseHelper.queryRowtask(selectRoomid);
          setState(() {});
        },
        child: Container(
          width: screenSizeWidth * 0.3,
          height: screenSizeHeight * 0.065,
          // padding: EdgeInsets.all(screenSizeWidth * 0.03),
          alignment: const Alignment(0.0, 0.0), //真ん中に配置
          decoration: BoxDecoration(color: selectButton[index] ? Constant.white : Constant.glay, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: index == 0
              ? CustomText(text: 'すべて', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
              : CustomText(text: roomList[index - 1]['sub_room'], fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
        ));
  }

  // タスクリスト
  Widget allTaskList(List list) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: list.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        // statusの値に合わせて表示を変更
        return list[index]['status_progress'] == status_progress || status_progress == 3
            ? Card(
                color: Constant.glay.withAlpha(0),
                elevation: 0,
                child: InkWell(
                    onTap: () {
                      // ここに処理を記述
                    },
                    child: taskCard(list, index)))
            : const SizedBox.shrink();
      },
    );
  }

  // -タスクを繰り返し表示する際のひな形
  Widget taskCard(List taskList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    return Container(
        width: screenSizeWidth * 0.7,
        height: screenSizeHeight * 0.1,
        padding: EdgeInsets.only(right: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
        //alignment: const Alignment(0.0, 0.0), //真ん中に配置
        decoration: BoxDecoration(
          color: Constant.white,
          borderRadius: BorderRadius.circular(10), // 角丸
        ),
        child: Row(children: [
          // 日付部分
          Container(
            width: screenSizeWidth * 0.15,
            height: screenSizeHeight * 0.1,
            alignment: const Alignment(0.0, 0.0), //真ん中に配置
            padding: EdgeInsets.all(screenSizeWidth * 0.025),
            child: CustomText(
                text: '${DateTime.parse(taskList[index]['task_limit']).month}\n${DateTime.parse(taskList[index]['task_limit']).day}', fontSize: screenSizeWidth * 0.055, color: Constant.blackGlay),
          ),
          SizedBox(
            width: screenSizeWidth * 0.01,
          ),
          Container(
              width: screenSizeWidth * 0.5,
              margin: EdgeInsets.only(top: screenSizeWidth * 0.04, bottom: screenSizeWidth * 0.04),
              child: Column(children: [
                // 時間
                Container(
                    width: screenSizeWidth * 0.625,
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                        text: '${DateTime.parse(taskList[index]['task_limit']).hour}:${DateTime.parse(taskList[index]['task_limit']).minute}まで\n-------------------------------',
                        fontSize: screenSizeWidth * 0.035,
                        color: Constant.blackGlay)),
                // 中身
                Container(
                    width: screenSizeWidth * 0.625, alignment: Alignment.centerLeft, child: CustomText(text: taskList[index]['contents'], fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay))
              ]))
        ]));
  }

  int status_progress = 0;
  Widget statusButton() {
    List status_name = ['消化中', '消化済', 'リスケ申請中'];
    return DropdownButton(
      items: const [
       
        DropdownMenuItem(
          value: 0,
          child: Text('消化中'),
        ),
        DropdownMenuItem(
          value: 1,
          child: Text('消化済'),
        ),
        DropdownMenuItem(
          value: 2,
          child: Text('リスケ中'),
        ),
         DropdownMenuItem(
          value: 3,
          child: Text('すべて'),
        ),
      ],
      value: status_progress,
      onChanged: (int? value) {
        setState(() {
          status_progress = value!;
        });
      },
    );
  }

  // 初期化メソッド
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.Nums();
    nowRoomInfo = widget.nowRoomInfo;
    infoGet();
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      // ページの中身
      child: Container(
        width: double.infinity,
        height: screenSizeHeight,
        // 背景色
        decoration: const BoxDecoration(color: Constant.main),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                  child: Row(children: [
                // 上部バー部分
                molecules.PageTitle(context, 'スタッフルーム'),
                SizedBox(
                  width: screenSizeWidth * 0.05,
                ),
                statusButton()
              ])),
              // タスク部分
              Container(
                  width: screenSizeWidth * 0.9,
                  height: screenSizeHeight * 0.85,
                  child: Column(
                    children: [selectRoomList(), Container(width: screenSizeWidth * 0.9, height: screenSizeHeight * 0.75, child: allTaskList(nowRoomTaskList))],
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}
