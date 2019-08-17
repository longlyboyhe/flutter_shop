import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/mine/CountDownView.dart';

///
/// 输入框
/// @author longlyboyhe
/// @date 2019/3/8
///
enum InputType { password, text, countdown, phone, number,pay_password }

class PassWordInput extends StatefulWidget {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final String lableText;
  final TextStyle lableStyle;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle inputStyle;
  final InputType inputType;
  final CountDownView countDownView;
  final ValueChanged<String> getInputText;
  final TextDirection textDirection;

  PassWordInput(
      {this.margin = const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      this.lableText,
      this.hintText,
      @required this.inputType,
      this.countDownView,
      this.getInputText,
      this.lableStyle = const TextStyle(
          color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
      this.hintStyle = const TextStyle(
          color: Color(0xFFACACAC), fontWeight: FontWeight.w400, fontSize: 12),
      this.inputStyle = const TextStyle(
          color: Color(0xFFACACAC), fontWeight: FontWeight.w400, fontSize: 12),
      this.padding = const EdgeInsets.only(left: 20),
      this.textDirection = TextDirection.ltr});

  @override
  _PassWordInputState createState() => _PassWordInputState();
}

class _PassWordInputState extends State<PassWordInput> {
  String _inputText = "";
  bool showPwd = false;
  TextEditingController _controller;
  List<TextInputFormatter> inputFormatters = List();
  TextInputType keyboardType;

  @override
  void initState() {
    super.initState();
    if (widget.inputType == InputType.phone) {
      inputFormatters.add(LengthLimitingTextInputFormatter(11));
      inputFormatters.add(WhitelistingTextInputFormatter.digitsOnly);
      keyboardType = TextInputType.phone;
    } else if (widget.inputType == InputType.number) {
      inputFormatters.add(WhitelistingTextInputFormatter.digitsOnly);
      keyboardType = TextInputType.number;
    } else if (widget.inputType == InputType.countdown) {
      keyboardType = TextInputType.number;
    }else if(widget.inputType==InputType.pay_password){
      keyboardType=TextInputType.number;
      inputFormatters.add(LengthLimitingTextInputFormatter(6));
      inputFormatters.add(WhitelistingTextInputFormatter.digitsOnly);
    } else {
      keyboardType = TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _suffix;
    if (widget.inputType == InputType.password || widget.inputType==InputType.pay_password) {
      _suffix = GestureDetector(
        onTap: () {
          ///搜索框内清除按钮
          setState(() {
            showPwd = !showPwd;
          });
        },
        child: showPwd?Image.asset("images/pwd_open.png"):Image.asset("images/pwd_close.png"),
//        child: Icon(Icons.remove_red_eye,
//            size: ScreenUtil().L(15),
//            color: showPwd ? Colors.black : KColor.dividerColor),
      );
    } else if (widget.inputType == InputType.countdown) {
      _suffix = widget.countDownView;
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
              child: Icon(Icons.clear, size: 15, color: KColor.dividerColor))
          : ConstrainedBox(constraints: BoxConstraints.tight(Size(15, 15)));
    }
    return Container(
      margin: widget.margin,
      alignment: Alignment.center,
      padding: widget.padding,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
      child: Row(
        children: <Widget>[
          Text(widget.lableText, style: widget.lableStyle),
          Expanded(
              child: TextField(
            controller: _controller,
            textDirection: widget.textDirection,
            inputFormatters: inputFormatters,
            style: widget.inputStyle,
            keyboardType: keyboardType,
            obscureText: !showPwd && (widget.inputType == InputType.password||widget.inputType==InputType.pay_password),
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
                suffixIcon: _suffix,
                hintText: widget.hintText,
                contentPadding:
                    EdgeInsets.only(left: ScreenUtil().L(10), right: -5),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    borderSide: BorderSide.none),
                hintStyle: widget.hintStyle),
          ))
        ],
      ),
    );
  }
}
