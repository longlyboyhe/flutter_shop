import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/mine/pay/TransferInformation.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';

///
/// 对公转账
/// @author longlyboyhe
/// @date 2019/3/11
///
class TransferAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
          context: context, title: "账户安全", bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TransferContent(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(25)),
              color: KColor.dividerColor,
              height: 0.5,
            ),
            AppButton(
              title: "已汇款",
              enable: true,
              useLoadding: false,
              margin: EdgeInsets.only(
                  left: ScreenUtil().L(15),
                  right: ScreenUtil().L(15),
                  top: ScreenUtil().L(30)),
              onTap: () {
                routePagerNavigator(context, TransferInformation());
              },
            )
          ],
        ),
      ),
    );
  }
}

class TransferContent extends StatelessWidget {
  Widget _item(String title, String subTitle) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().L(25), vertical: ScreenUtil().L(16)),
      child: Row(
        children: <Widget>[
          Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400)),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().L(10)),
            child: Text(subTitle,
                maxLines: 2,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
          )),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(25)),
      color: KColor.dividerColor,
      height: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().L(25),
              top: ScreenUtil().L(15),
              bottom: ScreenUtil().L(15)),
          alignment: Alignment.centerLeft,
          color: Color(0xFFD4D4D4),
          child: Text("收款方信息",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
        _item("公司名称", "宜春美淘商贸有限公司"),
        _divider(),
        _item("公司地址", "江西省宜春市袁州区彬江机电产业基地创业大道16号"),
        _divider(),
        _item("公司银行账户", "36050182019800000282"),
        _divider(),
        _item("开户银行名称", "中国建设银行股份有限公司宜春袁州支行"),
        _divider(),
//        _item("开户行地址", "北京市东城区小牌坊胡同甲七号"),
//        _divider(),
        _item("开户行银行代号", "105431000019"),
      ],
    );
  }
}
