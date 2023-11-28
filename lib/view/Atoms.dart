import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../view/pages/page_massages.dart';
import './items.dart';
import 'constant.dart';

class Atoms {
  // ページ遷移アイコン
  // アイコン、遷移先
  static Widget PageShiftIcon(BuildContext context, IconData functionIcon, Widget widget) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    // double screenSizeHeight = MediaQuery.of(context).size.height;

    return Container(
        margin: EdgeInsets.only(left: screenSizeWidth * 0.025, right: screenSizeWidth * 0.025, top: screenSizeWidth * 0.0225),
        child: IconButton(
            onPressed: () {
              // ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              ).then((value) {});
            },
            icon: Icon(
              functionIcon,
              color: Constant.glay,
              size: 55,
            )));
  }

  // 画面上部バー
  // 戻るボタンとタイトル
  static Widget PageTitle(BuildContext context,String text) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return Container(
      alignment: const Alignment(0.0, 0.0),
      margin: EdgeInsets.all(screenSizeWidth * 0.02),
      child: Row(
        children: [
          SizedBox(width: screenSizeWidth * 0.05),
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
          CustomText(text: text, fontSize: screenSizeWidth * 0.06, color: Constant.glay),
        ],
      ),
    );
  }
}
