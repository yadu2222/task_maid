import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_maid/data/controller/room_manager.dart';
import '../design_system/constant.dart';
import '../../const/items.dart';
import '../../data/models/component_communication.dart';
import 'page_task.dart';
import 'page_setting.dart';
import 'page_message.dart';
import '../parts/Molecules.dart';

// 各情報のクラス
import '../../data/controller/door.dart';
import '../../data/controller/task_manager.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);
  //const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  // インスタンス宣言
  SocketIO sio = SocketIO();

  final Door _door = Door();

  // task_listの繰り返し処理
  Widget taskList(TaskManager _taskManager, RoomManager _roomManager) {
    //画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      // indexの作成 widgetが表示される数
      itemCount: _door.taskCount(),
      itemBuilder: (context, index) {
        // 繰り返し描画されるwidget
        return _door.taskFindbyIndex(index).status == 0
            ? Card(
                color: Constant.glay,
                elevation: 0,
                child: InkWell(
                    onTap: () async {
                      // ページ遷移

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PageTask(
                                  nowRoomInfo: _door.roomFindbyid(_door.taskFindbyIndex(index).roomid),
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
                          child: CustomText(text: _door.taskFindbyIndex(index).contents, fontSize: screenSizeWidth * 0.035, color: Constant.blackGlay)),
                    )))
            : const SizedBox.shrink();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _door.load();
    
  }

  final TaskManager _taskManager = TaskManager();
  final RoomManager _roomManager = RoomManager();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    // 状態管理
    return ChangeNotifierProvider<TaskManager>(
        create: (context) => _taskManager,
        child: Scaffold(
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
                      SizedBox(
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
                                    widget: PageTask(
                                      nowRoomInfo: _roomManager.findByindex(0),
                                    ),
                                  ),

                                  //設定
                                  const PageShiftIcon(
                                    functionIcon: Icons.settings,
                                    widget: PageSetting(),
                                  )
                                ],
                              ))),

                      // body
                      SizedBox(
                          width: screenSizeWidth,
                          height: screenSizeHeight * 0.865, // エラー発生中
                          child: Stack(children: <Widget>[
                            // Row(
                            //   children: [
                            //右半分 メイドさんの立ち絵
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                  width: screenSizeWidth,
                                  height: screenSizeHeight * 0.9,
                                  //alignment: Alignment.bottomCenter,
                                  //padding: EdgeInsets.only(top: screenSizeHeight*0.05),

                                  //右寄せ
                                  child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                        items.taskMaid['standing'][0],
                                        fit: BoxFit.contain, // containで画像の比率を保ったままの最大サイズ
                                      ))),
                            ),

                            // 左半分
                            Container(
                                width: screenSizeWidth * 0.45,
                                height: screenSizeHeight * 0.866,
                                margin: EdgeInsets.only(top: screenSizeWidth * 0.02, left: screenSizeWidth * 0.02),
                                child: Column(children: [
                                  // taskList.isNotEmpty
                                  //     ? SizedBox.shrink()
                                  //     : SizedBox(
                                  //         height: screenSizeHeight * 0.5,
                                  //       ),

                                  // ふきだし設置予定
                                  Container(
                                    width: screenSizeWidth * 0.38, // : screenSizeWidth * 0.7,
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
                                        text:
                                            // 処理建設予定地
                                            // items.message.isNotEmpty
                                            //     ? '${items.message[items.message.length - 1]['room_id']}号室から「${items.message[items.message.length - 1]['msg']}」とお手紙が届いていますよ'
                                            //     : 'おつかれさまでした。大変でしたね。今日はたくさん休んでください',
                                            'おわんないですね……',
                                        fontSize: screenSizeWidth * 0.035,
                                        color: Constant.blackGlay),
                                  ),

                                  // タスクリスト
                                  // リストが空であれば表示しない
                                  // 更新のタイミングが謎
                                  _taskManager.count() != 0
                                      ? Container(
                                          width: screenSizeWidth * 0.38,
                                          height: screenSizeHeight * 0.565, // エラー発生中
                                          padding: EdgeInsets.only(top: screenSizeWidth * 0.03, bottom: screenSizeWidth * 0.03),
                                          decoration: BoxDecoration(
                                            color: Constant.glay,
                                            borderRadius: BorderRadius.circular(10), // 角丸
                                          ),
                                          // ループ
                                          child: taskList(_taskManager, _roomManager))
                                      : const SizedBox.shrink()
                                ])),
                          ]))
                    ],
                  ),
                ])),
          ),
        )));
  }
}
