import 'package:flutter_shop/pages/login/FindPasswordPage.dart';
import 'package:flutter_shop/pages/login/RegisterPage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter/material.dart';

class LoginByShortMessagePage extends StatefulWidget {
  @override
  _LoginByShortMessagePageState createState() => _LoginByShortMessagePageState();
}

class _LoginByShortMessagePageState extends State<LoginByShortMessagePage> {
  final _formKey = GlobalKey<FormState>();
  String _telphone, _password;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Navigator.pop(context);
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
            routePagerNavigator(context, RegisterPage());
          },
        ),
        GestureDetector(
          child: Text(
            '找回密码',
            style: TextStyle(color: Colors.orangeAccent),

          ),
          onTap: () {
            Navigator.pop(context);
            routePagerNavigator(context, RegisterPage());
          },
        ),
      ],
    ),
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
          color: Colors.grey,
          textColor: Colors.white,
          //disabledColor:Colors.grey,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              print('telphone:$_telphone , assword:$_password');
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
          labelText: '密码',
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
        var telphoneReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!telphoneReg.hasMatch(value)) {
          return '请输入正确的手机号码';
        }
      },
      onSaved: (String value) => _telphone = value,
    );
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
}
