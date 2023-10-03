import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'package:intl/intl.dart';
import '../../database.dart';

// import 'package:intl/intl.dart';

class PageMassages extends StatefulWidget {
  // 誰とのメッセージなのかを引数でもらう
  final String messenger;

  PageMassages({required this.messenger, Key? key}) : super(key: key);

  @override
  _PageMassages createState() => _PageMassages(messenger: messenger);
}

class _PageMassages extends State<PageMassages> {
  String messenger;
  _PageMassages({required this.messenger});

  @override
  Widget build(BuildContext context) {
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    // メッセージの値を仮置きする変数
    String day = '';
    String time = '';
    // bool messagebool = true;
    String message = '';
    int stamp = 0;
    int level = 0;

    bool whose = false;

    return Scaffold(resizeToAvoidBottomInset: true, body: Center(child: Container()));
  }
}
