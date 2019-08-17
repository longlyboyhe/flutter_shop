import 'package:flutter/material.dart';

///
/// scrollable的TabBar(带tab的点击回调方法)
/// @author longlyboyhe
/// @date 2019/1/18
///
class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final TextStyle labelStyle;
  final TextStyle selectedLabelStyle;
  final Color indicatorColor;
  final double indicatorWeight;
  final double height;
  final EdgeInsetsGeometry labelPadding;
  final EdgeInsetsGeometry indicatorPadding;
  final ValueChanged<int> onTap;
  final double itemWith;
  final Color backgroundColor;
  final bool clickable;

  static const TextStyle defaultStle = const TextStyle(
      fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);

  CustomTabBar(
      {@required this.tabs,
      Key key,
      this.labelStyle = defaultStle,
      this.selectedLabelStyle = defaultStle,
      this.height = 45,
      this.onTap,
      this.itemWith,
      this.backgroundColor = const Color(0x00000000),
      this.labelPadding = const EdgeInsets.all(0),
      this.indicatorPadding = const EdgeInsets.all(0),
      this.indicatorColor = const Color(0xFFFF9C00),
      this.indicatorWeight = 3,
      this.clickable = true})
      : assert(tabs != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => CustomTabBarState();
}

class CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  int curIndex = 0;
  List<GlobalKey> _tabKeys = List();
  List<double> _tabWidth = List();

  Animation<double> animation;
  Animation<double> widthAnimation;
  AnimationController controller;
  bool clickable;

  void setClickable(bool clickable) {
    this.clickable = clickable;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    clickable = widget.clickable;
    _tabKeys = widget.tabs.map((String tab) => GlobalKey()).toList();
    ////35默认tab宽度
    _tabWidth = widget.tabs.map((String tab) => 35.0).toList();

    ///非常快速滑动会产生一点点的卡顿，时间越长越流畅
    controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    animation = Tween(begin: 0.0, end: 0.0).animate(controller);
    widthAnimation = Tween(begin: _tabWidth[0], end: 0.0).animate(controller);
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _buildItem(int index) {
    return GestureDetector(
      key: _tabKeys[index],
      onTap: () {
        if (this.clickable) {
          if (widget.onTap != null) widget.onTap(index);
          moveToTap(index);
        }
      },
      child: widget.itemWith != null
          ? Container(
              alignment: Alignment.center,
              width: widget.itemWith,
              padding: widget.labelPadding,
              child: Text(
                widget.tabs[index],
                softWrap: true,
                style: curIndex == index
                    ? widget.selectedLabelStyle
                    : widget.labelStyle,
              ),
            )
          : Center(
              child: Padding(
                padding: widget.labelPadding,
                child: Text(
                  widget.tabs[index],
                  softWrap: true,
                  style: curIndex == index
                      ? widget.selectedLabelStyle
                      : widget.labelStyle,
                ),
              ),
            ),
    );
  }

  ///防止多次调用moveToTap
  int firstIndex = -1;

  void moveToTap(int index) {
    if (firstIndex != index) {
      firstIndex = index;
      _moveToWidth(index);
      double begin = _leftDis(curIndex);
      double end = _leftDis(index);
      animation = Tween(begin: begin, end: end)
          .animate(CurvedAnimation(parent: controller, curve: Curves.linear));

      ///如果等动画执行完之后再改变当前index值的话会产生底部线每次都跳到0开始滑动的情况
      curIndex = index;
      controller.forward(from: 0);
    }
  }

  ///改变下划线宽度和lab一样宽
  _moveToWidth(int index) {
    if (index == curIndex) return;
    double begin = _tabWidth[curIndex];
    double end = _tabWidth[index];
    widthAnimation = Tween(begin: begin, end: end)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
  }

  double _leftDis(int index) {
    //前index个宽总和
    double dis = 0;
    for (int i = 0; i < _tabWidth.length; i++) {
      if (index == i) break;
      dis += _tabWidth[i];
    }
    return dis;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  void _onAfterRendering(Duration timeStamp) {
    //这里编写获取元素大小和位置的方法
    for (int i = 0; i < _tabKeys.length; i++) {
      GlobalKey<State<StatefulWidget>> state = _tabKeys[i];
      BuildContext currentContext = state.currentContext;
      if (currentContext != null && currentContext.size != null) {
        _tabWidth[i] = currentContext.size.width;
      }
    }
    widthAnimation = Tween(begin: _tabWidth[curIndex], end: _tabWidth[curIndex])
        .animate(new CurvedAnimation(parent: controller, curve: Curves.linear));
    controller.forward();
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabs != null && widget.tabs.length > 0) {
      List<Widget> tabWidgets = List();
      for (int i = 0; i < widget.tabs.length; i++) {
        tabWidgets.add(_buildItem(i));
      }
      return Container(
          color: widget.backgroundColor,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            child: Stack(
              children: <Widget>[
                Row(
                  children: tabWidgets,
                ),
                Positioned(
                  child: Container(
                    width: widthAnimation.value,
                    height: widget.indicatorWeight,
                    padding: widget.indicatorPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          width: widthAnimation.value,
                          color: widget.indicatorColor,
                        ))
                      ],
                    ),
                  ),
                  bottom: 0,
                  left: animation.value,
                )
              ],
            ),
          ));
    }
    return Container();
  }
}
