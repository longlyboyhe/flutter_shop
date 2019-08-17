import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/Constants.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/PayModel.dart';
import 'package:flutter_shop/model/address.dart';
import 'package:flutter_shop/model/cart_resp.dart';
import 'package:flutter_shop/model/settlement_center.dart';
import 'package:flutter_shop/pages/Orders/OrderPage.dart';
import 'package:flutter_shop/pages/address/AddressBook.dart';
import 'package:flutter_shop/pages/mine/setting/ChangePayPassword.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/ColorfulDividerWidget.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/pin_input_text_field.dart';

///
/// 结算中心
/// @author longlyboyhe
/// @date 2019/3/25
///
///


class SettlementCenter extends StatefulWidget {

  SettlementData settlementData;
  String cartIds;
  bool isDetailsEnter;
  //商品详情页进入结算中心所需要的订单信息
  List detailsOrderInfo;

  SettlementCenter(this.settlementData, this.cartIds,this.isDetailsEnter,{this.detailsOrderInfo});

  @override
  _SettlementCenterState createState() => _SettlementCenterState();
}

class _SettlementCenterState extends State<SettlementCenter> {

  Address address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: CommonAppBar(context: context, title: "结算中心"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            GoodAddress((Address adress){
              this.address=adress;
              setState(() {
              });
            }),
            ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int parentIndex) {
                  return SupplierGoodItem(
                    vendor: widget.settlementData.vendorList[parentIndex],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: ScreenUtil().L(10),
                    color: KColor.bgColor,
                  );
                },
                itemCount: widget.settlementData.vendorList.length),
            Container(
              margin: EdgeInsets.all(ScreenUtil().L(10)),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().L(10), horizontal: ScreenUtil().L(15)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
              child: Column(
                children: <Widget>[
                  _goodRow("商品总金额：", "￥${widget.settlementData.totalPay}"),
                  _goodRow("税金：", "￥${widget.settlementData.tax}",
                      margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().L(8))),
                  _goodRow("运费：", "￥${widget.settlementData.deliverFee}"),
                  _goodRow("总计：", "￥${widget.settlementData.totalPay+widget.settlementData.deliverFee+widget.settlementData.tax}",
                      margin: EdgeInsets.only(top: ScreenUtil().L(8))),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: CenterBottomView(
            settleModel: widget.settlementData,cartIds:widget.cartIds,address:address,isDetailsEnter:widget.isDetailsEnter,detailsOrderInfo:widget.detailsOrderInfo
        ),
      ),
    );
  }

  Widget _goodRow(String leftText, String rightText, {EdgeInsets margin}) {
    Widget _child;
    _child = Row(
      children: <Widget>[
        Expanded(
            child: Text(
          leftText,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 12),
        )),
        Text(
          rightText,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
        )
      ],
    );
    if (margin != null)
      _child = Padding(
        padding: margin,
        child: _child,
      );
    return _child;
  }
}

class GoodAddress extends StatefulWidget {

  Function addressCallBack;

  GoodAddress(this.addressCallBack);

  @override
  _GoodAddressState createState() => _GoodAddressState();
}

class _GoodAddressState extends State<GoodAddress> {
  Address address;

  void selectAddress() {
    routePagerNavigator(context, AddressBook()).then((value) {
      if (value != null) {
        setState(() {
          address = value;
          if(widget.addressCallBack!=null){
            widget.addressCallBack(address);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().L(10)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ColorfulDividerWidget(),
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().L(30), left: ScreenUtil().L(20)),
            child: Text(
              "快递配送",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().L(15),
                top: ScreenUtil().L(15),
                right: ScreenUtil().L(15)),
            color: KColor.dividerColor,
            height: 1,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: ScreenUtil().L(15)),
                child: Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: ScreenUtil().L(12),
                ),
              ),
              Expanded(
                  child: Text(
                "收货人信息",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              )),
              GestureDetector(
                onTap: () {
                  selectAddress();
                },
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().L(15)),
                  color: Colors.white,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: ScreenUtil().L(15),
                  ),
                ),
              )
            ],
          ),
          address != null
              ? Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().L(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            address.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 12),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().L(30)),
                            child: Text(
                              address.mobile,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().L(7), bottom: ScreenUtil().L(30)),
                        child: Text(
                          address.address,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 12),
                        ),
                      )
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    selectAddress();
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: ScreenUtil().L(15)),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color(0xFFE1E1E1),
                            width: ScreenUtil().L(3))),
                    child: Icon(
                      Icons.add,
                      size: 50,
                      color: Color(0xFFE1E1E1),
                    ),
                  ),
                ),
          ColorfulDividerWidget(),
        ],
      ),
    );
  }
}

class SupplierGoodItem extends StatelessWidget {
  final Vendor vendor;

  SupplierGoodItem({this.vendor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: ScreenUtil().L(10),
        right: ScreenUtil().L(10),
      ),
      padding: EdgeInsets.only(bottom: ScreenUtil().L(8)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: ScreenUtil().L(14),
              top: ScreenUtil().L(15),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().L(6)),
                  child: Image.asset("images/account_center_supplier.png"),
                ),
                Text(
                  vendor.wareHouseName==null?"":vendor.wareHouseName,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                )
              ],
            ),
          ),
          Container(
            color: KColor.dividerColor,
            height: 1,
            margin: EdgeInsets.only(
                left: ScreenUtil().L(15),
                right: ScreenUtil().L(15),
                top: ScreenUtil().L(15),
                bottom: ScreenUtil().L(10)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return GoodItem(
                model: vendor.cartList[index],
              );
            },
            itemCount: vendor.cartList != null ? vendor.cartList.length : 0,
          ),
        ],
      ),
    );
  }
}

class GoodItem extends StatelessWidget {
  final Cart model;

  GoodItem({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().L(30),
          right: ScreenUtil().L(23),
          top: ScreenUtil().L(10),
          bottom: ScreenUtil().L(10)),
      child: Row(
        children: <Widget>[
          FadeInImage(
            placeholder: AssetImage("images/default_good_image.png"),
            image: NetworkImage(model.picUrl==null?"":model.picUrl[0]),
            width: ScreenUtil().L(70),
            height: ScreenUtil().L(70),
            fit: BoxFit.fill,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(model.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(7)),
                child: model.getSpcAttr().isNotEmpty
                    ? Text(model.getSpcAttr(),
                        style: TextStyle(
                            color: Color(0xFF949494),
                            fontWeight: FontWeight.w300,
                            fontSize: 10))
                    : Container(),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("￥${model.originalPrice}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  Text("数量 ${model.originalQuantity}",
                      style: TextStyle(
                          color: Color(0xFF949494),
                          fontWeight: FontWeight.w400,
                          fontSize: 8))
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class CenterBottomView extends StatelessWidget {
  final SettlementData settleModel;
  final String cartIds;
  final Address address;
  final bool isDetailsEnter;
  bool createOrderSuccess=false;
  bool isPaySuccess=false;
  List detailsOrderInfo;
  PayModel payModel;
  CenterBottomView({this.settleModel,this.cartIds,this.address,this.isDetailsEnter,this.detailsOrderInfo});

  @override
  Widget build(BuildContext context) {
    BuildContext mContext = context;
    return Container(
      height: ScreenUtil().L(65),
      padding: EdgeInsets.symmetric(
          vertical: ScreenUtil().L(10), horizontal: ScreenUtil().L(15)),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0xffE5E5E5), offset: Offset(0, -1), blurRadius: 5),
      ]),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().L(5)),
            child: Text(
              "应付金额：",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w300,
                  fontSize: 10),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                settleModel.realPay.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              Text(
                "共计 ${settleModel.itemSize} 件商品",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 10),
              ),
            ],
          )),
          GestureDetector(
            onTap: () {
              createOrder(mContext);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().L(120),
              decoration: BoxDecoration(
                  color: Color(0xFFECE936),
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenUtil().L(23)))),
              child: Text(
                "确认支付",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  void createOrder(BuildContext mContext){
    if(address==null || address.id==null || address.id.toString().isEmpty){
      ToastUtil.showToast(mContext, "请选择收货地址");
      return;
    }

    if(createOrderSuccess==null || createOrderSuccess==false){
      LoadingDialogUtil.showLoading(mContext,barrierDismissible: false);
      //订单创建失败，或者没有创建订单
      Map map={
        "isInvoice":0,
        "addressId":address.id,
      };
      if(isDetailsEnter){
        map["spuId"]=cartIds;
        map["itemList"]=detailsOrderInfo;
      }else{
        map["cartIds"]=cartIds.split(",");
        map["deliverType"]=settleModel.deliverType;
      }
      String url=isDetailsEnter? Api.DETAILS_CREATE_ORDER:Api.CART_TO_CREATE_ORDER;
      HttpManager().postForm(mContext, url, map, (result){
        payModel=PayModel.fromJson(result);
        if(payModel.result.isSuccess){
          //订单创建成功
          createOrderSuccess=true;
          checkStatus(mContext);
        }else{
          Navigator.pop(mContext);
          ToastUtil.showToast(mContext, payModel.result.msg);
        }
      },onError: (error){
        Navigator.pop(mContext);
        ToastUtil.showToast(mContext, "网络异常，请重试");
      });
    }else{
      //订单创建成功，吊起支付
      if(payModel!=null){
        checkStatus(mContext);
      }
    }
  }

  void checkStatus(BuildContext mContext) {
    if(payModel.data!=null){
      if(payModel.data.havePwd==true){
        if(payModel.data.payAvailable==true){
          //余额充足
          showpayDialog(mContext,payModel);
        }else{
          //余额不足
          Navigator.pop(mContext);
          showDialog(
              context: mContext,
              barrierDismissible: false,
              builder: (context) {
                return CommonDialog(
                  title: "余额不足",
                  message: '进入我的订单/待支付订单继续支付！',
                  rightButtonText: '确定',
                  onRightPress: () {
                    //返回关闭
                    Navigator.pop(mContext);
                    routePagerNavigator(mContext, OrderPage(0)).then((value) {
                      Navigator.pop(mContext);
                    });
                  },
                );
              });
        }
      }else{
        //没有设置支付密码
        showSetPaypwdDialog(mContext);
      }
    }else{
      Navigator.pop(mContext);
      ToastUtil.showToast(mContext, "网络异常，请重试");
    }
  }

  void showSetPaypwdDialog(BuildContext mContext) {
    Navigator.pop(mContext);
     showDialog(
        context: mContext,
        barrierDismissible: false,
        builder: (context) {
          return CommonDialog(
            title: "未设置支付密码，扣款失败!",
            message:
            '将前往“我的-账户安全-修改支付密码” 设置支付密码后， 进入我 的订单/待支付订单继续支付',
            rightButtonText: '确定',
            onRightPress: () {
              //T返回关闭
              Navigator.pop(context);
              routePagerNavigator(context, ChangePayPassword(fromSetteleCenter: true,)).then((value) {
                Navigator.pop(mContext);
              });
            },
          );
        });
  }

  payMoneny(BuildContext mContext, String pwd, PinEditingController controller){
    HttpManager().put(mContext, Api.PAY_MONEY, {
      //后台订单id
      "order_number":payModel.data.orderId,
      //用户支付密码
      "user_password":pwd,
      //实际支付金额
      "ord_amt": settleModel.realPay,
      //支付方式 0：余额支付 1：支付宝 2：微信 3:余额充值
      "pay_type":0,
    }, (result){
      BaseResp baseResp=BaseResp.fromJson(result);
      if(baseResp.result.code==200){
        isPaySuccess=true;
        Navigator.pop(mContext);
        controller.clear();
        ToastUtil.showToast(mContext, "支付成功");
        routePagerNavigator(mContext, OrderPage(1)).then((value) {
          Navigator.pop(mContext);
        });
      }else if(baseResp.result.code==600002){
        ToastUtil.showToast(mContext, "支付密码错误，请重新输入");
        controller.clear();
      }else{
        ToastUtil.showToast(mContext, "支付失败，请在待付款页面进行支付");
        Navigator.pop(mContext);
        routePagerNavigator(mContext, OrderPage(0)).then((value) {
          Navigator.pop(mContext);
        });
      }
    },onError: (error){
      controller.clear();
      ToastUtil.showToast(mContext, "网络异常，请重新尝试");
    });
  }


  void showpayDialog(BuildContext mContext, PayModel payModel) {
    Navigator.pop(mContext);
    PinEditingController controller =PinEditingController();
    showDialog(context: mContext,barrierDismissible:false,builder: (context) {
       return AccountCenterPayPassword(mContext,payModel.data.balanceAmount.toString(),settleModel.realPay,(String payPwd){
          if(payPwd!=null && payPwd.length==6){
            String pwd=hex.encode(md5.convert(utf8.encode((payPwd+Constants.MD5_SECRET_KEY))).bytes);
            payMoneny(mContext,pwd,controller);
          }
       },controller);
    }).then((value){
      if(!isPaySuccess){
        routePagerNavigator(mContext, OrderPage(0)).then((value) {
          Navigator.pop(mContext);
        });
      }
    });
  }
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
                                routePagerNavigator(mContext, OrderPage(1)).then((value) {
                                  Navigator.pop(mContext);
                                });
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
