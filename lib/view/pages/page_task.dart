import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import '../constant.dart';
import '../items.dart';
import 'page_massages.dart';
import '../Molecules.dart';

class PageTask extends StatefulWidget {
  // どこの部屋のタスクを参照したいのか引数でもらう
  final String roomNum;

  const PageTask({required this.roomNum, Key? key}) : super(key: key);

  @override
  _PageTask createState() => _PageTask(roomNum: roomNum);
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

  String roomNum;
  _PageTask({required this.roomNum});

  // 検索用変数
  static String roomID = 'ルームID';
  static String ex = '検索結果はありません';

  // 例外にぎりつぶし文
  static String roomName() {
    try {
      return '『${items.room[roomID]['roomName']}』';
    } catch (e) {
      return ex;
    }
  }

  static String roomNames = roomName();
  static String taskRoomIndex = ''; // どのmyroomidを選ぶかのために使う 現在のデフォはてすとるーむ
  static String dateText = '期日を入力してね';
  static String please = 'リスケしてほしい日付を入力してね';

  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    // インスタンスメンバーを初期化
    taskRoomIndex = widget.roomNum;
  }

  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: sideBarKey,
        body: Center(
            child: Container(
          width: _screenSizeWidth,
          height: _screenSizeHeight,
          decoration: BoxDecoration(color: Constant.main),
          child: SafeArea(
              child: Stack(children: [
            Column(
              children: [
                Container(
                    width: _screenSizeWidth,
                    // バー部分
                    child: Row(children: [
                      Molecules.PageTitle(context, 'タスク'),
                      SizedBox(
                        width: _screenSizeWidth * 0.3,
                      ),
                      // タスク追加ボタン　リーダーのみ表示
                      items.room[taskRoomIndex]['leader'] == items.userInfo['userid']
                          ? Container(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                // ダイアログ表示
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Molecules.dialog(
                                            context,
                                            0.9,
                                            0.4,
                                            true,
                                            Column(children: [
                                              Container(
                                                margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                alignment: Alignment(0, 0),
                                                child: CustomText(text: 'タスク追加', fontSize: _screenSizeWidth * 0.05, color: Constant.blackGlay),
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
                                                      width: _screenSizeWidth * 0.5,
                                                      height: _screenSizeHeight * 0.05,
                                                      alignment: const Alignment(-1, 0),
                                                      //margin: EdgeInsets.only(left: _screenSizeWidth * 0.03),
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

                                                        // _screenSizeWidth * 0.04,
                                                        // Constant.blackGlay,
                                                      ))),
                                              Container(
                                                  width: _screenSizeWidth * 0.5,
                                                  height: _screenSizeHeight * 0.04,
                                                  alignment: const Alignment(0.0, 0.0),
                                                  margin: EdgeInsets.all(_screenSizeWidth * 0.03),

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

                                              Container(child: CustomText(text: '誰に頼む？', fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay)),

                                              Container(
                                                height: _screenSizeHeight * 0.1,
                                                child: ListView(
                                                  children: (items.room[taskRoomIndex]['workers'] as List<dynamic>).map<Widget>((workerId) {
                                                    // workerId を使って該当の情報を取得し、ウィジェットを生成する
                                                    //Map<String, dynamic> workerInfo = items.friend[workerId];
                                                    return ListTile(
                                                        title: InkWell(
                                                      // ボタンの色替えを建設しろ
                                                      onTap: () {
                                                        items.worker = items.friend[workerId]['name'];
                                                        items.friend[workerId]['bool'] = true;
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.only(top: _screenSizeWidth * 0.02, bottom: _screenSizeWidth * 0.02),
                                                        alignment: Alignment(0, 0),
                                                        decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                                        child: CustomText(text: items.friend[workerId]['name'], fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                                                      ),
                                                    ));
                                                  }).toList(),
                                                ),
                                              ),

                                              // タスク作成ボタン
                                              InkWell(
                                                onTap: () {
                                                  // 空文字だったら通さない
                                                  if (taskThinkController.text.isNotEmpty) {
                                                    FocusScope.of(context).unfocus(); //キーボードを閉じる
                                                    Navigator.of(context).pop(); //もどる

                                                    setState(() {
                                                      // タスクを追加
                                                      addTask(items.userInfo['name'], items.worker, items.newtask, items.limitTime, taskRoomIndex);

                                                      // 入力フォームの初期化
                                                      dateText = '期日を入力してね';
                                                      dayController.clear();
                                                      timeController.clear();
                                                      taskThinkController.clear();
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  width: _screenSizeWidth * 0.25,
                                                  alignment: Alignment(0, 0),
                                                  padding:
                                                      EdgeInsets.only(left: _screenSizeWidth * 0.03, right: _screenSizeWidth * 0.03, top: _screenSizeWidth * 0.02, bottom: _screenSizeWidth * 0.02),
                                                  margin: EdgeInsets.only(top: _screenSizeWidth * 0.02),
                                                  decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                                  child: CustomText(text: '作成', fontSize: _screenSizeWidth * 0.05, color: Constant.white),
                                                ),
                                              )
                                            ]));
                                      });
                                },
                                icon: Icon(Icons.add),
                                iconSize: 35,
                                color: Constant.glay,
                              ),
                            )
                          : SizedBox.shrink(),
                      IconButton(
                          onPressed: () {
                            sideBarKey.currentState!.openEndDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Constant.glay,
                            size: 35,
                          ))
                    ])),

                // 現在表示しているルームのボタン
                InkWell(
                    onTap: () {
                      // ダイアログ表示 現在加入中の部屋と検索バー表示
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Molecules.dialog(
                                context,
                                0.9,
                                0.465,
                                false,
                                Column(children: [
                                  // 検索バー
                                  Container(
                                      width: _screenSizeWidth * 0.7,
                                      //height: _screenSizeHeight * 0.067,
                                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(50)),
                                      margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: _screenSizeWidth * 0.02,
                                            ),
                                            const Icon(
                                              Icons.search,
                                              size: 30,
                                              color: Constant.blackGlay,
                                            ),
                                            SizedBox(
                                              width: _screenSizeWidth * 0.02,
                                            ),

                                            Container(
                                                width: _screenSizeWidth * 0.4,
                                                height: _screenSizeHeight * 0.04,
                                                alignment: const Alignment(0.0, 0.0),

                                                // テキストフィールド
                                                child: TextField(
                                                  controller: _messageController,
                                                  decoration: const InputDecoration(
                                                    hintText: '部屋番号を入力してね',
                                                  ),
                                                  onChanged: (text) {
                                                    roomID = text;
                                                  },
                                                  textInputAction: TextInputAction.search,
                                                )),
                                            SizedBox(
                                              width: _screenSizeWidth * 0.01,
                                            ),

                                            // やじるし
                                            IconButton(
                                                onPressed: () {
                                                  FocusScope.of(context).unfocus(); //キーボードを閉じる
                                                  Navigator.of(context).pop(); //もどる

                                                  roomNames = roomName(); // 変数の更新

                                                  if (_messageController.text.isNotEmpty) {
                                                    // データベースさんへ問い合わせた結果を表示
                                                    // ポップアップ
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
                                                              width: _screenSizeWidth * 0.95,
                                                              height: _screenSizeHeight * 0.215,
                                                              alignment: const Alignment(0.0, 0.0),
                                                              padding: roomNames == ex
                                                                  ? EdgeInsets.only(top: _screenSizeWidth * 0.085, left: _screenSizeWidth * 0.05, right: _screenSizeWidth * 0.05)
                                                                  : EdgeInsets.all(_screenSizeWidth * 0.05),
                                                              decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    // 検索した部屋の名前を表示
                                                                    width: _screenSizeWidth * 0.7,
                                                                    // height: _screenSizeHeight * 0.05,
                                                                    alignment: const Alignment(0.0, 0.0),
                                                                    margin: EdgeInsets.only(
                                                                      top: _screenSizeWidth * 0.0475,
                                                                      bottom: _screenSizeWidth * 0.02,
                                                                    ),
                                                                    child: CustomText(text: roomNames, fontSize: _screenSizeWidth * 0.045, color: Constant.blackGlay),
                                                                  ),
                                                                  roomNames == ex
                                                                      ? const SizedBox(
                                                                          width: 0,
                                                                          height: 0,
                                                                        )
                                                                      : Container(
                                                                          width: _screenSizeWidth * 0.7,
                                                                          //height: _screenSizeHeight * 0.05,
                                                                          alignment: const Alignment(0.0, 0.0),
                                                                          margin: EdgeInsets.only(bottom: _screenSizeWidth * 0.02),
                                                                          child: CustomText(text: '参加しますか？', fontSize: _screenSizeWidth * 0.045, color: Constant.blackGlay),
                                                                        ),
                                                                  roomNames == ex
                                                                      ? InkWell(
                                                                          onTap: () {
                                                                            // ここに処理
                                                                            Navigator.of(context).pop(); //もどる
                                                                          },
                                                                          child: Container(
                                                                            width: _screenSizeWidth * 0.3,
                                                                            height: _screenSizeHeight * 0.05,
                                                                            alignment: const Alignment(0.0, 0.0),
                                                                            margin: EdgeInsets.only(top: _screenSizeWidth * 0.03),
                                                                            //margin: EdgeInsets.only(left: _screenSizeWidth * 0.04),

                                                                            decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                                                            child: CustomText(text: 'はい', fontSize: _screenSizeWidth * 0.035, color: Constant.white),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          width: _screenSizeWidth * 0.9,
                                                                          alignment: const Alignment(0.0, 0.0),
                                                                          margin: EdgeInsets.only(left: _screenSizeWidth * 0.05),
                                                                          child: Row(
                                                                            children: [
                                                                              // 参加する
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop(); //もどる
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
                                                                                                width: _screenSizeWidth * 0.8,
                                                                                                height: _screenSizeHeight * 0.215,
                                                                                                alignment: Alignment(0, 0),
                                                                                                decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                                                                                child: CustomText(
                                                                                                    // text: roomIDcheck(roomID)
                                                                                                    //     ? '既に参加しています'
                                                                                                    //     : '参加しました！',
                                                                                                    text: '参加しました！',
                                                                                                    fontSize: _screenSizeWidth * 0.05,
                                                                                                    color: Constant.blackGlay),
                                                                                              ));
                                                                                        });

                                                                                    /**
                                                               * 未来のわたしへ 入ってたら既に参加していますしたいけどうまくいかないので時間あれば直してください
                                                               */

                                                                                    // ルームの追加
                                                                                    try {
                                                                                      if (!roomIDcheck(roomID)) {
                                                                                        // 参加した部屋番号を保持
                                                                                        items.myroom['myroomID'].add(roomID);

                                                                                        List<Map<String, dynamic>> friendRoomadd = [];
                                                                                        String leaderName = items.friend[items.room[roomID]['leader']]['name']; // 本来はデータベースに問い合わせる
                                                                                        // friendRoomadd[leaderName] = {};
                                                                                        items.message['sender'][leaderName] = friendRoomadd;
                                                                                      }
                                                                                    } catch (e) {
                                                                                      // 今だけ
                                                                                      print('だれもいないよ');
                                                                                    }

                                                                                    // ユーザーのIDをルームに追加
                                                                                    items.room[roomID]['workers'].add(items.userInfo['userid']);
                                                                                  },
                                                                                  child: Container(
                                                                                    width: _screenSizeWidth * 0.2,
                                                                                    height: _screenSizeHeight * 0.05,
                                                                                    margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                                                    padding: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                                                    alignment: const Alignment(0.0, 0.0),
                                                                                    decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                                                                    child: CustomText(text: 'はい', fontSize: _screenSizeWidth * 0.035, color: Constant.white),
                                                                                  )),

                                                                              // 参加しない
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    // ここに処理
                                                                                    Navigator.of(context).pop(); //もどる
                                                                                  },
                                                                                  child: Container(
                                                                                    width: _screenSizeWidth * 0.2,
                                                                                    height: _screenSizeHeight * 0.05,
                                                                                    margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                                                    padding: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                                                    alignment: const Alignment(0.0, 0.0),
                                                                                    decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                                                                    child: CustomText(text: 'いいえ', fontSize: _screenSizeWidth * 0.035, color: Constant.white),
                                                                                  )),
                                                                            ],
                                                                          ))
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
                                                ))
                                          ],
                                        ),

                                        // 現在参加中部屋のリスト
                                        Container(
                                          width: _screenSizeWidth * 0.7,
                                          height: _screenSizeHeight * 0.35,
                                          child: ListView(
                                            children: [
                                              ...((items.myroom['myroomID'] as List<String>).map<Widget>((roomId) {
                                                return ListTile(
                                                  title: InkWell(
                                                    onTap: () {
                                                      // 表示する部屋の切り替え
                                                      setState(() {
                                                        taskRoomIndex = roomId;
                                                        Navigator.pop(context); // 前のページに戻る
                                                      });
                                                    },
                                                    child: Container(
                                                      width: _screenSizeWidth * 0.7,
                                                      height: _screenSizeHeight * 0.05,
                                                      decoration: BoxDecoration(
                                                        color: Constant.main,
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      alignment: const Alignment(0, 0),
                                                      child: CustomText(
                                                        text: items.room[roomId]['roomName'],
                                                        color: Constant.white,
                                                        fontSize: _screenSizeWidth * 0.04,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList()),

                                              // 部屋を作成するためのaddボタン
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context); // 前のページに戻る
                                                  // ダイアログ表示 ここで部屋を作成
                                                  // 新規の番号もらってこないとなんですけどどうしましょう
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
                                                                width: _screenSizeWidth * 0.9,
                                                                height: _screenSizeHeight * 0.3,
                                                                padding: EdgeInsets.only(
                                                                    left: _screenSizeWidth * 0.03, right: _screenSizeWidth * 0.03, top: _screenSizeWidth * 0.05, bottom: _screenSizeWidth * 0.05),
                                                                decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                                                child: Column(children: [
                                                                  Container(
                                                                    margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                                                    alignment: Alignment(0, 0),
                                                                    child: CustomText(text: '新規作成', fontSize: _screenSizeWidth * 0.05, color: Constant.blackGlay),
                                                                  ),
                                                                  Container(
                                                                      width: _screenSizeWidth * 0.5,
                                                                      height: _screenSizeHeight * 0.04,
                                                                      alignment: const Alignment(0.0, 0.0),
                                                                      margin: EdgeInsets.all(_screenSizeWidth * 0.03),

                                                                      // テキストフィールド
                                                                      child: TextField(
                                                                        controller: roomNumController,
                                                                        decoration: const InputDecoration(
                                                                          hintText: '部屋番号を入力してね',
                                                                        ),
                                                                        onChanged: (num) {
                                                                          items.roomNum = num;
                                                                        },
                                                                        textInputAction: TextInputAction.next,
                                                                      )),
                                                                  Container(
                                                                      width: _screenSizeWidth * 0.5,
                                                                      height: _screenSizeHeight * 0.04,
                                                                      alignment: const Alignment(0.0, 0.0),
                                                                      margin: EdgeInsets.all(_screenSizeWidth * 0.03),

                                                                      // テキストフィールド
                                                                      child: TextField(
                                                                        controller: roomNameController,
                                                                        decoration: const InputDecoration(
                                                                          hintText: '部屋の名前を入力してね',
                                                                        ),
                                                                        onChanged: (newroomname) {
                                                                          items.roomName = newroomname;
                                                                        },
                                                                        textInputAction: TextInputAction.done,
                                                                      )),

                                                                  // 作成ボタン
                                                                  // かぶりがないかチェックしないといけないけど未実装です がば
                                                                  InkWell(
                                                                    onTap: () {
                                                                      // 空文字だったら通さない
                                                                      if (roomNameController.text.isNotEmpty && roomNumController.text.isNotEmpty) {
                                                                        FocusScope.of(context).unfocus(); //キーボードを閉じる
                                                                        Navigator.of(context).pop(); //もどる

                                                                        setState(() {
                                                                          // 追加する部屋のひな型
                                                                          var newroom = {
                                                                            'roomName': items.roomName,
                                                                            'leader': items.userInfo['userid'],
                                                                            'workers': [items.userInfo['userid']],
                                                                            'task': [],
                                                                          };
                                                                          items.room[items.roomNum] = newroom;
                                                                          items.myroom['myroomID'].add(items.roomNum);

                                                                          // 入力フォームの初期化
                                                                          roomNameController.clear();
                                                                          roomNumController.clear();
                                                                        });
                                                                      }
                                                                    },
                                                                    child: Container(
                                                                      width: _screenSizeWidth * 0.25,
                                                                      alignment: Alignment(0, 0),
                                                                      padding: EdgeInsets.only(
                                                                          left: _screenSizeWidth * 0.03, right: _screenSizeWidth * 0.03, top: _screenSizeWidth * 0.02, bottom: _screenSizeWidth * 0.02),
                                                                      margin: EdgeInsets.only(top: _screenSizeWidth * 0.02),
                                                                      decoration: BoxDecoration(color: Constant.main, borderRadius: BorderRadius.circular(16)),
                                                                      child: CustomText(text: '作成', fontSize: _screenSizeWidth * 0.05, color: Constant.glay),
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
                                              ),
                                            ],
                                          ),
                                        )
                                      ])),
                                ]));
                          });
                    },
                    // 現在のルーム名表示部分
                    child: Container(
                      width: _screenSizeWidth * 0.625,
                      alignment: Alignment(0, 0),
                      padding: EdgeInsets.all(_screenSizeWidth * 0.04),
                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: _screenSizeWidth * 0.03),
                      child: CustomText(text: items.room[taskRoomIndex]['roomName'], fontSize: _screenSizeWidth * 0.045, color: Constant.blackGlay),
                    )),

                // タスク表示
                Container(
                  width: _screenSizeWidth * 0.95,
                  height: _screenSizeHeight * 0.7,
                  child: taskList(items.taskList),
                )
              ],
            ),
          ])),
        )),

        // サイドバー設定
        endDrawer: sideBar());
  }

  Widget _test_taskList(var _screenSizeWidth) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(color: Constant.glay, elevation: 0, child: SizedBox());
      },
    );
  }

  // サイドバー
  Widget sideBar() {
    return Drawer(
      // 変更箇所
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("ルームマップ"),
            onTap: () {
              // ここにメニュータップ時の処理を記述
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("メンバー"),
            onTap: () {
              // ここにメニュータップ時の処理を記述
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text("サブルームの追加"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("権限の編集"),
            onTap: () {},
          )
        ],
      ),
    );
  }

  // タスク表示の処理
  Widget taskList(List item) {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: item.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return item[index]['status'] == 0 && item[index]['roomid'] == taskRoomIndex
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
                                child: Column(
                                  children: [
                                    // タスク内容表示
                                    Container(
                                      child: Column(
                                        children: [
                                          Container(
                                              width: _screenSizeWidth * 0.4,
                                              height: _screenSizeHeight * 0.05,
                                              alignment: const Alignment(0.0, 0.0),
                                              margin: EdgeInsets.only(top: _screenSizeWidth * 0.03, bottom: _screenSizeWidth * 0.02),
                                              child: CustomText(text: "詳細", fontSize: _screenSizeWidth * 0.05, color: Constant.blackGlay)),

                                          // 箱の中身
                                          Container(
                                              width: _screenSizeWidth * 0.6,
                                              height: _screenSizeHeight * 0.2,
                                              padding: EdgeInsets.all(_screenSizeWidth * 0.05),
                                              alignment: const Alignment(0.0, 0.0),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Constant.white),
                                              child: Column(children: [
                                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  CustomText(
                                                      text:
                                                          '依頼者：${item[index]['leader']}\n期限：${item[index]['limit'].month}月${item[index]['limit'].day}日${item[index]['limit'].hour}時${item[index]['limit'].minute}分\n-------------------------------',
                                                      fontSize: _screenSizeWidth * 0.035,
                                                      color: Constant.blackGlay),
                                                ]),
                                                SizedBox(
                                                  height: _screenSizeHeight * 0.01,
                                                ),

                                                // タスク内容の表示
                                                CustomText(text: item[index]['contents'], fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay),
                                              ])),

                                          Container(
                                              alignment: const Alignment(0.0, 0.0),
                                              margin: EdgeInsets.only(top: _screenSizeHeight * 0.02, left: _screenSizeWidth * 0.03, bottom: _screenSizeHeight * 0.0225
                                                  //right: _screenSizeWidth * 0.05,
                                                  ),
                                              padding: EdgeInsets.only(left: _screenSizeWidth * 0.02, right: _screenSizeWidth * 0.02),
                                              child: Row(children: [
                                                // できました！！ボタン
                                                InkWell(
                                                  onTap: () {
                                                    // 見ているタスクを引用してリスケを希望
                                                    // 辞書に追加
                                                    items.room[taskRoomIndex]['leader'] == items.userInfo['userid']
                                                        ? addMessage(items.karioki,'進捗どうですか？？？？？？？', 0, 0, 5,item[index]['roomid'])
                                                        : addMessage(items.karioki, 'できました！！！！！！！', 3, 0, 0, item[index]['roomid']);

                                                    if (!(items.room[taskRoomIndex]['leader'] == items.userInfo['userid'])) items.indexBool = false;

                                                    // ページ遷移
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PageMassages(
                                                                messenger: item[index]['roomid'],
                                                              )),
                                                    ).then((value) {
                                                      //戻ってきたら再描画
                                                      setState(() {
                                                        Navigator.pop(context);
                                                      });
                                                    });
                                                  },
                                                  child: Container(
                                                    width: _screenSizeWidth * 0.275,
                                                    height: _screenSizeWidth * 0.15,
                                                    padding: EdgeInsets.all(_screenSizeWidth * 0.01),
                                                    alignment: const Alignment(0.0, 0.0),
                                                    decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                                    child: CustomText(
                                                        text: items.room[taskRoomIndex]['leader'] == items.userInfo['userid'] ? '進捗どう\nですか？？？' : 'できました\n！！！！！！',
                                                        fontSize: _screenSizeWidth * 0.04,
                                                        color: Constant.blackGlay),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: _screenSizeWidth * 0.035,
                                                ),

                                                // リスケおねがいします、、ボタン
                                                InkWell(
                                                  onTap: () {
                                                    // 建設予定
                                                    DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime.now(), onConfirm: (date) {
                                                      setState(() {
                                                        items.limitTime = date;
                                                        please = '${date.year}年${date.month}月${date.day}日${date.hour}時${date.minute}分';
                                                      });
                                                    }, currentTime: DateTime.now(), locale: LocaleType.jp);

                                                    // 見ているタスクを引用してリスケを希望
                                                    // 辞書に追加
                                                    addMessage(items.karioki, 'リスケお願いします', 3, 0, 2, item[index]['roomid']);
                                                    items.indexBool = false;

                                                    // // ページ遷移
                                                    // Navigator.push(
                                                    //   context,
                                                    //   MaterialPageRoute(
                                                    //       builder: (context) => PageMassages(
                                                    //             messenger: item[index]['user'],
                                                    //           )),
                                                    // ).then((value) {
                                                    //   //戻ってきたら再描画

                                                    //   setState(() {
                                                    //     Navigator.pop(context);
                                                    //   });
                                                    // });
                                                  },
                                                  child: Container(
                                                    width: _screenSizeWidth * 0.275,
                                                    height: _screenSizeWidth * 0.15,
                                                    padding: EdgeInsets.all(_screenSizeWidth * 0.01),
                                                    alignment: const Alignment(0.0, 0.0),
                                                    decoration: BoxDecoration(color: const Color.fromARGB(255, 184, 35, 35), borderRadius: BorderRadius.circular(10)),
                                                    child: CustomText(text: 'リスケお願いします！！！', fontSize: _screenSizeWidth * 0.04, color: Constant.glay),
                                                  ),
                                                ),
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
                                        width: _screenSizeWidth * 0.3,
                                        height: _screenSizeHeight * 0.05,
                                        alignment: const Alignment(0.0, 0.0),
                                        margin: EdgeInsets.all(_screenSizeWidth * 0.01),
                                        decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                        child: CustomText(text: "もどる", fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                  child: Container(
                      width: _screenSizeWidth * 0.95,
                      height: _screenSizeHeight * 0.1,
                      padding: EdgeInsets.only(right: _screenSizeWidth * 0.02, left: _screenSizeWidth * 0.02),
                      //alignment: const Alignment(0.0, 0.0), //真ん中に配置
                      decoration: BoxDecoration(
                        color: Constant.glay,
                        borderRadius: BorderRadius.circular(10), // 角丸
                      ),
                      child: Row(children: [
                        Container(
                          width: _screenSizeWidth * 0.15,
                          height: _screenSizeHeight * 0.1,
                          alignment: const Alignment(0.0, 0.0), //真ん中に配置
                          padding: EdgeInsets.all(_screenSizeWidth * 0.025),
                          child: CustomText(text: '${item[index]['limit'].month}\n${item[index]['limit'].day}', fontSize: _screenSizeWidth * 0.055, color: Constant.blackGlay),
                        ),
                        SizedBox(
                          width: _screenSizeWidth * 0.01,
                        ),
                        Container(
                            width: _screenSizeWidth * 0.5,
                            margin: EdgeInsets.only(top: _screenSizeWidth * 0.04, bottom: _screenSizeWidth * 0.04),
                            child: Column(children: [
                              Container(
                                  width: _screenSizeWidth * 0.625,
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(text: '${item[index]['limit'].hour}:${item[index]['limit'].minute}まで\n-------------------------------', fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay)),
                              Container(
                                  width: _screenSizeWidth * 0.625,
                                  alignment: Alignment.centerLeft,
                                  child: CustomText(text: item[index]['contents'], fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay))
                            ]))
                      ])),
                ))
            : const SizedBox.shrink();
      },
    );
  }
}
