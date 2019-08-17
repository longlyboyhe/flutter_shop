import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/natives/umengshare.dart';
import 'package:flutter_shop/pages/ApplicationPage.dart';
import 'package:flutter_shop/pages/login/FindPasswordPage.dart';
import 'package:flutter_shop/pages/login/LoginByShortMessagePage.dart';
import 'package:flutter_shop/pages/login/RegisterPage.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/RegexUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _telphone, _password;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          brightness: Brightness.light,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                SizedBox(height: 30.0),
                buildTitle(),
                buildRegisterText(context),
                SizedBox(height: 70.0),
                buildTelPhoneTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildOtherLoginAndForgetPasswordText(),
                _otherLoad(),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '立即注册',
                style: TextStyle(color: Colors.orangeAccent),
              ),
              onTap: () {
                print('去注册');
                routePagerNavigator(context, RegisterPage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Align buildOtherLoginAndForgetPasswordText() {
    return Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Text(
              '短信登录',
              style: TextStyle(color: Colors.orangeAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              routePagerNavigator(context, LoginByShortMessagePage());
            },
          ),
          GestureDetector(
            child: Text(
              '找回密码',
              style: TextStyle(color: Colors.orangeAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              routePagerNavigator(context, FindPasswordPage());
            },
          ),
        ],
      ),
    );
  }

  Widget _otherLoad() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                iconSize: 55,
                icon: Image.asset(
                  "images/icon_qq.png",
                ),
                onPressed: () {
                  ToastUtil.showToast(context, "QQ登录");
                  UMengShare.login(UMPlatform.QQ,
                      onResult: (Map<String, String> userInfo) {
                    print("登录了=${userInfo.toString()}");
                  });
                }),
            IconButton(
                iconSize: 55,
                icon: Image.asset("images/icon_wechat.png"),
                onPressed: () {
                  ToastUtil.showToast(context, "微信登录");
                  UMengShare.login(UMPlatform.Wechat);
                })
          ]),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Container(
      child: Container(
//        alignment: Alignment.topCenter,
        height: 45.0,
//        width:300.0,
        child: RaisedButton(
          child: Text(
            '登录',
            //style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.orangeAccent,
          textColor: Colors.white,
          //disabledColor:Colors.grey,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              print('telphone:$_telphone , assword:$_password');
              loadData(_telphone, _password);
            }
          },
          //shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: '请输入密码',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildTelPhoneTextField() {
    return TextFormField(
        decoration: InputDecoration(
          labelText: '手机号',
        ),
        validator: (String value) {
          if (!RegexUtils.isMobileExact(value)) {
            return '请输入正确的手机号码';
          }
        },
        onSaved: (String value) => _telphone = value);
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登录',
        style: TextStyle(fontSize: 38.0),
      ),
    );
  }

  void loadData(String telphone, String password) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String imei = "";
    if (Platform.isIOS) {
      //ios相关代码
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      imei = iosDeviceInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      //android相关代码
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      imei = androidDeviceInfo.androidId;
    }
    Map<String, String> bodyParm = {
      'userPhone': telphone,
      'password': password,
      'imei': imei,
      'areaMobile': '86',
      'countryMobile': '中国'
    };
    //加载联系人列表
    HttpManager.instance.post(context,
        Api.USER_LOGIN,
        (json) {
          int code = json['result'];
          String msg = json['msg'];
          String memberId = json['memberId'];
          int memberCertificationState = json['memberCertificationState'];
          String token = json['token'];
          if (code == 1) {
            Map<String, dynamic> params = new Map();
            params[DataUtils.SP_AC_TOKEN] = token;
            params[DataUtils.SP_MEMBER_ID] = memberId;
            params[DataUtils.SP_MEMBER_CER_STATE] = memberCertificationState;
            Navigator.of(context).pop();
            routePagerNavigator(context, ApplicationPage());
          } else {
            ToastUtil.showToast(context, msg);
          }
        },
        params: bodyParm,
        errorCallback: (error) {
          ToastUtil.showToast(context, error);
        });
  }
}
