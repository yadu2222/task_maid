import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_task.dart';
import 'page_setting.dart';
import 'page_massage.dart';
import '../Molecules.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  // task_listの繰り返し処理
  // これで全部かきなおします、、、、
  Widget _taskList(List taskList) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskList[index]['status'] == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                    onTap: () {
                      // ページ遷移
                      // 建設予定 選択したタスクのルームに自動遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageTask(
                                  roomNum: taskList[index]['roomid'],
                                )),
                      ).then((value) {
                        // 戻ってきたら再描画
                        setState(() {});
                      });
                    },
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: screenSizeHeight * 0.07),
                      child: Container(
                          width: screenSizeWidth * 0.3,
                          padding: EdgeInsets.all(screenSizeWidth * 0.04),
                          margin: EdgeInsets.only(left: screenSizeWidth * 0.025, right: screenSizeWidth * 0.025, bottom: screenSizeWidth * 0.01),
                          alignment: const Alignment(0.0, 0.0),
                          decoration: BoxDecoration(
                            color: Constant.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomText(text: taskList[index]['contents'], fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)),
                    )))
            : SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    items.Nums();
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
                  // アイコンバー
                  Container(
                      width: _screenSizeWidth,
                      height: _screenSizeHeight * 0.075,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              //メール
                              // Componentsless.PageShiftIcon(functionIcon: Icons.mail_outline, widget:const PageMail()),
                              Molecules.PageShiftIcon(
                                context,
                                Icons.mail_outline,
                                PageMail(),
                              ),

                              //タスク
                              Molecules.PageShiftIcon(
                                context,
                                Icons.check_box,
                                PageTask(roomNum: '1111'),
                              ),

                              //設定
                              Molecules.PageShiftIcon(
                                context,
                                Icons.settings,
                                PageSetting(),
                              )
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
                                  child: _taskList(items.taskList))
                            ])),
                      ]))
                ],
              ),
            ])),
      ),
    ));
  }
}
