import 'package:flutter/material.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/search_result_model.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/home/GoodsItem.dart';
import 'package:flutter_shop/widgets/search/FilterBar.dart';

///
/// 搜索结果页列表
/// @author longlyboyhe
/// @date 2019/2/19
///
class SearchResultList extends StatefulWidget {
  List<GoodData> recommends = List();

  SearchResultList(this.recommends);

  @override
  _SearchResultListState createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          FilterBar(
              hasBrand: true,
              onTap: (type, id, text, lowPrice, highPrice) {
//                ToastUtil.showToast(context, "点击了$id");
              }),
          Expanded(
              child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: ScreenUtil().L(22)),
            physics: BouncingScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: ScreenUtil().L(26),
            childAspectRatio: 0.7,
            children: widget.recommends.map((goodsItemModel) {
              return GridViewItem(goodsItemModel);
            }).toList(),
          ))
        ],
      ),
    );
  }
}
