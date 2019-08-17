import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/color.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/pages/Orders/ToBePay.dart';
import 'package:flutter_shop/pages/Orders/NotDeliverGoods.dart';
import 'package:flutter_shop/pages/Orders/NotTakeGoods.dart';
import 'package:flutter_shop/pages/Orders/ReturnGoods.dart';
import 'package:flutter_shop/pages/Orders/AllGoodsList.dart';


class OrderPage extends StatefulWidget {
  int index;

  OrderPage(this.index);

  @override
  State<StatefulWidget> createState() {
    return OrderPageState();
  }
}

class OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  GlobalKey<ToBePayPageState> toBePayPageState = GlobalKey();
  GlobalKey<NotTakeGoodsState> noTakeGoodsKey = GlobalKey();
  GlobalKey<NotDeliverGoodsState> notDeliverGoodsState = GlobalKey();
  GlobalKey<AllGoodsListState> allGoodsListState = GlobalKey();
  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex:widget.index,length: 4, vsync: this);
  }

  List<Widget> getTabs() {
    List<Widget> tabs = List();
    tabs.add(getTabItem("待付款"));
    tabs.add(getTabItem("待发货"));
    tabs.add(getTabItem("待收货"));
//    tabs.add(getTabItem("退换货"));
    tabs.add(getTabItem("全部采购"));
    return tabs;
  }

  Widget getTabItem(String text) {
    return Container(
      padding: EdgeInsets.only(top: 15,bottom: 15),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: CommonAppBar(
              context: context,
              title: "我的采购单",),
          preferredSize: Size.fromHeight(50)),
      body: Column(
        children: <Widget>[
          getDivideLine(Color(0xffF1F1F1), ScreenUtil.getInstance().L(1)),
          TabBar(
            tabs: getTabs(),
            controller: tabController,
            onTap: (index){
              if(index==0){
                toBePayPageState.currentState.loadData(false);
              }else if(index==1){
                notDeliverGoodsState.currentState.loadData(false);
              }else if(index==2){
                notDeliverGoodsState.currentState.loadData(false);
              }else if(index==3){
                allGoodsListState.currentState.loadData(false);
              }
            },
            isScrollable: true,
            indicatorColor: KColor.yellowColor,
            indicatorWeight: ScreenUtil.getInstance().L(3),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Color(0xFF949494),
            labelColor: Colors.black,
            labelStyle:TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                ToBePayPage(toBePayPageState),
                NotDeliverGoods(notDeliverGoodsState),
                NotTakeGoods(noTakeGoodsKey),
//                ReturnGoods(),
                AllGoodsList(allGoodsListState),
              ],
            ),
          )
        ],
      ),
    );
  }

  getDivideLine(Color color, double height) {
    return Container(
      color: color,
      height: ScreenUtil.getInstance().L(height),
    );
  }
}
