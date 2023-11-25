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
              child: _messages(_screenSizeWidth,_screenSizeHeight)
            )
          ],
        ),
      ),
    )));
  }

  // トークルームの繰り返し処理
   Widget _messages(var _screenSizeWidth,var _screenSizeHeight) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.sender['sender'].length,
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
                                    messenger: items.sender['sender'][index],
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
                              // CustomText(text: messages[]['day'], fontSize:_screenSizeWidth*0.03, color: Constant.blackGlay),
                              // 名前の表示
                              Container(
                                width: _screenSizeWidth * 0.7,
                                alignment: Alignment.topLeft,
                                child: CustomText(text: items.sender['sender'][index], fontSize: _screenSizeWidth * 0.04, color: Constant.blackGlay),
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
                    ),);
      },
    );
  }
  
}
