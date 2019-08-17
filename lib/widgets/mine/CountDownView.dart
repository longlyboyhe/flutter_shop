import 'dart:async';

import 'package:flutter/material.dart';

///
/// 倒计时组件（不能记住倒计时）
/// @author longlyboyhe
/// @date 2019/3/8
///
class CountDownView extends StatefulWidget {
  String title;
  final double width;
  final double height;
  final Color enableColor;
  final Color disableColor;
  final EdgeInsets margin;
  final VoidCallback onTap;

  CountDownView(
      {Key key,
      @required this.title,
      this.width = 80,
      this.height = 20,
      this.enableColor = Colors.black,
      this.disableColor = const Color(0xFFACACAC),
      this.margin,
      this.onTap})
      : super(key: key);

  @override
  CountDownViewState createState() => CountDownViewState();
}

class CountDownViewState extends State<CountDownView> {
  bool _enable = true;
  bool _loadding = false;

  void _setEnable(bool enable) {
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

  Timer _countdownTimer;
  int _countdownNum = 59;

  void startCountDown() {
    if (_countdownTimer != null) {
      return;
    } else {
      widget.title = '重新获取（${_countdownNum--}）';
      _setEnable(false);
      _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        _setCountDown();
      });
    }
  }

  void _setCountDown() {
    setState(() {
      if (_countdownNum > 0) {
        widget.title = '重新获取（${_countdownNum--}）';
      } else {
        _setEnable(true);
        widget.title = '重新获取';
        _countdownNum = 59;
        _countdownTimer.cancel();
        _countdownTimer = null;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_enable && !_loadding) {
          setStartLoadding(true);
          widget.onTap();
        }
      },
      child: Container(
          alignment: Alignment.center,
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: _enable ? widget.enableColor : widget.disableColor)),
          child: Stack(
            children: <Widget>[
              Offstage(
                  offstage: _loadding,
                  child: Text(widget.title,
                      style: TextStyle(
                          color: _enable
                              ? widget.enableColor
                              : widget.disableColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 8))),
              Offstage(
                offstage: !_loadding,
                child: Container(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation(Colors.black))),
              )
            ],
          )),
    );
  }
}
