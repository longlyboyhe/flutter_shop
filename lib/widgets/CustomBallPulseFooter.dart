import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

/// 球脉冲底部视图
class CustomBallPulseFooter extends RefreshFooter {
  // 颜色
  final Color color;
  final double size;
  final Duration duration;
  final IndexedWidgetBuilder itemBuilder;

  // 背景颜色
  final Color backgroundColor;

  CustomBallPulseFooter({
    @required GlobalKey<RefreshFooterState> key,
    this.color: Colors.blue,
    this.size: 30,
    this.itemBuilder,
    this.duration: const Duration(milliseconds: 1400),
    this.backgroundColor: Colors.transparent,
  }) : super(key: key ?? new GlobalKey<RefreshFooterState>(), loadHeight: 30.0);

  @override
  CustomBallPulseFooterState createState() => CustomBallPulseFooterState();
}

class CustomBallPulseFooterState
    extends RefreshFooterState<CustomBallPulseFooter>
    with SingleTickerProviderStateMixin {
  AnimationController _scaleCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  // 开始加载
  @override
  Future onLoadStart() async {
    super.onLoadStart();
  }

  // 加载结束
  @override
  Future onLoadEnd() async {
    super.onLoadEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      height: this.height,
      child: Center(
        child: SizedBox.fromSize(
          size: Size(widget.size * 2, widget.size),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _circle(0, .0),
              _circle(1, .2),
              _circle(2, .4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(int index, double delay) {
    final _size = widget.size * 0.5;
    return ScaleTransition(
      scale: DelayTween(begin: 0.0, end: 1.0, delay: delay).animate(_scaleCtrl),
      child: SizedBox.fromSize(
        size: Size.square(_size),
        child: _itemBuilder(index),
      ),
    );
  }

  Widget _itemBuilder(int index) {
    return widget.itemBuilder != null
        ? widget.itemBuilder(context, index)
        : DecoratedBox(
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          );
  }
}
