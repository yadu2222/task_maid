import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import '../constant.dart';
import '../items.dart';
import 'page_massages.dart';
import '../molecules.dart';
import 'package:task_maid/database_helper.dart';

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

  // 画面の再構築メソッド
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void reloadWidgetTree() {
    _scaffoldKey.currentState?.reassemble();
  }

  // どこの部屋のタスクを参照したいのか引数でもらう
  String roomNum;
  _PageTask({required this.roomNum});

  // 例外にぎりつぶし文
  static String roomName(String roomID) {
    String ex = '検索結果はありません';
    try {
      return '『${items.room[roomID]['roomName']}』';
    } catch (e) {
      return ex;
    }
  }

  // static String roomNames = roomName();
  static String taskRoomIndex = ''; // どのmyroomidを選ぶかのために使う 現在のデフォはてすとるーむ
  static String dateText = '期日を入力してね';
  static String please = 'リスケしてほしい日付を入力してね';
  static int karioki2 = 4587679;

  // 初期化メソッド
  @override
  void initState() {
    super.initState();
    items.Nums();
    // インスタンスメンバーを初期化
    taskRoomIndex = widget.roomNum;
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
  Widget taskList(List taskList) {
    items.Nums();
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskList[index]['status'] == 0 && taskList[index]['roomid'] == taskRoomIndex
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
                                    content: taskDialog(taskList, index));
                              });
                        },
                        // 繰り返し表示されるひな形呼び出し
                        child: taskCard(taskList, index)))
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
                text: '${DateTime.parse(taskList[index]['limitTime']).month}\n${DateTime.parse(taskList[index]['limitTime']).day}', fontSize: screenSizeWidth * 0.055, color: Constant.blackGlay),
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
                        text: '${DateTime.parse(taskList[index]['limitTime']).hour}:${DateTime.parse(taskList[index]['limitTime']).minute}まで\n-------------------------------',
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
                            text: '依頼者：${taskList[index]['leader']}\n期限：${dateformat(taskList[index]['limitTime'], 3)}\n-------------------------------',
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
                      msgbutton(items.room[taskRoomIndex]['leader'] == items.userInfo['userid'] ? 1 : 2, taskList, index)
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
        // dbにメッセージ追加
        switch (type) {
          case 0:
            addMessage(karioki2, 'できました！！！！！！！', 3, index, 0, taskList[index]['roomid']);
            break;

          case 1:
            addMessage(karioki2, '進捗どうですか？？？？？？？', 1, index, 5, taskList[index]['roomid']);
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

            addMessage(karioki2, 'リスケお願いします', 3, index, 2, taskList[index]['roomid']);
        }

        // dbから取り出し
        items.message = await DatabaseHelper.queryAllRows('msgchats');
        // ページ遷移
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PageMassages(
                    messenger: taskList[index]['roomid'],
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
        // 新規の番号もらってこないとなんですけどどうしましょう
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // 部屋作成用の値を仮置きする変数
              String roomName = '';
              String roomid = '0000';
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 0.0, // ダイアログの影を削除
                  backgroundColor: Constant.white.withOpacity(0), // 背景色

                  content: Container(
                      width: screenSizeWidth * 0.9,
                      height: screenSizeHeight * 0.3,
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
                            // dbとの通信建設予定地
                            // 部屋番号をもらう
                            child: TextField(
                              controller: roomNumController,
                              decoration: const InputDecoration(
                                hintText: '部屋番号を入力してね',
                              ),
                              onChanged: (num) {
                                roomNum = num;
                              },
                              textInputAction: TextInputAction.next,
                            )),
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
                                roomName = newroomname;
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
                                dbAddRoom(roomid, roomName, leaders, workers, tasks);

                                // 入力フォームの初期化
                                roomNameController.clear();
                                roomNumController.clear();
                              });
                            }
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

  // 現在参加中の部屋の表示
  Widget joinRoom() {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenSizeWidth * 0.7,
      height: screenSizeHeight * 0.35,
      // 繰り返し表示
      child: ListView.builder(
        itemCount: items.myroom.length + 1,
        itemBuilder: (context, index) {
          return Card(
              color: Constant.glay.withAlpha(0),
              elevation: 0,
              child: index != items.myroom.length
                  ? InkWell(
                      onTap: () {
                        // 表示する部屋の切り替え
                        setState(() {
                          taskRoomIndex = items.myroom[index];
                          Navigator.pop(context); // 前のページに戻る
                        });
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
                          text: items.room[items.myroom[index]]['roomName'],
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
                                padding: EdgeInsets.only(top: screenSizeWidth * 0.02, bottom: screenSizeWidth * 0.02),
                                alignment: Alignment(0, 0),
                                decoration: BoxDecoration(color: Constant.white, borderRadius: BorderRadius.circular(10)),
                                child: CustomText(text: items.friend[workerId]['name'], fontSize: screenSizeWidth * 0.04, color: Constant.blackGlay),
                              ),
                            ));
                          }).toList(),
                        ),
                      ),

                      // タスク作成ボタン
                      InkWell(
                        onTap: () async {
                          // 空文字だったら通さない
                          if (taskThinkController.text.isNotEmpty) {
                            // タスクを追加
                            addTask(karioki2, items.userInfo['name'], items.worker, items.newtask, items.limitTime, taskRoomIndex, 0);

                            // 入力フォームの初期化
                            dateText = '期日を入力してね';
                            dayController.clear();
                            timeController.clear();
                            taskThinkController.clear();

                            FocusScope.of(context).unfocus(); // キーボードを閉じる
                            Navigator.of(context).pop(); // 戻る
                            // 値の更新
                            items.taskList = await DatabaseHelper.queryAllRows('tasks');
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

  // ルーム選択、検索、追加ボタン
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
          child: CustomText(text: items.room[taskRoomIndex]['roomName'], fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
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
                            child: CustomText(text: searchBool ? '${searchRoomName}/nに参加しますか？' : falseResult, fontSize: screenSizeWidth * 0.045, color: Constant.blackGlay),
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
                                            
                                                // 参加申請中であって参加確定ではないのでこの処理は違う
                                                // 部屋情報のdbに申請中ユーザーのidを保持する列をつくればよいのではないか
                                          },
                                          // ボタン呼び出し
                                          child: dialogButton(true, 0.2)),
                                      // 「いいえ」
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop(); //もどる
                                          },
                                          // ボタン呼び出し
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
          decoration: BoxDecoration(color: Constant.main),
          child: SafeArea(
              child: Stack(children: [
            Column(
              children: [
                Container(
                    width: screenSizeWidth,
                    // バー部分
                    child: Row(children: [
                      molecules.PageTitle(context, 'タスク'),
                      SizedBox(
                        width: screenSizeWidth * 0.3,
                      ),
                      // タスク追加ボタン　リーダーのみ表示
                      items.room[taskRoomIndex]['leader'] == items.userInfo['userid'] ? addTaskBottun() : const SizedBox.shrink(),

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
                SizedBox(
                  width: screenSizeWidth * 0.95,
                  height: screenSizeHeight * 0.7,
                  child: taskList(items.taskList),
                )
              ],
            ),
          ])),
        )),

        // サイドバー設定
        endDrawer: sideBar());
  }
}
