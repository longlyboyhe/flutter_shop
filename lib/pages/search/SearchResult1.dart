import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/RecommendModel.dart';
import 'package:flutter_shop/pages/search/SearchResultList.dart';
import 'package:flutter_shop/pages/search/SearchResultNoData.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 搜索结果页
/// @author longlyboyhe
/// @date 2019/2/19
///
class SearchResult extends StatefulWidget {
  String text;
  List<GoodsItemModel> results = List();

  SearchResult(this.text, this.results);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  RecommendModel recommendModel;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    rootBundle.loadString("datas/recommends.json").then((value) {
      setState(() {
        recommendModel = RecommendModel.fromJson(jsonDecode(value));
      });
    });
  }

  Widget _searchWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().L(15)),
                padding: EdgeInsets.only(
                    left: ScreenUtil().L(21),
                    top: ScreenUtil().L(5),
                    bottom: ScreenUtil().L(5),
                    right: ScreenUtil().L(21)),
                height: ScreenUtil().L(30),
                decoration: BoxDecoration(
                    color: KColor.bgColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(ScreenUtil().L(15)))),
                child: Text(
                  widget.text,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ))),
      RawMaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.only(
            left: ScreenUtil().L(12), right: ScreenUtil().L(15)),
        constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
        child: Text(KString.cancel,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight + 13),
        child: Column(
          children: <Widget>[
            _searchWidget(),
            Expanded(
                child: Stack(
              children: <Widget>[
                Offstage(
                  offstage: widget.results.length > 0,
                  child: SearchResultNoData(
                      widget.text,
                      recommendModel != null && recommendModel.data != null
                          ? recommendModel.data
                          : List()),
                ),
                Offstage(
                  offstage: widget.results.length == 0,
                  child: SearchResultList(
                      recommendModel != null && recommendModel.data != null
                          ? recommendModel.data
                          : List()),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
