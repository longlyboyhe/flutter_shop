import 'package:flutter/material.dart';

///
/// 下三角变上三角的选择器
/// @author longlyboyhe
/// @date 2019/1/28
///
class SelectorArrowDown extends StatefulWidget {
  final Color color;
  final double size;
  final EdgeInsetsGeometry padding;

  SelectorArrowDown(
      {Key key,
      this.color = const Color(0xFFFFFFFF),
      this.size = 12,
      this.padding = const EdgeInsets.all(0)})
      : super(key: key);

  @override
  SelectorArrowDownState createState() => SelectorArrowDownState();
}

class SelectorArrowDownState extends State<SelectorArrowDown>
    with TickerProviderStateMixin {
  AnimationController _controller; //动画控制器
  Animation<double> _animation;
  bool forward = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween(begin: 0.0, end: 0.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void update() {
    setState(() {
      _setState();
    });
  }

  void _setState() {
    if (forward) {
      _controller.forward(); //向前播放动画
    } else {
      _controller.reverse(); //向后播放动画
    }
    forward = !forward;
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: Icon(
        Icons.keyboard_arrow_down,
        color: widget.color,
        size: widget.size,
      ),
    );
  }
}
