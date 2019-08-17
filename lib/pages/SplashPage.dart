import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_shop/utils/DataUtils.dart';

/**
 * 闪屏页面
 * @author longlyboyhe
 * @date 2018/12/28
 */

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return new ConstrainedBox(
      child: Container(
        color: Color(0xffffffff),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(bottom: 100),
        //child: Image.asset("images/login_logo.png",fit: BoxFit.fitHeight),
      ),
      constraints: new BoxConstraints.expand(),
    );
   // return new Image.asset("images/bg.jpeg");
  }

  @override
  void initState() {
    super.initState();
    countDown();
  }

// 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 3);
    new Future.delayed(_duration, go2HomePage);
  }

  void go2HomePage() {
//    DataUtils.isLogin().then((isLogin) {
//      if (isLogin) {
        Navigator.of(context).pushReplacementNamed('/MainPage');
//      } else {
//        Navigator.of(context).pushReplacementNamed('/LoginPage');
//      }
//    });
  }
}