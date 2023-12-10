import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_messages.dart';
import '../molecules.dart';
import '../../database_helper.dart';

class PageMail extends StatefulWidget {
  const PageMail({Key? key}) : super(key: key);

  @override
  _PageMail createState() => _PageMail();
}

dbroomGet() async {
  items.rooms = await DatabaseHelper.queryAllRows('rooms');
}

class _PageMail extends State<PageMail> {
  // トークルームの繰り返し処理
  Widget _messages() {
    
    //画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.rooms.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(
          color: Constant.glay,
          elevation: 0,
          child: InkWell(
            onTap: () {
              // ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PageMassages(
                          messenger: items.rooms[index]['roomid'],
                        )),
              ).then((value) {
                //戻ってきたら再描画
                setState(() {});
              });
            },
            child: Container(
              width: _screenSizeWidth * 0.8,
              height: _screenSizeHeight * 0.075,
              padding: EdgeInsets.only(top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025, left: _screenSizeWidth * 0.045),
              decoration: BoxDecoration(
                color: Constant.glay,
                borderRadius: BorderRadius.circular(5), // 角丸
              ),
              child: Row(
                children: [
                  Column(children: [
                    // 最終送信日時とかも入れたいね

                    // 最新を入れたいのでソートを行わないといけない
                    // 名前の表示
                    Container(
                      width: _screenSizeWidth * 0.7,
                      alignment: Alignment.topLeft,
                      child: CustomText(text: items.rooms[index]['roomName'], fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
                    ),
                    Container(
                        width: _screenSizeWidth * 0.7,
                        child:
                            // 部屋の名前表示
                            // 建設予定
                            CustomText(text: '建設予定', fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay))
                  ])
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dbroomGet();
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
            // バー部分
            molecules.PageTitle(context, 'メッセージ'),
            Container(width: _screenSizeWidth * 0.95, height: _screenSizeHeight * 0.85, child: _messages())
          ],
        ),
      ),
    )));
  }
}
