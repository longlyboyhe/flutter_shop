import 'package:flutter/material.dart';
import 'package:flutter_shop/model/good_detail_model.dart';
import 'package:flutter_shop/pages/want/WantSinglePage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 尺寸选择器，一行4个
/// @author longlyboyhe
/// @date 2019/1/28
///
class SizeSelector extends StatefulWidget {
  final List<Spec_values> sizes;
  final Color selectedBorderColor;
  final Color borderColor;
  final EdgeInsetsGeometry margin;
  final ValueChanged<Spec_values> onTap;
  final String selectedPath; //如果点选第一行（颜色），为空，如果点选第二行（尺码），为id:vid
  final List<String> spe_path; //供应商spe_path集合，用于判断是否可选

  SizeSelector({
    Key key,
    this.sizes,
    this.selectedBorderColor = const Color(0xFFEBE700),
    this.borderColor = const Color(0xFF979797),
    this.onTap,
    this.margin = const EdgeInsets.all(0),
    this.spe_path,
    this.selectedPath,
  }) : super(key: key);

  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  int curIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(BuildContext context, int index) {
    bool enable = widget.selectedPath == null
        ? true
        : widget.spe_path.contains(widget.selectedPath);
    return GestureDetector(
      onTap: () {
        enable
            ? setState(() {
                curIndex = index;
                widget.onTap(widget.sizes[index]);
              })
            : routePagerNavigator(context, WantSinglePage());
      },
//      child: SizeSelectorItem(
//        text: widget.sizes[index].size,
//        textStyle: TextStyle(
//            color: Colors.black,
//            fontSize: ScreenUtil().setSp(11),
//            fontWeight: FontWeight.w300),
//        enable: widget.sizes[index].enable,
//        selected: curIndex == index,
//      ),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: enable && curIndex == index
                    ? Color(0xFFECE936)
                    : Color(0xFFBABABA),
                width: 1)),
        child: Text(
          widget.sizes[index].value,
          maxLines: 1,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: enable ? Colors.black : Color(0xFFB5B5B5),
              fontSize: 11,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sizes.length > 0) {
      return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: widget.margin,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: ScreenUtil().L(10),
          crossAxisSpacing: ScreenUtil().L(15),
          childAspectRatio: 2.3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(context, index);
        },
        itemCount: widget.sizes.length,
      );
    }
    return Container();
  }
}
