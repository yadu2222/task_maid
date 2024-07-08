import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../constant/items.dart'; // 画像のパス用
import '../design_system/constant.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _Loading();
}

// 動作してないよーーーー; ;
class _Loading extends State<Loading> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    initState() {
      _startOverlayLoadingAnimation();
    }

    double screenSizeWidth = MediaQuery.of(context).size.width;
    double screenSizeHeight = MediaQuery.of(context).size.height;
    return _isLoading
        ? Scaffold(
            body: Center(
              child: Container(
                width: screenSizeWidth * 0.3,
                height: screenSizeWidth * 0.3,
                decoration: BoxDecoration(
                  color: Constant.glay,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  items.taskMaid['move'][0],
                  fit: BoxFit.contain, // containで画像の比率を保ったままの最大サイズ
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Future<void> _startOverlayLoadingAnimation() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isLoading = false;
    });
  }
}
