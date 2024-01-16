import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import './items.dart';
import 'constant.dart';
import 'pages/page_home.dart';

class molecules {
  // 画面上部バー
  // 戻るボタンとタイトル
  static Widget PageTitle(BuildContext context, String text,int popType, Widget widget) {
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

              popType == 0 ? 
               Navigator.pop(context)
              : Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            },
          ),
          CustomText(text: text, fontSize: screenSizeWidth * 0.06, color: Constant.glay),
        ],
      ),
    );
  }

  // dialog表示
  static Widget dialog(
    BuildContext context,
    double inWidth,
    double inHeight,
    bool pabool,
    Widget widget,
  ) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;

    // paddingの有無
    pabool;
    // 中身のサイズ
    inWidth;
    inHeight;
    // 中身のwidget
    widget;

    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0, // ダイアログの影を削除
        backgroundColor: Constant.white.withOpacity(0), // 背景色

        content: Container(
            width: screenSizeWidth * inWidth,
            height: screenSizeHeight * inHeight,
            decoration: BoxDecoration(color: Constant.glay, borderRadius: BorderRadius.circular(16)),
            padding: pabool
                ? EdgeInsets.only(
                    left: screenSizeWidth * 0.03,
                    right: screenSizeWidth * 0.03,
                    top: screenSizeWidth * 0.05,
                  )
                : EdgeInsets.all(0),
            child: widget));
  }

  // 日時指定ドラムロール
  static dataRoll(BuildContext context) {
    return DatePicker.showDateTimePicker(context, showTitleActions: true, minTime: DateTime(2022, 1, 1, 11, 22), maxTime: DateTime(2023, 12, 31, 11, 22), onChanged: (date) {
      print(date);
    }, onConfirm: (date) {
      print(date);
    }, currentTime: DateTime.now(), locale: LocaleType.jp);
  }

  // ループして繰り返すリストウィジェットのサンプル
  static Widget rollList(Widget widget, List list) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: list.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(color: Constant.glay, elevation: 0, child: widget);
      },
    );
  }
}

// ページ遷移アイコン
// setStateを使いたかったので移動
class PageShiftIcon extends StatefulWidget {
  final IconData functionIcon;
  final Widget widget;
  const PageShiftIcon({Key? key, required this.functionIcon, required this.widget}) : super(key: key);

  @override
  _PageShiftIconState createState() => _PageShiftIconState();
}

class _PageShiftIconState extends State<PageShiftIcon> {
  @override
  Widget build(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(left: screenSizeWidth * 0.025, right: screenSizeWidth * 0.025, top: screenSizeWidth * 0.0225),
      child: IconButton(
        onPressed: () {
          // ページ遷移
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.widget),
          ).then((value) {
            setState(() {
              
            });
          });
        },
        icon: Icon(
          widget.functionIcon,
          color: Constant.glay,
          size: 55,
        ),
      ),
    );
  }
}

// ページのひな型
class pageName extends StatefulWidget {
  const pageName({Key? key}) : super(key: key);

  @override
  _pageName createState() => _pageName();
}

class _pageName extends State<pageName> {
  // 初期化メソッド
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      // ページの中身
      child: Container(
        width: double.infinity,
        height: screenSizeHeight,
        // 背景色
        decoration: const BoxDecoration(color: Constant.main),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [SizedBox.shrink()],
          ),
        ),
      ),
    ));
  }
}
