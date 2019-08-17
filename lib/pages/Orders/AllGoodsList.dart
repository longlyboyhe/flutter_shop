import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/Constants.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/check_pay_status.dart';
import 'package:flutter_shop/model/my_order_model.dart';
import 'package:flutter_shop/pages/Orders/ToBePay.dart';
import 'package:flutter_shop/pages/cart/CartSinglePage.dart';
import 'package:flutter_shop/pages/mine/setting/ChangePayPassword.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/pin_input_text_field.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'GoodsListWidget.dart';
import 'LogisticsPage.dart';

//退换货
class AllGoodsList extends StatefulWidget {

  AllGoodsList(Key key):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return AllGoodsListState();
  }
}

class AllGoodsListState extends State<AllGoodsList>
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
      'order_status': "",
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
          isLoading = false;
          isShowLoadError=false;
          _easyRefreshKey?.currentState?.callRefreshFinish();
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          setState(() {
          });
        },
        params: params,
        errorCallback: (errorMsg) {
          if(page>1){
            page--;
          }
          isLoading = false;
          isShowLoadError = goodsList.length==0;
          if(isEasyRefresh){
            _easyRefreshKey?.currentState?.callRefreshFinish();
            _easyRefreshKey?.currentState?.callLoadMoreFinish();
          }else{
            setState(() {
            });
          }
        });
  }

  Widget getItemWidget(int index, Color stateColor) {
    Order model = goodsList[index];
    double leftRight = screenUtil.L(14);
    double topBottom = screenUtil.L(18);

    List<Widget> list=List();
    Order order=goodsList[index];
    if(order.statusCode==1){
      list.add(OrderUtil.getCircBgButton("去支付", Color(0xFF313131), Color(0xFFffffff), () {
        //去支付
        checkStatus(order);
      }));
    }else if(order.statusCode==0){
      //已取消，只有再次购买
      list.add(OrderUtil.getCircBgButton("再次下单", Color(0xFF313131), Color(0xFFffffff), () {
        addCartGoods(model);
      }));
    }else if(order.statusCode==2){
      //代发货
      list.add(OrderUtil.getCircBgButton("提醒发货", Color(0xFF313131), Color(0xFFffffff), () {
        ToastUtil.showToast(context, "已提醒商家发货");
      }));
    }else if(order.statusCode==3){
      //待收货
      list.add(OrderUtil.getCircBgButton("确认收货", Color(0xFF313131), Color(0xFFffffff), () {
        //确认收货
        confirmReceipt(order.id);
      }));
    }else if(order.statusCode==4){
      //已完成
      list.add(OrderUtil.getCircBgButton("再次下单", Color(0xFF313131), Color(0xFFffffff), () {
        addCartGoods(model);
      }));
      list.add(Padding(padding: EdgeInsets.only(left: screenUtil.L(10), right: screenUtil.L(10)),
        child: OrderUtil.getCircBgButton( "查看物流", Color(0xFF313131), Color(0xFFffffff), () {
          routePagerNavigator(context, LogisticsPage(model.id));
        }),));
    }

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
                children: list,
              )
            ],
          ),
        )
      ],
    );
  }

  void checkStatus(Order model){
    HttpManager().get(context, Api.CHECK_PAY_AVAILABE, (result){
      CheckPayStatus checkPayStatus=CheckPayStatus.fromJson(result);
      if(checkPayStatus.result.isSuccess){
        if(checkPayStatus.data!=null){
          if(checkPayStatus.data.havePwd==true){
            //有支付密码
            if(checkPayStatus.data.balanceAmount>model.totalPay){
              //余额充足
              pay(model,checkPayStatus.data.balanceAmount);
            }else{
              ToastUtil.showToast(context, "余额不足请充值之后，在进行支付");
            }
          }else{
            //没有支付密码,跳转到支付设置支付密码页面
            showDialog(context: context,barrierDismissible: false,
                builder: (context) {
                  return CommonDialog(
                    title: "未设置支付密码，扣款失败!",
                    message:'将前往“我的-账户安全-修改支付密码” 设置支付密码后， 进入我 的订单/待支付订单继续支付',
                    rightButtonText: '确定',
                    onRightPress: () {
                      Navigator.pop(context);
                      routePagerNavigator(context, ChangePayPassword());
                    },
                  );
                }
            );
          }
        }
      }else{
        ToastUtil.showToast(context, "网络异常，请重试");
      }
    },errorCallback: (error){
      ToastUtil.showToast(context, "网络异常，请重试");
    },params:{"order_id":model.id.toString()});
  }

  void pay(Order model, double balanceAmount){
    PinEditingController controller =PinEditingController();
    showDialog(context: context,barrierDismissible:false,builder: (context) {
      return AccountCenterPayPassword(context,balanceAmount.toString(),model.realPay,(String payPwd){
        if(payPwd!=null && payPwd.length==6){
          String pwd=hex.encode(md5.convert(utf8.encode((payPwd+Constants.MD5_SECRET_KEY))).bytes);
          payMoneny(pwd,controller,model.id,model.realPay);
        }
      },controller);
    });
  }

  payMoneny(String pwd, PinEditingController controller, int id, double realPay){
    HttpManager().put(context, Api.PAY_MONEY, {
      //后台订单id
      "order_number":id,
      //用户支付密码
      "user_password":pwd,
      //实际支付金额
      "ord_amt": realPay,
      //支付方式 0：余额支付 1：支付宝 2：微信 3:余额充值
      "pay_type":0,
    }, (result){
      BaseResp baseResp=BaseResp.fromJson(result);
      if(baseResp.result.code==200){
        ToastUtil.showToast(context, "支付成功");
        Navigator.pop(context);
        page=1;
        loadData(false);
      }else if(baseResp.result.code==600002){
        ToastUtil.showToast(context, "支付密码错误，请重新输入");
        controller.clear();
      }else{
        controller.clear();
        ToastUtil.showToast(context, "网络异常，请重新尝试");
      }
    },onError: (error){
      controller.clear();
      ToastUtil.showToast(context, "网络异常，请重新尝试");
    });
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

  void addCartGoods(Order model) {
    List list=List();
    for(Order_item_list item in model.orderItemList){
      list.add({
        "skuId":item.productId,
        "spuId":item.spuId,
        "vendorId":item.vendorId,
        "vendorType":item.vendorType,
        "originalPrice":item.nowPrice,
        "originalQuantity":item.quantity
      });
    }
    if(list.length>0){
      HttpManager().postForm(context,Api.ADD_CART_GOODS, {"cartList":list,}, (json){
        BaseResp baseResp=BaseResp.fromJson(json);
        if(baseResp.result.isSuccess){
          routePagerNavigator(context, CartSinglePage());
          //添加成功后下单数量置0
        }else{
          ToastUtil.showToast(context, baseResp.result.msg);
        }
      },onError: (error){
        ToastUtil.showToast(context, "网络异常，请重试");
      });
    }
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
                  return getItemWidget(index, Color(0xFFC10000));
                }, childCount: goodsList.length)),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[footview]))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}
