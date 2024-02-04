import 'package:flutter/material.dart';
import 'package:task_maid/data/controller/msg_manager.dart';

// widgetとか
import '../design_system/constant.dart';
import '../parts/Molecules.dart';

// userInfoや画像のパス
import '../../const/items.dart';

// 各情報のクラス
import '../../data/controller/door.dart';
import '../../data/models/task_class.dart';

import '../../data/models/msg_class.dart';
import '../../data/models/room_class.dart';
import '../../data/controller/task_manager.dart';

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

  // final chatRoomManager _chatRoomManager = chatRoomManager();
  final TaskManager _taskManager = TaskManager();

  // 仮置きする変数
  String message = '';
  int level = 0;
  int status = 0;

  // MsgManager messageList = messageRoom.msgList;
  // 引用の有無
  bool quote = false;
  bool stamp = false;
  int taskIndex = 0;
  String quoteTaskid = '';

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
  Widget choiceMsg(int status, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    // 変数に代入
    String msg = messageRoom.msgManager.findByindex(index).msg;
    String sender = messageRoom.msgManager.findByindex(index).senderid;
    int stampid = messageRoom.msgManager.findByindex(index).stampid;

    // タスクを用意できておればよい
    String quoteTaskid = messageRoom.msgManager.findByindex(index).quoteid;
    Task quoteTask = _taskManager.findByid(quoteTaskid);

    switch (status) {
      case 0:
        return Container(
            alignment: Alignment.centerLeft,
            // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constant.white),
            child: CustomText(
                text: msg,
                fontSize: screenSizeWidth * 0.035,
                // リスケお願いしますのときだけ赤文字
                color: msg == 'リスケお願いします' ? Constant.red : Constant.blackGlay));
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
                            child: CustomText(text: '期限：${quoteTask.taskLimit}\n------------------------------', fontSize: screenSizeWidth * 0.0325, color: Constant.blackGlay),
                          ),

                          SizedBox(
                            height: screenSizeHeight * 0.01,
                          ),

                          // タスク内容の表示
                          CustomText(text: quoteTask.contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
                        ])),

                    // 自分以外の人からのメッセージであればボタンを表示
                    sender != items.userInfo['userid']
                        ? Container(
                            alignment: const Alignment(0.0, 0.0),
                            margin: EdgeInsets.all(screenSizeWidth * 0.03),
                            child: Row(children: [
                              // 順調ですボタン
                              msgbutton(true, index),
                              // リスケお願いしますボタン
                              msgbutton(false, index)
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
              items.taskMaid['stamp'][stampid],
              fit: BoxFit.contain,
            ));
    }
    return const SizedBox.shrink();
  }

  // msgの日付表示の処理
  Widget datedisplay(int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    // 比較するデータを変数に代入
    String data1 = index > 0 ? messageRoom.msgManager.findByindex(index - 1).msgDatetime : '0'; // 0だとエラーが出る
    String data2 = messageRoom.msgManager.findByindex(index).msgDatetime;

    // indexが0より大きければ比較
    // 年月日をそれぞれ比較
    return index > 0 && DateTime.parse(data1).year == DateTime.parse(data2).year && DateTime.parse(data1).month == DateTime.parse(data2).month && DateTime.parse(data1).day == DateTime.parse(data2).day
        ? const SizedBox.shrink()
        : Container(
            height: screenSizeHeight * 0.05,
            alignment: Alignment.center,
            child: CustomText(text: dateformat(data2, 1), fontSize: screenSizeWidth * 0.03, color: Constant.white),
          );
  }

  // 送信時間表示ウィジェット
  Widget sendTime(int index, bool status) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return status
        ? Container(
            padding: EdgeInsets.only(bottom: screenSizeHeight * 0.01),
            alignment: Alignment.bottomCenter,
            width: screenSizeWidth * 0.1,
            child: CustomText(text: dateformat(messageRoom.msgManager.findByindex(index).msgDatetime, 2), fontSize: screenSizeWidth * 0.025, color: Constant.white),
          )
        : const SizedBox.shrink();
  }

  // Container(
  //                   width: screenSizeWidth,
  //                   margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
  //                   child: Column(children: [
  //                     // 日付表示
  //                     datedisplay(index),
  //                     Container(
  //                         width: screenSizeWidth,
  //                         // 相手のメッセージならば左 自分のメッセージなら右に寄せて表示
  //                         alignment: messageRoom.msgList.findByindex(index).senderid != items.userInfo['userid'] ? Alignment.centerLeft : Alignment.centerRight,
  //                         child: SizedBox(
  //                             width: screenSizeWidth * 0.7,
  //                             // rowの高さを揃えるクラス
  //                             child: IntrinsicHeight(
  //                                 child: Row(children: [
  //                               // 送信時間表示
  //                               sendTime(index,  messageRoom.msgList.findByindex(index).senderid == items.userInfo['userid']),
  //                               Column(children: [
  //                                 Container(
  //                                     width: screenSizeWidth * 0.6,
  //                                     padding: messageRoom.msgList.findByindex(index).statusAddition != 2
  //                                         ? EdgeInsets.only(top: screenSizeWidth * 0.035, left: screenSizeWidth * 0.035, right: screenSizeWidth * 0.035, bottom: screenSizeWidth * 0.03)
  //                                         : const EdgeInsets.all(0),
  //                                     decoration: BoxDecoration(
  //                                       color: messageRoom.msgList.findByindex(index).statusAddition == 0 || messageRoom.msgList.findByindex(index).statusAddition == 1 || messageRoom.msgList.findByindex(index).statusAddition == 3
  //                                           ? Constant.glay
  //                                           : Constant.glay.withOpacity(0),
  //                                       borderRadius: BorderRadius.circular(10), // 角丸
  //                                     ),
  //                                     // statusに合わせてメッセージ表示メソッド
  //                                     child: Column(children: [
  //                                      messageRoom.msgList.findByindex(index).statusAddition != 2 ? choiceMsg(0, messages, index) : choiceMsg(messageRoom.msgList.findByindex(index).statusAddition, messages, index),
  //                                       messageRoom.msgList.findByindex(index).statusAddition == 1 || messageRoom.msgList.findByindex(index).statusAddition == 3
  //                                           ? choiceMsg(messageRoom.msgList.findByindex(index).statusAddition, messages, index)
  //                                           : const SizedBox.shrink()
  //                                     ]))
  //                               ]),
  //                               // 送信時間表示
  //                               sendTime(index, messageRoom.msgList.findByindex(index).senderid != items.userInfo['userid']),
  //                             ]))))
  //                   ]))
  // -----------------もとのやつ-------------

  Widget msgCard(int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    String senderid = messageRoom.msgManager.findByindex(index).senderid;
    int statusAddition = messageRoom.msgManager.findByindex(index).statusAddition;

    return Container(
        width: screenSizeWidth,
        margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
        child: Column(children: [
          // 日付表示
          datedisplay(index),
          Container(
              width: screenSizeWidth,
              // 相手のメッセージならば左 自分のメッセージなら右に寄せて表示
              alignment: senderid != items.userInfo['userid'] ? Alignment.centerLeft : Alignment.centerRight,
              child: SizedBox(
                  width: screenSizeWidth * 0.7,
                  // rowの高さを揃えるクラス
                  child: IntrinsicHeight(
                      child: Row(children: [
                    // 送信時間表示
                    sendTime(index, senderid == items.userInfo['userid']),
                    Column(children: [
                      Container(
                          width: screenSizeWidth * 0.6,
                          padding: statusAddition != 2
                              ? EdgeInsets.only(top: screenSizeWidth * 0.035, left: screenSizeWidth * 0.035, right: screenSizeWidth * 0.035, bottom: screenSizeWidth * 0.03)
                              : const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: statusAddition == 0 || statusAddition == 1 || statusAddition == 3 ? Constant.glay : Constant.glay.withOpacity(0),
                            borderRadius: BorderRadius.circular(10), // 角丸
                          ),
                          // statusに合わせてメッセージ表示メソッド
                          child: Column(children: [
                            messageRoom.msgManager.findByindex(index).statusAddition != 2 ? choiceMsg(0, index) : choiceMsg(statusAddition, index),
                            messageRoom.msgManager.findByindex(index).statusAddition == 1 || messageRoom.msgManager.findByindex(index).statusAddition == 3
                                ? choiceMsg(statusAddition, index)
                                : const SizedBox.shrink()
                          ]))
                    ]),
                    // 送信時間表示
                    sendTime(index, messageRoom.msgManager.findByindex(index).senderid != items.userInfo['userid']),
                  ]))))
        ]));
  }

  // メッセージ表示処理
  Widget messageList() {
    return ListView.builder(
      // controllerの設置
      controller: _scrollController,
      // indexの作成 widgetが表示される数
      itemCount: messageRoom.msgManager.count(),
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(color: Constant.glay.withAlpha(0), elevation: 0, child: msgCard(index));
      },
    );
  }

  // 順調ですorリスケお願いしますボタン
  Widget msgbutton(bool status, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;

    String quoteid = messageRoom.msgManager.findByindex(index).quoteid;

    String msg1 = '順調です！！！！！！';
    String msg2 = 'リスケお願いします';

    return InkWell(
      onTap: () {
        // メッセージ追加

        messageRoom.msgManager.add(status ? msg1 : msg2, 1, 0, quoteid, 0);

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
        child: CustomText(text: status ? msg1 : msg2, fontSize: screenSizeWidth * 0.03725, color: status ? Constant.blackGlay : Constant.glay),
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
          messageRoom.msgManager.add(
            '',
            status,
            picture,
            '',
            0,
          );
          setState(() {
            // ステータス書き換え
            stamp = false;
            status = 0;
            // items.Nums();
          });

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
                                  child: CustomText(text: '${messageRoom.roomName}からのタスク', fontSize: screenSizeWidth * 0.038, color: Constant.blackGlay)),

                              // 箱の中身
                              SizedBox(
                                  width: screenSizeWidth * 0.6,
                                  height: screenSizeHeight * 0.35,
                                  // タスク選択処理
                                  child: taskList()),
                            ],
                          ),
                        )
                      ])));
            });
      },
    );
  }

  Widget taskCard(int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;

    //変数に格納
    Task task = messageRoom.taskDatas[index];
    String taskid = task.taskid;
    String taskLimit = task.taskLimit;
    String contents = task.contents;

    return Card(
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
              quoteTaskid = taskid;
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
                            '期限:${dateformat(taskLimit, 0)}',
                        fontSize: screenSizeWidth * 0.03,
                        color: Constant.blackGlay)),
                SizedBox(
                  child: CustomText(text: '---------------------------------', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay),
                ),
                SizedBox(child: CustomText(text: '${contents}', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay))
              ],
            ),
          ),
        ));
  }

  // タスク選択時の処理
  Widget taskList() {
    List<Task> taskDataList = messageRoom.taskDatas;

    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskDataList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskDataList[index].taskid == '0'
            ? taskCard(index)
            // falseなら空の箱を返す
            : const SizedBox.shrink();
      },
    );
  }

  // タスクを選択した際表示されるバー
  Widget taskBar(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;

    // ここでタスクを用意できておればよい

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
                CustomText(text: '改修！！！！！！！！！', fontSize: screenSizeWidth * 0.03, color: Constant.blackGlay)
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

          messageRoom.msgManager.add(message, status, 0, quoteTaskid, 0);

          // 入力フォームの初期化
          _messageController.clear();
          quote = false;
        }
        // 値の更新
        // stamplistを消す
        stamp = false;

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
                    molecules.PageTitle(context, messageRoom.roomName, 0, const SizedBox.shrink()),
                    // メッセージ部分
                    SizedBox(width: screenSizeWidth * 0.9, height: screenSizeHeight * 0.8, child: messageList()),
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
