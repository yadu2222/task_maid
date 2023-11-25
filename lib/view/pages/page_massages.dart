import 'package:flutter/material.dart';
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
                    // 戻るボタン
                    Container(
                      width: _screenSizeWidth,
                      alignment: const Alignment(0.0, 0.0),
                      margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                      child: Row(
                        children: [
                          SizedBox(width: _screenSizeWidth * 0.05),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Constant.glay,
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CustomText(text: messenger, fontSize: _screenSizeWidth * 0.06, color: Constant.glay),
                        ],
                      ),
                    ),

                    // メッセージ部分
                    Container(width: _screenSizeWidth * 0.9, height: _screenSizeHeight * 0.8, child: messageList(_screenSizeWidth, _screenSizeHeight, items.message['$messenger'])),
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
                                  decoration: BoxDecoration(color: Constant.glay),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    // 引用中のタスク
                                    items.indexBool
                                        ? Container(
                                            width: _screenSizeWidth,
                                            decoration: BoxDecoration(color: Constant.white),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      items.indexBool = false;
                                                    });
                                                  },
                                                  icon: Icon(Icons.close),
                                                  color: Constant.blackGlay,
                                                ),
                                                CustomText(text: items.taskList['id'][items.taskIndex]['task'], fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay)
                                              ],
                                            ),
                                          )
                                        : SizedBox(
                                            width: 0,
                                            height: 0,
                                          ),
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
                                                                      child: taskList(_screenSizeWidth, _screenSizeHeight, items.taskList['id'])),
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
                                            items.stamplist = true;
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
                                            style: TextStyle(
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
                                              addMessage(messenger, true, message, false, 0, 5, items.indexBool, items.taskIndex, false);
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
                              items.stamplist
                                  ? stampList(scaffoldKey: _scaffoldKey, scrollController: _scrollController, width: _screenSizeWidth, height: _screenSizeHeight, messenger: messenger)
                                  : const SizedBox(
                                      width: 0,
                                      height: 0,
                                    ),
                            ])))
              ],
            ),
          ),
        ),
      ),
    );
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

  // メッセージ表示処理
  Widget messageList(var _screenSizeWidth, var _screenSizeHeight, List messages) {
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
                width: _screenSizeWidth,
                // 相手のメッセージならば左 自分のメッセージなら右に寄せて表示
                alignment: messages[index]['whose'] ? Alignment.centerLeft : Alignment.centerRight,
                margin: EdgeInsets.only(top: _screenSizeWidth * 0.02),
                child: Column(children: [
                  Container(
                      width: _screenSizeWidth * 0.5,
                      padding: messages[index]['messagebool']
                          ? EdgeInsets.only(top: _screenSizeWidth * 0.035, left: _screenSizeWidth * 0.035, right: _screenSizeWidth * 0.035, bottom: _screenSizeWidth * 0.03)
                          : EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: messages[index]['messagebool'] ? Constant.glay : Constant.glay.withOpacity(0),
                        borderRadius: BorderRadius.circular(10), // 角丸
                      ),

                      // 文章部分
                      child: messages[index]['messagebool']
                          ? Column(children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                      text: '${messages[index]['sendDay']}\t${messages[index]['sendTime']}\n----------------------------',
                                      fontSize: _screenSizeWidth * 0.035,
                                      color: Constant.blackGlay)),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(
                                      text: messages[index]['message'],
                                      fontSize: _screenSizeWidth * 0.035,
                                      // リスケお願いしますのときだけ赤文字
                                      color: messages[index]['message'] == 'リスケお願いします' ? Constant.red : Constant.blackGlay)),

                              // 引用するタスク部分
                              messages[index]['indexBool']
                                    ?
                              Container(
                                // 引用してるか否かを判定
                                child:  Container(
                                        width: _screenSizeWidth * 0.8,
                                        decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
                                        child: Column(
                                          children: [
                                            // タスク内容表示
                                            Container(
                                              child: Column(
                                                children: [
                                                  // 箱の中身

                                                  Container(
                                                      width: _screenSizeWidth * 0.6,
                                                      //height: _screenSizeHeight * 0.2,
                                                      padding: EdgeInsets.all(_screenSizeWidth * 0.035),
                                                      margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                      alignment: const Alignment(0.0, 0.0),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Constant.white),
                                                      child: Column(children: [
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          CustomText(
                                                              text:
                                                                  '期限：${items.taskList['id'][messages[index]['index']]['limitDay']}\t${items.taskList['id'][messages[index]['index']]['limitTime']}\n---------------------',
                                                              fontSize: _screenSizeWidth * 0.0325,
                                                              color: Constant.blackGlay),
                                                        ]),
                                                        SizedBox(
                                                          height: _screenSizeHeight * 0.01,
                                                        ),

                                                        // タスク内容の表示
                                                        CustomText(text: items.taskList['id'][messages[index]['index']]['task'], fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay),
                                                      ])),

                                                  messages[index]['whose']
                                                      ? Container(
                                                          alignment: const Alignment(0.0, 0.0),
                                                          margin: EdgeInsets.all(_screenSizeWidth * 0.03),
                                                          child: Row(children: [
                                                            // できました！！ボタン
                                                            InkWell(
                                                              onTap: () {
                                                                // メッセージ追加
                                                                addMessage(messenger, true, '順調です！', false, 0, 0, true,  messages[index]['index'], false);
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
                                                                width: _screenSizeWidth * 0.1525,
                                                                height: _screenSizeWidth * 0.15,
                                                                margin: EdgeInsets.only(left: _screenSizeWidth * 0.005, right: _screenSizeWidth * 0.025),
                                                                padding: EdgeInsets.all(_screenSizeWidth * 0.01),
                                                                alignment: const Alignment(0.0, 0.0),
                                                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                                                child: CustomText(text: '順調です！！！！！！', fontSize: _screenSizeWidth * 0.03725, color: Constant.blackGlay),
                                                              ),
                                                            ),

                                                            // リスケおねがいします、、ボタン
                                                            InkWell(
                                                              onTap: () {
                                                                // メッセージ追加
                                                                addMessage(messenger, true, 'リスケお願いします', false, 0, 0, true,  messages[index]['index'], false);
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
                                                                width: _screenSizeWidth * 0.1525,
                                                                height: _screenSizeWidth * 0.15,
                                                                padding: EdgeInsets.all(_screenSizeWidth * 0.01),
                                                                margin: EdgeInsets.only(left: _screenSizeWidth * 0.025),
                                                                alignment: const Alignment(0.0, 0.0),
                                                                decoration: BoxDecoration(color: const Color.fromARGB(255, 184, 35, 35), borderRadius: BorderRadius.circular(10)),
                                                                child: CustomText(text: 'リスケお願いします', fontSize: _screenSizeWidth * 0.03725, color: Constant.glay),
                                                              ),
                                                            ),
                                                          ]))
                                                      : SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    
                              ) : SizedBox.shrink()
                            ])
                          : SizedBox.shrink()),

                  // スタンプの表示
                  Container(
                    // そもスタンプを選択しているかの判定
                    child: messages[index]['stampBool']
                        ? Container(
                            width: _screenSizeWidth * 0.5,
                            height: _screenSizeWidth * 0.5,
                            margin: EdgeInsets.only(top: _screenSizeWidth * 0.02, bottom: _screenSizeWidth * 0.02),
                            child: Image.asset(
                              items.taskMaid['stamp'][messages[index]['stamp']],
                              fit: BoxFit.contain,
                            ))
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  )
                ])));
      },
    );
  }

  // タスク選択時の処理
  Widget taskList(var _screenSizeWidth, var _screenSizeHeight, List item) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: item.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return item[index]['user'] == messenger && !item[index]['bool']
                ?
        Card(
            color: Constant.glay,
            elevation: 0,
            child:  InkWell(
                    onTap: () {
                      // 引用中に変更
                      setState(() {
                        items.indexBool = true;
                        // 個の変数がどこの子なのかわからない、、
                        // items.taskIndex = quoteIndex;
                        Navigator.of(context).pop();
                      });
                    },
                    // 日付表示
                    child: Container(
                      width: _screenSizeWidth * 0.7,
                      padding: EdgeInsets.all(_screenSizeWidth * 0.02),
                      decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          SizedBox(child: CustomText(text: '期限:${item[index]['limitDay']}\t${item[index]['limitTime']}', fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay)),
                          SizedBox(
                            child: CustomText(text: '---------------------------------', fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay),
                          ),
                          SizedBox(child: CustomText(text: '${item[index]['task']}', fontSize: _screenSizeWidth * 0.03, color: Constant.blackGlay))
                        ],
                      ),
                    ),
                  )
                )
            // falseなら空の箱を返す
            : SizedBox.shrink();
      },
    );
  }
}
