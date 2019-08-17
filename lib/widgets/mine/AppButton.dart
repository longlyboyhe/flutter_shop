import 'package:flutter/material.dart';

///
/// 可以设置是否可以点击(带loadding)
/// @author longlyboyhe
/// @date 2019/3/7
///
class AppButton extends StatefulWidget {
  final String title;
  final Color enableColor;
  final Color disableColor;
  final EdgeInsets margin;
  final double height;
  final VoidCallback onTap;
  final bool enable;
  final bool useLoadding;
  final Color textColor;

  AppButton(
      {Key key,
      this.enableColor = Colors.black,
      this.disableColor = const Color(0xFFD8D8D8),
      @required this.title,
      this.margin,
      this.textColor,
      this.height = 45,
      this.onTap,
      this.enable = false,
      this.useLoadding = true})
      : super(key: key);

  @override
  AppButtonState createState() => AppButtonState();
}

class AppButtonState extends State<AppButton> {
  bool _enable;

  bool _loadding = false;

  @override
  void initState() {
    super.initState();
    _enable = widget.enable;
  }

  void setEnable(bool enable) {
    if (_enable != enable) {
      setState(() {
        _enable = enable;
      });
    }
  }

  void setStartLoadding(bool loadding) {
    if (_loadding != loadding) {
      setState(() {
        _loadding = loadding;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_enable && !_loadding) {
          if (widget.useLoadding) setStartLoadding(true);
          widget.onTap();
        }
      },
      child: Container(
        height: widget.height,
        margin: widget.margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _enable ? widget.enableColor : widget.disableColor,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Stack(
          children: <Widget>[
            Offstage(
              offstage: _loadding,
              child: Text(widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: widget.textColor==null ? Colors.white : widget.textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),
            Offstage(
              offstage: !_loadding,
              child: Container(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
