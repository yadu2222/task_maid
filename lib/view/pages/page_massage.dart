import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_massages.dart';

class PageMail extends StatefulWidget {
  const PageMail({Key? key}) : super(key: key);

  @override
  _PageMail createState() => _PageMail();
}

class _PageMail extends State<PageMail> {
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
        bottom: false,
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
                  CustomText(text: "メッセージ", fontSize: _screenSizeWidth * 0.06, color: Constant.glay),
                ])),
            Container(
              width: _screenSizeWidth * 0.95,
              height: _screenSizeHeight * 0.85,
              child: ListView(
                children: (items.message['sender'] as Map<String, dynamic>).entries.map<Widget>((entry) {
                  String senderName = entry.key;
                  List<Map<String, dynamic>> messages = entry.value as List<Map<String, dynamic>>;
                  // sender のリスト内での位置を取得
                  int senderIndex = (items.message['sender'] as Map<String, dynamic>).keys.toList().indexOf(senderName);

                  //int index = (messages['senderName'] as Map<String,dynamic>).indexof(messages);
                  return ListTile(
                    title: InkWell(
                      onTap: () {
                        // ページ遷移
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PageMassages(
                                    messenger: senderName,
                                  )),
                        ).then((value) {
                          //戻ってきたら再描画
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: _screenSizeWidth * 0.8,
                        height: _screenSizeHeight * 0.075,
                        padding: EdgeInsets.only(
                            top: _screenSizeWidth * 0.025,
                            bottom: _screenSizeWidth * 0.025,
                            left: _screenSizeWidth * 0.045),
                        decoration: BoxDecoration(
                          color: Constant.glay,
                          borderRadius: BorderRadius.circular(5), // 角丸
                        ),
                        child: Row(
                          children: [
                            Column(children: [
                              // 最終送信日時とかも入れたいね

                              // 最新を入れたいのでソートを行わないといけない
                              // CustomText(text: messages[]['day'], fontSize:_screenSizeWidth*0.03, color: Constant.blackGlay),
                              // 名前の表示
                              Container(
                                width: _screenSizeWidth * 0.7,
                                alignment: Alignment.topLeft,
                                child: CustomText(
                                    text: senderName, fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                              ),
                              Container(
                                  width: _screenSizeWidth * 0.7,
                                  child:
                                      // 部屋の名前表示
                                      CustomText(
                                          text: items.room[items.myroom['myroomID'][senderIndex]]['roomName'],
                                          fontSize: _screenSizeWidth * 0.035,
                                          color: Constant.blackGlay))
                            ])
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    )));
  }
}
