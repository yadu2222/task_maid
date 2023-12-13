import 'package:flutter/material.dart';
import '../constant.dart';
import '../items.dart';
import 'page_task.dart';
import 'page_setting.dart';
import 'page_message.dart';
import '../molecules.dart';
import 'package:task_maid/database_helper.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  
  // dbにテストルームがあるかないかを判別、なければ追加
  dbroomFirstAdd() async {
    if (!await DatabaseHelper.firstdb()) {
      // 追加する部屋の変数
      var leaders = [
        {'leader': items.userInfo['userid']}
      ];
      var workers = [
        {'worker': items.userInfo['userid']}
      ];
      var tasks = [{}];
      dbAddRoom('1111', 'てすとるーむ', leaders, workers, tasks);
      setState(() {
        defaultRoomSet();
      });
    }
  }

  List defaultRoom = [];
  defaultRoomSet() async {
    defaultRoom = await DatabaseHelper.selectRoom('1111');
    // ここで更新することでページ遷移時に渡す変数が書き換えられる
    setState(() {});
  }

  // task_listの繰り返し処理
  Widget _taskList(List taskList) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return taskList[index]['status_progress'] == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                    onTap: () async {
                      // ページ遷移
                      List selectRoom = await DatabaseHelper.selectRoom(taskList[index]['room_id']);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageTask(
                                  nowRoomInfo: selectRoom,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    items.Nums();
    dbroomFirstAdd();
    defaultRoomSet();
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
        decoration: const BoxDecoration(color: Constant.main),
        child: SafeArea(
            bottom: false,
            child: Stack(children: [
              Column(
                children: [
                  // header
                  // アイコンバー
                  Container(
                      width: screenSizeWidth,
                      height: screenSizeHeight * 0.075,
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            children: [
                              //メール
                              // Componentsless.PageShiftIcon(functionIcon: Icons.mail_outline, widget:const PageMail()),
                              const PageShiftIcon(
                                functionIcon: Icons.mail_outline,
                                widget: PageMail(),
                              ),

                              //タスク
                              PageShiftIcon(
                                functionIcon: Icons.check_box,
                                widget: PageTask(nowRoomInfo: defaultRoom),
                              ),

                              //設定
                              const PageShiftIcon(
                                functionIcon: Icons.settings,
                                widget: PageSetting(),
                              )
                            ],
                          ))),

                  // body
                  Container(
                      width: screenSizeWidth,
                      height: screenSizeHeight * 0.8675, // エラー発生中
                      child: Stack(children: <Widget>[
                        // Row(
                        //   children: [
                        //右半分 メイドさんの立ち絵
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              width: screenSizeWidth,
                              height: screenSizeHeight * 0.9,
                              //alignment: Alignment.bottomCenter,
                              //padding: EdgeInsets.only(top: screenSizeHeight*0.05),

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
                            width: screenSizeWidth * 0.45,
                            height: screenSizeHeight * 0.866,
                            margin: EdgeInsets.only(top: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
                            child: Column(children: [
                              // ふきだし設置予定
                              Container(
                                width: screenSizeWidth * 0.38,
                                //height: screenSizeHeight * 0.2,
                                alignment: const Alignment(0.0, 0.0), //中身の配置真ん中
                                margin: EdgeInsets.only(top: screenSizeHeight * 0.05, bottom: screenSizeHeight * 0.05),
                                padding: EdgeInsets.all(screenSizeWidth * 0.03),
                                decoration: BoxDecoration(
                                  color: Constant.glay,
                                  borderRadius: BorderRadius.circular(10), // 角丸
                                ),
                                // ふきだしの中身
                                child: CustomText(
                                    text: //'おつかれさまでした。大変でしたね。今日はたくさん休んでください',
                                        // 処理建設予定地
                                        'せろり様が「遊んでないで仕事してください！！」と大変お怒りです！',
                                    fontSize: screenSizeWidth * 0.035,
                                    color: Constant.blackGlay),
                              ),

                              // タスクリスト
                              Container(
                                  width: screenSizeWidth * 0.38,
                                  height: screenSizeHeight * 0.565, // エラー発生中
                                  padding: EdgeInsets.only(top: screenSizeWidth * 0.03, bottom: screenSizeWidth * 0.03),
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
