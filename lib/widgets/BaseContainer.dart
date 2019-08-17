import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/event/NetWorkEvent.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/widgets/LoadingView.dart';
import 'package:flutter_shop/widgets/ReloadView.dart';
import 'package:flutter/material.dart';

/**
 * 集成loading，空白页，重新加载，无网页面，上拉加载下拉刷新
 * @author longlyboyhe
 * @date 2018/12/24
 *
 * 显示优先级
 * loading > showLoadError > empty > child
 */
class BaseContainer extends Container {
  //是否在loading，如果没有赋值则不显示loading
  bool isLoading;

  //是否显示无网提示dialog
  bool showNoNet = true;

  //是否显示重新加载页面
  bool showLoadError = false;

  //是否显示空页面
  bool showEmpty = false;

  //空页面
  Widget empty;

  //子view
  Widget child;

  //点击重新加载回调
  GestureTapCallback reLoad;

  BaseContainer(
      {@required this.child,
      this.empty,
      Key key,
      this.showEmpty = false,
      this.isLoading = false,
      this.showNoNet = true,
      this.showLoadError = false,
      this.reLoad})
      : super(key: key, child: child);

  StreamSubscription stream;
  ConnectivityResult _connectionStatus = ConnectivityResult.mobile;

  @override
  Widget build(BuildContext context) {
    stream = HttpManager.eventBus.on<NetWorkEvent>().listen((event) {
      _connectionStatus = event.connectionType;
    });
    if (showNoNet == true && _connectionStatus == ConnectivityResult.none) {
      ToastUtil.showToast(context, "没有网络啦");
    }

    Widget mEmpty = empty;
    if (showEmpty && mEmpty == null) {
      mEmpty = Center(
        child: Text(
          "没有数据",
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    Widget mChild = Stack(
      children: <Widget>[
        Offstage(
          offstage: isLoading != true,
          child: LoadingView(),
        ),
        Offstage(
          offstage: isLoading == true || showLoadError != true,
          child: Center(
            child: ReloadView(
              reLoad: reLoad,
            ),
          ),
        ),
        Offstage(
          offstage:
              isLoading == true || showLoadError == true || showEmpty != true,
          child: mEmpty,
        ),
        Offstage(
          offstage:
              isLoading == true || showLoadError == true || showEmpty == true,
          child: child,
        )
      ],
    );
    return mChild;
  }
}
