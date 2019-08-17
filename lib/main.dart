import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/pages/ApplicationPage.dart';
import 'package:flutter_shop/pages/Orders/OrderPage.dart';
import 'package:flutter_shop/pages/login/LoginPage.dart';
import 'constants/RouterConstants.dart';
import 'pages/SplashPage.dart';

/**
 * 主界面
 * @author longlyboyhe
 * @date 2018/12/28
 */

void main() {
  runApp(new MyDisLuxClient());
}

class MyDisLuxClient extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    /// 强制竖屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      // 后台进行显示的名字，在任务管理窗口中所显示的应用名字
      title: '品购商城',
      //设置主题
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColorBrightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      //设置配置路由
      // 定义应用中页面跳转规则。 该对象是一个 Map<String, WidgetBuilder>。
      //当使用 Navigator.pushNamed 来路由的时候，会在 routes 查找路由名字，
      // 然后使用对应的 WidgetBuilder 来构造一个带有页面切换动画的 MaterialPageRoute。
      // 如果应用只有一个界面，则不用设置这个属性，使用home设置这个界面即可。
      routes: {
        RouterConstants.MAIN_PAGE: (ctx) => ApplicationPage(),
        RouterConstants.LOGIN_PAGE: (ctx) => LoginPage(),
        RouterConstants.ORDER_PAGE: (ctx) => OrderPage(0),
      },
      //应用默认所显示的界面 Widget
      home:  SplashPage(), // 闪屏页
//      routes: <String, WidgetBuilder>{ // 路由
//        '/HomePage': (BuildContext context) => new HomePage()
//      },
    );
  }
}

