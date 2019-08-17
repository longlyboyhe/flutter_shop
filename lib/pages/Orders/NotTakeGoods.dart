import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/my_order_model.dart';
import 'package:flutter_shop/pages/Orders/GoodsListWidget.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';

import 'LogisticsPage.dart';

//代取货
class NotTakeGoods extends StatefulWidget {

  NotTakeGoods(Key key):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return NotTakeGoodsState();
  }
}

class NotTakeGoodsState extends State<NotTakeGoods>
    with AutomaticKeepAliveClientMixin {
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  List<Order> goodsList = List();
  Map<int, bool> stateMap = Map();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey =
      GlobalKey<RefreshHeaderState>();
  Widget footview;
  Widget headerView;
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  int page = 1;
  bool noMoreData = false;
  int maPage=1;

  @override
  void initState() {
    super.initState();
    footview = OrderUtil.getFooterView();
    headerView = OrderUtil.getRefreshHeaderView();
    loadData(false);
  }

  void loadData(bool isEasyRefresh) async {
    ///1=仅显示待付款 2=仅显示待发货 3=仅显示待收货(已发货)
    Map<String, String> params = {
      'page_no': "$page",
      'page_size': "100",
      'order_status': "3",
    };

    HttpManager.instance.get(context, Api.MY_ORDER, (json) {
          MyOrderModel model = MyOrderModel.fromJson(json);
          if(page==1){
            goodsList.clear();
          }
          if(model.data!=null && model.data.data!=null){
            maPage=model.data.totalPage;
            page=model.data.pageNo;
            goodsList.addAll(model.data.data);
            noMoreData = page==maPage;
          }
          isShowEmptyView = goodsList.length==0;
          _easyRefreshKey?.currentState?.callRefreshFinish();
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          setState(() {
          });
          isLoading=false;
          isShowLoadError=false;
        },
        params: params,
        errorCallback: (errorMsg) {
          if(page>1){
            page--;
          }
          isLoading = false;
          isShowLoadError = goodsList.length==0;
          _easyRefreshKey?.currentState?.callRefreshFinish();
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          setState(() {
          });
        });
  }

  Widget getItemWidget(int index) {
    Order model = goodsList[index];
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
                  Image.asset(
                    "images/account_center_supplier.png",
                    fit: BoxFit.fill,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: screenUtil.L(6)),
                      child: Text(
                          model.wareHouseName != null
                              ? model.wareHouseName
                              : "",
                          style: OrderUtil.getTextStyle(
                              10, Color(0xFF000000), FontWeight.bold)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: screenUtil.L(17)),
                    child: Text(model.statusMsg != null ? model.statusMsg : "",
                        style: OrderUtil.getTextStyle(
                            12, Color(0xFFDAD710), FontWeight.bold)),
                  ),
                ],
              ),
              OrderUtil.getDivideLine(Color(0xFFF1F1F1), 1),
              GoodsListWidget(stateMap, index, goodsList[index].orderItemList),
              Container(
                padding: EdgeInsets.only(
                    top: screenUtil.L(17), bottom: screenUtil.L(18)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "（运费：¥${model.deliverFee} 税费：¥${model.tax}）",
                      style: OrderUtil.getTextStyle(
                          12, Color(0xFF949494), FontWeight.w400),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: screenUtil.L(10)),
                      child: Text("总金额：¥${model.totalPay}",
                          style: OrderUtil.getTextStyle(
                              12, Color(0xFF000000), FontWeight.bold)),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OrderUtil.getCircBgButton(
                      "查看物流", Color(0xFF313131), Color(0xffffffff), () {
                    routePagerNavigator(context, LogisticsPage(model.id));
                  }),
                  Padding(
                    padding: EdgeInsets.only(left: screenUtil.L(10)),
                    child: OrderUtil.getCircBgButton(
                        "确认收货", Color(0xFFECE936), Color(0xFFECE936), () {
                      confirmReceipt(model.id);
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

  void confirmReceipt(int id) async {
    LoadingDialogUtil.showLoading(context,barrierDismissible: false);
    //加载联系人列表
    Map<String, String> params = {'orderId': "$id"};
    HttpManager.instance.post(
        context,
        Api.CONFIRM_RECEIPT,
        (json) {
          Navigator.pop(context);
          Map result = json["result"];
          bool is_success = result["is_success"];
          if (is_success == true) {
            ToastUtil.showBottomToast(context, "确认收货成功");
            page = 1;
            loadData(false);
          } else {
            String msg = result["msg"];
            msg = msg != null && msg.isNotEmpty ? msg : "确认收货失败";
            ToastUtil.showToast(context, msg);
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          Navigator.pop(context);
          ToastUtil.showToast(context, "确认收货失败");
        });
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        isLoading: isLoading,
        showEmpty: isShowEmptyView,
        showLoadError: isShowLoadError,
        reLoad: () {
          page = 1;
          loadData(false);
        },
        child: EasyRefresh(
            onRefresh: () {
              page = 1;
              loadData(true);
            },
            loadMore: () {
              page++;
              if(page>maPage){
                noMoreData=true;
                _easyRefreshKey.currentState.callLoadMoreFinish();
                return;
              }
              loadData(true);
            },
            key: _easyRefreshKey,
            refreshHeader: ConnectorHeader(
              key: _connectorHeaderKey,
              header: headerView,
            ),
            refreshFooter: ConnectorFooter(
              key: _connectorFooterKey,
              footer: footview,
            ),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[headerView])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return getItemWidget(index);
                }, childCount: goodsList.length)),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[footview]))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
