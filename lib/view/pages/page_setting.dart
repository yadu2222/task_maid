import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {
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
                  CustomText(text: "設定", fontSize: _screenSizeWidth * 0.06, color: Constant.glay),
                ])),
            Container(
              margin: EdgeInsets.all(_screenSizeWidth * 0.05),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: _screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(_screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ID：${items.userInfo['userid']}', fontSize: _screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: _screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(_screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ユーザーネーム', fontSize: _screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    width: _screenSizeWidth * 0.8,
                    height: _screenSizeHeight * 0.065,
                    padding: EdgeInsets.only(left: _screenSizeWidth * 0.05, right: _screenSizeWidth * 0.05, top: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.025),
                    decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: items.userInfo['name'], // いまのなまえ
                      ),
                      onChanged: (text) {
                        items.userInfo['name'] = text;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }

  
}
