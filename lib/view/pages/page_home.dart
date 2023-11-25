import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_task.dart';
import 'page_setting.dart';
import 'page_massage.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    var _screenSizeWidth = MediaQuery.of(context).size.width;
    var _screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Center(
      // ページの中身
      child: Container(
        width: double.infinity,
        height: _screenSizeHeight,
        decoration: const BoxDecoration(color: Constant.main),
        child: SafeArea(
            bottom: false,
            child: Stack(children: [
              Column(
                children: [
                  // header
                  Container(
                      width: _screenSizeWidth,
                      height: _screenSizeHeight * 0.075,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              //メール
                              Container(
                                  margin: EdgeInsets.only(left: _screenSizeWidth * 0.05, right: _screenSizeWidth * 0.025, top: _screenSizeWidth * 0.0225),
                                  child: IconButton(
                                      onPressed: () {
                                        // ここに処理設置
                                        // ページ遷移
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PageMail()),
                                        ).then((value) {
                                          //戻ってきたら再描画
                                          setState(() {});
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.mail_outline,
                                        color: Constant.glay,
                                        size: 55,
                                      ))),

                              //タスク
                              Container(
                                  margin: EdgeInsets.only(left: _screenSizeWidth * 0.025, right: _screenSizeWidth * 0.025, top: _screenSizeWidth * 0.0225),
                                  child: IconButton(
                                      onPressed: () {
                                        //ページ遷移
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PageTask()),
                                        ).then((value) {
                                          //戻ってきたら再描画
                                          setState(() {});
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check_box,
                                        color: Constant.glay,
                                        size: 55,
                                      ))),

                              //設定
                              Container(
                                  margin: EdgeInsets.only(left: _screenSizeWidth * 0.025, right: _screenSizeWidth * 0.025, top: _screenSizeWidth * 0.0225),
                                  child: IconButton(
                                      onPressed: () {
                                        //ここに処理設置
                                        //ページ遷移
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => PageSetting()),
                                        ).then((value) {
                                          //戻ってきたら再描画
                                          setState(() {});
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        color: Constant.glay,
                                        size: 55,
                                      )))
                            ],
                          ))),

                  // body
                  Container(
                      width: _screenSizeWidth,
                      height: _screenSizeHeight * 0.8675, // エラー発生中
                      child: Stack(children: <Widget>[
                        // Row(
                        //   children: [

                        //右半分 メイドさんの立ち絵
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              width: _screenSizeWidth,
                              height: _screenSizeHeight * 0.9,
                              //alignment: Alignment.bottomCenter,
                              //padding: EdgeInsets.only(top: _screenSizeHeight*0.05),

                              //右寄せ
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset(
                                    items.taskMaid['standing'][2],
                                    fit: BoxFit.contain, // containで画像の比率を保ったままの最大サイズ
                                  ))),
                        ),

                        // 左半分
                        Container(
                            width: _screenSizeWidth * 0.45,
                            height: _screenSizeHeight * 0.866,
                            margin: EdgeInsets.only(top: _screenSizeWidth * 0.02, left: _screenSizeWidth * 0.02),
                            child: Column(children: [
                              // ふきだし設置予定
                              Container(
                                width: _screenSizeWidth * 0.38,
                                //height: _screenSizeHeight * 0.2,
                                alignment: const Alignment(0.0, 0.0), //中身の配置真ん中
                                margin: EdgeInsets.only(top: _screenSizeHeight * 0.05, bottom: _screenSizeHeight * 0.05),
                                padding: EdgeInsets.all(_screenSizeWidth * 0.03),
                                decoration: BoxDecoration(
                                  color: Constant.glay,
                                  borderRadius: BorderRadius.circular(10), // 角丸
                                ),
                                // ふきだしの中身
                                child: CustomText(
                                    text: //'おつかれさまでした。大変でしたね。今日はたくさん休んでください',
                                        '${items.leaderWord['idWord'][0]['sender']}様が「${items.leaderWord['idWord'][0]['word']}」と大変お怒りです！',
                                    fontSize: _screenSizeWidth * 0.035,
                                    color: Constant.blackGlay),
                              ),

                              // タスクリスト
                              Container(
                                  width: _screenSizeWidth * 0.38,
                                  height: _screenSizeHeight * 0.565, // エラー発生中
                                  padding: EdgeInsets.only(top: _screenSizeWidth * 0.03, bottom: _screenSizeWidth * 0.03),
                                  decoration: BoxDecoration(
                                    color: Constant.glay,
                                    borderRadius: BorderRadius.circular(10), // 角丸
                                  ),
                                  // ループ
                                  child: _taskList(_screenSizeWidth))
                            ])),
                      ]))
                ],
              ),
            ])),
      ),
    ));
  }

  // task_listの繰り返し処理
  // これで全部かきなおします、、、、
  Widget _taskList(var _screenSizeWidth) {
    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: items.taskList['id'].length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return Card(
            color: Constant.glay,
            elevation: 0,
            child: items.taskList['id'][index]['bool']
                ? const SizedBox(
                    width: 0,
                    height: 0,
                  )
                : InkWell(
                    onTap: () {
                      // ページ遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PageTask()),
                      ).then((value) {
                        // 戻ってきたら再描画
                        setState(() {});
                      });
                    },
                    child: Container(
                        // width: _screenSizeWidth * 0.3,
                        padding: EdgeInsets.all(_screenSizeWidth * 0.04),
                        margin: EdgeInsets.only(left: _screenSizeWidth * 0.025, right: _screenSizeWidth * 0.025, bottom: _screenSizeWidth * 0.01),
                        alignment: const Alignment(0.0, 0.0),
                        // boxに下線
                        decoration: BoxDecoration(
                          color: Constant.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CustomText(text: items.taskList['id'][index]['task'], fontSize: _screenSizeWidth * 0.035, color: Constant.blackGlay)),
                  ));
      },
    );
  }
}
