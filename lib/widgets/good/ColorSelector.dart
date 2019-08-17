import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/good_detail_model.dart';

///
/// 颜色选择器，横向
/// @author longlyboyhe
/// @date 2019/1/28
///
class ColorSelector extends StatefulWidget {
  final List<Spec_values> goods;
  final Color selectedColor;
  final Color unSelectedColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry itemPadding;
  final ValueChanged<Spec_values> onTap;

  ColorSelector(
      {Key key,
      this.goods,
      this.selectedColor = const Color(0xFFEBE700),
      this.unSelectedColor = const Color(0xFF979797),
      this.itemPadding = const EdgeInsets.only(right: 10),
      this.onTap,
      this.margin})
      : super(key: key);

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          curIndex = index;
          widget.onTap(widget.goods[index]);
        });
      },
      child: Container(
        margin: widget.itemPadding,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(3)),
            border: Border.all(
                color: curIndex == index
                    ? widget.selectedColor
                    : widget.unSelectedColor,
                width: 1)),
//        child: Image.network(
//          widget.goods[index].img,
//          fit: BoxFit.fitHeight,
//          width: 40,
//          height: 40,
//        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.goods.length > 0) {
      return Container(
        height: 40,
        margin: widget.margin,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.goods.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(context, index);
            }),
      );
    }
    return Container();
  }
}
