import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';
import 'package:flutter_shop/widgets/mine/CountDownView.dart';
import 'package:flutter_shop/widgets/mine/InputView.dart';

///
/// 修改登录密码
/// @author longlyboyhe
/// @date 2019/3/8
///
class FindLoginPassword extends StatefulWidget {
  @override
  _FindLoginPasswordState createState() => _FindLoginPasswordState();
}

class _FindLoginPasswordState extends State<FindLoginPassword> {
  GlobalKey<CountDownViewState> _countdownKey = GlobalKey();
  GlobalKey<AppButtonState> _appButtonKey = GlobalKey();
  bool verifyByPhone = true;
  String oldPassword = "";
  String verifyCode = "";
  String newPassword = "";

  void setButtonEnable() {
    if (oldPassword.isNotEmpty &&
        verifyCode.isNotEmpty &&
        newPassword.isNotEmpty) {
      _appButtonKey.currentState.setEnable(true);
    } else {
      _appButtonKey.currentState.setEnable(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KColor.mineBgColor,
        appBar: CommonAppBar(
            context: context,
            title: "修改登录密码",
            bottom: CommonAppBarBottomLine()),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          PassWordInput(
            inputType: InputType.password,
            lableText: "当前登陆密码",
            hintText: "请输入",
            getInputText: (string) {
              oldPassword = string;
              setButtonEnable();
            },
          ),
          PassWordInput(
            inputType: InputType.countdown,
            lableText: verifyByPhone ? "手机验证码" : "邮箱验证码",
            hintText: "请输入",
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
            countDownView: CountDownView(
              key: _countdownKey,
              title: verifyByPhone ? "获取验证码" : "邮箱验证",
              margin: EdgeInsets.all(ScreenUtil().L(10)),
              onTap: () {
                //TODO 分邮箱验证还是手机号验证
                Future.delayed(Duration(seconds: 1), () {
                  _countdownKey.currentState.setStartLoadding(false);
                  _countdownKey.currentState.startCountDown();
                });
              },
            ),
            getInputText: (string) {
              verifyCode = string;
              setButtonEnable();
            },
          ),
          PassWordInput(
            inputType: InputType.password,
            lableText: "新密码",
            hintText: "请输入",
            getInputText: (string) {
              newPassword = string;
              setButtonEnable();
            },
          ),
          AppButton(
            key: _appButtonKey,
            title: "确定",
            margin: EdgeInsets.only(
                left: ScreenUtil().L(15),
                right: ScreenUtil().L(15),
                top: ScreenUtil().L(30)),
            onTap: () {
              Future.delayed(Duration(seconds: 1), () {
                _appButtonKey.currentState.setStartLoadding(false);
              });
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                verifyByPhone = !verifyByPhone;
              });
            },
            child: Container(
              padding: EdgeInsets.only(
                  right: ScreenUtil().L(15), top: ScreenUtil().L(10)),
              alignment: Alignment.centerRight,
              child: Text(verifyByPhone ? "邮箱验证" : "手机号验证",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),
          )
        ])));
  }
}
