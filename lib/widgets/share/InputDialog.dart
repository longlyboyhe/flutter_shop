import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';

///
/// dialog中添加输入框必须使用StatefulWidget，否则输入框内text获取不到
/// 自定义分享价格/自定义商品描述
/// @author longlyboyhe
/// @date 2019/2/25
///
class InputDialog extends StatefulWidget {
  String message;
  String hintText;
  String buttonText;
  bool isMoney;
  ValueChanged<String> onSave;

  InputDialog(
      {@required this.message,
      @required this.buttonText,
      this.hintText,
      this.isMoney = false,
      this.onSave});

  @override
  _InputDialogState createState() => _InputDialogState();
}

///只能输入两位小数的小数
class MyTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value != "" && value.trim() == oldValue.text.trim()) {
      //输入了空格
      value = value.trim();
      selectionIndex--;
    } else if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
        strToFloat(value, defaultDouble) == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    } else if (value.contains(".") &&
        value.substring(value.lastIndexOf("."), value.length - 1).length > 2) {
      //最多两位小数
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class _InputDialogState extends State<InputDialog> {
  String inputText = "";

  List<TextInputFormatter> inputFormatters = List();
  TextInputType keyboardType;

  @override
  void initState() {
    super.initState();
    if (widget.isMoney) {
      inputFormatters.add(MyTextInputFormatter());
      keyboardType = TextInputType.number;
    } else {
      keyboardType = TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _body = [];
    _body.add(Expanded(
        child: Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 5.0, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Text(widget.message,
              style: TextStyle(
                  color: Color(0xFFACACAC),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          Padding(
              padding: EdgeInsets.only(top: 26, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.isMoney
                      ? Text("￥",
                          style: TextStyle(
                              color: Color(0xFFACACAC),
                              fontSize: 14,
                              fontWeight: FontWeight.w400))
                      : Container(),
                  Container(
                      width: 100,
                      child: TextField(
                        onChanged: (value) {
                          print("value====$value");
                          inputText = value;
                        },
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                        keyboardType: keyboardType,
                        inputFormatters: inputFormatters,
                        decoration: InputDecoration(
                            hintText: widget.hintText,
                            contentPadding:
                                EdgeInsets.only(left: 15, right: 15),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Color(0xFFACACAC),
                                fontWeight: FontWeight.w400,
                                fontSize: 10)),
                      ))
                ],
              )),
          Container(
            color: KColor.dividerColor,
            height: 1.0,
            margin: EdgeInsets.only(bottom: 16),
          ),
          RawMaterialButton(
            //控件没有margin
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            elevation: 0,
            fillColor: Color(0xFFEFEFEF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            onPressed: () {
              if (inputText.isEmpty) {
                ToastUtil.showToast(context, "请输入");
              } else {
                widget.onSave(inputText);
              }
            },
            child: Text(widget.buttonText,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
            constraints: BoxConstraints(
                minHeight: 45,
                maxHeight: 45,
                minWidth: double.infinity,
                maxWidth: double.infinity),
          )
        ],
      ),
    )));
    _body.add(RawMaterialButton(
      //控件没有margin
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.only(
          left: 5.0, right: 10.0, top: 10.0, bottom: 10.0),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Icon(Icons.clear, size: 15, color: Colors.black),
      constraints: BoxConstraints(minWidth: 10, minHeight: 10),
    ));
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minHeight: 80),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _body,
                ),
              )
            ],
          ),
        ));
  }
}
