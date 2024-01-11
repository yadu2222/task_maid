import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_maid/view/molecules.dart';
import '../constant.dart';
import '../items.dart';
import '../../database_helper.dart';
import '../Room.dart';
import '../Room_manager.dart';

// import 'package:intl/intl.dart';

class PageMassages extends StatefulWidget {
  // 誰とのメッセージなのかを引数でもらう
  final Room messageRoom;

  PageMassages({required this.messageRoom, Key? key}) : super(key: key);
  @override
  _PageMassages createState() => _PageMassages(messageRoom: messageRoom);
}

class _PageMassages extends State<PageMassages> {
  Room messageRoom;
  _PageMassages({required this.messageRoom});

  // 画面の再構築メソッド
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void reloadWidgetTree() {
    _scaffoldKey.currentState?.reassemble();
  }

  // 仮置きする変数
  String message = '';
  int level = 0;
  int status = 0;
  int karioki = 12800;

  // 引用の有無
  bool quote = false;
  bool stamp = false;
  int taskIndex = 0;
  String quoteTaskid = '';

  // JSON文字列をデコードしてListを取得する関数
  List<dynamic> decodeJsonList(String jsonString) {
    return jsonDecode(jsonString);
  }

  Map nowRoomInfo = {};

  List getTaskList = [];
  List decodedLeaders = [];
  List decodedWorkers = [];
  List decodedTasks = [];
  // List decodedSubRooms = [];

  // 開いた部屋の自分のタスクを棕取得
  // taskGet() async {
  //   getTaskList = await DatabaseHelper.serachRows('tasks', 2, ['room_id', 'worker'], [messenger['room_id'], items.userInfo['userid']], 'task_limit');
  //   setState(() {});
  // }

  // 無限ループ対策
  int dbCount = 1;
  int dbCountFuture = 0;

  // getTaskListから部屋番号に応じた値を返す
  String quoteTaskGet(String key, String value) {
    String result = '';
    for (int i = 0; i < getTaskList.length; i++) {
      if (getTaskList[i]['task_id'] == value) {
        result = getTaskList[i][key];
        break;
      }
    }
    return result;
  }

  // listvewを自動スクロールするためのメソッド
  var _scrollController = ScrollController();

  // textfieldを初期化したり中身の有無を判定するためのコントローラー
  TextEditingController _messageController = TextEditingController();
  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    // nowRoomInfo = widget.messenger;
    // taskGet();

    // ウィジェットがビルドされた後にスクロール位置を設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  @override
  void didUpdateWidget(covariant PageMassages oldWidget) {
    super.didUpdateWidget(oldWidget);

    // コントローラーを再初期化するのではなく、既存のコントローラーをクリア
    _messageController.clear();
    // ウィジェットがビルドされた後にスクロール位置を設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  // メッセージ内容の表示
  // statusの値に合わせて表示するwidgetを変更
  Widget choiceMsg(int status, List messages, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    switch (status) {
      case 0:
        return Container(
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constant.white),
            child: CustomText(
                text: messages[index]['msg'],
                fontSize: screenSizeWidth * 0.035,
                // リスケお願いしますのときだけ赤文字
                color: messages[index]['msg'] == 'リスケお願いします' ? Constant.red : Constant.blackGlay));
      case 1:
      case 3:
        return Container(
            child: Container(
          width: screenSizeWidth * 0.8,
          decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              // タスク内容表示
              Container(
                child: Column(
                  children: [
                    // 箱の中身
                    Container(
                        width: screenSizeWidth * 0.6,
                        padding: EdgeInsets.all(screenSizeWidth * 0.035),
                        margin: EdgeInsets.all(screenSizeWidth * 0.02),
                        alignment: const Alignment(0.0, 0.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constant.white),
                        child: Column(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            // ${dateformat(quoteTask[0]['task_limit']',0)}
                            child: CustomText(
                                text: '期限：${quoteTaskGet('task_limit', messages[index]['quote_id'])}\n------------------------------', fontSize: screenSizeWidth * 0.0325, color: Constant.blackGlay),
                          ),

                          SizedBox(
                            height: screenSizeHeight * 0.01,
                          ),

                          // タスク内容の表示
                          CustomText(text: quoteTaskGet('contents', messages[index]['quote_id']), fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                        ])),

                    // 自分以外の人からのメッセージであればボタンを表示
                    messages[index]['sender'] != items.userInfo['userid']
                        ? Container(
                            alignment: const Alignment(0.0, 0.0),
                            margin: EdgeInsets.all(screenSizeWidth * 0.03),
                            child: Row(children: [
                              // 順調ですボタン
                              msgbutton(true, messages, index),
                              // リスケお願いしますボタン
                              msgbutton(false, messages, index)
                            ]))
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ));

      // スタンプ表示
      case 2:
        return SizedBox(
            width: screenSizeWidth * 0.6,
            height: screenSizeWidth * 0.6,
            // margin: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
            child: Image.asset(
              items.taskMaid['stamp'][messages[index]['stamp_id']],
              fit: BoxFit.contain,
            ));
    }
    return const SizedBox.shrink();
  }

  // msgの日付表示の処理
  Widget datedisplay(int index, List messages) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    // indexが0より大きければ比較
    // 年月日をそれぞれ比較
    return index > 0 &&
            DateTime.parse(messages[index - 1]['msg_datetime']).year == DateTime.parse(messages[index]['msg_datetime']).year &&
            DateTime.parse(messages[index - 1]['msg_datetime']).month == DateTime.parse(messages[index]['msg_datetime']).month &&
            DateTime.parse(messages[index - 1]['msg_datetime']).day == DateTime.parse(messages[index]['msg_datetime']).day
        ? const SizedBox.shrink()
        : Container(
            height: screenSizeHeight * 0.05,
            alignment: Alignment.center,
            child: CustomText(text: dateformat(messages[index]['msg_datetime'], 1), fontSize: screenSizeWidth * 0.03, color: Constant.white),
          );
  }

  // 送信時間表示ウィジェット
  Widget sendTime(int index, List messages, bool status) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return status
        ? Container(
            padding: EdgeInsets.only(bottom: screenSizeHeight * 0.01),
            alignment: Alignment.bottomCenter,
            width: screenSizeWidth * 0.1,
            child: CustomText(text: dateformat(messages[index]['msg_datetime'], 2), fontSize: screenSizeWidth * 0.025, color: Constant.white),
          )
        : const SizedBox.shrink();
  }

  // メッセージ表示処理
  Widget messageList(List messages) {
    items.itemsGet();
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // controllerの設置
      controller: _scrollController,
      // indexの作成 widgetが表示される数
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return messages[index]['room_id'] == nowRoomInfo['room_id']
            ? Card(
                color: Constant.glay.withAlpha(0),
                elevation: 0,
                child: Container(
                    width: screenSizeWidth,
                    margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
                    child: Column(children: [
                      // 日付表示
                      datedisplay(index, messages),
                      Container(
                          width: screenSizeWidth,
                          // 相手のメッセージならば左 自分のメッセージなら右に寄せて表示
                          alignment: messages[index]['sender'] != items.userInfo['userid'] ? Alignment.centerLeft : Alignment.centerRight,
                          child: SizedBox(
                              width: screenSizeWidth * 0.7,
                              // rowの高さを揃えるクラス
                              child: IntrinsicHeight(
                                  child: Row(children: [
                                // 送信時間表示
                                sendTime(index, messages, messages[index]['sender'] == items.userInfo['userid']),
                                Column(children: [
                                  Container(
                                      width: screenSizeWidth * 0.6,
                                      padding: messages[index]['status_addition'] != 2
                                          ? EdgeInsets.only(top: screenSizeWidth * 0.035, left: screenSizeWidth * 0.035, right: screenSizeWidth * 0.035, bottom: screenSizeWidth * 0.03)
                                          : const EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                        color: messages[index]['status_addition'] == 0 || messages[index]['status_addition'] == 1 || messages[index]['status_addition'] == 3
                                            ? Constant.glay
                                            : Constant.glay.withOpacity(0),
                                        borderRadius: BorderRadius.circular(10), // 角丸
                                      ),
                                      // statusに合わせてメッセージ表示メソッド
                                      child: Column(children: [
                                        messages[index]['status_addition'] != 2 ? choiceMsg(0, messages, index) : choiceMsg(messages[index]['status_addition'], messages, index),
                                        messages[index]['status_addition'] == 1 || messages[index]['status_addition'] == 3
                                            ? choiceMsg(messages[index]['status_addition'], messages, index)
                                            : const SizedBox.shrink()
                                      ]))
                                ]),
                                // 送信時間表示
                                sendTime(index, messages, messages[index]['sender'] != items.userInfo['userid'])
                              ]))))
                    ])))
            : const SizedBox.shrink();
      },
    );
  }

  // 順調ですorリスケお願いしますボタン
  Widget msgbutton(bool status, List messages, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        // メッセージ追加
        addMessage(karioki, status ? '順調です！！！！！！' : 'リスケお願いします', 1, 0, messages[index]['quote_id'], 0, nowRoomInfo['room_id']);
        dbCount++;

        // 再読み込みとスクロール
        setState(() {
          // ちょっと待たせて実行
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        });
        reloadWidgetTree();
      },
      child: Container(
        width: screenSizeWidth * 0.1525,
        height: screenSizeWidth * 0.15,
        padding: EdgeInsets.all(screenSizeWidth * 0.01),
        margin: EdgeInsets.only(left: screenSizeWidth * 0.025),
        alignment: const Alignment(0.0, 0.0),
        decoration: BoxDecoration(color: status ? Constant.white : const Color.fromARGB(255, 184, 35, 35), borderRadius: BorderRadius.circular(10)),
        child: CustomText(text: status ? '順調です！！！！！！' : 'リスケお願いします', fontSize: screenSizeWidth * 0.03725, color: status ? Constant.blackGlay : Constant.glay),
      ),
    );
  }

  // にこにこボタン　スタンプ選択
  Widget stampButtun() {
    return IconButton(
      icon: const Icon(
        Icons.add_reaction,
        color: Constant.blackGlay,
        size: 35,
      ),
      onPressed: () {
        // スタンプリスト表示するかの変数を変更
        stamp = !stamp;
        setState(() {});
      },
    );
  }

  // スタンプ選択の表示
  Widget stampPicture(int picture) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () async {
          status = 2;
          karioki++;
          addMessage(karioki, '', status, picture, '', 0, nowRoomInfo['room_id']);
          setState(() {
            // ステータス書き換え
            stamp = false;
            status = 0;
            // items.Nums();
          });

          // 値の更新
          items.message = await DatabaseHelper.queryAllRows('msg_chats');

          setState(() {});

          // ビルドサイクルが完了するまで待機
          Future.delayed(Duration.zero, () {
            // 画面更新のための処理をここに記述

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          });
        },
        child: Container(
          width: screenSizeWidth * 0.2,
          height: screenSizeWidth * 0.2,
          margin: EdgeInsetsDirectional.all(screenSizeWidth * 0.02),
          child: Image.asset(
            items.taskMaid['stamp'][picture],
            fit: BoxFit.contain,
          ),
        ));
  }

  // スタンプ選択表示の繰り返し
  Widget stampPictures() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    // 表示非表示を変数で判断
    return stamp
        ? Container(
            width: screenSizeWidth,
            decoration: const BoxDecoration(color: Constant.glay),
            child: Column(
              children: [
                Container(
                    // containerの中心に表示してくださいということ
                    alignment: const Alignment(0, 0),
                    padding: EdgeInsets.only(left: screenSizeWidth * 0.025),
                    child: Row(children: [
                      stampPicture(0),
                      stampPicture(1),
                      stampPicture(2),
                      stampPicture(3),
                    ])),
                Container(
                    alignment: const Alignment(0, 0),
                    padding: EdgeInsets.only(left: screenSizeWidth * 0.025),
                    child: Row(children: [
                      stampPicture(4),
                      stampPicture(5),
                      stampPicture(6),
                      stampPicture(7),
                    ]))
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  // +ボタン タスク引用ボタン
  Widget taskQuote(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return IconButton(
      icon: const Icon(
        Icons.add,
        color: Constant.blackGlay,
        size: 35,
      ),
      onPressed: () {
        // タスク選択ダイアログ
        // 詳細ダイアログ表示
        showDialog(
            context: context,
            barrierDismissible: true, // ユーザーがダイアログ外をタップして閉じられないようにする
            builder: (BuildContext context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    // side: const BorderSide(
                    //   color: Constant.sub3, width: 5, // ダイアログの形状を変更
                    // ),
                  ),
                  elevation: 0.0, // ダイアログの影を削除
                  backgroundColor: Constant.white.withOpacity(0), // 背景色

                  content: Container(
                      width: screenSizeWidth * 0.8,
                      height: screenSizeHeight * 0.465,
                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                      child: Column(children: [
                        // タスク内容表示
                        Container(
                          child: Column(
                            children: [
                              Container(
                                  width: screenSizeWidth * 0.4,
                                  height: screenSizeHeight * 0.05,
                                  alignment: const Alignment(0.0, 0.0),
                                  margin: EdgeInsets.only(top: screenSizeWidth * 0.03, bottom: screenSizeWidth * 0.02),
                                  child: CustomText(text: '${nowRoomInfo['room_name']}からのタスク', fontSize: screenSizeWidth * 0.038, color: Constant.blackGlay)),

                              // 箱の中身
                              SizedBox(
                                  width: screenSizeWidth * 0.6,
                                  height: screenSizeHeight * 0.35,
                                  // タスク選択処理
                                  child: taskList(getTaskList)),
                            ],
                          ),
                        )
                      ])));
            });
      },
    );
  }

  // タスク選択時の処理
  Widget taskList(List taskList) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    print(taskList);
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskList[index]['status_progress'] == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    // 引用中に変更
                    setState(() {
                      status = 1;
                      quote = true;
                      // この変数がどこの子なのかわからない、、
                      // ダミーーーー
                      // task_idを指定したい
                      taskIndex = index;
                      quoteTaskid = taskList[index]['task_id'];
                      Navigator.of(context).pop();
                    });
                  },
                  // 日付表示
                  child: Container(
                    width: screenSizeWidth * 0.7,
                    padding: EdgeInsets.all(screenSizeWidth * 0.02),
                    decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(
                            child: CustomText(
                                text:
                                    // もっと、みじかく、ならないかなあ
                                    '期限:${dateformat(taskList[index]['task_limit'], 0)}',
                                fontSize: screenSizeWidth * 0.03,
                                color: Constant.blackGlay)),
                        SizedBox(
                          child: CustomText(text: '---------------------------------', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                        ),
                        SizedBox(child: CustomText(text: '${taskList[index]['contents']}', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay))
                      ],
                    ),
                  ),
                ))
            // falseなら空の箱を返す
            : const SizedBox.shrink();
      },
    );
  }

  // タスクを選択した際表示されるバー
  Widget taskBar(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return quote
        ? Container(
            width: screenSizeWidth,
            decoration: const BoxDecoration(color: Constant.white),
            child: Row(
              children: [
                // ばつボタン
                IconButton(
                  onPressed: () {
                    setState(() {
                      // 状態管理用の変数をfalseに変更
                      quote = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                  color: Constant.blackGlay,
                ),
                CustomText(text: getTaskList[taskIndex]['contents'], fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay)
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  // 入力部分
  Widget newText(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return // 入力部分
        Container(
      width: screenSizeWidth * 0.55,
      height: screenSizeHeight * 0.04,
      // alignment: const Alignment(0.0, 0.0),
      margin: EdgeInsets.only(left: screenSizeWidth * 0.035, right: screenSizeWidth * 0.035),
      //decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _messageController,
        style: const TextStyle(
            // fontFamily: GoogleFonts.kiwiMaru,
            ),

        cursorColor: Constant.blackGlay,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Constant.white,
          border: InputBorder.none,
        ),

        // 入力内容を保存用変数に代入
        onChanged: (text) {
          message = text;
        },
        // keyboardType: TextInputType.text,
      ),
    );
  }

  // 送信ボタン
  Widget sendButtun() {
    return IconButton(
      icon: const Icon(
        Icons.send,
        color: Constant.blackGlay,
        size: 35,
      ),
      onPressed: () async {
        // 入力フォームが空じゃなければ
        // ここでデータベース送信と受け取り？
        if (_messageController.text.isNotEmpty) {
          FocusScope.of(context).unfocus(); //キーボードを閉じる

          // db追加メソッド呼び出し
          // 怒りレベル建設予定地
          karioki++;
          addMessage(karioki, message, status, 0, quoteTaskid, 0, nowRoomInfo['room_id']);
          dbCount++;
          print(nowRoomInfo);
          print(nowRoomInfo['room_id']);
          // 入力フォームの初期化
          _messageController.clear();
          quote = false;
        }
        // 値の更新
        // stamplistを消す
        stamp = false;
        items.message = await DatabaseHelper.queryAllRows('msg_chats');

        // 再読み込みとスクロール
        setState(() {});
        // ビルドサイクルが完了するまで待機
        Future.delayed(Duration.zero, () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          });
        });
      },
    );
  }

  // ここから表示部分
  @override
  Widget build(BuildContext context) {
    // dbnowRoom();
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          width: screenSizeWidth,
          height: screenSizeHeight,
          decoration: const BoxDecoration(color: Constant.main),

          // セーフエリアに対応
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    // 上部バー
                    molecules.PageTitle(context, nowRoomInfo['room_name'],0,SizedBox.shrink()),
                    // メッセージ部分
                    Container(width: screenSizeWidth * 0.9, height: screenSizeHeight * 0.8, child: messageList(items.message)),
                  ]),
                ),

                // 下のバー
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        constraints: BoxConstraints(maxHeight: screenSizeHeight * 0.34, minHeight: screenSizeHeight * 0.0578),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end, // columの要素を下詰めにする
                            children: [
                              Container(
                                  width: screenSizeWidth,
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(top: screenSizeWidth * 0.005, bottom: screenSizeWidth * 0.005),
                                  decoration: const BoxDecoration(color: Constant.glay),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    // 引用中のタスク
                                    taskBar(context),
                                    Row(
                                      children: [
                                        // +ボタン タスクを選択して引用
                                        taskQuote(context),
                                        // にこにこボタン スタンプ選択
                                        stampButtun(),
                                        // 入力部分
                                        newText(context),
                                        //送信ボタン
                                        sendButtun()
                                      ],
                                    ),
                                  ])),

                              // スタンプリスト
                              stampPictures()
                            ])))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
