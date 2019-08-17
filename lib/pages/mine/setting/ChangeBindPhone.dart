import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';
import 'package:flutter_shop/widgets/mine/CountDownView.dart';
import 'package:flutter_shop/widgets/mine/InputView.dart';

///
/// 修改绑定手机号
/// @author longlyboyhe
/// @date 2019/3/8
///
class ChangeBindPhone extends StatefulWidget {
  @override
  _ChangeBindPhoneState createState() => _ChangeBindPhoneState();
}

class _ChangeBindPhoneState extends State<ChangeBindPhone> {
  GlobalKey<CountDownViewState> _oldPhoneCountdownKey = GlobalKey();
  GlobalKey<CountDownViewState> _newPhonecountdownKey = GlobalKey();
  GlobalKey<AppButtonState> _appButtonKey = GlobalKey();
  bool verifyByPhone = true;
  String password = "";
  String oldPhoneVerifyCode = "";
  String newPhone = "";
  String newPhoneVerifyCode = "";

  void setButtonEnable() {
    if (password.isNotEmpty &&
        oldPhoneVerifyCode.isNotEmpty &&
        newPhone.isNotEmpty &&
        newPhoneVerifyCode.isNotEmpty &&
        StringUtils.verifyPhone(newPhone)) {
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
            title: "修改绑定手机号",
            bottom: CommonAppBarBottomLine()),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          PassWordInput(
            inputType: InputType.password,
            lableText: "当前登陆密码",
            hintText: "请输入",
            getInputText: (string) {
              password = string;
              setButtonEnable();
            },
          ),
          PassWordInput(
            inputType: InputType.countdown,
            lableText: verifyByPhone ? "手机验证码" : "邮箱验证码",
            hintText: "请输入",
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
            countDownView: CountDownView(
              key: _oldPhoneCountdownKey,
              title: verifyByPhone ? "获取验证码" : "邮箱验证",
              margin: EdgeInsets.all(ScreenUtil().L(10)),
              onTap: () {
                //TODO 分邮箱验证还是手机号验证
                Future.delayed(Duration(seconds: 1), () {
                  _oldPhoneCountdownKey.currentState.setStartLoadding(false);
                  _oldPhoneCountdownKey.currentState.startCountDown();
                });
              },
            ),
            getInputText: (string) {
              oldPhoneVerifyCode = string;
              setButtonEnable();
            },
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(10)),
            child: Column(
              children: <Widget>[
                PassWordInput(
                  inputType: InputType.phone,
                  margin: EdgeInsets.zero,
                  lableText: "新手机号",
                  hintText: "请输入",
                  getInputText: (string) {
                    newPhone = string;
                    setButtonEnable();
                  },
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(20)),
                  color: KColor.bgColor,
                ),
                PassWordInput(
                  margin: EdgeInsets.zero,
                  inputType: InputType.countdown,
                  lableText: "验证码",
                  hintText: "请输入",
                  countDownView: CountDownView(
                    key: _newPhonecountdownKey,
                    title: "获取验证码",
                    margin: EdgeInsets.all(ScreenUtil().L(10)),
                    onTap: () {
                      Future.delayed(Duration(seconds: 1), () {
                        _newPhonecountdownKey.currentState
                            .setStartLoadding(false);
                        _newPhonecountdownKey.currentState.startCountDown();
                      });
                    },
                  ),
                  getInputText: (string) {
                    newPhoneVerifyCode = string;
                    setButtonEnable();
                  },
                ),
              ],
            ),
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
