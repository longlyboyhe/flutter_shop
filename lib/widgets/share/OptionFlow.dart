import 'package:flutter/material.dart';
import 'package:flutter_shop/model/ShareImageModel.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/share/DragableFlow.dart';
import 'package:flutter_shop/widgets/share/InputDialog.dart';

///
/// 备选flow
/// @author longlyboyhe
/// @date 2019/2/23
///
typedef Custom = Widget Function(ShareImageModel model, int size);

class OptionFlow extends StatefulWidget {
  List<ShareImageModel> items;
  final Delete onSelected;
  final Custom onCustom;
  final int maxCustomNum;

  OptionFlow(this.items,
      {this.onSelected, this.onCustom, @required this.maxCustomNum});

  @override
  _OptionFlowState createState() => _OptionFlowState();
}

class _OptionFlowState extends State<OptionFlow> {
  List<ShareImageModel> typeItems = List();
  List<ShareImageModel> customs = List();

  List<Widget> children = List();

  void _buildChildren() {
    //使用clear清除不掉
    children = List();
    typeItems = List();
    if (widget.items != null) typeItems.addAll(widget.items);
    if (customs.length < 5) typeItems?.add(ShareImageModel(attr: "+"));
    for (int index = 0; index < typeItems.length; index++) {
      ShareImageModel item = typeItems[index];
      children.add(item.attr == "+"
          ? CustomButton(onTap: () {
              _addCustomAttr();
            })
          : GestureDetector(
              onTap: () {
                if (widget.onSelected != null) widget.onSelected(item, index);
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().L(9),
                    right: ScreenUtil().L(9),
                    top: ScreenUtil().L(4),
                    bottom: ScreenUtil().L(4)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                    border: Border.all(color: Colors.black, width: 1.0)),
                child: Text(item.attr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12)),
              ),
            ));
    }
  }

  _addCustomAttr() {
    showDialog(
        context: context,
        builder: (context) {
          return InputDialog(
            message: '自定义商品描述',
            buttonText: '保存',
            hintText: '请输入描述',
            onSave: (text) {
              ShareImageModel model = ShareImageModel(attr: text, name: text);
              if (widget.onCustom != null)
                widget.onCustom(model, widget.maxCustomNum - customs.length);
              addCustomButton(model);
              Navigator.pop(context);
            },
          );
        });
  }

  void addCustomButton(ShareImageModel attr) {
    if (customs.length < 5) {
      customs.add(attr);
      if (customs.length == 5) {
        typeItems.removeLast();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _buildChildren();
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
          spacing: 9.0, // gap between adjacent chips
          runSpacing: 5.0, // gap between lines
          children: children),
    );
  }
}

class CustomButton extends StatelessWidget {
  VoidCallback onTap;

  CustomButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().L(9),
            right: ScreenUtil().L(9),
            top: ScreenUtil().L(4),
            bottom: ScreenUtil().L(4)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            border: Border.all(color: Color(0xFFBCBCBC), width: 1.0)),
        child: Text("自定义 +",
            style: TextStyle(
                color: Color(0xFFBCBCBC),
                fontWeight: FontWeight.w400,
                fontSize: 12)),
      ),
    );
  }
}
