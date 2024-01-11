import 'package:flutter/material.dart';
import 'pages/page_home.dart';
import 'items.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //デバッグの表示を消す
      home: MyStatefulWidget(), //ホーム画面を呼び出す
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  // アプリケーションの動的なUIの作成と更新？
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  
  @override
  Widget build(BuildContext context) {
    items.itemsGet();
    return Scaffold(
      body: PageHome(),
    );
  }
}
