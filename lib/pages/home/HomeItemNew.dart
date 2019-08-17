import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/RecommendModel.dart';
import 'package:flutter_shop/model/TodayNewBrands.dart';
import 'package:flutter_shop/pages/category/classification.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/home/GoodsItem1.dart';
import 'package:flutter_shop/widgets/right_sheet.dart';

///
/// 首页-今日上新
/// @author longlyboyhe
/// @date 2019/1/23
///
class HomeItemNew extends StatefulWidget {
  @override
  _HomeItemNewState createState() => _HomeItemNewState();
}

class _HomeItemNewState extends State<HomeItemNew>
    with SingleTickerProviderStateMixin {
  List<TodayNewBrands> staggeredList1 = List();
  List<TodayNewBrands> staggeredList2 = List();
  List<GoodsItemModel> bottomList = List();

  ScrollController _scrollController;
  ScrollController _topScrollController;

  //是否只显示一行品牌推荐
  bool hideOneLine = true;

  //第一次滚动,防止多次调用方法
  bool scrollFirstTime = true;

  ///选中的品牌
  TodayNewBrands selected = TodayNewBrands(name: "", count: "0");

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _topScrollController = ScrollController();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      if (offset >= 10 && scrollFirstTime) {
        setState(() {
          scrollFirstTime = false;
          hideOneLine = false;
          _topScrollController.jumpTo(0);
        });
      } else if (offset == 0) {
        setState(() {
          scrollFirstTime = true;
          hideOneLine = true;
          _topScrollController.jumpTo(0);
        });
      }
    });

    staggeredList1.add(TodayNewBrands(name: "Gucci", count: "100"));
    staggeredList1.add(TodayNewBrands(name: "Bottega Veneta", count: "58"));
    staggeredList1.add(TodayNewBrands(name: "Chloe", count: "14"));
    staggeredList1.add(TodayNewBrands(name: "Bvlgari", count: "10"));
    staggeredList1.add(TodayNewBrands(name: "Louis Vuitton", count: "8"));
    staggeredList1.add(TodayNewBrands(name: "Gucci", count: "100"));
    staggeredList1.add(TodayNewBrands(name: "Bottega Veneta", count: "58"));
    staggeredList1.add(TodayNewBrands(name: "Chloe", count: "14"));
    staggeredList1.add(TodayNewBrands(name: "Bvlgari", count: "10"));
    staggeredList1.add(TodayNewBrands(name: "Louis Vuitton", count: "8"));

    staggeredList2.add(TodayNewBrands(name: "Versace", count: "14"));
    staggeredList2.add(TodayNewBrands(name: "Chloe", count: "100"));
    staggeredList2.add(TodayNewBrands(name: "Louis Vuitton", count: "8"));
    staggeredList2.add(TodayNewBrands(name: "Versace", count: "14"));
    staggeredList2.add(TodayNewBrands(name: "LOEWE", count: "50"));
    staggeredList2.add(TodayNewBrands(name: "Chloe", count: "100"));
    staggeredList2.add(TodayNewBrands(name: "Versace", count: "14"));
    staggeredList2.add(TodayNewBrands(name: "Louis Vuitton", count: "8"));
    staggeredList2.add(TodayNewBrands(name: "LOEWE", count: "50"));
    staggeredList2.add(TodayNewBrands(name: "Versace", count: "14"));

    loadData();
  }

  void loadData() async {
    rootBundle.loadString("datas/recommends.json").then((value) {
      setState(() {
        RecommendModel recommendModel =
            RecommendModel.fromJson(jsonDecode(value));
        bottomList.addAll(recommendModel.data);
      });
    });
  }

  Widget _buildBrandItem(TodayNewBrands brand) {
    Color selectedColor =
        selected.name == brand.name ? KColor.yellowColor : Colors.grey;
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = brand;
        });
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd8d8d8),
                  offset: Offset(0, 1),
                  blurRadius: 1.5),
            ]),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(right: 5),
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Text(
                  brand.name,
                  style: TextStyle(color: selectedColor, fontSize: 14),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  "+${brand.count}",
                  style: TextStyle(color: selectedColor, fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }

  Widget _drawer() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: ScreenUtil().L(16)),
        child: Scaffold(
          appBar: CommonAppBar(
              context: context,
              existBackIcon: false,
              title: "筛选",
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              bottom: CommonAppBarBottomLine()),
          body: Classification(
            isFilter: true,
            selectedId: (type, id, text, lowPrice, highPrice) {
              //TODO 根据id筛选
              Navigator.pop(context);
            },
          ),
        ));
  }

  Widget _topBrands() {
    List<Widget> row1 = staggeredList1.map((brand) {
      return _buildBrandItem(brand);
    }).toList();
    List<Widget> row2 = staggeredList2.map((brand) {
      return _buildBrandItem(brand);
    }).toList();
    List<Widget> allRow = List();
    allRow.addAll(row1);
    allRow.addAll(row2);

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          controller: _topScrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: EdgeInsets.only(right: hideOneLine ? 60 + 5.0 : 45 + 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Offstage(
                  offstage: hideOneLine,
                  child: Row(
                    children: allRow,
                  ),
                ),
                Offstage(
                  offstage: !hideOneLine,
                  child: Row(
                    children: row1,
                  ),
                ),
                Offstage(
                  offstage: !hideOneLine,
                  child: Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      children: row2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          child: GestureDetector(
            onTap: () {
              showModalRightSheet(
                  context: context,
                  builder: (context) {
                    return _drawer();
                  });
            },
            child: Container(
              width: hideOneLine ? 60 : 45,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffd8d8d8),
                        offset: Offset(0, 1),
                        blurRadius: 8),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 5,
                    ),
                    child: Image.asset("images/filter.png"),
                  ),
                  Text(
                    "筛选",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
          right: 0,
          top: 0,
          bottom: 0,
        )
      ],
    );
  }

  Widget _bottomList() {
    return GridView.count(
      controller: _scrollController,
      crossAxisCount: 2,
      mainAxisSpacing: 20,
      childAspectRatio: 0.8,
      children: bottomList.map((goodsItemModel) {
        return GridViewItem(goodsItemModel);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      color: KColor.bgColor,
      child: Column(
        children: <Widget>[
          _topBrands(),
          Expanded(
              child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(bottom: 10),
            child: _bottomList(),
            color: Colors.white,
          ))
        ],
      ),
    );
  }
}
