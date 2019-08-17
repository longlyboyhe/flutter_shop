import 'package:flutter/material.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';

/*
 * 发票页面
 */
class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  ScreenUtil screenUtil=ScreenUtil.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: "申请开票"),
      body: Container(
        color: Color(0xFFF7F7F7),
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: screenUtil.L(11),left: screenUtil.L(15),right: screenUtil.L(15),bottom: screenUtil.L(11)),
              padding: EdgeInsets.only(left:screenUtil.L(21),right: screenUtil.L(21),top: screenUtil.L(15),bottom: screenUtil.L(15)),
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "images/bg1.jpg",
                    height: screenUtil.L(60),
                    width: screenUtil.L(60),
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: screenUtil.L(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("订单编号 6092468933984",style: OrderUtil.getTextStyle(12, Color(0xFF000000), FontWeight.w400),),
                        Padding(
                          padding: EdgeInsets.only(top: screenUtil.L(13),bottom: screenUtil.L(13),),
                          child: OrderUtil.getDivideLine(Color(0xFFF7F7F7), 1),
                        ),
                          Text("开票金额 ¥8888.88",style: OrderUtil.getTextStyle(12, Color(0xFF000000), FontWeight.w400),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  static getDivideLine(Color color, double height) {
    return  Container(
      color: color,
      height: ScreenUtil.getInstance().L(height),
    );
  }
}

