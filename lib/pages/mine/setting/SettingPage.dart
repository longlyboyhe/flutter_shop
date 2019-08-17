import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_plugin/native_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_shop/constants/RouterConstants.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/pages/ApplicationPage.dart';
import 'package:flutter_shop/pages/login/LoginPage.dart';
import 'package:flutter_shop/pages/mine/setting/AccountSecurity.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import "package:flutter_shop/widgets/CommonDialog.dart";
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 设置页面
/// @author longlyboyhe
/// @date 2019/3/7
///
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String version = "1.0.0";

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      StringUtils.getVersion().then((newVersion) {
        setState(() {
          version = newVersion;
        });
      });
      NativePlugin.channel.setMethodCallHandler((MethodCall call) {
        switch (call.method) {
          case "showToast":
            ToastUtil.showToast(context, call.arguments.toString());
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.mineBgColor,
      appBar: CommonAppBar(
          context: context,
          title: KString.settingTitle,
          bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
//            SettingItem(
//                title: KString.infomation,
//                isArrow: true,
//                havaMargin: true,
//                onTap: () {
//                  routePagerNavigator(context, Information());
//                }),
            SettingItem(
                havaMargin: true,
                title: KString.accountSecurity,
                isArrow: true,
                onTap: () {
                  routePagerNavigator(context, AccountSecurity());
                }),
//            SettingItem(
//                title: KString.messageSwitch,
//                isArrow: false,
//                havaMargin: false,
//                onChange: (on) {
//                  if (on) {
//                    ToastUtil.showToast(context, "接收消息");
//                  } else {
//                    ToastUtil.showToast(context, "不接受消息");
//                  }
//                }),
            SettingItem(
              title: KString.clear,
              subTitle: KString.clearSubtitle,
              isArrow: true,
              havaMargin: false,
              onTap: () {
                ToastUtil.showToast(context, "已清除");
              },
            ),
            Platform.isAndroid
                ? SettingItem(
                    title: KString.version,
                    subTitle: "当前版本 $version",
                    isArrow: false,
                    havaMargin: true,
                    isQuit: true,
                    onTap: () {
                      downloadApk();
                    })
                : Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil().L(10)),
                  ),
            SettingItem(
                title: KString.quit,
                isQuit: true,
                havaMargin: false,
                onTap: () {
                  logout();
                })
          ],
        ),
      ),
    );
  }

  void logout() async {
    User user = await DataUtils.getUserInfo();
    if (user != null) {
      HttpManager().post(context, Api.USER_LOGOUT, (result) {
        BaseResp baseResp = BaseResp.fromJson(result);
        if (baseResp.result != null && baseResp.result.isSuccess) {
          DataUtils.clearLoginInfo();
          Navigator.pushNamedAndRemoveUntil(context, RouterConstants.LOGIN_PAGE, ModalRoute.withName('/'));
        } else {
          ToastUtil.showToast(context, "退成登录失败，请重试");
        }
      }, errorCallback: (error) {
        ToastUtil.showToast(context, "网络连接异常，请稍后重试");
      }, params: {
        "user_id": user.userId?.toString(),
        "platform": "phone",
      });
    }
  }

  void downloadApk() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String oldVersion = packageInfo.version;
    HttpManager.instance.get(context, Api.GET_VERSION, (json) {
      Map data = json['data'];
      String android_version = data["android_version"];
      if (android_version.compareTo(oldVersion) > 0) {
        String message = data["tip"] != null
            ? data["tip"]
            : "尊敬的用户， 品上商城${android_version}版本更新啦！ 立即升级？";
        String update_url =
            data["update_url"] != null ? data["update_url"] : "";
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

class SettingItem extends StatelessWidget {
  final bool havaMargin;
  final String title;
  final String subTitle;
  final bool isQuit;
  final bool isArrow;
  final ValueChanged<bool> onChange;
  final VoidCallback onTap;

  SettingItem(
      {this.havaMargin,
      @required this.title,
      this.subTitle,
      this.isQuit,
      this.isArrow,
      this.onChange,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> _row = List();
    _row.add(Text(title,
        style: TextStyle(
            color: isQuit != null && isQuit ? Color(0xFFDAD619) : Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 12)));
    if (subTitle != null && subTitle.isNotEmpty) {
      _row.add(Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil().L(10)),
              child: Text(subTitle,
                  style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontWeight: FontWeight.w400,
                      fontSize: 10)))));
    } else {
      _row[0] = Expanded(child: _row[0]);
    }
    if (isQuit == null || !isQuit) {
      if (isArrow) {
        _row.add(Icon(Icons.arrow_forward_ios,
            size: ScreenUtil().L(10), color: Color(0xFFACACAC)));
      } else {
        _row.add(Switch(onChange));
      }
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenUtil().L(45),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
        padding: EdgeInsets.only(
            left: ScreenUtil().L(20), right: ScreenUtil().L(10)),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().L(15),
            vertical:
                havaMargin != null && havaMargin ? ScreenUtil().L(10) : 0),
        child: Row(
          children: _row,
        ),
      ),
    );
  }
}

class Switch extends StatefulWidget {
  final ValueChanged<bool> onChange;

  Switch(this.onChange);

  @override
  _SwitchState createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  bool messageOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().L(40),
      height: ScreenUtil().L(25),
      child: FittedBox(
        fit: BoxFit.fill,
        child: CupertinoSwitch(
            value: messageOn,
            onChanged: (on) {
              setState(() {
                messageOn = on;
                if (widget.onChange != null) widget.onChange(on);
              });
            },
            activeColor: Color(0xFFFFCD02)),
      ),
    );
  }
}
