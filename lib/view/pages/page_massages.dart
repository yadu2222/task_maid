import 'package:flutter/material.dart';
import 'package:task_maid/view/Molecules.dart';
import '../constant.dart';
import '../items.dart';
import '../../database_helper.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:intl/intl.dart';

class PageMassages extends StatefulWidget {
  // 誰とのメッセージなのかを引数でもらう
  final String messenger;

  PageMassages({required this.messenger, Key? key}) : super(key: key);
  @override
  _PageMassages createState() => _PageMassages(messenger: messenger);
}

class _PageMassages extends State<PageMassages> {
  String messenger;
  _PageMassages({required this.messenger});

  // 画面の再構築メソッド
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void reloadWidgetTree() {
    _scaffoldKey.currentState?.reassemble();
  }

  // 仮置きする変数
  String message = '';
  int level = 0;
  bool whose = false;
  int status = 0;

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Container(
          width: _screenSizeWidth,
          height: _screenSizeHeight,
          decoration: BoxDecoration(color: Constant.main),

          // セーフエリアに対応
          child: SafeArea(
            bottom: false,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    // 上部バー
                    Molecules.PageTitle(context, items.room[messenger]['roomName']),
                    // メッセージ部分
                    Container(width: _screenSizeWidth * 0.9, height: _screenSizeHeight * 0.8, child: messageList(items.message[messenger])),
                  ]),
                ),

                // 下のバー
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        constraints: BoxConstraints(maxHeight: _screenSizeHeight * 0.34, minHeight: _screenSizeHeight * 0.0578),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end, // columの要素を下詰めにする
                            children: [
                              Container(
                                  width: _screenSizeWidth,
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(top: _screenSizeWidth * 0.005, bottom: _screenSizeWidth * 0.005),
                                  decoration: const BoxDecoration(color: Constant.glay),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    // 引用中のタスク
                                    items.indexBool
                                        ? Container(
                                            width: _screenSizeWidth,
                                            decoration: const BoxDecoration(color: Constant.white),
                                            child: Row(
                                              children: [
                                                // ばつボタン
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // 状態管理用の変数をfalseに変更
                                                      items.indexBool = false;
                                                    });
                                                  },
                                                  icon: const Icon(Icons.close),
                                                  color: Constant.blackGlay,
                                                ),
                                                CustomText(text: items.taskList[items.taskIndex]['contents'], fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay)
                                              ],
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    Row(
                                      children: [
                                        // +ボタン タスクを選択して引用
                                        IconButton(
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
                                                          width: _screenSizeWidth * 0.8,
                                                          height: _screenSizeHeight * 0.465,
                                                          decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                                          child: Column(children: [
                                                            // タスク内容表示
                                                            Container(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                      width: _screenSizeWidth * 0.4,
                                                                      height: _screenSizeHeight * 0.05,
                                                                      alignment: const Alignment(0.0, 0.0),
                                                                      margin: EdgeInsets.only(top: _screenSizeWidth * 0.03, bottom: _screenSizeWidth * 0.02),
                                                                      child: CustomText(text: '${messenger}からのタスク', fontSize: _screenSizeWidth * 0.038, color: Constant.blackGlay)),

                                                                  // 箱の中身
                                                                  Container(
                                                                      width: _screenSizeWidth * 0.6,
                                                                      height: _screenSizeHeight * 0.35,
                                                                      // タスク選択処理
                                                                      child: taskList(items.taskList)),
                                                                ],
                                                              ),
                                                            )
                                                          ])));
                                                });
                                          },
                                        ),

                                        // にこにこボタン スタンプ選択
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_reaction,
                                            color: Constant.blackGlay,
                                            size: 35,
                                          ),
                                          onPressed: () {
                                            //
                                            items.stamplist = !items.stamplist;
                                            setState(() {});
                                          },
                                        ),

                                        // 入力部分
                                        Container(
                                          width: _screenSizeWidth * 0.55,
                                          height: _screenSizeHeight * 0.04,
                                          // alignment: const Alignment(0.0, 0.0),
                                          margin: EdgeInsets.only(left: _screenSizeWidth * 0.035, right: _screenSizeWidth * 0.035),
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
                                        ),

                                        // 送信ボタン
                                        IconButton(
                                          icon: const Icon(
                                            Icons.send,
                                            color: Constant.blackGlay,
                                            size: 35,
                                          ),
                                          onPressed: () {
                                            // 入力フォームが空じゃなければ
                                            // ここでデータベース送信と受け取り？
                                            if (_messageController.text.isNotEmpty) {
                                              FocusScope.of(context).unfocus(); //キーボードを閉じる

                                              // メッセージ追加メソッド呼び出し
                                              // 怒りレベル建設予定地
                                              addMessage(items.karioki, message, status, items.taskIndex, 0, messenger);
                                              // 入力フォームの初期化
                                              _messageController.clear();
                                              items.indexBool = false;
                                            }

                                            // stamplistを消す
                                            items.stamplist = false;

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
                                        ),
                                      ],
                                    ),
                                  ])),

                              // スタンプリスト
                              // 表示非表示を変数で判断
                              items.stamplist ? stampPictures() : const SizedBox.shrink()
                            ])))
              ],
            ),
          ),
        ),
      ),
    );
  }

/**
 * ここからこのページの処理まとめ
 */

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

  // statusの値に合わせて表示するwidgetを変更
  Widget choiceMsg(int status, List messages, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    switch (status) {
      case 0:
        return Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
                text: messages[index]['message'],
                fontSize: screenSizeWidth * 0.035,
                // リスケお願いしますのときだけ赤文字
                color: messages[index]['message'] == 'リスケお願いします' ? Constant.red : Constant.blackGlay));
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
                            child: CustomText(
                                text:
                                    '期限：${items.taskList[messages[index]['index']]['limit'].year}.${items.taskList[messages[index]['index']]['limit'].month}.${items.taskList[messages[index]['index']]['limit'].day}\t${items.taskList[messages[index]['index']]['limit'].hour}:${items.taskList[messages[index]['index']]['limit'].minute}\n------------------------------',
                                fontSize: screenSizeWidth * 0.0325,
                                color: Constant.blackGlay),
                          ),

                          SizedBox(
                            height: screenSizeHeight * 0.01,
                          ),

                          // タスク内容の表示
                          CustomText(text: items.taskList[messages[index]['index']]['contents'], fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay),
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
        return Container(
            width: screenSizeWidth * 0.5,
            height: screenSizeWidth * 0.5,
            margin: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
            child: Image.asset(
              items.taskMaid['stamp'][messages[index]['index']],
              fit: BoxFit.contain,
            ));
    }
    return const SizedBox.shrink();
  }

  // メッセージ表示処理
  Widget messageList(List messages) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // controllerの設置
      controller: _scrollController,
      // indexの作成 widgetが表示される数
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(
            color: Constant.glay.withAlpha(0),
            elevation: 0,
            child: Container(
                width: screenSizeWidth,
                margin: EdgeInsets.only(top: screenSizeWidth * 0.02),
                child: Column(children: [
                  // 日付表示
                  // indexが0より大きければ比較
                  // 年月日をそれぞれ比較
                  index > 0 &&
                          messages[index - 1]['time'].year == messages[index]['time'].year &&
                          messages[index - 1]['time'].month == messages[index]['time'].month &&
                          messages[index - 1]['time'].day == messages[index]['time'].day
                      ? const SizedBox.shrink()
                      : Container(
                          height: screenSizeHeight * 0.05,
                          alignment: Alignment.center,
                          child: CustomText(
                              text: '${messages[index]['time'].year}/${messages[index]['time'].month}/${messages[index]['time'].day}', fontSize: screenSizeWidth * 0.03, color: Constant.white),
                        ),

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
                                  padding: messages[index]['status'] != 2
                                      ? EdgeInsets.only(top: screenSizeWidth * 0.035, left: screenSizeWidth * 0.035, right: screenSizeWidth * 0.035, bottom: screenSizeWidth * 0.03)
                                      : const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: messages[index]['status'] == 0 || messages[index]['status'] == 1 || messages[index]['status'] == 3 ? Constant.glay : Constant.glay.withOpacity(0),
                                    borderRadius: BorderRadius.circular(10), // 角丸
                                  ),

                                  // statusに合わせてメッセージ表示メソッド
                                  child: Column(children: [
                                    messages[index]['status'] != 2 ? choiceMsg(0, messages, index) : choiceMsg(messages[index]['status'], messages, index),
                                    messages[index]['status'] == 1 || messages[index]['status'] == 3 ? choiceMsg(messages[index]['status'], messages, index) : const SizedBox.shrink()
                                  ]))
                            ]),
                            // 送信時間表示
                            sendTime(index, messages, messages[index]['sender'] != items.userInfo['userid'])
                          ]))))
                ])));
      },
    );
  }

  // 順調ですorリスケお願いしますボタン
  Widget msgbutton(bool status, List messages, int index) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        // メッセージ追加
        addMessage(items.karioki, status ? '順調です！！！！！！' : 'リスケお願いします', 1, messages[index]['index'], 0, messenger);
        items.indexBool = false;
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

  // 送信時間表示ウィジェット
  Widget sendTime(int index, List messages, bool status) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return status
        ? Container(
            padding: EdgeInsets.only(bottom: screenSizeHeight * 0.01),
            alignment: Alignment.bottomCenter,
            width: screenSizeWidth * 0.1,
            child: CustomText(text: '${messages[index]['time'].hour}:${messages[index]['time'].minute}', fontSize: screenSizeWidth * 0.025, color: Constant.white),
          )
        : SizedBox.shrink();
  }

  // スタンプ選択の表示
  Widget stampPicture(int picture) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () {
          items.stampIndex = picture;
          status = 2;
          addMessage(items.karioki, '', status, items.stampIndex, 0, messenger);
          setState(() {
            // ステータス書き換え
            items.stamplist = false;
            status = 0;
            void reloadWidgetTree() {
              _scaffoldKey.currentState?.reassemble();
            }

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
    return Container(
      width: screenSizeWidth,
      decoration: BoxDecoration(color: Constant.glay),
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
    );
  }

  // タスク選択時の処理
  Widget taskList(List taskList) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskList[index]['roomid'] == messenger && taskList[index]['status'] == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                  onTap: () {
                    // 引用中に変更
                    setState(() {
                      status = 1;
                      items.indexBool = true;
                      // この変数がどこの子なのかわからない、、
                      // items.taskIndex = quoteIndex;
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
                                    '期限:${taskList[index]['limit'].year}.${taskList[index]['limit'].month}.${taskList[index]['limit'].day}\t${taskList[index]['limit'].hour}:${taskList[index]['limit'].minute}',
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
}
