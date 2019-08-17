import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_plugin/native_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/pages/cart/CartPage.dart';
import 'package:flutter_shop/pages/category/category.dart';
import 'package:flutter_shop/pages/home/HomePage1.dart';
import 'package:flutter_shop/pages/mine/MinePage.dart';
import 'package:flutter_shop/pages/push/JPush.dart';
import 'package:flutter_shop/pages/want/WantPage.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';

/**
 * 首页底部tab导航框架和判断版本更新
 * @author longlyboyhe
 * @date 2018/12/28
 */
class ApplicationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AppPage();
  }
}

class _AppPage extends State<ApplicationPage>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  //未选中效果
  final tabTextStyleNormal =
      new TextStyle(color: const Color(0xffffffff), fontSize: 13);
  //选中效果
  final tabTextStyleSelected =
      new TextStyle(color: const Color(0xFFEBE700), fontSize: 13);

  var tabImages;
  var _body;
  var appBarTitles = ['首页', '分类', '求购', '购物车', '我'];
  List<Widget> tabList = List();

  //根据传入path获取到Image
  Image getTabImage(path) {
    return new Image.asset(path, width: 25, height: 25);
  }

  //设置全局的key,当定义widget时，可以定义是否有返回以及设置一个独立的key
  GlobalKey<CartPageState> _cartKey = GlobalKey();
  GlobalKey<MinePageState> _mineKey = GlobalKey();

  //初始化页面状态
  @override
  void initState() {
    super.initState();
    PushPage.init();
    tabList.add(HomePage1());
    tabList.add(Category());
    tabList.add(SelectionPage());
    tabList.add(CartPage(
      key: _cartKey,
    ));
    tabList.add(MinePage(
      key: _mineKey,
    ));
//    tabList.add(ShopCartPage());
    //如果是android平台的化，会有更新提示
    if (Platform.isAndroid) {
      // 版本更新
      _getVersion();
      NativePlugin.channel.setMethodCallHandler((MethodCall call) {
        switch (call.method) {
          case "showToast":
            ToastUtil.showToast(context, call.arguments.toString());
            break;
        }
      });
    }
  }

  //异步获取版本
  _getVersion() async {
    bool isTimeToPromp = await DataUtils.isTimeToPromp();
    if (isTimeToPromp) {
      //获取版本信息，并请求服务器接口，是否有新版本更新
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String oldVersion = packageInfo.version;
      //请求接口获取版本更新信息
      HttpManager.instance.get(context, Api.GET_VERSION, (json) {
        Map data = json['data'];
        String android_version = data["android_version"];
        if (android_version.compareTo(oldVersion) > 0) {
          //设置更新文案
          String message = data["tip"] != null
              ? data["tip"]
              : "尊敬的用户， 品购商城${android_version}版本更新啦！ 立即升级？";
          String update_url =
              data["update_url"] != null ? data["update_url"] : "";
          //弹出更新提示
          showDialog(
              context: context,
              builder: (context) {
                return CommonDialog(
                  message: message,
                  leftButtonText: '下次提醒',
                  rightButtonText: '立即更新',
                  onLeftPress: () {
                    DataUtils.setGetVersionTime();
                    Navigator.pop(context);
                  },
                  onRightPress: () {
                    if (update_url.startsWith("http")) {
                      NativePlugin.downloadApk(update_url);
                    } else {
                      ToastUtil.showToast(context, "下载失败");
                    }
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      }, errorCallback: (errorMsg) {});
    }
  }

  //初始化tab数据
  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/home.png'),
          getTabImage('images/home_selected.png')
        ],
        [
          getTabImage('images/category.png'),
          getTabImage('images/category_selected.png')
        ],
        [
          getTabImage('images/want.png'),
          getTabImage('images/want_selected.png')
        ],
        [
          getTabImage('images/cart.png'),
          getTabImage('images/cart_selected.png')
        ],
        [
          getTabImage('images/mine.png'),
          getTabImage('images/mine_selected.png')
        ]
      ];
    }

    _body = new IndexedStack(
      children: tabList,
      index: _tabIndex,
    );
  }

  //获取当前的展示的文字样式
  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  //获取到当前的tab Image
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  //获取当前的tab的标题
  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  int _lastClickTime = 0;

  //重复返回退出
  Future<bool> _doubleExit() {
    int nowTime = new DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 2000) {
      return new Future.value(true);
    } else {
      _lastClickTime = new DateTime.now().microsecondsSinceEpoch;
      new Future.delayed(const Duration(milliseconds: 2000), () {
        _lastClickTime = 0;
      });
      ToastUtil.showToast(context, "再返回一次退出");
      return new Future.value(false);
    }
  }

  //widget的build方法
  @override
  Widget build(BuildContext context) {
    //按照屏幕宽度适配页面UI
    ScreenUtil.instance = ScreenUtil(width: ScreenUtil.designWidth)
      ..init(context);
    print("application build");
    if (_tabIndex == 3 && _cartKey != null && _cartKey.currentState != null) {
      _cartKey.currentState.loadData(false);
    } else if (_tabIndex == 4 &&
        _mineKey != null &&
        _mineKey.currentState != null) {
      _mineKey.currentState.getAccountBalance();
    }
    initData();
    return WillPopScope(
      //因为页面需要弹框所以new WillPopScope StatefulWidget
        child: Scaffold(
          key: ObjectKey("ApplicationPage"),
          body: _body,
          bottomNavigationBar: new CupertinoTabBar(
            backgroundColor: Colors.black,
            items: <BottomNavigationBarItem>[
              new BottomNavigationBarItem(
                  icon: getTabIcon(0), title: getTabTitle(0)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(1), title: getTabTitle(1)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(2), title: getTabTitle(2)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(3), title: getTabTitle(3)),
              new BottomNavigationBarItem(
                  icon: getTabIcon(4), title: getTabTitle(4)),
            ],
            currentIndex: _tabIndex,
            onTap: (index) {
              if (_tabIndex != index) {
                //同一个tab重复点击无效果
                setState(() {
                  _tabIndex = index;
                });
              }
            },
          ),
        ),
        onWillPop: _doubleExit);
  }
}
