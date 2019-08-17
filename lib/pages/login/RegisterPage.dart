import 'package:flutter_shop/utils/RegexUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _telphone,_verifycode, _password,_invitecode;
  bool _isObscure = true;
  Color _eyeColor,_verifyCodeButtonColor;
  final TextEditingController _telphone_controller = new TextEditingController();

   changeVerifyCodeButton() {
    if (RegexUtils.isMobileExact(_telphone_controller.text.toString())) {
      setState(() {
        _verifyCodeButtonColor = Colors.black;
      });
    } else {
      setState(() {
        _verifyCodeButtonColor = Colors.grey;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _telphone_controller.addListener((){
      changeVerifyCodeButton();
    });
  }

  @override
  void dispose() {
    _telphone_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white12,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back),color: Colors.black, onPressed: () {
            Navigator.pop(context);
          }),),

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
                buildNewUserTipText(context),
                SizedBox(height: 70.0),
                buildTelPhoneTextField(),
                SizedBox(height: 10.0),
                buildShortMessageTextField(context),
                SizedBox(height: 10.0),
                buildPasswordTextField(context),
                SizedBox(height: 10.0),
                buildInviteCodeTextField(context),
                SizedBox(height: 5.0),
                buildInviteCodeText(),
                SizedBox(height: 60.0),
                buildLoginButton(context),
              ],
            )));
  }

  Align buildNewUserTipText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('新用户请先进行手机号验证'),
          ],
        ),
      ),
    );
  }

  Align buildInviteCodeText() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('若没有邀请吗请关注奢批公众号获取邀请码',style: TextStyle(color: Colors.grey),),
          ],
        ),
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
            '下一步',
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

  TextFormField buildInviteCodeTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _invitecode = value,
      decoration: InputDecoration(
        labelText: '请输入邀请码',
      ),
      validator: (String value){
        if (value.isEmpty) {
          return '请输入邀请码';
        }
      },
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入6～20位密码';
        }
      },
      decoration: InputDecoration(
          labelText: '请输入6～20位密码',
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
      controller: _telphone_controller,
      decoration: InputDecoration(
        labelText: '手机号',
      ),
      validator: (String value) {
        if (!RegexUtils.isMobileExact(value)) {
          return '请输入正确的手机号码';
        }
      },
      onSaved: (String value) => _telphone = value,
    );
  }

  TextFormField buildShortMessageTextField(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '短信验证码',
          suffixIcon: Container(
            alignment:Alignment.center,
            width: 130,
            child:RaisedButton(
                color: _verifyCodeButtonColor,
                textColor: Colors.white,//该按钮上文字颜色
                highlightColor: Colors.black,  // 高亮时的背景色
                disabledColor: Colors.grey,//失效时背景色
                child: Text('获取验证码',style:TextStyle(fontSize: 14)),
                onPressed: (){
                if (RegexUtils.isMobileExact(_telphone_controller.text)) {
                 print("获取短信验证码");
                }else if(_telphone_controller.text.isEmpty){
                 ToastUtil.showToast(context, "请输入手机号码");
                }else{
                 ToastUtil.showToast(context, "请输入正确的手机号码");
                }
             }
            ),
          ),

      ),
        validator: (String value) {
          if (value.isEmpty) {
            return '请输入验证码';
          }
        },
        onSaved: (String value) => _verifycode = value,
    );

  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '会员注册',
        style: TextStyle(fontSize: 38.0),
      ),
    );
  }
}
