import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/want/ToBeCheck.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 我的求购
/// @author longlyboyhe
/// @date 2019/3/20
///
class MyWantToBuy extends StatefulWidget {
  @override
  _MyWantToBuyState createState() => _MyWantToBuyState();
}

class _MyWantToBuyState extends State<MyWantToBuy>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    Tab(text: "待审核"),
    Tab(text: "找货中"),
    Tab(text: "可下单"),
    Tab(text: "失效/取消"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          TabBar(
            tabs: myTabs,
            controller: _tabController,
            indicatorColor: KColor.yellowColor,
            indicatorWeight: ScreenUtil.getInstance().L(3),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Color(0xFF949494),
            labelColor: Colors.black,
            labelStyle: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
                fontSize: 14,
                color: Color(0xFF949494),
                fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
//                ToBeCheck(),
//                ToBeCheck(),
//                ToBeCheck(),
//                ToBeCheck(),
//                SearchingGoods(),
//                CanOrder(),
//                InvalidOrCancel(),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
