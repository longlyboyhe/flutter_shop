import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Toast {
  static final int LENGTH_SHORT = 2000;
  static final int LENGTH_LONG = 3500;
  static final int BOTTOM = 0;
  static final int CENTER = 1;
  static final int TOP = 2;

  static void show(String msg, BuildContext context,
      {int duration = 1,
      int gravity = 0,
      Color backgroundColor = const Color(0xCC000000),
      Color textColor = Colors.white,
      double backgroundRadius = 20}) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity, backgroundColor,
        textColor, backgroundRadius);
  }
}

class ToastView {
  static final ToastView _singleton = new ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry overlayEntry;
  static bool _isVisible = false;

  static void createView(
      String msg,
      BuildContext context,
      int duration,
      int gravity,
      Color background,
      Color textColor,
      double backgroundRadius) async {
    overlayState = Overlay.of(context);

    var controllerShowAnim = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var controllerHide = new AnimationController(
      vsync: overlayState,
      duration: Duration(milliseconds: 250),
    );
    var opacityAnim1 =
        new Tween(begin: 0.0, end: 1.0).animate(controllerShowAnim);
    var opacityAnim2 = new Tween(begin: 1.0, end: 0.0).animate(controllerHide);

    overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
            widget: Container(
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(backgroundRadius),
              ),
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 17.0),
              child: Text(msg,
                  style: TextStyle(
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w400)),
            ),
            gravity: gravity,
            opacityAnim1: opacityAnim1,
            opacityAnim2: opacityAnim2,
          ),
    );
    _isVisible = true;

    overlayState.insert(overlayEntry);
    controllerShowAnim.forward();
    await new Future.delayed(Duration(
        milliseconds: duration == null ? Toast.LENGTH_SHORT : duration));
    dismiss(controllerHide: controllerHide);
  }

  static dismiss({var controllerHide}) async {
    if (!_isVisible) {
      return;
    }
    if (controllerHide != null) {
      controllerHide.forward();
      await Future.delayed(Duration(milliseconds: 250));
    }
    _isVisible = false;
    overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
    this.opacityAnim1,
    this.opacityAnim2,
  }) : super(key: key);

  final Widget widget;
  final int gravity;
  final Animation<double> opacityAnim1;
  final Animation<double> opacityAnim2;

  @override
  Widget build(BuildContext context) {
    Alignment alignment = gravity == Toast.BOTTOM
        ? Alignment.bottomCenter
        : gravity == Toast.CENTER ? Alignment.center : Alignment.topCenter;
    EdgeInsets margin = gravity == Toast.BOTTOM
        ? EdgeInsets.only(bottom: 55)
        : gravity == Toast.CENTER ? EdgeInsets.zero : EdgeInsets.only(top: 55);
    return AnimatedBuilder(
      animation: opacityAnim1,
      child: Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ),
        alignment: alignment,
      ),
      builder: (context, child_to_build) {
        return Opacity(
            opacity: opacityAnim1.value,
            child: AnimatedBuilder(
                animation: opacityAnim2,
                builder: (context, _) {
                  return Opacity(
                    opacity: opacityAnim2.value,
                    child: child_to_build,
                  );
                }));
      },
    );
  }
}
