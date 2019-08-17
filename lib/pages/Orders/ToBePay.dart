import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/Constants.dart';
import 'package:flutter_shop/constants/color.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/my_order_model.dart';
import 'package:flutter_shop/pages/Orders/GoodsListWidget.dart';
import 'package:flutter_shop/pages/mine/setting/ChangePayPassword.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/pin_input_text_field.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_shop/model/check_pay_status.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
//待支付
class ToBePayPage extends StatefulWidget {

  ToBePayPage(Key key):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return ToBePayPageState();
  }
}

class ToBePayPageState extends State<ToBePayPage>
    with AutomaticKeepAliveClientMixin {
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  List<Order> goodsList = List();
  Map<int, bool> stateMap = Map();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey = GlobalKey<RefreshHeaderState>();
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
      'page_size': "999",
      'order_status': "1",
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
                        style: OrderUtil.getTextStyle(12, Color(0xFFDAD710), FontWeight.bold)),
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
//                  OrderUtil.getCircBoderButton("取消支付", () {
//                    showDialog(
//                        context: context,
//                        builder: (context) {
//                          return CommonDialog(
//                            message: '确认要取消支付吗?',
//                            leftButtonText: '取消',
//                            rightButtonText: '确定',
//                            onLeftPress: () {
//                              Navigator.of(context).pop();
//                            },
//                            onRightPress: () {
//                              //TODO 取消支付操作
//                              Navigator.of(context).pop();
//                              ToastUtil.showBottomToast(context, "取消支付成功");
//                            },
//                          );
//                        });
//                  }),
                  Padding(
                    padding: EdgeInsets.only(left: screenUtil.L(10)),
                    child: OrderUtil.getCircBgButton("去支付", Color(0xFFECE936), Color(0xFFECE936), () {
                      checkStatus(model);
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

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
        isLoading: isLoading,
        showEmpty: isShowEmptyView,
        showLoadError: isShowLoadError,
        reLoad: () {
          page == 1;
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
                return ;
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
                  },
                      childCount: goodsList != null && goodsList.length > 0
                          ? goodsList.length
                          : 0),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[footview]))
              ],
            )));
  }

  @override
  bool get wantKeepAlive => true;
}



class AccountCenterPayPassword extends StatelessWidget {
  final BuildContext mContext;
  Function payPwdCallBack;
  PinEditingController controller;
  String balanceAmount;
  double realPayMoney;

  AccountCenterPayPassword(this.mContext,this.balanceAmount,this.realPayMoney,this.payPwdCallBack,this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minHeight: 80),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding:
                          const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          alignment: Alignment.center,
                          child: Text("请输入支付密码",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: RawMaterialButton(
                              //控件没有margin
                              materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: const EdgeInsets.only(
                                  left: 5.0,
                                  right: 10.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              onPressed: () {
                                Navigator.pop(mContext);
                                ToastUtil.showToast(context, "支付失败");
                              },
                              child: Icon(Icons.clear,
                                  size: 20, color: Colors.black),
                              constraints:
                              BoxConstraints(minWidth: 10, minHeight: 10),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: ScreenUtil().L(27)),
                      color: KColor.bgColor,
                      height: 1,
                    ),
                    Text("支付金额",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w300)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("¥",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        Text("$realPayMoney",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().L(26), bottom: ScreenUtil().L(18)),
                      color: KColor.bgColor,
                      height: 1,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().L(24),
                              right: ScreenUtil().L(6)),
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.black,
                            size: ScreenUtil().L(15),
                          ),
                        ),
                        Text("余额支付",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                        Text("  "+balanceAmount,
                            style: TextStyle(
                                color: Color(0xFF949494),
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: ScreenUtil().L(16)),
                      color: KColor.bgColor,
                      height: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().L(30)),
                      child: PinInputTextField(
                        pinLength: 6,
                        decoration: BoxLooseDecoration(
                          radius: Radius.circular(0),
                          strokeColor: Color(0xFFEFEFEF),
                          textStyle: TextStyle(
                              fontSize: 32,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          enteredColor: Colors.deepOrange,
                        ),
                        pinEditingController: controller,
                        autoFocus: true,
                        onSubmit: (pin) {
                          if(payPwdCallBack!=null){
                            payPwdCallBack(pin);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
