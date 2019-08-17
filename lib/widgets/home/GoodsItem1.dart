import 'package:flutter/material.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/pages/cart/CartSinglePage.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 商品item
/// TODO 数据类型不相同
/// @author longlyboyhe
/// @date 2019/1/15
///
class GridViewItem extends StatelessWidget {
  GoodsItemModel goodsItemModel;

  GridViewItem(this.goodsItemModel);

  Widget _borderText(String text) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().L(1.5), right: ScreenUtil().L(1.5)),
      height: ScreenUtil().L(14),
      decoration: ShapeDecoration(
          shape:
              Border.all(color: Color(0xFFFECF84), width: ScreenUtil().L(1))),
      alignment: Alignment.center,
      padding:
          EdgeInsets.only(left: ScreenUtil().L(4), right: ScreenUtil().L(4)),
      child: Text(
        text,
        style: TextStyle(
            color: Color(0xFFFECF84), fontSize: ScreenUtil().setSp(8)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> sizes = goodsItemModel.sizes;
    List<Widget> sizeWidgets = List();
    sizes?.forEach((size) {
      sizeWidgets.add(_borderText(size));
    });

    ///如果没有尺寸则流出位置（为了对齐）
    if (sizeWidgets.length == 0) {
      sizeWidgets.add(
        Container(
          height: ScreenUtil().L(14),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        ToastUtil.showToast(context, "点击了${goodsItemModel.name}");
        routePagerNavigator(context, GoodsDetailsPage(goodsItemModel.id));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  goodsItemModel.originalSize != null
                      ? Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          margin: EdgeInsets.only(bottom: 22),
                          color: Colors.grey[300],
                          child: Text(
                            "${goodsItemModel.originalSize}个货源",
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        )
                      : Container(),
                  Expanded(
                      child: Image.network(
                    StringUtils.getImageUrl(goodsItemModel.img),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ))
                ],
              ),
//              Positioned(
//                child: GestureDetector(
//                  onTap: () {
//                    ToastUtil.showToast(context, "分享");
//                  },
//                  child: Image.asset(
//                    "images/share.png",
//                    width: ScreenUtil().L(20),
//                    height: ScreenUtil().L(20),
//                  ),
//                ),
//                right: ScreenUtil().L(16),
//              ),
//              Positioned(
//                child: CircleAvatar(
//                  radius: Klength.px_10,
//                  backgroundColor: Color(0xFFD8D8D8),
//                  child: Text(
//                    "实拍",
//                    style: TextStyle(
//                        color: Color(0xFF1D1E1F), fontSize: Klength.sp_6),
//                  ),
//                ),
//                right: Klength.px_16,
//                top: Klength.px_20 + Klength.px_10,
//              ),
            ],
          )),
          Padding(
              padding: EdgeInsets.only(top: ScreenUtil().L(10)),
              child: Text(
                goodsItemModel.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().L(12)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                goodsItemModel.originalPrice != null
                    ? "￥${goodsItemModel.originalPrice}"
                    : "",
                style: TextStyle(
                    color: Color(0xFFD8D8D8),
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil().L(12),
                    decoration: TextDecoration.lineThrough),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().L(7), right: ScreenUtil().L(7)),
                child: Text(
                  "￥${goodsItemModel.price}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: ScreenUtil().L(14)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              goodsItemModel.discount != null
                  ? Container(
                      constraints: BoxConstraints.loose(
                          Size.fromWidth(ScreenUtil().L(50))),
                      padding: EdgeInsets.only(
                          left: ScreenUtil().L(5),
                          right: ScreenUtil().L(5),
                          top: ScreenUtil().L(2),
                          bottom: ScreenUtil().L(2)),
                      color: Color(0xFFE7E6E6),
                      height: ScreenUtil().L(15),
                      child: Text(
                        goodsItemModel.discount,
                        style: TextStyle(
                            color: Color(0xFFA60000),
                            fontSize: ScreenUtil().setSp(8)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
            ],
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(top: ScreenUtil().L(10)),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sizeWidgets,
            ),
          )
        ],
      ),
    );
  }
}
