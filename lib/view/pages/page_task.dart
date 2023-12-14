import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:task_maid/view/pages/page_roomSetting.dart';
import 'package:task_maid/view/pages/page_taskSetting.dart';
import '../constant.dart';
import '../items.dart';
import 'page_messages.dart';
import '../molecules.dart';
import 'package:task_maid/database_helper.dart';

class PageTask extends StatefulWidget {
  // どこの部屋のタスクを参照したいのか引数でもらう
  final List nowRoomInfo;

  const PageTask({required this.nowRoomInfo, Key? key}) : super(key: key);

  @override
  _PageTask createState() => _PageTask(nowRoomInfo: nowRoomInfo);
}

class _PageTask extends State<PageTask> {
  // textfieldを初期化したり中身の有無を判定するためのコントローラー
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

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

  // 参照したい部屋の情報を引数にもらう
  List nowRoomInfo;
  _PageTask({required this.nowRoomInfo});

  // static String roomNames = roomName();
  static String nowRoomid = ''; // どのmyroomidを選ぶかのために使う 現在のデフォはてすとるーむ
  static String dateText = '期日を入力してね';
  static String please = 'リスケしてほしい日付を入力してね';
  static int karioki2 = 4587679;

  // 変数まとめ
  List joinRoomInfo = items.rooms;

  List subRooms = [];
  List<dynamic> decodedLeaders = [];
  List<dynamic> decodedWorkers = [];
  List<dynamic> decodedTasks = [];
  List<dynamic> decodedSubRooms = [];
  List nowRoomTaskList = [];

  void dbroomInfo() async {
    // db取り出し
    joinRoomInfo = await DatabaseHelper.queryAllRows('rooms');
    subRooms = await DatabaseHelper.selectSubRoom(nowRoomid);
  }

  // JSON文字列をデコードしてListを取得する関数
  List<dynamic> decodeJsonList(String jsonString) {
    return jsonDecode(jsonString);
  }

  // 今の部屋
  dbnowRoom() async {
    Future<List<Map<String, dynamic>>> result = DatabaseHelper.selectRoom(nowRoomid);
    nowRoomInfo = await result;
    // データベースから取得したデータをデコードして使用
    if (nowRoomInfo.isNotEmpty) {
      decodedLeaders = decodeJsonList(nowRoomInfo[0]['leaders']);
      decodedWorkers = decodeJsonList(nowRoomInfo[0]['workers']);
      decodedTasks = decodeJsonList(nowRoomInfo[0]['tasks']);
      decodedSubRooms = decodeJsonList(nowRoomInfo[0]['sub_rooms']);
    }
    // print(decodedLeaders);
    setState(() {});
  }

  // 現在のタスクを参照する
  taskGet() async {
    // nowRoomTaskList = await DatabaseHelper.queryRowtask(nowRoomid);
    nowRoomTaskList = await DatabaseHelper.queryRowtaskss(nowRoomid, items.userInfo['userid']);
    // print('しゅとくしてください');
    // print(nowRoomTaskList);
  }

// リーダーチェック
  bool leaderCheck() {
    bool result = false;
    // リストが空じゃなければ
    if (nowRoomInfo.isNotEmpty) {
      for (int i = 0; i < decodedLeaders.length; i++) {
        if (decodedLeaders[i]["leader"] == items.userInfo['userid']) {
          result = true;
          break;
        }
      }
    }
    return result;
  }

  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    // インスタンスメンバーを初期化
    nowRoomInfo = widget.nowRoomInfo;
    nowRoomid = nowRoomInfo[0]['room_id'];
    dbnowRoom();
    dbroomInfo();
    taskGet();
  }

  bool memberDisplay = false;
  bool roomDisplay = false;
  bool subRoomAddDisplay = false;
  String newSubRoomName = '';
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
            child: Text(nowRoomInfo[0]['room_name']),
            decoration: BoxDecoration(
              color: Constant.main,
            ),
          ),
          ListTile(
            title: CustomText(
              text: '${nowRoomInfo[0]['room_id']}号室',
              color: Constant.blackGlay,
              fontSize: screenSizeWidth * 0.035,
            ),
            onTap: () {
              // ここにメニュータップ時の処理を記述
            },
          ),

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
          for (int i = 0; i < decodedWorkers.length; i++)
            memberDisplay
                ? ListTile(
                    leading: i == 0 ? const Icon(Icons.horizontal_rule) : const SizedBox.shrink(),
                    title: Row(children: [
                      leaderCheck() ? const Icon(Icons.military_tech) : const Icon(Icons.horizontal_rule),
                      CustomText(text: '\t${decodedWorkers[i]['worker']}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
                    ]),
                    // リーダーはタップでDMにとべる
                    onTap: () {
                      if (leaderCheck()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageMassages(
                                    messenger: nowRoomInfo[0],
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

          for (int i = 0; i < decodedSubRooms.length; i++)
            roomDisplay
                ? ListTile(
                    leading: i == 0 ? const Icon(Icons.horizontal_rule) : const SizedBox.shrink(),
                    title: Row(children: [
                      decodedSubRooms[i]['sub_room'].contains('-') ? const Icon(Icons.key_rounded) : const Icon(Icons.sensor_door),
                      CustomText(text: i == 0 ? '\t\t${nowRoomInfo[0]['room_name']}' : '\t\t\t${subRooms[i - 1]['room_name']}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
                    ]),
                    // タップで該当の部屋にとべる
                    onTap: () {},
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
                setState(() {
                  items.Nums();
                });
              });
            },
          ),

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
                          // 仮置き
                          // ここでサーバーに数字をもらう
                          // ユーザーが見える形で置いておく必要がある

                          // 追加する部屋の変数
                          // roomidはサーバー側で決められるようにしたい
                          var leaders = [
                            {'leader': items.userInfo['userid']}
                          ];
                          var workers = [
                            {'worker': items.userInfo['userid']}
                          ];
                          var tasks = [{}];

                          String newRoomid = '${nowRoomid}-4567';

                          // db追加メソッド呼び出し
                          dbAddSubRoom(newRoomid, newSubRoomName, leaders, workers, tasks, nowRoomid);
                          Map addrecode = {'sub_room': newRoomid};

                          decodedSubRooms.add(addrecode);

                          // 上書き
                          Map<String, dynamic> newRoomInfo = {
                            'room_id': nowRoomid,
                            'room_name': nowRoomInfo[0]['room_name'],
                            'leaders': jsonEncode(decodedLeaders),
                            'workers': jsonEncode(decodedWorkers),
                            'tasks': jsonEncode(decodedTasks),
                            'sub_rooms': jsonEncode(decodedSubRooms)
                          };

                          // newRoomInfo['subrooms'] = jsonEncode(decodedSubRooms);
                          DatabaseHelper.update('rooms', 'room_name', newRoomInfo, nowRoomInfo[0]['room_name']);

                          // db呼び出し
                          // nowRoomid = newRoomid;
                          joinRoomInfo = await DatabaseHelper.queryAllRows('rooms');
                          dbroomInfo();
                          dbnowRoom();
                          taskGet();
                          setState(() {});

                          // 入力フォームの初期化
                          roomNameController.clear();
                          roomNumController.clear();

                          Navigator.of(context).pop(); //もどる
                          // items.myroom.add(newRoomid);
                        }
                      },
                      icon: Icon(Icons.key)),
                )
              : const SizedBox.shrink(),

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
                setState(() {
                  items.Nums();
                });
              });
            },
          )
        ],
      ),
    );
  }

  // タスク表示の処理
  Widget taskList() {
    taskGet();
    return ListView.builder(
      // indexの作成 widgetが表示される数
      // 現在の部屋の情報からタスクの数を取得
      itemCount: nowRoomTaskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return nowRoomTaskList[index]['status_progress'] == 0
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
                                    content: taskDialog(nowRoomTaskList, index));
                              });
                        },
                        // 繰り返し表示されるひな形呼び出し
                        child: taskCard(nowRoomTaskList, index)))
            : const SizedBox.shrink();
      },
    );
  }

  // -タスクを繰り返し表示する際のひな形
  Widget taskCard(List taskList, int index) {
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

  // -詳細ダイアログの中身
  Widget taskDialog(List taskList, int index) {
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
                        CustomText(
                            text: '依頼者：${taskList[index]['leaders']}\n期限：${dateformat(taskList[index]['task_limit'], 3)}\n-------------------------------',
                            fontSize: screenSizeWidth * 0.035,
                            color: Constant.blackGlay),
                      ]),
                      SizedBox(
                        height: screenSizeHeight * 0.01,
                      ),

                      // タスク内容の表示
                      CustomText(text: taskList[index]['contents'], fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                    ])),

                Container(
                    alignment: const Alignment(0.0, 0.0),
                    margin: EdgeInsets.only(top: screenSizeHeight * 0.02, left: screenSizeWidth * 0.03, bottom: screenSizeHeight * 0.0225
                        //right: screenSizeWidth * 0.05,
                        ),
                    padding: EdgeInsets.only(left: screenSizeWidth * 0.02, right: screenSizeWidth * 0.02),
                    child: Row(children: [
                      // できました！！ボタン
                      msgbutton(0, taskList, index),
                      SizedBox(
                        width: screenSizeWidth * 0.035,
                      ),
                      msgbutton(leaderCheck() ? 1 : 2, taskList, index)
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
  Widget msgbutton(int type, List taskList, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    // ボタンに表示する文字を管理する変数
    List buttunType = buttuntypeSelect(type);
    return InkWell(
      onTap: () async {
        if (type == 0 || type == 2) {
          // できました！！またはリスケ申請であればdb書き換え
          Map<String, dynamic> updateTask = {
            'task_id': taskList[index]['task_id'],
            'task_limit': taskList[index]['task_limit'],
            'status_progress': type,
            'leaders': taskList[index]['leaders'],
            'worker': taskList[index]['worker'],
            'room_id': taskList[index]['room_id'],
            'contents': taskList[index]['contents']
          };
          DatabaseHelper.update('tasks', 'contents', updateTask, taskList[index]['contents']);
          setState(() {});
        }

        // dbにメッセージ追加
        switch (type) {
          case 0:
            addMessage(karioki2, 'できました！！！！！！！', 3, index, 0, taskList[index]['room_id']);
            break;
          case 1:
            addMessage(karioki2, '進捗どうですか？？？？？？？', 1, index, 5, taskList[index]['room_id']);
            break;
          case 2:
            // 建設予定
            // データの取り出し、決定ボタンを押したら遷移の処理
            DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onConfirm: (date) {
              setState(() {
                items.limitTime = date;
                please = '${date.year}年${date.month}月${date.day}日${date.hour}時${date.minute}分';
              });
            }, currentTime: DateTime.now(), locale: LocaleType.jp);

            addMessage(karioki2, 'リスケお願いします', 3, index, 2, nowRoomTaskList[index]['room_id']);
        }

        // dbから取り出し
        items.message = await DatabaseHelper.queryAllRows('msg_chats');
        // ページ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageMassages(
                    messenger: nowRoomInfo[0],
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
                            String newRoomid = '4567';
                            // 入力フォームが空じゃなければ
                            if (roomNameController.text.isNotEmpty) {
                              FocusScope.of(context).unfocus(); //キーボードを閉じる
                              // 仮置き
                              // ここでサーバーに数字をもらう
                              // ユーザーが見える形で置いておく必要がある
                              // サイドバーの上部に置いておけばよろしと今思いました　そうします
                              newRoomid = '4567';

                              // 追加する部屋の変数
                              // roomidはサーバー側で決められるようにしたい
                              var leaders = [
                                {'leader': items.userInfo['userid']}
                              ];
                              var workers = [
                                {'worker': items.userInfo['userid']}
                              ];
                              var tasks = [{}];

                              // db追加メソッド呼び出し
                              dbAddRoom(newRoomid, newRoomName, leaders, workers, tasks);
                              items.myroom.add(newRoomid);
                            }

                            // 現在の部屋の切り替えと変数の上書き
                            nowRoomid = newRoomid;
                            joinRoomInfo = await DatabaseHelper.queryAllRows('rooms');
                            dbnowRoom();
                            taskGet();
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
        itemCount: joinRoomInfo.length + 1,
        itemBuilder: (context, index) {
          return Card(
              color: Constant.glay.withAlpha(0),
              elevation: 0,
              child: index != joinRoomInfo.length
                  ? InkWell(
                      onTap: () async {
                        // 表示する部屋の切り替え
                        nowRoomid = joinRoomInfo[index]["room_id"];
                        await dbnowRoom();
                        print('タスクリスト更新');
                        taskGet();
                        // print(nowRoomTaskList);
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
                          text: joinRoomInfo[index]["room_name"],
                          color: Constant.white,
                          fontSize: screenSizeWidth * 0.04,
                        ),
                      ),
                    )
                  : addRoom());
        },
      ),
    );
  }

  // タスク追加ボタン
  Widget addTaskBottun() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

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
                                items.limitTime = date;
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
                            onChanged: (task) {
                              items.newtask = task;
                            },
                            textInputAction: TextInputAction.done,
                          )),

                      Container(child: CustomText(text: '誰に頼む？', fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay)),

                      Container(
                        height: screenSizeHeight * 0.1,
                        child: ListView.builder(
                          itemCount: decodedWorkers.length,
                          itemBuilder: (context, index) {
                            return Card(
                                color: Constant.glay,
                                elevation: 0,
                                child: InkWell(
                                  // ボタンの色替えを建設しろ
                                  onTap: () {
                                    // タスク追加用変数に代入を行っている
                                    items.worker = '12345';
                                    //  items.friend[workerId]['bool'] = true;
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                                    alignment: Alignment(0, 0),
                                    decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),

                                    // ここでサーバーから名前をもらってくる
                                    child: CustomText(text: decodedWorkers[index]['worker'], fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
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
                            // タスクを追加
                            // worker を改築
                            addTask(karioki2, items.userInfo['userid'], items.userInfo['userid'], items.newtask, items.limitTime, nowRoomid, 0);

                            // 入力フォームの初期化
                            dateText = '期日を入力してね';
                            dayController.clear();
                            timeController.clear();
                            taskThinkController.clear();

                            FocusScope.of(context).unfocus(); // キーボードを閉じる
                            Navigator.of(context).pop(); // 戻る
                            // 値の更新
                            items.taskList = await DatabaseHelper.queryAllRows('tasks');
                            // nowRoomTaskList = await DatabaseHelper.queryRowtask(nowRoomid);

                            // dbに追加
                            // print(nowRoomTaskList);
                            taskGet();
                            // 画面の更新
                            setState(() {});
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

  // ルーム選択、検索ボタン
  Widget roomBottun() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    // 検索用変数
    String searchID = 'ルームID';
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
                                      controller: _messageController,
                                      decoration: const InputDecoration(
                                        hintText: '部屋番号を入力してね',
                                      ),
                                      onChanged: (text) {
                                        searchID = text;
                                      },
                                      textInputAction: TextInputAction.search,
                                    )),
                                SizedBox(
                                  width: screenSizeWidth * 0.01,
                                ),
                                // やじるし 検索ボタン
                                searchButton(searchID)
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

          // ここかわるぞ
          // 改築予定
          // おわらんすぎる
          child: CustomText(text: nowRoomInfo[0]['room_name'], fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
        ));
  }

  // -検索処理
  Widget searchButton(String searchID) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return IconButton(
        onPressed: () {
          FocusScope.of(context).unfocus(); //キーボードを閉じる
          Navigator.of(context).pop(); //もどる

          // 入力されていなければはじく
          if (_messageController.text.isNotEmpty) {
            // roomNames = roomName(); // 変数の更新
            // roomIDをkeyにしてここで問い合わせ
            // ひとまずは仮の結果を用意する
            // 値が帰ってくるかを判別する変数
            // サーバー処理設置願い
            String searchRoomName = 'てすとてすと';
            bool searchBool = true;
            String falseResult = '検索結果はありません';

            String result = searchBool ? searchRoomName : falseResult;

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
                            child: CustomText(text: searchBool ? '${searchRoomName}\nに参加しますか？' : falseResult, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
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
                                            bool joinBool = true;
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
                                                        child: CustomText(text: joinBool ? '既に参加しています' : '参加申請を送りました', fontSize: screenSizeWidth * 0.05, color: Constant.blackGlay),
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
                                          child: dialogButton(true, 0.2)),
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

  // 表示部分
  @override
  Widget build(BuildContext context) {
    // items.Nums();

    // dbroomFirstAdd();
    // dbnowRoom();
    // dbroomInfo();
    // taskGet();

    // print(nowRoomInfo);

    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: sideBarKey,
        body: Center(
            child: Container(
          width: screenSizeWidth,
          height: screenSizeHeight,
          decoration: const BoxDecoration(color: Constant.main),
          child: SafeArea(
              child: Stack(children: [
            Column(
              children: [
                SizedBox(
                    width: screenSizeWidth,
                    // バー部分
                    child: Row(children: [
                      molecules.PageTitle(context, 'タスク'),
                      SizedBox(
                        width: screenSizeWidth * 0.3,
                      ),
                      // タスク追加ボタン　リーダーのみ表示
                      //leaderCheck()
                      true ? addTaskBottun() : const SizedBox.shrink(),

                      // サイドバーを開く
                      IconButton(
                          onPressed: () {
                            sideBarKey.currentState!.openEndDrawer();
                          },
                          icon: const Icon(
                            Icons.menu,
                            color: Constant.glay,
                            size: 35,
                          ))
                    ])),

                // 現在表示しているルームのボタン
                // ここからルーム選択、検索、追加ができる
                roomBottun(),

                // タスク表示
                SizedBox(width: screenSizeWidth * 0.95, height: screenSizeHeight * 0.7, child: taskList())
              ],
            ),
          ])),
        )),

        // サイドバー設定
        endDrawer: sideBar());
  }
}
