import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/home/BrandGoodsItem.dart';
import 'package:flutter/material.dart';

/**
 * 水平滑动展示的的ListView
 * @author longlyboyhe
 * @date 2018/12/25
 */
class HorizontalGoodsListView extends StatefulWidget {
  //ListView高
  double height;
  double itemWidth;

  //滑动最后是否显示查看更多按钮(首页中部分有更多按钮)，默认不显示
  bool showMoreButton;

  //如果itemBuilder不为空则使用给定的
  Widget itemWidget;

  //是否只显示图片(商品列表页只显示图片)，默认为false
  bool onlyImg;

  //是否显示原价(商品详情中显示中划线原价)，默认不显示
  bool showOldPrice;

  ///是否显示打折
  bool showDiscount;

  //商品名称style
  TextStyle nameStyle;

  //商品名称maxLine
  int nameMaxLine;

  //价格style
  TextStyle priceStyle;
  EdgeInsetsGeometry pricePadding;

  //原价style
  TextStyle oldPriceStyle;
  List<GoodsItemModel> data;

  OnItemClick onItemClick;
  EdgeInsetsGeometry padding;
  EdgeInsetsGeometry itemPadding;

  static const defaultNameStyle = TextStyle(color: Colors.black, fontSize: 14);
  static const defaultPriceStyle =
      TextStyle(color: Color(0xFFC10000), fontSize: 14);

  static const defaultOldPriceStyle = TextStyle(
      color: Color(0xFFBDBDBD),
      fontSize: 10,
      decoration: TextDecoration.lineThrough);

  static const defaultPadding = EdgeInsets.all(0);

  HorizontalGoodsListView(this.data,
      {this.height,
      @required this.itemWidth,
      this.showDiscount = false,
      this.showMoreButton = true,
      this.itemWidget,
      this.nameMaxLine = 1,
      this.onlyImg = false,
      this.showOldPrice = false,
      this.nameStyle = defaultNameStyle,
      this.priceStyle = defaultPriceStyle,
      this.pricePadding = defaultPadding,
      this.oldPriceStyle = defaultOldPriceStyle,
      this.onItemClick,
      this.padding = defaultPadding,
      this.itemPadding = defaultPadding});

  @override
  State<StatefulWidget> createState() {
    return HorizontalGoodsListViewState();
  }
}

class HorizontalGoodsListViewState extends State<HorizontalGoodsListView> {
//  List<GoodsItemModel> dataList = List();

  buildItem(BuildContext context, int i) {
    GoodsItemModel model = widget.data[i];
//    GoodsItemModel model = dataList[i];
//    if (i == dataList.length - 1 && model.showMoreButton) {
////      return MoreButton(
////        width: widget.itemWidth,
////        onTap: () {
////          ToastUtil.showToast(context, "点击了查看更多");
////        },
////      );
////    }
    return widget.itemWidget != null
        ? widget.itemWidget
        : BrandGoodsItem(model,
            height: widget.itemWidth,
            width: widget.itemWidth,
            onlyImg: widget.onlyImg,
            showDiscount: widget.showDiscount,
            nameStyle: widget.nameStyle,
            pricePadding: widget.pricePadding,
            nameMaxLine: widget.nameMaxLine,
            showOldPrice: widget.showOldPrice,
            priceStyle: widget.priceStyle,
            oldPriceStyle: widget.oldPriceStyle,
            index: i,
            onTap: widget.onItemClick,
            padding: widget.itemPadding);
  }

  @override
  void initState() {
    super.initState();
//    initData();
  }

//  void initData() {
//    dataList.clear();
//    dataList.addAll(widget.data);
//    if (widget.showMoreButton) {
//      dataList.add(GoodsItemModel(showMoreButton: true));
//    }
//  }

  @override
  Widget build(BuildContext context) {
//    initData();
//    if (dataList != null && dataList.length > 0) {
//      List<Widget> widgets = List();
//      for (int i = 0; i < dataList.length; i++) {
//        widgets.add(buildItem(context, i));
//      }
    if (widget.data != null && widget.data.length > 0) {
      List<Widget> widgets = List();
      for (int i = 0; i < widget.data.length; i++) {
        widgets.add(buildItem(context, i));
      }
      return Container(
        height: widget.height,
        child: SingleChildScrollView(
          padding: widget.padding,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            children: widgets,
          ),
        ),
      );
    }
    return Container();
  }
}

/**
 * 查看更多按钮
 * @author longlyboyhe
 * @date 2018/12/26
 */
//class MoreButton extends StatelessWidget {
//  GestureTapCallback onTap;
//  double width;
//
//  MoreButton({this.onTap, this.width: 100});
//
//  @override
//  Widget build(BuildContext context) {
//    double widths = width > 100 ? 100 : width;
//    return GestureDetector(
//      onTap: onTap,
//      child: Container(
//        margin: EdgeInsets.only(left: ScreenUtil().L(15)),
//        width: widths,
//        height: widths,
////        decoration:
////            ShapeDecoration(shape: Border.all(color: Colors.black, width: 1.0)),
//        decoration: BoxDecoration(
//            color: Colors.white,
//            shape: BoxShape.rectangle,
//            borderRadius: BorderRadius.all(Radius.circular(8)),
//            boxShadow: [
//              BoxShadow(
//                  color: Color(0xffd8d8d8),
//                  offset: Offset(0, 1),
//                  blurRadius: 15),
//            ]),
//
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(
//              "查看更多",
//              style: TextStyle(
//                  color: Colors.black,
//                  fontSize: ScreenUtil().L(12),
//                  fontWeight: FontWeight.w300),
//            ),
//            Container(
//              margin: EdgeInsets.only(top: ScreenUtil().L(7)),
//              color: Colors.black,
//              height: ScreenUtil().L(1),
//              width: ScreenUtil().L(45),
//            )
//          ],
//        ),
//      ),
//    );
//  }
//}
