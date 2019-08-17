import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

typedef OnItemClick = void Function(GoodsItemModel data, int index);

/**
 * 图文上下混排item（横划列表和分类三级类目商品）
 * @author longlyboyhe
 * @date 2018/12/26
 */
class BrandGoodsItem extends StatelessWidget {
  //ListView高
  double height;
  double width;
  double imgRatio = 1; //图片宽高比例

  //滑动最后是否显示查看更多按钮(首页中部分有更多按钮)，默认不显示
  bool showMoreButton;

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
  GoodsItemModel data;

  OnItemClick onTap;
  EdgeInsetsGeometry padding;

  //点击的下标
  int index;
  String placeholder; //占位图

  static const defaultNameStyle =
      TextStyle(color: Color(0xFF616161), fontSize: 11);
  static const defaultPriceStyle =
      TextStyle(color: Color(0xFF616161), fontSize: 12);

  static const defaultOldPriceStyle = TextStyle(
      color: Color(0xFFBDBDBD),
      fontSize: 10,
      decoration: TextDecoration.lineThrough);
  static const defaultPadding = EdgeInsets.all(0);

  BrandGoodsItem(this.data,
      {this.height,
      this.width,
      this.onlyImg = false,
      this.showOldPrice = false,
      this.showDiscount = false,
      this.nameStyle = defaultNameStyle,
      this.priceStyle = defaultPriceStyle,
      this.pricePadding = defaultPadding,
      this.oldPriceStyle = defaultOldPriceStyle,
      this.onTap,
      this.nameMaxLine = 1,
      this.padding,
      this.placeholder,
      this.index = 0});

  @override
  Widget build(BuildContext context) {
    bool disDiscount =
        onlyImg || !showDiscount || StringUtils.isEmpty(data.discount);
    bool disName = onlyImg || StringUtils.isEmpty(data.name);
    bool disPrice = onlyImg || data.price == null;
    bool disOriginalPrice =
        onlyImg || !showOldPrice || data.originalPrice == null;
    Widget _body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: FadeInImage(
              placeholder: AssetImage("images/default_good_image.png"),
              fit: BoxFit.fill,
              image: NetworkImage(StringUtils.getImageUrl(data.img))),
        ),
        //打折
        Offstage(
          offstage: disDiscount,
          child: Container(
            margin: EdgeInsets.only(bottom: ScreenUtil().L(6)),
            alignment: Alignment.center,
            color: KColor.yellowColor,
            height: ScreenUtil().L(12),
            width: ScreenUtil().L(50),
            child: Text(
              data.discount != null ? data.discount + " 折" : "",
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(8)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Offstage(
          offstage: disName,
          child: Text(
            data.name != null ? data.name : "",
            style: nameStyle,
            maxLines: nameMaxLine,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        //商品价格
        Offstage(
          offstage: disPrice,
          child: Padding(
              padding: pricePadding,
              child: Text(
                data.price != null ? "￥${data.price}" : "",
                style: priceStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        ),
        //商品原价
        Offstage(
          offstage: disOriginalPrice,
          child: Text(
            data.originalPrice != null ? "￥${data.originalPrice}" : "",
            style: oldPriceStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );

    double widgetHeight = width;
    if (!onlyImg && widgetHeight != null) {
      //显示打折
      widgetHeight = disDiscount
          ? widgetHeight
          : widgetHeight + ScreenUtil().L(12) + ScreenUtil().L(6);
      //名称
      widgetHeight = disName ? widgetHeight : widgetHeight + ScreenUtil().L(20);
      //价格
      widgetHeight =
          disPrice ? widgetHeight : widgetHeight + ScreenUtil().L(20);
    }
    return GestureDetector(
      onTap: () {
        onTap(data, index);
      },
      child: Container(
        margin: padding,
        height: widgetHeight,
        width: width,
        child: _body,
      ),
    );
  }
}
