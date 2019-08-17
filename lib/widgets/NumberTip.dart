import 'package:flutter/material.dart';

///
/// 红点提示数量
/// @author longlyboyhe
/// @date 2019/1/25
///
class NumberTip extends StatefulWidget {
  int nums;

  ///是否显示小红点（不传nums）
  bool alwaysShow;
  double radius;
  EdgeInsetsGeometry margin;

  NumberTip(
      {Key key,
      this.nums,
      this.alwaysShow = false,
      this.radius = 7,
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  _NumberTipState createState() => _NumberTipState();
}

class _NumberTipState extends State<NumberTip> {
  void updateNum(int num) {
    setState(() {
      widget.nums = num;
    });
  }

  String setNum(int num) {
    if (num == null) return "";
    if (num < 0) return "0";
    if (num < 100) return "$num";
    if (num >= 100) return "99+";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Offstage(
        offstage:
            !widget.alwaysShow && !(widget.nums != null && widget.nums > 0),
        child: CircleAvatar(
            backgroundColor: Color(0xFFC10000),
            radius: widget.radius,
            child: Text(
              setNum(widget.nums),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
