import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/RechargeMethodModel.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/pages/mine/pay/TransferAccount.dart';
import 'package:flutter_shop/pages/mine/pay/TransferInformation.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 账户资金
/// @author longlyboyhe
/// @date 2019/3/8
///
class RechargePage extends StatefulWidget {
  final double accountBalance;

  RechargePage(this.accountBalance);

  @override
  _RechargePageState createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
//  List<RechargeMethodModel> rechargeMethodList = List();

  @override
  void initState() {
    super.initState();
//    rechargeMethodList.add(RechargeMethodModel(type: 1, name: "对公账户"));
//    rechargeMethodList.add(RechargeMethodModel(type: 2, name: "支付宝"));
//    rechargeMethodList.add(RechargeMethodModel(type: 3, name: "微信"));
//    rechargeMethodList.add(RechargeMethodModel(type: 4, name: "银联卡"));
    loadData();
  }

  String waitingMoney = "0"; //待到账金额
  void loadData() async {
    User user = await DataUtils.getUserInfo();
    Map<String, String> params = {'user_id': "${user.userId}"};
    HttpManager.instance.get(context, Api.PAYCENTER_AMOUNT, (json) {
      num data = json['data'];
      print("rechargePage ---------$data---------");
      if (data != null && data > 0) {
        setState(() {
          waitingMoney = "$data";
        });
      }
    }, params: params, errorCallback: (errorMsg) {});
  }

  Widget _item(String text, EdgeInsets margin, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: EdgeInsets.only(
            left: ScreenUtil().L(20), right: ScreenUtil().L(10)),
        height: ScreenUtil().L(45),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12))),
            Icon(Icons.arrow_forward_ios,
                size: ScreenUtil().L(10), color: Color(0xFFACACAC))
          ],
        ),
      ),
    );
  }

  Widget _accountDetail() {
    return Container(
      alignment: Alignment.bottomLeft,
      constraints: BoxConstraints.expand(height: ScreenUtil().L(185)),
      padding: EdgeInsets.only(
          left: ScreenUtil().L(18),
          right: ScreenUtil().L(19),
          bottom: ScreenUtil().L(30)),
      margin: EdgeInsets.symmetric(
          vertical: ScreenUtil().L(10), horizontal: ScreenUtil().L(15)),
      decoration: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("账户余额（元）",
              style: TextStyle(
                  color: Color(0xFF818181),
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
          Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(top: ScreenUtil().L(8)),
                child: Text("${widget.accountBalance}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold)),
              )),
              Container(
                color: Colors.black,
                height: ScreenUtil().L(30),
                width: 1,
                margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(30)),
              ),
              Column(
                children: <Widget>[
                  Text("待到账（元）",
                      style: TextStyle(
                          color: Color(0xFF818181),
                          fontSize: 12,
                          fontWeight: FontWeight.w400)),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenUtil().L(5)),
                    child: Text(waitingMoney,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KColor.mineBgColor,
        appBar: CommonAppBar(
            context: context, title: "账户资金", bottom: CommonAppBarBottomLine()),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _accountDetail(),
              RechargeItem(
                  "充值", EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
                  () {
                ///刷新待到账金额
                loadData();
              }),
//              RechargeItem(
//                  "退款",
//                  EdgeInsets.symmetric(
//                      horizontal: ScreenUtil().L(15),
//                      vertical: ScreenUtil().L(10)),
//                  rechargeMethodList)
            ],
          ),
        ));
  }
}

class RechargeItem extends StatelessWidget {
  final EdgeInsets margin;
  final String text;
  final VoidCallback refresh;

//  final List<RechargeMethodModel> list;

  RechargeItem(this.text, this.margin, this.refresh);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        showMyBottomSheet(
//            context: context,
//            builder: (context) {
//              return RechargeMethod(list);
//            });
        routePagerNavigator(context, TransferInformation()).then((success) {
          if (success == true) {
            if (refresh != null) refresh();
          }
        });
      },
      child: Container(
        margin: margin,
        padding: EdgeInsets.only(
            left: ScreenUtil().L(20), right: ScreenUtil().L(10)),
        height: ScreenUtil().L(45),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(text,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12))),
            Icon(Icons.arrow_forward_ios,
                size: ScreenUtil().L(10), color: Color(0xFFACACAC))
          ],
        ),
      ),
    );
  }
}

class RechargeMethod extends StatelessWidget {
  final List<RechargeMethodModel> list;

  RechargeMethod(this.list);

  @override
  Widget build(BuildContext context) {
    Widget _buildItem(RechargeMethodModel model) {
      Widget _child;
      if (model.type == 1) {
        _child = Text("对公账户",
            style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500));
      } else {
        _child = Image.asset("images/icon_wechat.png",
            width: ScreenUtil().L(25), height: ScreenUtil().L(25));
      }
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (model.type == 1) {
            routePagerNavigator(context, TransferAccount());
          } else {
            ToastUtil.showToast(context, "支付方式${model.type}");
          }
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: ScreenUtil().L(14)),
          height: ScreenUtil().L(45),
          color: Colors.white,
          child: _child,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5), topRight: Radius.circular(5))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Color(0xFFF1F1F1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            width: ScreenUtil.screenWidth,
            height: ScreenUtil().L(50),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Text("选择支付方式",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                Positioned(
                    right: 0,
                    child: RawMaterialButton(
                      //控件没有margin
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.only(
                          left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                          size: ScreenUtil().L(15), color: Colors.black),
                      constraints:
                          BoxConstraints(minWidth: 10.0, minHeight: 10.0),
                    ))
              ],
            ),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: list?.length,
              itemBuilder: (context, i) => _buildItem(list[i]),
              separatorBuilder: (context, i) => Divider(
                    color: KColor.dividerColor,
                    height: 1,
                  ))
        ],
      ),
    );
  }
}
