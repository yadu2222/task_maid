import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import '../Molecules.dart';
import 'package:task_maid/database_helper.dart';
import 'page_task.dart';

// ページのひな型
class page_roomSetting extends StatefulWidget {
  const page_roomSetting({Key? key}) : super(key: key);

  @override
  _page_roomSetting createState() => _page_roomSetting();
}

class _page_roomSetting extends State<page_roomSetting> {
  // 初期化メソッド
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.itemsGet();
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
            children: [
              molecules.PageTitle(context, 'スタッフルーム',0,PageTask(nowRoomInfo: [])),
            ],
          ),
        ),
      ),
    ));
  }
}
