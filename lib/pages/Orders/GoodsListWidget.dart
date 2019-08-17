import 'package:flutter/material.dart';
import 'package:flutter_shop/model/my_order_model.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

class GoodsListWidget extends StatefulWidget {
  Map<int, bool> stateMap;
  int index;
  List<Order_item_list> list;

  GoodsListWidget(
      Map<int, bool> stateMap, int index, List<Order_item_list> list) {
    this.stateMap = stateMap;
    this.index = index;
    this.list = list;
  }

  @override
  _GoodsListWidgetState createState() => _GoodsListWidgetState();
}

class _GoodsListWidgetState extends State<GoodsListWidget> {
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  Map<int, bool> stateMap;
  int index;
  List<Order_item_list> list;

  @override
  void initState() {
    super.initState();
    stateMap = widget.stateMap;
    index = widget.index;
    list = widget.list;
  }

  Widget getMoreGoodsWidgetHint(String txt, IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        if (stateMap.containsKey(index)) {
          bool expanded = stateMap[index];
          stateMap[index] = !expanded;
        } else {
          stateMap[index] = true;
        }
        setState(() {});
      },
      child: Column(
        children: <Widget>[
          Container(
            height: screenUtil.L(49),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  txt,
                  style: getTextStyle(10, Color(0xFF000000), FontWeight.w400),
                ),
                Icon(
                  icon,
                  color: Colors.black,
                  size: screenUtil.L(20),
                )
              ],
            ),
          ),
          getDivideLine(Color(0xFFF1F1F1), screenUtil.L(1))
        ],
      ),
    );
  }

  Widget getGoodsItem(Order_item_list goodItem) {
    return GestureDetector(
      onTap: () {
        routePagerNavigator(context, GoodsDetailsPage(goodItem.productId));
      },
      child: Container(
        padding: EdgeInsets.only(top: screenUtil.L(10)),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: AssetImage("images/default_good_image.png"),
                  image: NetworkImage(
                      StringUtils.getImageUrl(goodItem.productImg)),
                  height: screenUtil.L(70),
                  width: screenUtil.L(70),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenUtil.L(9)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            goodItem.productName != null
                                ? goodItem.productName
                                : "",
                            style: getTextStyle(
                                12, Color(0xFF000000), FontWeight.w300)),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenUtil.L(8), bottom: screenUtil.L(10)),
                          child: Text(
                            goodItem.getSpcAttr(),
                            style: getTextStyle(
                                10, Color(0xFF949494), FontWeight.w300),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Text(
                              "¥${goodItem.nowPrice}",
                              style: getTextStyle(
                                  12, Color(0xFF000000), FontWeight.w500),
                            ),
                            Expanded(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(left: screenUtil.L(10)),
                                  child: Text("数量:${goodItem.quantity}",
                                      style: getTextStyle(10, Color(0xFF949494),
                                          FontWeight.w300))),
                            ),
                            Text(
                              "商品编码:${goodItem.productCode}",
                              style: getTextStyle(
                                  10, Color(0xFF949494), FontWeight.w300),
                              textDirection: TextDirection.rtl,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: screenUtil.L(10)),
              child: getDivideLine(Color(0xFFF1F1F1), screenUtil.L(1)),
            )
          ],
        ),
      ),
    );
  }

  getDivideLine(Color color, double height) {
    return Container(
      color: color,
      height: ScreenUtil.getInstance().L(height),
    );
  }

  getTextStyle(double fontSize, Color color, FontWeight wight) {
    return TextStyle(
      fontWeight: wight,
      color: color,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    int count = list != null && list.length > 0 ? list.length : 0;
    bool isMore = count > 2;
    bool expanded = false;
    if (stateMap.containsKey(index)) {
      expanded = stateMap[index];
      if (isMore) {
        if (expanded) {
          count += 1;
        } else {
          count = 3;
        }
      }
    } else if (isMore) {
      count = 3;
    }
    return ListView.builder(
        itemCount: count,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int position) {
          if (count == 3 &&
              (stateMap[index] == null || stateMap[index] == false) &&
              position == count - 1) {
            return getMoreGoodsWidgetHint(
                "显示其余${list.length - 2}件", Icons.arrow_drop_down, index);
          } else if (count > 3 && expanded && position == list.length) {
            return getMoreGoodsWidgetHint("收起", Icons.arrow_drop_up, index);
          } else {
            return getGoodsItem(list[position]);
          }
        });
  }
}
