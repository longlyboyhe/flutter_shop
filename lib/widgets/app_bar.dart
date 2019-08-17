import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 统一APPBar
/// @author longlyboyhe
/// @date 2019/1/31
///
Widget CommonAppBar(
    {@required BuildContext context,
    Color backgroundColor = const Color(0xFFFFFFFF),
    Color backColor = const Color(0xFF000000),
    bool existBackIcon = true,
    @required String title,
    onBackPressed,
    List<Widget> actions,
    PreferredSizeWidget bottom}) {
  return AppBar(
    backgroundColor: backgroundColor,
    brightness: Brightness.light,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
    ),
    leading: existBackIcon
        ? IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: backColor,
            ),
            onPressed: onBackPressed != null
                ? onBackPressed
                : () {
                    Navigator.pop(context);
                  })
        : Container(),
    actions: actions,
    bottom: bottom,
  );
}

//AppBar底部的一条线
Widget CommonAppBarBottomLine() {
  return PreferredSize(
      child: Container(
        color: KColor.dividerColor,
        height: ScreenUtil().L(1),
      ),
      preferredSize: Size.fromHeight(ScreenUtil().L(1)));
}

class Button extends StatefulWidget {
  Widget child;
  VoidCallback onPressed;
  EdgeInsetsGeometry padding;
  Color fillColor;
  BoxConstraints constraints;

  Button(
      {this.child,
      this.onPressed,
      this.padding = EdgeInsets.zero,
      this.fillColor,
      this.constraints =
          const BoxConstraints(minWidth: 10.0, minHeight: 10.0)});

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      //控件没有margin
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: widget.padding,
      fillColor: widget.fillColor,
      onPressed: widget.onPressed,
      child: widget.child,
      constraints: widget.constraints,
    );
  }
}

///状态栏颜色  我的页面黑底白色图标状态栏，其他默认白底黑色图标
class BlankAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Brightness brightness;
  final Color backgroundColor;
  double height;

  BlankAppBar(
      {this.brightness = Brightness.light,
      this.height = 0.0,
      this.backgroundColor = const Color(0xFFFFFFFF)});

  @override
  Widget build(BuildContext context) {
    final SystemUiOverlayStyle overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          top: true,
          child: Container(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
