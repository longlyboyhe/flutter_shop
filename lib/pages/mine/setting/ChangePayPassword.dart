import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/Constants.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/pages/Orders/OrderPage.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';
import 'package:flutter_shop/widgets/mine/InputView.dart';
///
/// 修改支付密码
/// @author longlyboyhe
/// @date 2019/3/25
///
class ChangePayPassword extends StatefulWidget {
  ///是否来自结算中心-未设置密码，设置成功之后跳转到订单待支付
  final bool fromSetteleCenter;

  ChangePayPassword({this.fromSetteleCenter = false});

  @override
  _ChangePayPasswordState createState() => _ChangePayPasswordState();
}

class _ChangePayPasswordState extends State<ChangePayPassword> {
  GlobalKey<AppButtonState> _appButtonKey = GlobalKey();
  String loginPassword = "";
  String payPassword1 = "";
  String payPassword2 = "";

  void setButtonEnable() {
    if (loginPassword.isNotEmpty &&
        payPassword1.isNotEmpty &&
        payPassword2.isNotEmpty) {
      _appButtonKey.currentState.setEnable(true);
    } else {
      _appButtonKey.currentState.setEnable(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          context: context,
          title: "修改支付密码",
          onBackPressed: () {
            onBackPressed();
          },
          bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        PassWordInput(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(10)),
          inputType: InputType.password,
          lableText: "登陆密码",
          hintText: "请输入",
          getInputText: (string) {
            loginPassword = string;
          },
        ),
        PassWordInput(
          margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
          inputType: InputType.pay_password,
          lableText: "支付密码",
          hintText: "请输入",
          getInputText: (string) {
            payPassword1 = string;
          },
        ),
        PassWordInput(
          margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(10)),
          inputType: InputType.pay_password,
          lableText: "确认密码",
          hintText: "请输入",
          getInputText: (string) {
            payPassword2 = string;
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
            _changePayPassword();
          },
        ),
      ])),
    );
  }

  _changePayPassword() async{
    if(payPassword1!=payPassword2){
      _appButtonKey.currentState.setStartLoadding(false);
      ToastUtil.showToast(context, "两次输入的支付密码不一样");
      return;
    }

    if (payPassword1.length != 6) {
      _appButtonKey.currentState.setStartLoadding(false);
      ToastUtil.showToast(context, "支付密码不满6位");
      return;
    }

    User user= await  DataUtils.getUserInfo();
    String pwd=hex.encode(md5.convert(utf8.encode((loginPassword+Constants.MD5_SECRET_KEY))).bytes);
    String paypwd=hex.encode(md5.convert(utf8.encode((payPassword1+Constants.MD5_SECRET_KEY))).bytes);
    HttpManager().post(context,Api.SET_PAY_PASSWORD, (result){
      BaseResp baseResp=BaseResp.fromJson(result);
      if(baseResp.result!=null && baseResp.result.isSuccess){
        ToastUtil.showToast(context, "密码设置成功");
        Navigator.pop(context);
      } else {
        ToastUtil.showToast(context, "密码设置失败");
      }
      _appButtonKey.currentState.setStartLoadding(false);
    }, errorCallback: (error) {
      ToastUtil.showToast(context, "密码设置失败");
      _appButtonKey.currentState.setStartLoadding(false);
    },params: {
      "user_id":user?.userId.toString(),
      "password":pwd,
      "pay_pwd":paypwd,
    });
  }

  void onBackPressed() {
    if (widget.fromSetteleCenter) {
      routePagerNavigator(context, OrderPage(0)).then((value) {
        Navigator.pop(context);
      });
    } else {
      Navigator.pop(context);
    }
  }
}
