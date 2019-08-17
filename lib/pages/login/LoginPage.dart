import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/Constants.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';
import 'package:flutter_shop/widgets/mine/InputView.dart';
///
/// 登录
/// @author longlyboyhe
/// @date 2019/3/20
///
class LoginPage extends StatefulWidget {
  Function callback;

  //是否pop页面
  bool isPop;

  LoginPage({this.callback, this.isPop});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<AppButtonState> _appButtonKey = GlobalKey();
  String account = "";
  String password = "";
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  Color defaultColor = Color(0xFF6A6A6A);
  Color textColor;

  @override
  void initState() {
    super.initState();
  }

  void setButtonEnable() {
    if (password.isNotEmpty && account.isNotEmpty) {
      _appButtonKey.currentState.setEnable(true);
    } else {
      _appButtonKey.currentState.setEnable(false);
    }
    setState(() {
      textColor = password.isNotEmpty && account.isNotEmpty
          ? Colors.white
          : defaultColor;
    });
  }

  void loadLogin(BuildContext context, String username, String password) {
    if(username==null || username.isEmpty){
      ToastUtil.showToast(context, "请输入账号");
      return;
    }

    if(password==null || password.isEmpty){
      ToastUtil.showToast(context, "请输入密码");
      return;
    }

    String pwd=hex.encode(md5.convert(utf8.encode((password+Constants.MD5_SECRET_KEY))).bytes);
    Map<String, String> bodyParm = {
      'username': username,
      'platform': 'phone',
      'password': pwd,
    };
    //加载联系人列表
    HttpManager.instance.post(context,Api.USER_LOGIN, (json) {
      LoginModel loginModel=LoginModel.fromJson(json);
      if (loginModel != null && loginModel.result != null &&
          loginModel.result.isSuccess) {
        var data = loginModel.data;
        if (data != null) {
          if (data.user != null) {
            DataUtils.saveUserInfo(data.user);
          }
          if (data.token != null) {
            DataUtils.saveLoginInfo(data.token);
          }
        }
        ToastUtil.showToast(context, "登录成功");
        DataUtils.setLoginSuccess(true);
        HttpManager().refreshHeader();
        Navigator.of(context).pushReplacementNamed('/MainPage');
      } else {
        ToastUtil.showToast(context, "登陆失败");
      }
      _appButtonKey.currentState.setStartLoadding(false);
    },
    errorCallback: (error) {
      ToastUtil.showToast(context, "登陆失败");
      _appButtonKey.currentState.setStartLoadding(false);
    },params: bodyParm);
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: ScreenUtil.designWidth)..init(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: <Widget>[
            Image.asset(
              "images/login_bg.png",
              width: ScreenUtil.screenWidth,
              height: ScreenUtil.screenHeight,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.only(top: screenUtil.L(90)),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: screenUtil.L(90)),
                    child: Image.asset("images/login_logo.png",
                        fit: BoxFit.fitHeight),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenUtil.L(20)),
                    child: InputView(
                      inputType: InputType.text,
                      hintText: "账号",
                      getInputText: (string) {
                        account = string;
                        setButtonEnable();
                      },
                    ),
                  ),
                  InputView(
                    inputType: InputType.password,
                    hintText: "密码",
                    getInputText: (string) {
                      password = string;
                      setButtonEnable();
                    },
                  ),
                  AppButton(
                    key: _appButtonKey,
                    disableColor: Color(0xFF000000),
                    textColor: textColor,
                    title: "确定",
                    margin: EdgeInsets.only(
                        left: ScreenUtil().L(50),
                        right: ScreenUtil().L(50),
                        top: ScreenUtil().L(50)),
                    onTap: () {
                      loadLogin(context, account, password);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
                bottom: ScreenUtil().L(30),
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil.screenWidth,
                  child: Text(
                    KString.loginTip,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 10),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class InputView extends StatefulWidget {
  final EdgeInsets margin;
  final InputType inputType;
  final ValueChanged<String> getInputText;
  final String hintText;

  InputView(
      {this.margin = const EdgeInsets.symmetric(horizontal: 50),
      this.inputType,
      this.getInputText,
      this.hintText = ""});

  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  String _inputText = "";
  bool showPwd = false;
  TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    Widget _suffix;
    if (widget.inputType == InputType.password) {
      _suffix = GestureDetector(
        onTap: () {
          ///搜索框内清除按钮
          setState(() {
            showPwd = !showPwd;
          });
        },
        child: showPwd
            ? Image.asset("images/pwd_open.png")
            : Image.asset("images/pwd_close.png"),
      );
    } else {
      _controller = TextEditingController.fromValue(TextEditingValue(
          text: _inputText,
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream, offset: _inputText.length))));
      _suffix = _inputText.isNotEmpty
          ? GestureDetector(
              onTap: () {
                ///搜索框内清除按钮
                setState(() {
                  _inputText = "";
                  if (widget.getInputText != null) widget.getInputText("");
                });
              },
              child: Icon(Icons.clear, size: 20, color: Colors.black54))
          : ConstrainedBox(constraints: BoxConstraints.tight(Size(15, 15)));
    }
    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
            keyboardType: TextInputType.text,
            obscureText: !showPwd && widget.inputType == InputType.password,
            onChanged: (string) {
              if (widget.getInputText != null) widget.getInputText(string);
              if (widget.inputType == InputType.text ||
                  widget.inputType == InputType.phone ||
                  widget.inputType == InputType.number) {
                setState(() {
                  _inputText = string;
                });
              }
            },
            decoration: InputDecoration(
                prefixIcon: widget.inputType == InputType.password
                    ? Image.asset("images/password.png")
                    : Image.asset("images/account.png"),
                suffixIcon: _suffix,
                hintText: widget.hintText,
                contentPadding:
                    EdgeInsets.only(left: ScreenUtil().L(10), right: -5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide.none),
                hintStyle: TextStyle(
                    color: Color(0xFFACACAC),
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
          ),
          Container(
            color: Colors.black,
            height: 1,
          )
        ],
      ),
    );
  }
}
