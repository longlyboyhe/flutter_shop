import 'package:flutter/material.dart';
import 'package:flutter_shop/model/ShareImageModel.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 可拖拽的Flow
/// @author longlyboyhe
/// @date 2019/2/23
///
typedef Delete = Widget Function(ShareImageModel model, int position);

class DragableFlow extends StatefulWidget {
  List<ShareImageModel> items;
  final Delete onDelete;

  DragableFlow(this.items, {this.onDelete});

  @override
  _DragableFlowState createState() => _DragableFlowState();
}

class _DragableFlowState extends State<DragableFlow> {
  List<Widget> children = List();

  void _buildChildren() {
    children.clear();
    print("DragableFlow items=${widget.items.length}");
    if (widget.items != null) {
      for (int index = 0; index < widget.items.length; index++) {
        ShareImageModel item = widget.items[index];
        children.add(Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().L(9),
              top: ScreenUtil().L(4),
              bottom: ScreenUtil().L(4)),
          decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.all(Radius.circular(3.0)),
              boxShadow: [
                BoxShadow(
                    color: Color(0xFFDBDBDB),
                    offset: Offset(0, 1),
                    blurRadius: 1)
              ]),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Text(item.attr,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
            GestureDetector(
              onTap: () {
                if (widget.onDelete != null) widget.onDelete(item, index);
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().L(7), right: ScreenUtil().L(7)),
                  child: Image.asset("images/icon_clear.png",
                      width: 18.0, height: 18.0)),
            )
          ]),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildChildren();
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
          spacing: 5.0, // gap between adjacent chips
          runSpacing: 5.0, // gap between lines
          children: children),
    );
  }
}
