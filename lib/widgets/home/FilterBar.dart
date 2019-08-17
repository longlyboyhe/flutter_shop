import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 能横向滑动的筛选头部列表
/// @author longlyboyhe
/// @date 2019/1/15
///
class FilterBar extends StatefulWidget {
  List<String> filters;
  double itemWidth;
  double height;
  ValueChanged<int> changed;

  FilterBar(this.filters,
      {this.itemWidth = 80, this.height = 40, this.changed});

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  List<Widget> filterTabs = List();
  int curFilterIndex = 0;

  void initData() {
    filterTabs.clear();
    for (int i = 0; i < widget.filters.length; i++) {
      filterTabs.add(GestureDetector(
        onTap: () {
          setState(() {
            curFilterIndex = i;
          });
          widget.changed(curFilterIndex);
        },
        child: Container(
          width: widget.itemWidth,
          height: widget.height,
          decoration: curFilterIndex == i
              ? ShapeDecoration(
                  shape: Border.all(color: Color(0xFFFF9C00), width: 1.0))
              : ShapeDecoration(
                  shape: Border.all(color: Colors.transparent, width: 0.0)),
          child: Center(
            child: Text(widget.filters[i],
                style: curFilterIndex == i
                    ? TextStyle(
                        fontSize: ScreenUtil().setSp(16),
                        color: Color(0xFFFF9C00),
                        fontWeight: FontWeight.w500)
                    : TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(14),
                        fontWeight: FontWeight.w300)),
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filters != null && widget.filters.length > 0) {
      initData();
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: filterTabs,
        ),
      );
    }
    return Container();
  }
}
