import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:task_maid/view/pages/page_home.dart';
import 'package:task_maid/view/pages/page_roomSetting.dart';
import 'package:task_maid/view/pages/page_taskSetting.dart';
import '../constant.dart';
import 'page_messages.dart';

import '../items.dart';
import '../molecules.dart';
import '../TaskManager.dart';
import '../task.dart';
import '../Room.dart';
import '../Room_manager.dart';
import 'package:task_maid/database_helper.dart';

import '../component_communication.dart';
import 'package:http/http.dart' as http; // http

class PageTask extends StatefulWidget {
  // どこの部屋のタスクを参照したいのか引数でもらう
  final Room nowRoomInfo;

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

  // クラス呼び出し
  TaskManager _taskManager = TaskManager();
  RoomManager _roomManager = RoomManager();

  // 参照したい部屋の情報を引数にもらう
  Room nowRoomInfo;
  _PageTask({required this.nowRoomInfo});

  // static String roomNames = roomName();
  // タスク作成時などに使う保存用変数
  String nowRoomid = ''; // どのmyroomidを選ぶかのために使う 現在のデフォはてすとるーむ
  String dateText = '期日を入力してね';
  String please = 'リスケしてほしい日付を入力してね';
  String worker = '';
  String newTask = '0000';
  DateTime limitTime = DateTime.now();
  static int karioki2 = 44487879;

  // 変数まとめ
  // List subRooms = [];

  // List nowRoomTaskList = [];
  // String main_room_id = '';

  // // 無限ループ対策
  // int dbCount = 1;
  // int dbCountFuture = 0;

  // // 今の部屋の詳細を取得
  // // 部屋切り替え時に使用
  // dbnowRoom() async {
  //   if (dbCount != dbCountFuture) {
  //     Future<List<Map<String, dynamic>>> result = DatabaseHelper.serachRows('rooms', 1, ['room_id'], [nowRoomid], 'room_id');
  //     nowRoomInfo = await result;
  //     // データベースから取得したデータをデコードして使用

  //     // 切り替え時に元がmainRoomだった場合そのidを保存
  //     saveMainRoom();
  //     // サブルームのデータを取得
  //     subRooms = await DatabaseHelper.serachRows('rooms', 1, ['main_room_id'], [main_room_id], 'room_id');
  //     taskGet();
  //     print(decodedWorkers);
  //   }
  // }

  // JSON文字列をデコードしてListを取得する関数
  List<dynamic> decodeJsonList(String jsonString) {
    return jsonDecode(jsonString);
  }

  // リーダーチェック
  bool leaderCheck() {
    bool result = false;
    // リストが空じゃなければ
    for (int i = 0; i < nowRoomInfo.leaders.length; i++) {
      if (nowRoomInfo.leaders == items.userInfo['userid']) {
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

  // // メインルームか判別してidを保存するメソッド
  // void saveMainRoom() {
  //   if (nowRoomInfo.subRoom == 0) {
  //     setState(() {
  //       nowRoomInfo = nowRoomInfo.roomid;
  //     });
  //   }
  // }

  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    // インスタンスメンバーを初期化
    nowRoomInfo = widget.nowRoomInfo;
    // dbCount++;
    // dbnowRoom();
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
              text: '${nowRoomInfo.roomid}号室',
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
                    exit = false;
                    exitConfirmation = false;
                  },
                )
              : const SizedBox.shrink(),

          exitConfirmation
              ? ListTile(
                  title: CustomText(text: 'はい', fontSize: screenSizeWidth * 0.035, color: Constant.red),
                  onTap: () {
                    // ユーザーのidを削除
                    nowRoomInfo.leaders.remove(items.userInfo['userid']);
                    nowRoomInfo.workers.remove(items.userInfo['userid']);
                    items.myroom.remove(items.userInfo['userid']);

                    // db更新
                    // サーバーに送信

                    // 退室処理呼び出し
                    _roomManager.deleat(nowRoomInfo);

                    // 手持ちのデータを更新
                    nowRoomInfo = _roomManager.findByindex(0);
                    _taskManager.load();

                    setState(() {});
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
                      leaderCheck() ? const Icon(Icons.military_tech) : const Icon(Icons.horizontal_rule),

                      // 改築予定
                      CustomText(text: '\t${nowRoomInfo.workers[i]}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
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

          for (int i = 0; i < nowRoomInfo.sameGroup.length; i++)
            roomDisplay
                ? ListTile(
                    leading: i == 0 ? const Icon(Icons.horizontal_rule) : const SizedBox.shrink(),
                    title: Row(children: [
                      // subRoomであれば鍵アイコン
                      _roomManager.findByindex(i).subRoom == 1 ? const Icon(Icons.key_rounded) : const Icon(Icons.sensor_door),
                      CustomText(text: '\t\t\t${_roomManager.findByindex(i).roomName}', fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)
                    ]),
                    // タップで該当の部屋にとべる
                    onTap: () {
                      // saveMainRoom();
                      nowRoomInfo = _roomManager.findByindex(i);
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
                          // 仮置き
                          // ここでサーバーに数字をもらう
                          // ユーザーが見える形で置いておく必要がある

                          // 追加する部屋の変数
                          // 部屋の追加
                          _roomManager.add(nowRoomInfo, newSubRoomName, [items.userInfo['userid']], nowRoomInfo.workers, [], 1, nowRoomInfo.sameGroup,
                            nowRoomInfo.mainRoomid,
                          );

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
                  items.itemsGet();
                  // taskGet();
                });
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
                setState(() {
                  items.itemsGet();
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
    return ListView.builder(
      // indexの作成 widgetが表示される数
      // 現在の部屋の情報からタスクの数を取得
      itemCount: nowRoomInfo.taskDatas.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return nowRoomInfo.tasks[index]['status_progress'] == 0
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
                                    content: taskDialog(nowRoomInfo.taskDatas, index));
                              });
                        },
                        // 繰り返し表示されるひな形呼び出し
                        child: taskCard(nowRoomInfo.taskDatas, index)))
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
    // ボタンに表示する文字を管理する変数
    List buttunType = buttuntypeSelect(type);
    return InkWell(
      onTap: () async {
        if (type == 0 || type == 2) {
          // できました！！またはリスケ申請であれば更新処理
          _taskManager.update(task, task.contents, type == 0 ? 1 : 2, task.taskLimit, task.worker);

          setState(() {});
        }

        // dbにメッセージ追加
        // これもクラス化したいね
        switch (type) {
          case 0:
            addMessage(karioki2, 'できました！！！！！！！', 3, 0, task.taskid, 0, task.roomid);
            break;
          case 1:
            addMessage(karioki2, '進捗どうですか？？？？？？？', 1, 0, task.taskid, 5, task.roomid);
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

            addMessage(karioki2, 'リスケお願いします', 3, 0, task.taskid, 2, task.roomid);
        }

        // dbから取り出し
        items.message = await DatabaseHelper.queryAllRows('msg_chats');
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
                              
            
                              // サイドバーの上部に置いておけばよろしと今思いました　そうします
                              // newRoomid = '4567';

                              
                              _roomManager.add(nowRoomInfo, newRoomName, [items.userInfo['userid']], [items.userInfo['userid']], [], 0, []);

                    
                              // items.myroom.add(newRoomid);
                            }

                            // 現在の部屋の切り替えと変数の上書き
                           // nowRoomid = newRoomid;
                            nowRoomInfo = _roomManager.findByindex(_roomManager.count() - 1);

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
        itemCount: _roomManager.count() + 1,
        itemBuilder: (context, index) {
          return Card(
              color: Constant.glay.withAlpha(0),
              elevation: 0,
              child: index != _roomManager.count()
                  ? InkWell(
                      onTap: () async {
                        // 表示する部屋の切り替え
                        
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
                          text: _roomManager.findByindex(index).roomName,
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
                            onChanged: (task) {
                              setState(() {
                                newTask = task;
                              });
                            },
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

                                    // ここでサーバーから名前をもらってくる
                                    child: CustomText(text: nowRoomInfo.workers[index], fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
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
                            _taskManager.add(newTask, newTask, limitTime.toString(), worker, nowRoomid);
                            

                            // 入力フォームの初期化
                            dateText = '期日を入力してね';
                            dayController.clear();
                            timeController.clear();
                            taskThinkController.clear();

                            FocusScope.of(context).unfocus(); // キーボードを閉じる
                            Navigator.of(context).pop(); // 戻る
                            // 値の更新
                            // items.taskList = await DatabaseHelper.queryAllRows('tasks');
                            // nowRoomTaskList = await DatabaseHelper.queryRowtask(nowRoomid);

                            // サーバーと通信
                            // -------ここから----------
                            // http.Response response = await HttpToServer.httpReq("POST", "/post_ins_new_record", {
                            //   "tableName": "tasks",
                            //   "pKey": "task_id",
                            //   "pKeyValue": "",
                            //   "recordData": {
                            //     "task_id": "",
                            //     "task_limit": limitTime.toString(),
                            //     "leaders": ["005f9164-5eeb-4cfb-a039-8a9dceb07162"],
                            //     "worker": "46956da2-7b0a-49e6-b980-f5ef4e7e3f12",
                            //     "contents": newTask,
                            //     "room_id": nowRoomid
                            //   }
                            // });
                            // print(response.body);
                            // Map<String, dynamic> parsedData = jsonDecode(response.body);
                            // String task_uuid = parsedData["server_response_data"];
                            // print(task_uuid);

                            // // 失敗
                            // http.Response getRes = await HttpToServer.httpReq("GET", "/get_record", {"tableName": "tasks", "pKey": "task_id", "pKeyValue": task_uuid});

                            // print(getRes.body);
                            // ---------ここまで---------------

                            // dbに追加
                            // print(nowRoomTaskList);
                            // taskGet();
                            // 画面の更新
                            // msg
                            addMessage(karioki2, 'がんばってください', 1, 0, karioki2.toString(), 0, nowRoomid);
                            // msg更新
                            items.message = await DatabaseHelper.queryAllRows('msg_chats');
                            setState(() {
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
                            });
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
    double screenSizeHeight = MediaQuery.of(context).size.height;
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
          child: CustomText(text: nowRoomInfo.roomName, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
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
                      molecules.PageTitle(context, 'タスク', 1, PageHome()),
                      SizedBox(
                        width: screenSizeWidth * 0.3,
                      ),
                      // タスク追加ボタン　リーダーのみ表示
                      //leaderCheck()
                      // メインタスクはリーダーのみ追加可能
                      addTaskBottun(),

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
                nowRoomInfo.subRoom
                 == 1 ? subRoomName() : roomBottun(),

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
