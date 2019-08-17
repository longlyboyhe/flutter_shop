import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/mine/setting/ChangePayPassword.dart';
import 'package:flutter_shop/pages/mine/setting/FindLoginPassword.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// 账户安全
/// @author longlyboyhe
/// @date 2019/3/8
///
class AccountSecurity extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.mineBgColor,
      appBar: CommonAppBar(
          context: context, title: "账户安全", bottom: CommonAppBarBottomLine()),
      body: Column(
        children: <Widget>[
          _item(
              "修改登陆密码",
              EdgeInsets.symmetric(
                  vertical: ScreenUtil().L(10),
                  horizontal: ScreenUtil().L(15)), () {
//            routePagerNavigator(context, FindLoginPassword());
            showDialog(
                context: context,
                builder: (context) {
                  return CommonDialog(
                    message:
                        '尊敬的用户，如需更改登录密码， 欢迎拨打65266268或18518239266 致电人工客服，我们竭诚为您服务！',
                    leftButtonText: '关闭',
                    rightButtonText: '拨打客服',
                    onLeftPress: () {
                      Navigator.pop(context, false);
                    },
                    onRightPress: () {
                      Navigator.pop(context, true);
                      _launchURL(context);
                    },
                  );
                });
          }),
          _item("修改支付密码", EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
              () {
            routePagerNavigator(context, ChangePayPassword());
          }),
//          _item("注销账号", EdgeInsets.symmetric(horizontal: ScreenUtil().L(15)),
//              () {
//            _cancellation(context);
//          })
        ],
      ),
    );
  }

  _launchURL(BuildContext context) async {
    const url = 'tel:65266268';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showToast(context, "未能打开拨号页面");
    }
  }

  _cancellation(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CommonDialog(
            message: '注销账号后，该账号的所有已购商品 将不再享受本平台的售后服务， 账号所有信息和权益将永久清除”确认注销?',
            leftButtonText: '取消注销',
            rightButtonText: '确认注销',
            onLeftPress: () {
              Navigator.pop(context, false);
            },
            onRightPress: () {
              ToastUtil.showToast(context, "账号已注销");
              Navigator.pop(context, true);
            },
          );
        });
  }
}
