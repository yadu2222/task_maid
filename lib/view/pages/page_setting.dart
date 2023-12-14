import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import '../molecules.dart';

class PageSetting extends StatefulWidget {
  const PageSetting({Key? key}) : super(key: key);

  @override
  _PageSetting createState() => _PageSetting();
}

class _PageSetting extends State<PageSetting> {
  @override
  Widget build(BuildContext context) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
            child: Container(
      width: screenSizeWidth,
      height: screenSizeHeight,
      decoration: BoxDecoration(color: Constant.main),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // 上部バー部分
            molecules.PageTitle(context, '設定'),

            // 設定
            Container(
              margin: EdgeInsets.all(screenSizeWidth * 0.05),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ID：${items.userInfo['userid']}', fontSize: screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenSizeWidth * 0.03),
                    padding: EdgeInsets.all(screenSizeWidth * 0.03),
                    alignment: Alignment.bottomLeft,
                    child: CustomText(text: 'ユーザーネーム', fontSize: screenSizeWidth * 0.045, color: Constant.glay),
                  ),
                  Container(
                    width: screenSizeWidth * 0.8,
                    height: screenSizeHeight * 0.065,
                    padding: EdgeInsets.only(left: screenSizeWidth * 0.05, right: screenSizeWidth * 0.05, top: screenSizeWidth * 0.025, bottom: screenSizeWidth * 0.025),
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
