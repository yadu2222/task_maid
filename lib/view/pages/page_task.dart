import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';

class PageTask extends StatefulWidget {
  const PageTask({Key? key}) : super(key: key);

  @override
  _PageTask createState() => _PageTask();
}

class _PageTask extends State<PageTask> {
  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      width: _screenSizeWidth,
      height: _screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        child: Column(
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
            Container(
              width: _screenSizeWidth * 0.95,
              height: _screenSizeHeight * 0.85,
              child: ListView(
                // item に items.taskList['id']リストの中身をループする
                children: (items.taskList['id'] as List<Map<String, dynamic>>).map<Widget>((item) {
                  int index = (items.taskList['id'] as List<Map<String, dynamic>>?)?.indexOf(item) ?? -1; //null除外
                  // リストの中身
                  return ListTile(
                      title: InkWell(
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
                                  decoration:
                                      BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
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
                                                    top: _screenSizeWidth * 0.03, bottom: _screenSizeWidth * 0.02),
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
                                                    borderRadius: BorderRadius.circular(16), color: Constant.white),
                                                child: Column(children: [
                                                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                    CustomText(
                                                        text:
                                                            '依頼者：${item['user']}\n期限：${item['month']}/${item['day']}\t${item['our']}\n-------------------------------',
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
                                                    left: _screenSizeWidth * 0.02, right: _screenSizeWidth * 0.02),
                                                child: Row(children: [
                                                  // できました！！ボタン
                                                  InkWell(
                                                    onTap: () {
                                                      // 処理設置予定
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
                                                      // 処理設置予定
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
                                              color: Constant.white, borderRadius: BorderRadius.circular(10)),
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
                              margin: EdgeInsets.only(top: _screenSizeWidth * 0.04, bottom: _screenSizeWidth * 0.04),
                              child: Column(children: [
                                Container(
                                    width: _screenSizeWidth * 0.625,
                                    alignment: Alignment.centerLeft,
                                    child: CustomText(
                                        text: '${item['our']}まで\n-------------------------------',
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
      ),
    )));
  }
}
