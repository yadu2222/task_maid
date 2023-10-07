import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_massages.dart';

class PageTask extends StatefulWidget {
  const PageTask({Key? key}) : super(key: key);

  @override
  _PageTask createState() => _PageTask();
}

class _PageTask extends State<PageTask> {
  // textfieldを初期化したり中身の有無を判定するためのコントローラー
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

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
  static int taskRoomIndex = 0; // どのmyroomidを選ぶかのために使う

  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    alignment: const Alignment(0.0, 0.0), //真ん中に配置
                    margin: EdgeInsets.all(_screenSizeWidth * 0.02),

                    // バー部分
                    child: Row(children: [
                      SizedBox(width: _screenSizeWidth * 0.05),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Constant.glay,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.pop(context); // 前のページに戻る
                        },
                      ),
                      CustomText(text: "タスク", fontSize: _screenSizeWidth * 0.06, color: Constant.glay),
                    ])),

                // 現在表示しているルームのボタン
                InkWell(
                    onTap: () {
                      // ここに処理を設置
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
                                    height: _screenSizeHeight * 0.465,
                                    decoration:
                                        BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                                    child: Column(children: [
                                      Container(
                                          width: _screenSizeWidth * 0.7,
                                          height: _screenSizeHeight * 0.065,
                                          decoration: BoxDecoration(
                                              color: Constant.glay, borderRadius: BorderRadius.circular(50)),
                                          margin: EdgeInsets.all(_screenSizeWidth * 0.02),
                                          child: Column(children: [
                                            // Container(
                                            //     width: _screenSizeWidth * 0.7,
                                            //     child: IconButton(
                                            //       onPressed: () {},
                                            //       icon: Icon(
                                            //         Icons.add,
                                            //         color: Constant.blackGlay,
                                            //         size: 30,
                                            //       ),
                                            //     )),
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
                                                                      ? EdgeInsets.only(
                                                                          top: _screenSizeWidth * 0.085,
                                                                          left: _screenSizeWidth * 0.05,
                                                                          right: _screenSizeWidth * 0.05)
                                                                      : EdgeInsets.all(_screenSizeWidth * 0.05),
                                                                  decoration: BoxDecoration(
                                                                      color: Constant.glay,
                                                                      borderRadius: BorderRadius.circular(16)),
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
                                                                        child: CustomText(
                                                                            text: roomNames,
                                                                            fontSize: _screenSizeWidth * 0.045,
                                                                            color: Constant.blackGlay),
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
                                                                              margin: EdgeInsets.only(
                                                                                  bottom: _screenSizeWidth * 0.02),
                                                                              child: CustomText(
                                                                                  text: '参加しますか？',
                                                                                  fontSize: _screenSizeWidth * 0.045,
                                                                                  color: Constant.blackGlay),
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
                                                                                margin: EdgeInsets.only(
                                                                                    top: _screenSizeWidth * 0.03),
                                                                                //margin: EdgeInsets.only(left: _screenSizeWidth * 0.04),

                                                                                decoration: BoxDecoration(
                                                                                    color: Constant.main,
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(16)),
                                                                                child: CustomText(
                                                                                    text: 'はい',
                                                                                    fontSize: _screenSizeWidth * 0.035,
                                                                                    color: Constant.white),
                                                                              ),
                                                                            )
                                                                          : Container(
                                                                              width: _screenSizeWidth * 0.9,
                                                                              alignment: const Alignment(0.0, 0.0),
                                                                              margin: EdgeInsets.only(
                                                                                  left: _screenSizeWidth * 0.05),
                                                                              child: Row(
                                                                                children: [
                                                                                  // 参加する
                                                                                  InkWell(
                                                                                      onTap: () {
                                                                                        Navigator.of(context)
                                                                                            .pop(); //もどる
                                                                                        showDialog(
                                                                                            context: context,
                                                                                            builder:
                                                                                                (BuildContext context) {
                                                                                              return AlertDialog(
                                                                                                  shape:
                                                                                                      RoundedRectangleBorder(
                                                                                                    borderRadius:
                                                                                                        BorderRadius
                                                                                                            .circular(
                                                                                                                16.0),
                                                                                                  ),
                                                                                                  elevation:
                                                                                                      0.0, // ダイアログの影を削除
                                                                                                  backgroundColor:
                                                                                                      Constant.white
                                                                                                          .withOpacity(
                                                                                                              0), // 背景色

                                                                                                  content: Container(
                                                                                                    width:
                                                                                                        _screenSizeWidth *
                                                                                                            0.8,
                                                                                                    height:
                                                                                                        _screenSizeHeight *
                                                                                                            0.215,
                                                                                                    alignment:
                                                                                                        Alignment(0, 0),
                                                                                                    decoration: BoxDecoration(
                                                                                                        color: Constant
                                                                                                            .glay,
                                                                                                        borderRadius:
                                                                                                            BorderRadius
                                                                                                                .circular(
                                                                                                                    16)),
                                                                                                    child: CustomText(
                                                                                                        // text: roomIDcheck(roomID)
                                                                                                        //     ? '既に参加しています'
                                                                                                        //     : '参加しました！',
                                                                                                        text: '参加しました！',
                                                                                                        fontSize:
                                                                                                            _screenSizeWidth *
                                                                                                                0.05,
                                                                                                        color: Constant
                                                                                                            .blackGlay),
                                                                                                  ));
                                                                                            });

                                                                                        /**
                                                               * 未来のわたしへ 入ってたら既に参加していますしたいけどうまくいかないので時間あれば直してください
                                                               */

                                                                                        // ルームの追加
                                                                                        try {
                                                                                          if (!roomIDcheck(roomID)) {
                                                                                            // 参加した部屋番号を保持
                                                                                            items.myroom['myroomID']
                                                                                                .add(roomID);

                                                                                            List<Map<String, dynamic>>
                                                                                                friendRoomadd = [];
                                                                                            String leaderName = items
                                                                                                        .friend[
                                                                                                    items.room[roomID]
                                                                                                        ['leader']][
                                                                                                'name']; // 本来はデータベースに問い合わせる
                                                                                            // friendRoomadd[leaderName] = {};
                                                                                            items.message['sender']
                                                                                                    [leaderName] =
                                                                                                friendRoomadd;
                                                                                          }
                                                                                        } catch (e) {
                                                                                          // 今だけ
                                                                                          print('だれもいないよ');
                                                                                        }

                                                                                        // ユーザーのIDをルームに追加
                                                                                        items.room[roomID]['workers']
                                                                                            .add(items
                                                                                                .userInfo['userid']);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: _screenSizeWidth * 0.2,
                                                                                        height:
                                                                                            _screenSizeHeight * 0.05,
                                                                                        margin: EdgeInsets.all(
                                                                                            _screenSizeWidth * 0.02),
                                                                                        padding: EdgeInsets.all(
                                                                                            _screenSizeWidth * 0.02),
                                                                                        alignment:
                                                                                            const Alignment(0.0, 0.0),
                                                                                        decoration: BoxDecoration(
                                                                                            color: Constant.main,
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(
                                                                                                    16)),
                                                                                        child: CustomText(
                                                                                            text: 'はい',
                                                                                            fontSize: _screenSizeWidth *
                                                                                                0.035,
                                                                                            color: Constant.white),
                                                                                      )),

                                                                                  // 参加しない
                                                                                  InkWell(
                                                                                      onTap: () {
                                                                                        // ここに処理
                                                                                        Navigator.of(context)
                                                                                            .pop(); //もどる
                                                                                      },
                                                                                      child: Container(
                                                                                        width: _screenSizeWidth * 0.2,
                                                                                        height:
                                                                                            _screenSizeHeight * 0.05,
                                                                                        margin: EdgeInsets.all(
                                                                                            _screenSizeWidth * 0.02),
                                                                                        padding: EdgeInsets.all(
                                                                                            _screenSizeWidth * 0.02),
                                                                                        alignment:
                                                                                            const Alignment(0.0, 0.0),
                                                                                        decoration: BoxDecoration(
                                                                                            color: Constant.main,
                                                                                            borderRadius:
                                                                                                BorderRadius.circular(
                                                                                                    16)),
                                                                                        child: CustomText(
                                                                                            text: 'いいえ',
                                                                                            fontSize: _screenSizeWidth *
                                                                                                0.035,
                                                                                            color: Constant.white),
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
                                          ])),
                                    ])));
                          });
                    },
                    // 現在のルーム名表示部分
                    child: Container(
                      padding: EdgeInsets.only(
                          top: _screenSizeWidth * 0.04,
                          bottom: _screenSizeWidth * 0.04,
                          left: _screenSizeWidth * 0.08,
                          right: _screenSizeWidth * 0.08),
                      decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: _screenSizeWidth * 0.03),
                      child: CustomText(
                          text: items.room[items.myroom['myroomID'][taskRoomIndex]]['roomName'],
                          fontSize: _screenSizeWidth * 0.045,
                          color: Constant.blackGlay),
                    )),

                Container(
                  width: _screenSizeWidth * 0.95,
                  height: _screenSizeHeight * 0.7,
                  child: ListView(
                    // item に items.taskList['id']リストの中身をループする
                    children: (items.taskList['id'] as List<Map<String, dynamic>>).map<Widget>((item) {
                      int index = (items.taskList['id'] as List<Map<String, dynamic>>?)?.indexOf(item) ?? -1; //null除外
                      // リストの中身
                      return ListTile(
                          // タスクの状態を判定して表示
                          title: item['bool']
                              ? SizedBox(
                                  width: 0,
                                  height: 0,
                                )
                              : InkWell(
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
                                                decoration: BoxDecoration(
                                                    color: Constant.glay, borderRadius: BorderRadius.circular(16)),
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
                                                              margin: EdgeInsets.only(
                                                                  top: _screenSizeWidth * 0.03,
                                                                  bottom: _screenSizeWidth * 0.02),
                                                              child: CustomText(
                                                                  text: "詳細",
                                                                  fontSize: _screenSizeWidth * 0.05,
                                                                  color: Constant.blackGlay)),

                                                          // 箱の中身
                                                          Container(
                                                              width: _screenSizeWidth * 0.6,
                                                              height: _screenSizeHeight * 0.2,
                                                              padding: EdgeInsets.all(_screenSizeWidth * 0.05),
                                                              alignment: const Alignment(0.0, 0.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(16),
                                                                  color: Constant.white),
                                                              child: Column(children: [
                                                                Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      CustomText(
                                                                          text:
                                                                              '依頼者：${item['user']}\n期限：${item['limitDay']}\t${item['limitTime']}\n-------------------------------',
                                                                          fontSize: _screenSizeWidth * 0.035,
                                                                          color: Constant.blackGlay),
                                                                    ]),
                                                                SizedBox(
                                                                  height: _screenSizeHeight * 0.01,
                                                                ),

                                                                // タスク内容の表示
                                                                CustomText(
                                                                    text: item['task'],
                                                                    fontSize: _screenSizeWidth * 0.035,
                                                                    color: Constant.blackGlay),
                                                              ])),

                                                          Container(
                                                              alignment: const Alignment(0.0, 0.0),
                                                              margin: EdgeInsets.only(
                                                                  top: _screenSizeHeight * 0.02,
                                                                  left: _screenSizeWidth * 0.03,
                                                                  bottom: _screenSizeHeight * 0.0225
                                                                  //right: _screenSizeWidth * 0.05,
                                                                  ),
                                                              padding: EdgeInsets.only(
                                                                  left: _screenSizeWidth * 0.02,
                                                                  right: _screenSizeWidth * 0.02),
                                                              child: Row(children: [
                                                                // できました！！ボタン
                                                                InkWell(
                                                                  onTap: () {
                                                                    // 見ているタスクを引用してリスケを希望
                                                                    // 辞書に追加
                                                                    addMessage(item['user'], true, 'できました！！！！！！！',
                                                                        false, 0, 0, true, index, false);
                                                                    items.indexBool = false;

                                                                    // タスクの状態を変更
                                                                    item['bool'] = true;
                                                                    // ページ遷移
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PageMassages(
                                                                                messenger: item['user'],
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
                                                                    decoration: BoxDecoration(
                                                                        color: Constant.white,
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child: CustomText(
                                                                        text: 'できました\n！！！！！！',
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
                                                                    // 見ているタスクを引用してリスケを希望
                                                                    // 辞書に追加
                                                                    addMessage(item['user'], true, 'リスケお願いします', false,
                                                                        0, 0, true, index, false);
                                                                    items.indexBool = false;
                                                                    // ページ遷移
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => PageMassages(
                                                                                messenger: item['user'],
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
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(255, 184, 35, 35),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child: CustomText(
                                                                        text: 'リスケお願いします！！！',
                                                                        fontSize: _screenSizeWidth * 0.04,
                                                                        color: Constant.glay),
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
                                                        decoration: BoxDecoration(
                                                            color: Constant.white,
                                                            borderRadius: BorderRadius.circular(10)),
                                                        child: CustomText(
                                                            text: "もどる",
                                                            fontSize: _screenSizeWidth * 0.04,
                                                            color: Constant.blackGlay),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ));
                                        });
                                  },
                                  child: Container(
                                      width: _screenSizeWidth * 0.95,
                                      height: _screenSizeHeight * 0.125,
                                      padding: EdgeInsets.only(
                                          right: _screenSizeWidth * 0.02, left: _screenSizeWidth * 0.02),
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
                                          child: CustomText(
                                              text: '${item['month']}\n${item['day']}',
                                              fontSize: _screenSizeWidth * 0.055,
                                              color: Constant.blackGlay),
                                        ),
                                        SizedBox(
                                          width: _screenSizeWidth * 0.01,
                                        ),
                                        Container(
                                            width: _screenSizeWidth * 0.5,
                                            margin: EdgeInsets.only(
                                                top: _screenSizeWidth * 0.04, bottom: _screenSizeWidth * 0.04),
                                            child: Column(children: [
                                              Container(
                                                  width: _screenSizeWidth * 0.625,
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                      text: '${item['limitTime']}まで\n-------------------------------',
                                                      fontSize: _screenSizeWidth * 0.035,
                                                      color: Constant.blackGlay)),
                                              Container(
                                                  width: _screenSizeWidth * 0.625,
                                                  alignment: Alignment.centerLeft,
                                                  child: CustomText(
                                                      text: item['task'],
                                                      fontSize: _screenSizeWidth * 0.035,
                                                      color: Constant.blackGlay))
                                            ]))
                                      ])),
                                ));
                    }).toList(),
                  ),
                )
              ],
            ),
          ])),
        )));
  }
}
