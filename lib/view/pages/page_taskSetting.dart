import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:task_maid/data/controller/msg_manager.dart';
import 'package:task_maid/data/controller/room_manager.dart';
import 'package:task_maid/data/controller/task_manager.dart';

import '../design_system/constant.dart';
import '../parts/Molecules.dart';
import 'page_task.dart';
import 'page_messages.dart';

import '../../data/models/room_class.dart';
import '../../data/models/task_class.dart';

// ページのひな型
class page_taskSetting extends StatefulWidget {
  // どこの部屋のタスクを参照したいのか引数でもらう
  final Room nowRoomInfo;
  const page_taskSetting({required this.nowRoomInfo, Key? key}) : super(key: key);

  @override
  _page_taskSetting createState() => _page_taskSetting(selectRoomInfo: nowRoomInfo);
}

class _page_taskSetting extends State<page_taskSetting> {
  // 参照したい部屋の情報を引数でもらう
  Room selectRoomInfo;
  _page_taskSetting({required this.selectRoomInfo});

  final RoomManager _roomManager = RoomManager();
  final MsgManager _msgManager = MsgManager();
  final TaskManager _taskManager = TaskManager();

  List selectButton = [true];

  // 引数を元に必要な情報を参照する
  infoGet() async {
    // 初期化
    selectButton = [];
    for (int i = 0; i < selectRoomInfo.sameGroupId.length + 1; i++) {
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
    return SizedBox(
      width: screenSizeWidth * 0.9,
      height: screenSizeHeight * 0.065,
      child: ListView.builder(
        // リストの向きを横向きにする
        scrollDirection: Axis.horizontal,
        // indexの作成 widgetが表示される数
        itemCount: selectRoomInfo.sameGroupId.length,
        itemBuilder: (context, index) {
          // 繰り返し描画されるwidget
          return Card(color: Constant.glay.withAlpha(0), elevation: 0, child: roomCard(selectRoomInfo.sameGroupId, index));
        },
      ),
    );
  }

  // - ルームリストで繰り返し表示するひながた
  Widget roomCard(List<dynamic> roomList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    // String selectRoomid;

    // 現在の部屋
    Room dispRoom = _roomManager.findByroomid(roomList[index].toString());

    return InkWell(
        onTap: () async {
          // 押したボタンに合わせてタスクを再検索
          selectButton[index] = true;
          for (int i = 0; i < selectButton.length; i++) {
            if (i != index) {
              selectButton[i] = false;
            }
          }
          setState(() {
            selectRoomInfo = dispRoom;
          });
        },
        child: Container(
          width: screenSizeWidth * 0.3,
          height: screenSizeHeight * 0.065,
          // padding: EdgeInsets.all(screenSizeWidth * 0.03),
          alignment: const Alignment(0.0, 0.0), //真ん中に配置
          decoration: BoxDecoration(color: selectButton[index] ? Constant.white : Constant.glay, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: // index == 0 ? CustomText(text: 'すべて', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay):
              CustomText(text: dispRoom.roomName, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
        ));
  }

  // タスクリスト
  Widget allTaskList(
    List<Task> list,
  ) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: list.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        // statusの値に合わせて表示を変更
        return list[index].status == status_progress || status_progress == 3
            ? Card(
                color: Constant.glay.withAlpha(0),
                elevation: 0,
                child: InkWell(
                    onTap: () {
                      DateTime limitTime = DateTime.parse(list[index].taskLimit);
                      String dateText = '新しい期日を入力してね';
                      String worker = list[index].worker;
                      // ここに処理を記述
                      // 編集用ダイアログを起動
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return molecules.dialog(
                                context,
                                0.9,
                                0.5,
                                true,
                                Column(children: [
                                  Container(
                                    margin: EdgeInsets.all(screenSizeWidth * 0.02),
                                    alignment: Alignment(0, 0),
                                    child: CustomText(text: 'タスク編集', fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay),
                                  ),

                                  // 期日入力
                                  // データピッカー
                                  InkWell(
                                      onTap: () {
                                        DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onConfirm: (date) {
                                          setState(() {
                                            limitTime = date;
                                            dateText = '${date.year}年${date.month}月${date.day}日${date.hour}時${date.minute}分';
                                          });
                                        }, currentTime: DateTime.now(), locale: LocaleType.jp);
                                      },
                                      child: Container(
                                          width: screenSizeWidth * 0.5,
                                          height: screenSizeHeight * 0.05,
                                          alignment: const Alignment(-1, 0),
                                          //margin: EdgeInsets.only(left: screenSizeWidth * 0.03),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                            bottom: BorderSide(
                                              color: Constant.blackGlay, //枠線の色
                                              width: 1, //枠線の太さ
                                            ),
                                          )),
                                          child: Text(
                                            dateText,

                                            textAlign: TextAlign.left,
                                            style: TextStyle(color: Constant.blackGlay),

                                            // screenSizeWidth * 0.04,
                                            // Constant.blackGlay,
                                          ))),
                                  Container(
                                      width: screenSizeWidth * 0.6,
                                      height: screenSizeHeight * 0.1,
                                      alignment: const Alignment(0.0, 0.0),
                                      margin: EdgeInsets.all(screenSizeWidth * 0.03),
                                      decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),

                                      // 内容
                                      child: CustomText(text: list[index].contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)),

                                  Container(child: CustomText(text: '誰に頼む？', fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay)),

                                  Container(
                                    height: screenSizeHeight * 0.15,
                                    child: ListView.builder(
                                      itemCount: selectRoomInfo.workers.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                            color: Constant.glay,
                                            elevation: 0,
                                            child: InkWell(
                                              // ボタンの色替えを建設しろ
                                              onTap: () {
                                                // falseに上書き
                                                // workerSelectButton();
                                                // workerBottun[index] = !workerBottun[index];

                                                // うまく更新されないね；～～～～～～～；
                                                // タスク追加用変数に代入を行っている
                                                setState(() {
                                                  worker = selectRoomInfo.workers[index];
                                                });

                                                //  items.friend[workerId]['bool'] = true;
                                                // setState(() {});
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                                                alignment: Alignment(0, 0),
                                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),

                                                // ここでサーバーから名前をもらってくる
                                                child: CustomText(text: selectRoomInfo.workers[index], fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),

                                  // タスク作成ボタン
                                  InkWell(
                                    onTap: () async {
                                      FocusScope.of(context).unfocus(); // キーボードを閉じる
                                      Navigator.of(context).pop(); // 戻る

                                      // 改築

                                      // タスクを上書き
                                      // Map<String, dynamic> updTask = {
                                      //   'task_id': list[index]['task_id'],
                                      //   'task_limit': limitTime.toString(),
                                      //   'status_progress': list[index]['status_progress'],
                                      //   'leaders': list[index]['leaders'],
                                      //   'worker': worker,
                                      //   'room_id': list[index]['room_id'],
                                      //   'contents': list[index]['contents']
                                      // };
                                      // DatabaseHelper.update('tasks', 'contents', updTask, list[index]['contents']);

                                      // 値の更新
                                      // items.taskList = await DatabaseHelper.queryAllRows('tasks');
                                      // msgのdbに追加
                                      // infoGet();
                                      // 画面の更新
                                      // msg

                                      _msgManager.add('かえたよ～～～～', 1, 0, list[index].taskid, 0, selectRoomInfo.roomid);

                                      setState(() {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PageMassages(
                                                    messageRoom: selectRoomInfo,
                                                  )),
                                        ).then((value) {
                                          //戻ってきたら再描画
                                          setState(() {});
                                        });
                                      });
                                    },
                                    child: Container(
                                      width: screenSizeWidth * 0.25,
                                      alignment: Alignment(0, 0),
                                      padding: EdgeInsets.only(left: screenSizeWidth * 0.03, right: screenSizeWidth * 0.03, top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                                      margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
                                      decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                      child: CustomText(text: '編集', fontSize: screenSizeWidth * 0.05, color: Constant.white),
                                    ),
                                  )
                                ]));
                          });
                    },
                    child: taskCard(list, index)))
            : const SizedBox.shrink();
      },
    );
  }

  // -タスクを繰り返し表示する際のひな形
  Widget taskCard(List<Task> taskList, int index) {
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
            child:
                CustomText(text: '${DateTime.parse(taskList[index].taskLimit).month}\n${DateTime.parse(taskList[index].taskLimit).day}', fontSize: screenSizeWidth * 0.055, color: Constant.blackGlay),
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
                    child: CustomText(text: '${taskList[index].worker}さん\n-------------------------------', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)),
                // 中身
                Container(
                    width: screenSizeWidth * 0.625, alignment: Alignment.centerLeft, child: CustomText(text: taskList[index].contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay))
              ]))
        ]));
  }

  // プルダウン
  int status_progress = 0;
  Widget statusButton() {
    // List status_name = ['消化中', '消化済', 'リスケ申請中'];
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
    selectRoomInfo = widget.nowRoomInfo;
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
                molecules.PageTitle(context, 'スタッフルーム', 0, PageTask(nowRoomInfo: selectRoomInfo)),
                SizedBox(
                  width: screenSizeWidth * 0.05,
                ),
                statusButton()
              ])),
              // タスク部分
              SizedBox(
                  width: screenSizeWidth * 0.9,
                  height: screenSizeHeight * 0.85,
                  child: Column(
                    children: [selectRoomList(), SizedBox(width: screenSizeWidth * 0.9, height: screenSizeHeight * 0.75, child: allTaskList(_taskManager.findByRoomid(selectRoomInfo.roomid)))],
                  )),
            ],
          ),
        ),
      ),
    ));
  }
}
