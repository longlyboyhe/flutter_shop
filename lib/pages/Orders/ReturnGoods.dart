import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/pages/Orders/GoodsListWidget.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

import 'LogisticsPage.dart';
//退换货
class ReturnGoods extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReturnGoodsState();
  }
}

class ReturnGoodsState extends State<ReturnGoods> with AutomaticKeepAliveClientMixin{
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  List<List> goodsList=List();
  Map<int,bool> stateMap=Map();
  GlobalKey<EasyRefreshState> _easyRefreshKey = new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
  GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey =
  GlobalKey<RefreshHeaderState>();
  Widget footview;
  Widget headerView;
  @override
  void initState() {
    super.initState();
    List subList=List(3);
    goodsList.add(subList);
    goodsList.add(subList=List(1));
    goodsList.add(subList=List(5));
    goodsList.add(subList=List(2));
    goodsList.add(subList=List(4));
    goodsList.add(subList=List(6));

    footview=OrderUtil.getFooterView();
    headerView = OrderUtil.getRefreshHeaderView();
  }

  Widget getItemWidget(int index) {
    double leftRight = screenUtil.L(14);
    double topBottom = screenUtil.L(18);
    return Column(
      children: <Widget>[
        OrderUtil.getDivideLine(Color(0xFFF1F1F1), 10),
        Padding(
          padding:
              EdgeInsets.fromLTRB(leftRight, topBottom, leftRight, topBottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text("订单编号: 6092468933984",
                          style: OrderUtil.getTextStyle(
                              10, Color(0xFF000000), FontWeight.bold))),
                  Text("退货中",
                      style:
                      OrderUtil.getTextStyle(12, Color(0xFFC10000), FontWeight.bold))
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: screenUtil.L(8), bottom: screenUtil.L(17)),
                child: Text("订单ID: 6092468933984",
                    style:
                    OrderUtil.getTextStyle(10, Color(0xFF000000), FontWeight.bold)),
              ),
              OrderUtil. getDivideLine(Color(0xFFF1F1F1), 1),
              GoodsListWidget(stateMap,index,goodsList[index]),
              Container(
                padding: EdgeInsets.only(
                    top: screenUtil.L(17), bottom: screenUtil.L(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "（运费：¥666 税费：¥666）",
                      style:
                      OrderUtil.getTextStyle(12, Color(0xFF949494), FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenUtil.L(10)),
                      child: Text("总金额：¥666",
                          style: OrderUtil.getTextStyle(
                              12, Color(0xFF000000), FontWeight.bold)),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OrderUtil. getCircBoderButton("查看物流",(){
                    routePagerNavigator(context,LogisticsPage(80225024010));
                  }),
                  Padding(
                    padding: EdgeInsets.only(left: screenUtil.L(10)),
                    child: OrderUtil.getCircBoderButton("联系客服",(){
                      //TODO 跳转到支付列表
                      ToastUtil.showBottomToast(context, "联系客服");
                    }),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
        onRefresh: (){
          //TODO 下拉刷新
          _easyRefreshKey.currentState.callRefreshFinish();
        },
        loadMore: (){
          //TODO 上拉加载
          _easyRefreshKey.currentState.callLoadMoreFinish();
        },
        key: _easyRefreshKey,
        refreshHeader: ConnectorHeader(
          key: _connectorHeaderKey,
          header: headerView,
        ),
        refreshFooter: ConnectorFooter(
          key:_connectorFooterKey,
          footer: footview,
        ) ,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[headerView])
            ),
            SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index){
              return getItemWidget(index);
            },childCount:goodsList.length)),
            SliverList(
                delegate: SliverChildListDelegate(<Widget>[footview])
            )
          ],
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
