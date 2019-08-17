import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/search_result_model.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/home/GoodsItem.dart';

///
/// 搜索结果页-没有结果
/// @author longlyboyhe
/// @date 2019/2/19
///
class SearchResultNoData extends StatefulWidget {
  String text;
  List<GoodData> recommends = List();

  SearchResultNoData(this.text, this.recommends);

  @override
  _SearchResultNoDataState createState() => _SearchResultNoDataState();
}

class _SearchResultNoDataState extends State<SearchResultNoData> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().L(26), bottom: ScreenUtil().L(26)),
              child: Text(
                '抱歉，没有找到与“${widget.text}”相关的商品',
                style: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )),
          Container(height: ScreenUtil().L(10), color: KColor.bgColor),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(
                left: ScreenUtil().L(14), top: ScreenUtil().L(30)),
            child: Text(
              KString.recommendTitle,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: ScreenUtil().L(22)),
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: ScreenUtil().L(26),
            childAspectRatio: 0.7,
            children: widget.recommends.map((goodsItemModel) {
              return GridViewItem(goodsItemModel);
            }).toList(),
          )
        ],
      ),
    );
  }
}
