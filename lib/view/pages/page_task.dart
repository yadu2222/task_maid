import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:task_maid/view/pages/page_home.dart';
import 'package:task_maid/view/pages/page_roomSetting.dart';
import 'package:task_maid/view/pages/page_taskSetting.dart';
import '../design_system/constant.dart';
import 'page_messages.dart';

import '../../const/items.dart';
import '../parts/Molecules.dart';
import '../parts/loading.dart';

// 各情報のクラス
import '../../data/models/task_class.dart';
import '../../data/models/room_class.dart';
import '../../data/controller/room_manager.dart';
import '../../data/controller/task_manager.dart';
import 'package:task_maid/data/controller/msg_manager.dart';
import '../../data/controller/user_manager.dart';

// 通信用のクラス
import '../../data/models/component_communication.dart';
import 'package:http/http.dart' as http; // http

class PageTask extends StatefulWidget {
  final Room nowRoomInfo;

  const PageTask({
    required this.nowRoomInfo,
    Key? key,
  }) : super(key: key);

  @override
  _PageTask createState() => _PageTask(
        nowRoomInfo: nowRoomInfo,
      );
}

class _PageTask extends State<PageTask> {
  // textfieldを初期化したり中身の有無を判定するためのコントローラー
  final TextEditingController _messageController = TextEditingController();
    final TextEditingController serchIdController = TextEditingController();
  // final TextEditingController _controller = TextEditingController();

  // タスク作成時のフォームに使うコントローラー
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController taskThinkController = TextEditingController();

  // 部屋番号のコントローラー
  final TextEditingController roomNumController = TextEditingController();
  // 部屋名のコントローラー
  final TextEditingController roomNameController = TextEditingController();

  // サイドバー表示用のkey
  var sideBarKey = GlobalKey<ScaffoldState>();

  // 画面の再構築メソッド
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void reloadWidgetTree() {
    _scaffoldKey.currentState?.reassemble();
  }

  // インスタンス呼び出し
  final TaskManager taskManager = TaskManager();
  final RoomManager roomManager = RoomManager();
  final MsgManager msgManager = MsgManager();
  final UserManager userManager = UserManager();
  // 現在の部屋を取得
  Room nowRoomInfo;
  _PageTask({required this.nowRoomInfo});

  // タスク作成時などに使う保存用変数
  String dateText = '期日を入力してね';
  String please = 'リスケしてほしい日付を入力してね';
  String worker = '';
  String newTask = '0000';
  DateTime limitTime = DateTime.now();

  // メインルームidを保存

  // リーダーチェック
  bool leaderCheck() {
    bool result = false;
    // リストが空じゃなければ
    for (int i = 0; i < nowRoomInfo.leaders.length; i++) {
      if (nowRoomInfo.leaders == userManager.getId()) {
        result = true;
        break;
      }
    }
    return result;
  }

  // ボタン色替え検討措置　うまくいかないね
  List workerBottun = [true];
  void workerSelectButton() {
    workerBottun = [];
    for (int i = 0; i < nowRoomInfo.workers.length + 1; i++) {
      workerBottun.add(false);
    }
    setState(() {});
  }

  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    workerSelectButton();
  }

  bool memberDisplay = false;
  bool roomDisplay = false;
  bool subRoomAddDisplay = false;
  String newSubRoomName = '';
  bool exit = false;
  bool exitConfirmation = false;
  // サイドバー
  Widget sideBar() {
    // 画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: ListView(
        children: [
          // なんか画像入れる？
          // ヘッダー
          DrawerHeader(
            child: Text(nowRoomInfo.roomName),
            decoration: BoxDecoration(
              color: Constant.main,
            ),
          ),
          ListTile(
            title: CustomText(
              text: '${nowRoomInfo.roomNumber}号室',
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ここにメニュータップ時の処理を記述
              setState(() {
                exit = !exit;
                exitConfirmation = false;
              });
            },
          ),

          exit
              ? ListTile(
                  title: CustomText(text: '退出しますか？', fontSize: screenSizeWidth * 0.035, color: Constant.red),
                  onTap: () {
                    setState(() {
                      exitConfirmation = !exitConfirmation;
                    });
                  },
                )
              : const SizedBox.shrink(),

          exitConfirmation
              ? ListTile(
                  title: CustomText(text: 'いいえ', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                  onTap: () {
                    setState(() {
                      exit = false;
                      exitConfirmation = false;
                    });
                  },
                )
              : const SizedBox.shrink(),

          exitConfirmation
              ? ListTile(
                  title: CustomText(text: 'はい', fontSize: screenSizeWidth * 0.035, color: Constant.red),
                  onTap: () {
                    // ユーザーのidを削除
                    nowRoomInfo.leaders.remove(userManager.getId());
                    nowRoomInfo.workers.remove(userManager.getId());

                    // 退室処理呼び出し
                    roomManager.deleat(nowRoomInfo);

                    // 手持ちのデータを更新
                    nowRoomInfo = roomManager.findByindex(0);
                    

                    taskManager.load();

                    setState(() {
                      exit = false;
                      exitConfirmation = false;
                    });
                  },
                )
              : const SizedBox.shrink(),

          ListTile(
            // 左側に表示される
            leading: const Icon(Icons.account_box_outlined),
            // まんなか
            title: CustomText(
              text: "メンバー",
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ここにメニュータップ時の処理を記述
              // メンバー一覧が見れる
              setState(() {
                memberDisplay = !memberDisplay;
              });
            },
          ),
          // 開かれるメンバー一覧　アイコンあったほうがいいですね、、、
          // 現在はidの表示　名前を　出したい
          for (int i = 0; i < nowRoomInfo.workers.length; i++)
            memberDisplay
                ? ListTile(
                    leading: i == 0 ? const Icon(Icons.horizontal_rule) : const SizedBox.shrink(),
                    title: Row(children: [
                      // leaderCheck() ? const Icon(Icons.military_tech) : const Icon(Icons.horizontal_rule),
                      // 改築予定
                      // なんかとれないね
                      CustomText(text: '\t${userManager.getName(nowRoomInfo.workers[i])}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
                    ]),
                    // リーダーはタップでDMにとべる
                    onTap: () {
                      if (leaderCheck()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageMassages(
                                    messageRoom: nowRoomInfo,
                                  )),
                        ).then((value) {
                          //戻ってきたら再描画
                          setState(() {});
                        });
                      }
                    },
                  )
                : const SizedBox.shrink(),

          ListTile(
            leading: const Icon(Icons.map),
            title: CustomText(
              text: "ルームマップ",
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ここにメニュータップ時の処理を記述
              setState(() {
                roomDisplay = !roomDisplay;
              });
            },
          ),

          for (int i = 0; i < nowRoomInfo.sameGroupId.length; i++)
            roomDisplay
                ? ListTile(
                    leading: nowRoomInfo.roomid == nowRoomInfo.sameGroupId[i].toString() ? const Icon(Icons.horizontal_rule) : const SizedBox.shrink(),
                    title: Row(children: [
                      // subRoomであれば鍵アイコン
                      roomManager.findByroomid(nowRoomInfo.sameGroupId[i].toString()).subRoom == 1 ? const Icon(Icons.key_rounded) : const Icon(Icons.sensor_door),
                      CustomText(text: '\t\t\t${roomManager.findByroomid(nowRoomInfo.sameGroupId[i].toString()).roomName}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
                    ]),
                    // タップで該当の部屋にとべる
                    onTap: () {
                      // saveMainRoom();
                      nowRoomInfo = roomManager.findByroomid(nowRoomInfo.sameGroupId[i].toString());
                      // nowRoomid = subRooms[i]['room_id'];
                      setState(() {});
                    },
                  )
                : const SizedBox.shrink(),

          ListTile(
            leading: const Icon(Icons.login),
            title: CustomText(
              text: "サブルームの追加",
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              setState(() {
                subRoomAddDisplay = !subRoomAddDisplay;
              });
            },
          ),

          subRoomAddDisplay
              ? ListTile(
                  title: TextField(
                    controller: roomNameController,
                    decoration: const InputDecoration(
                      hintText: '部屋の名前を入力してね',
                    ),
                    onChanged: (newroomname) {
                      newSubRoomName = newroomname;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                  trailing: IconButton(
                      onPressed: () async {
                        if (roomNameController.text.isNotEmpty) {
                          roomDisplay = false;
                          FocusScope.of(context).unfocus(); //キーボードを閉じる

                          // 部屋の追加
                          roomManager.add(
                            nowRoomInfo,
                            newSubRoomName,
                            [userManager.getId()],
                            nowRoomInfo.workers,
                            [],
                            1,
                            taskManager,
                          );

                          setState(() {});

                          // 入力フォームの初期化
                          roomNameController.clear();
                          roomNumController.clear();

                          Navigator.of(context).pop(); //もどる
                        }
                      },
                      icon: Icon(Icons.key)),
                )
              : const SizedBox.shrink(),

          ListTile(
            leading: const Icon(Icons.check),
            title: CustomText(
              text: "タスク一覧",
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => page_taskSetting(
                          nowRoomInfo: nowRoomInfo,
                        )),
              ).then((value) {
                setState(() {});
              });
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock_outlined),
            title: CustomText(
              text: "権限の編集",
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page_roomSetting()),
              ).then((value) {
                setState(() {});
              });
            },
          )
        ],
      ),
    );
  }

  // タスク表示の処理
  Widget taskList() {
    List<Task> taskDatas = taskManager.findByRoomid(nowRoomInfo.roomid);

    return ListView.builder(
      // indexの作成 widgetが表示される数
      // 現在の部屋の情報からタスクの数を取得
      itemCount: taskDatas.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskDatas[index].status == 0
            ? Card(
                color: Constant.glay.withAlpha(0),
                elevation: 0,
                child: // タスクの状態を判定して表示
                    InkWell(
                        onTap: () {
                          // 詳細ダイアログ表示
                          showDialog(
                              context: context,
                              barrierDismissible: false, // ユーザーがダイアログ外をタップして閉じられないようにする
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    elevation: 0.0, // ダイアログの影を削除
                                    backgroundColor: Constant.white.withOpacity(0), // 背景色
                                    // 中身
                                    content: taskDialog(taskDatas, index));
                              });
                        },
                        // 繰り返し表示されるひな形呼び出し
                        child: taskCard(taskDatas, index)))
            : const SizedBox.shrink();
      },
    );
  }

  // -タスクを繰り返し表示する際のひな形
  Widget taskCard(List<Task> taskList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
        width: screenSizeWidth * 0.95,
        height: screenSizeHeight * 0.1,
        padding: EdgeInsets.only(right: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
        //alignment: const Alignment(0.0, 0.0), //真ん中に配置
        decoration: BoxDecoration(
          color: Constant.glay,
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
                    child: CustomText(
                        text: '${DateTime.parse(taskList[index].taskLimit).hour}:${DateTime.parse(taskList[index].taskLimit).minute}まで\n-------------------------------',
                        fontSize: screenSizeWidth * 0.035,
                        color: Constant.blackGlay)),
                // 中身
                Container(
                    width: screenSizeWidth * 0.625, alignment: Alignment.centerLeft, child: CustomText(text: taskList[index].contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay))
              ]))
        ]));
  }

  // -詳細ダイアログの中身
  Widget taskDialog(List<Task> taskList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenSizeWidth * 0.8,
      height: screenSizeHeight * 0.465,
      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // タスク内容表示
          Container(
            child: Column(
              children: [
                Container(
                    width: screenSizeWidth * 0.4,
                    height: screenSizeHeight * 0.05,
                    alignment: const Alignment(0.0, 0.0),
                    margin: EdgeInsets.only(top: screenSizeWidth * 0.03, bottom: screenSizeWidth * 0.02),
                    child: CustomText(text: "詳細", fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay)),

                // 箱の中身
                Container(
                    width: screenSizeWidth * 0.6,
                    height: screenSizeHeight * 0.2,
                    padding: EdgeInsets.all(screenSizeWidth * 0.05),
                    alignment: const Alignment(0.0, 0.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Constant.white),
                    child: Column(children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        CustomText(text: '期限：${dateformat(taskList[index].taskLimit, 3)}\n-------------------------------', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                      ]),
                      SizedBox(
                        height: screenSizeHeight * 0.01,
                      ),

                      // タスク内容の表示
                      CustomText(text: taskList[index].contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                    ])),

                Container(
                    alignment: const Alignment(0.0, 0.0),
                    margin: EdgeInsets.only(top: screenSizeHeight * 0.02, left: screenSizeWidth * 0.03, bottom: screenSizeHeight * 0.0225
                        //right: screenSizeWidth * 0.05,
                        ),
                    padding: EdgeInsets.only(left: screenSizeWidth * 0.02, right: screenSizeWidth * 0.02),
                    child: Row(children: [
                      // できました！！ボタン
                      msgbutton(0, taskList[index]),
                      SizedBox(
                        width: screenSizeWidth * 0.035,
                      ),
                      msgbutton(leaderCheck() ? 1 : 2, taskList[index])
                    ])),
              ],
            ),
          ),

          // 戻るボタン
          InkWell(
            onTap: () {
              Navigator.of(context).pop(); //もどる
            },
            child: Container(
              width: screenSizeWidth * 0.3,
              height: screenSizeHeight * 0.05,
              alignment: const Alignment(0.0, 0.0),
              margin: EdgeInsets.all(screenSizeWidth * 0.01),
              decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
              child: CustomText(text: "もどる", fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
            ),
          )
        ],
      ),
    );
  }

  // -ボタンのタイプを決める
  List buttuntypeSelect(int type) {
    String buttunMsg = '';
    Color buttunColor = Constant.white;
    Color fontColor = Constant.blackGlay;

    // 引数に合わせて変数を変更
    switch (type) {
      case 0:
        buttunMsg = 'できました\n！！！！！！';
        buttunColor = Constant.white;
        fontColor = Constant.blackGlay;
        break;
      case 1:
        buttunMsg = '進捗どう\nですか？？？';
        buttunColor = const Color.fromARGB(255, 184, 35, 35);
        fontColor = Constant.glay;
        break;
      case 2:
        buttunMsg = 'リスケお願いします！！！';
        buttunColor = const Color.fromARGB(255, 184, 35, 35);
        fontColor = Constant.glay;
    }

    // リストに格納して返す
    List buttunType = [buttunMsg, buttunColor, fontColor];
    return buttunType;
  }

  // -できましたボタン or 進捗どうですか or リスケお願いしますボタン
  Widget msgbutton(
    int type,
    Task task,
  ) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    String nowRoomid = nowRoomInfo.roomid;

    // MsgManager msgManager = nowRoomInfo.msgManager;

    // ボタンに表示する文字を管理する変数
    List buttunType = buttuntypeSelect(type);
    return InkWell(
      onTap: () async {
        if (type == 0 || type == 2) {
          // できました！！またはリスケ申請であれば更新処理
          taskManager.update(task, task.contents, type == 0 ? 1 : 2, task.taskLimit, task.worker);

          setState(() {});
        }

        // dbにメッセージ追加
        switch (type) {
          case 0:
            msgManager.add('できました！！！！！！！', 3, 0, task.taskid, 0, nowRoomid);
            break;
          case 1:
            msgManager.add('進捗どうですか？？？？？？？', 1, 0, task.taskid, 5, nowRoomid);
            break;
          case 2:
            // 建設予定
            // データの取り出し、決定ボタンを押したら遷移の処理
            DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onConfirm: (date) {
              setState(() {
                limitTime = date;
                please = '${date.year}年${date.month}月${date.day}日${date.hour}時${date.minute}分';
              });
            }, currentTime: DateTime.now(), locale: LocaleType.jp);
            msgManager.add('リスケお願いします', 3, 0, task.taskid, 2, nowRoomid);
        }

        // dbから取り出し
        // items.message = await DatabaseHelper.queryAllRows('msg_chats');
        // ページ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageMassages(
                    messageRoom: nowRoomInfo,
                  )),
        ).then((value) {
          //戻ってきたら再描画
          setState(() {
            Navigator.pop(context);
          });
        });
      },
      child: Container(
        width: screenSizeWidth * 0.275,
        height: screenSizeWidth * 0.15,
        padding: EdgeInsets.all(screenSizeWidth * 0.01),
        alignment: const Alignment(0.0, 0.0),
        decoration: BoxDecoration(color: buttunType[1], borderRadius: BorderRadius.circular(10)),
        child: CustomText(text: buttunType[0], fontSize: screenSizeWidth * 0.04, color: buttunType[2]),
      ),
    );
  }

  // 部屋を作成するためのaddボタン
  Widget addRoom() {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    return IconButton(
      onPressed: () {
        Navigator.pop(context); // 前のページに戻る
        // ダイアログ表示 ここで部屋を作成
        // 新規の番号もらってくる
        // サーバー処理設置願い
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // 部屋作成用の値を仮置きする変数
              String newRoomName = '';
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0.0, // ダイアログの影を削除
                  backgroundColor: Constant.white.withOpacity(0), // 背景色

                  content: Container(
                      width: screenSizeWidth * 0.9,
                      height: screenSizeHeight * 0.25,
                      padding: EdgeInsets.only(left: screenSizeWidth * 0.03, right: screenSizeWidth * 0.03, top: screenSizeWidth * 0.05, bottom: screenSizeWidth * 0.05),
                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.all(screenSizeWidth * 0.02),
                          alignment: Alignment(0, 0),
                          child: CustomText(text: '新規作成', fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay),
                        ),

                        Container(
                            width: screenSizeWidth * 0.5,
                            height: screenSizeHeight * 0.04,
                            alignment: const Alignment(0.0, 0.0),
                            margin: EdgeInsets.all(screenSizeWidth * 0.03),

                            // テキストフィールド
                            child: TextField(
                              controller: roomNameController,
                              decoration: const InputDecoration(
                                hintText: '部屋の名前を入力してね',
                              ),
                              onChanged: (newroomname) {
                                newRoomName = newroomname;
                              },
                              textInputAction: TextInputAction.done,
                            )),

                        // 作成ボタン
                        InkWell(
                          onTap: () async {
                            // String newRoomid = '4567';
                            // 入力フォームが空じゃなければ
                            if (roomNameController.text.isNotEmpty) {
                              FocusScope.of(context).unfocus(); //キーボードを閉じる
                              // 仮置き
                              // 部屋を追加
                              roomManager.add(nowRoomInfo, newRoomName, [userManager.getId()], [userManager.getId()], [], 0, taskManager);
                            }

                            // 現在の部屋の切り替えと変数の上書き
                            // nowRoomid = newRoomid;

                            // 0.5秒間待機
                            await Future.delayed(const Duration(milliseconds: 500));

                            nowRoomInfo = roomManager.findByindex(roomManager.count() - 1);
                            setState(() {});
                            // 入力フォームの初期化
                            roomNameController.clear();
                            roomNumController.clear();
                            Navigator.of(context).pop(); //もどる
                          },
                          child: Container(
                            width: screenSizeWidth * 0.25,
                            alignment: Alignment(0, 0),
                            padding: EdgeInsets.only(left: screenSizeWidth * 0.03, right: screenSizeWidth * 0.03, top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                            margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
                            decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                            child: CustomText(text: '作成', fontSize: screenSizeWidth * 0.05, color: Constant.glay),
                          ),
                        )
                      ])));
            });
      },
      icon: const Icon(
        Icons.add,
        size: 35,
        color: Constant.blackGlay,
      ),
    );
  }

  // 現在参加中の部屋のリスト表示
  Widget joinRoom() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenSizeWidth * 0.7,
      height: screenSizeHeight * 0.35,
      // 繰り返し表示
      child: ListView.builder(
        itemCount: roomManager.count() + 1,
        itemBuilder: (context, index) {
          // 最後のうぃじぇっとがaddRoomになるよう条件付け
          return index != roomManager.count() && roomManager.findByindex(index).subRoom == 0
              ? Card(
                  color: Constant.glay.withAlpha(0),
                  elevation: 0,
                  child: InkWell(
                    onTap: () async {
                      // 表示する部屋の切り替え
                      nowRoomInfo = roomManager.findByindex(index);
                      setState(() {});
                      Navigator.pop(context); // 前のページに戻る
                    },
                    child: Container(
                      width: screenSizeWidth * 0.7,
                      height: screenSizeHeight * 0.05,
                      decoration: BoxDecoration(
                        color: Constant.main,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: const Alignment(0, 0),
                      child: CustomText(
                        // db
                        text: roomManager.findByindex(index).roomName,
                        color: Constant.white,
                        fontSize: screenSizeWidth * 0.04,
                      ),
                    ),
                  ))
              : index == roomManager.count()
                  ? addRoom()
                  : const SizedBox.shrink();
        },
      ),
    );
  }

  // タスク追加ボタン
  Widget addTaskBottun() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    // MsgManager msgManager = nowRoomInfo.msgManager;

    return Container(
      alignment: Alignment.centerRight,
      child: IconButton(
        // ダイアログ表示
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return molecules.dialog(
                    context,
                    0.9,
                    0.4,
                    true,
                    Column(children: [
                      Container(
                        margin: EdgeInsets.all(screenSizeWidth * 0.02),
                        alignment: Alignment(0, 0),
                        child: CustomText(text: 'タスク追加', fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay),
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
                          width: screenSizeWidth * 0.5,
                          height: screenSizeHeight * 0.04,
                          alignment: const Alignment(0.0, 0.0),
                          margin: EdgeInsets.all(screenSizeWidth * 0.03),

                          // 内容
                          child: TextField(
                            controller: taskThinkController,
                            decoration: const InputDecoration(
                              hintText: 'タスク内容を入力してね',
                            ),
                            onChanged: (text) {},
                            textInputAction: TextInputAction.done,
                          )),

                      Container(child: CustomText(text: '誰に頼む？', fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay)),

                      Container(
                        height: screenSizeHeight * 0.1,
                        child: ListView.builder(
                          itemCount: nowRoomInfo.workers.length,
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
                                      worker = nowRoomInfo.workers[index];
                                    });

                                    //  items.friend[workerId]['bool'] = true;
                                    // setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                                    alignment: Alignment(0, 0),
                                    decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                    child: CustomText(text: userManager.getName(nowRoomInfo.workers[index]), fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
                                  ),
                                ));
                          },
                          // workerId を使って該当の情報を取得し、ウィジェットを生成する
                          //Map<String, dynamic> workerInfo = items.friend[workerId];
                        ),
                      ),

                      // タスク作成ボタン
                      InkWell(
                        onTap: () async {
                          // 空文字だったら通さない
                          if (taskThinkController.text.isNotEmpty) {
                            FocusScope.of(context).unfocus(); // キーボードを閉じる

                            // タスクの追加
                            Task last = await taskManager.add(taskThinkController.text, taskThinkController.text, limitTime.toString(), worker, nowRoomInfo.roomid);

                            Navigator.of(context).pop(); // 戻る
                            msgManager.add('がんばってください', 1, 0, last.taskid, 0, nowRoomInfo.roomid);

                            // 入力フォームの初期化
                            dateText = '期日を入力してね';
                            dayController.clear();
                            timeController.clear();
                            taskThinkController.clear();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => PageMassages(messageRoom: nowRoomInfo)),
                            );
                          }
                        },
                        child: Container(
                          width: screenSizeWidth * 0.25,
                          alignment: Alignment(0, 0),
                          padding: EdgeInsets.only(left: screenSizeWidth * 0.03, right: screenSizeWidth * 0.03, top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                          margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
                          decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                          child: CustomText(text: '作成', fontSize: screenSizeWidth * 0.05, color: Constant.white),
                        ),
                      )
                    ]));
              });
        },
        icon: Icon(Icons.add),
        iconSize: 35,
        color: Constant.glay,
      ),
    );
  }

  // サブルーム選択時のルーム名表示部分
  Widget subRoomName() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    // double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenSizeWidth * 0.625,
      alignment: Alignment(0, 0),
      padding: EdgeInsets.all(screenSizeWidth * 0.04),
      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: screenSizeWidth * 0.03),
      child: CustomText(text: nowRoomInfo.roomName, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
    );
  }

  // ルーム選択、検索ボタン
  Widget roomBottun() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    // 検索用変数
    
    return InkWell(
        onTap: () {
          // ダイアログ表示 現在加入中の部屋と検索バー表示
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return molecules.dialog(
                    context,
                    0.9,
                    0.465,
                    false,
                    Column(children: [
                      // 検索バー
                      Container(
                          width: screenSizeWidth * 0.7,
                          //height: screenSizeHeight * 0.067,
                          decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.all(screenSizeWidth * 0.02),
                          child: Column(children: [
                            Row(
                              children: [
                                // 検索アイコン
                                Container(
                                    margin: EdgeInsets.only(right: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
                                    child: const Icon(
                                      Icons.search,
                                      size: 30,
                                      color: Constant.blackGlay,
                                    )),

                                Container(
                                    width: screenSizeWidth * 0.4,
                                    height: screenSizeHeight * 0.04,
                                    alignment: const Alignment(0.0, 0.0),
                                    // テキストフィールド
                                    child: TextField(
                                      controller: serchIdController,
                                      decoration: const InputDecoration(
                                        hintText: '部屋番号を入力してね',
                                      ),
                                      onChanged: (serchID) {
                                        
                                      },
                                      textInputAction: TextInputAction.search,
                                    )),

                                    
                                SizedBox(
                                  width: screenSizeWidth * 0.01,
                                ),
                                // やじるし 検索ボタン
                                searchButton(serchIdController.text)
                              ],
                            ),
                            // 現在参加中部屋のリスト
                            joinRoom()
                          ])),
                    ]));
              });
        },
        // 現在のルーム名表示部分 ガワ
        child: Container(
          width: screenSizeWidth * 0.625,
          alignment: Alignment(0, 0),
          padding: EdgeInsets.all(screenSizeWidth * 0.04),
          decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(bottom: screenSizeWidth * 0.03),
          child: CustomText(text: nowRoomInfo.roomName, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
        ));
  }

  // Widget addTaskBotton(String serchID) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false, //デバッグの表示を消す

  //     // 非同期処理
  //     home: FutureBuilder<bool>(
  //       // ここに入れた処理を待ってreturnの中身を実行する
  //       // dbの有無を確認
  //       future: roomManager.serchRoomServer(serchID)
  //       // snapshotに非同期処理の進捗や結果が含まれる
  //       builder: (context, snapshot) {
  //         // connectionStateを参照
  //         // connectionStateに関する補足
  //         // connectionState.none まだ非同期処理が開始されていない
  //         // waiting 非同期処理を実行中で結果がまだ出ていない
  //         // active 非同期処理を実行中で、結果が出た
  //         // done 非同期処理が完了し、結果を受け取った
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Loading();
  //           //  CircularProgressIndicator(); // データベース確認中のローディング表示
  //           // エラー
  //         } else if (snapshot.hasError) {
  //           return Text('Error: ${snapshot.error}');

  //           // waitingでもerrorでもない = 結果を受け取っている
  //         } else {
  //           Navigator.of(context).pop(); // 戻る

  //           // dbに追加
  //           // 画面の更新
  //           // msg
  //           msgManager.add('がんばってください', 1, 0, taskManager.findByIndex(taskManager.count() - 1).taskid, 0, nowRoomInfo.roomid);
  //           return PageMassages(messageRoom: nowRoomInfo);
  //         }
  //       },
  //     ),
  //   );
  // }

  // -検索処理
  Widget searchButton(String searchID) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () async {
          FocusScope.of(context).unfocus(); //キーボードを閉じる
          Navigator.of(context).pop(); //もどる

          // 入力されていなければはじく
          if (serchIdController.text.isNotEmpty) {
            // roomNames = roomName(); // 変数の更新
            // roomIDをkeyにしてここで問い合わせ
            // 検索処理
            String searchRoomName = await roomManager.serchRoomServer(searchID);
            // Future.delayed(const Duration(milliseconds: 500));
            bool searchBool = searchRoomName != '既に参加しています' && searchRoomName != '検索結果はありません';

            // データベースさんへ問い合わせた結果を表示するダイアログ
            showDialog(
                context: context,
                barrierDismissible: true, // ユーザーがダイアログ外をタップして閉じられないようにする
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 0.0, // ダイアログの影を削除
                    backgroundColor: Constant.white.withOpacity(0), // 背景色

                    content: Container(
                      width: screenSizeWidth * 0.95,
                      height: screenSizeHeight * 0.215,
                      alignment: const Alignment(0.0, 0.0),
                      padding: EdgeInsets.all(screenSizeWidth * 0.05),
                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        children: [
                          // 検索結果の表示
                          Container(
                            width: screenSizeWidth * 0.7,
                            // height: screenSizeHeight * 0.05,
                            alignment: const Alignment(0.0, 0.0),
                            margin: EdgeInsets.only(
                              top: screenSizeWidth * 0.0475,
                              bottom: screenSizeWidth * 0.02,
                            ),
                            child: CustomText(text: searchRoomName, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
                          ),

                          // 参加しますか？
                          searchBool
                              ? Container(
                                  width: screenSizeWidth * 0.9,
                                  alignment: const Alignment(0.0, 0.0),
                                  margin: EdgeInsets.only(left: screenSizeWidth * 0.05),
                                  child: Row(
                                    children: [
                                      // 「はい」
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(); //もどる
                                            // サーバーに参加問い合わせ
                                            // 既に参加しています or 参加申請を送りました
                                            // 結果
                                            // 参加確定に変更
                                            // TODO: みらいのわたしさんへ なおしてください
                                            roomManager.joinRoom();
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16.0),
                                                      ),
                                                      elevation: 0.0, // ダイアログの影を削除
                                                      backgroundColor: Constant.white.withOpacity(0), // 背景色
                                                      content: Container(
                                                        width: screenSizeWidth * 0.8,
                                                        height: screenSizeHeight * 0.215,
                                                        alignment: const Alignment(0, 0),
                                                        decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                                        child: CustomText(text: "参加しました！", fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay),
                                                      ));
                                                });

                                            // サーバーに参加申請処理願い
                                            // 部屋情報のdbに申請中ユーザーのidを保持する列をつくればよいのではないか
                                          },
                                          // ボタン
                                          child: dialogButton(true, 0.2)),
                                      // 「いいえ」
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(); //もどる
                                          },
                                          // ボタン
                                          child: dialogButton(false, 0.2)),
                                    ],
                                  ))
                              // 検索結果なし
                              : InkWell(
                                  onTap: () {
                                    // ここに処理
                                    Navigator.of(context).pop(); //もどる
                                  },
                                  child: dialogButton(true, 0.3))
                        ],
                      ),
                    ),
                  );
                });
          }
          setState(() {
            _messageController.clear(); // 入力フォームの初期化
          });
        },
        icon: const Icon(
          Icons.send,
          color: Constant.blackGlay,
          size: 30,
        ));
  }

  // -ダイアログ用ボタンのガワ
  Widget dialogButton(bool type, double size) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenSizeWidth * size,
      height: screenSizeHeight * 0.05,
      margin: EdgeInsets.all(screenSizeWidth * 0.02),
      padding: EdgeInsets.all(screenSizeWidth * 0.02),
      alignment: const Alignment(0.0, 0.0),
      decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
      child: CustomText(text: type ? 'はい' : 'いいえ', fontSize: screenSizeWidth * 0.035, color: Constant.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    return ChangeNotifierProvider<TaskManager>(
      create: (context) => taskManager,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: sideBarKey,
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: Center(
              child: Container(
                width: screenSizeWidth,
                height: screenSizeHeight,
                decoration: const BoxDecoration(color: Constant.main),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: screenSizeWidth,
                            // バー部分
                            child: Row(
                              children: [
                                molecules.PageTitle(context, 'タスク', 1, PageHome()),
                                SizedBox(
                                  width: screenSizeWidth * 0.3,
                                ),
                                // タスク追加ボタン　リーダーのみ表示
                                //leaderCheck()
                                // メインタスクはリーダーのみ追加可能
                                addTaskBottun(), // 修正: addTaskBottun() -> addTaskButton()

                                // サイドバーを開く
                                IconButton(
                                  onPressed: () {
                                    sideBarKey.currentState!.openEndDrawer();
                                  },
                                  icon: const Icon(
                                    Icons.menu,
                                    color: Constant.glay,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 現在表示しているルームのボタン
                          // ここからルーム選択、検索、追加ができる
                          nowRoomInfo.subRoom == 1 ? subRoomName() : roomBottun(), // 修正: roomBottun() -> roomButton()

                          // タスク表示
                          SizedBox(
                            width: screenSizeWidth * 0.95,
                            height: screenSizeHeight * 0.7,
                            child: taskList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // サイドバー設定
        endDrawer: sideBar(), // 修正: sideBar() の呼び出し方を確認
      ),
    );
  }
}
