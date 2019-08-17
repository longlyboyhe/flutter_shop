import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/image_upload_model.dart';
import 'package:flutter_shop/model/login_model.dart';
import 'package:flutter_shop/model/user_info_model.dart';
import 'package:flutter_shop/natives/image_picker.dart';
import 'package:flutter_shop/pages/Orders/OrderPage.dart';
import 'package:flutter_shop/pages/address/AddressBook.dart';
import 'package:flutter_shop/pages/login/LoginPage.dart';
import 'package:flutter_shop/pages/mine/pay/RechargePage.dart';
import 'package:flutter_shop/pages/mine/setting/SettingPage.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/Image.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MinePageState();

  MinePage({Key key}) : super(key: key);
}

class MinePageState extends State<MinePage> {
  double accountBalance = 0; //账户余额
  @override
  void initState() {
    super.initState();
    //账户余额
    getAccountBalance();
  }

  getAccountBalance() async {
    User user = await DataUtils.getUserInfo();
    Map<String, String> params = {'uid': "${user.userId}"};
    HttpManager.instance.get(
        context,
        Api.ACCOUNT_BALANCE,
        (json) {
          Map data = json['data'];
          if (data != null) {
            accountBalance =
                data["balance_amount"] != null ? data["balance_amount"] : 0;
            setState(() {});
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          print("获取账户余额失败");
        });
  }

  Widget _IconTextButton(String iconName, String title,
      {Color color = Colors.black,
      double fontSize = 10,
      FontWeight fontWeight = FontWeight.w400,
      VoidCallback onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: <Widget>[
            Image.asset(iconName),
            Padding(
                padding: EdgeInsets.only(top: ScreenUtil().L(9)),
                child: Text(title,
                    style: TextStyle(
                        color: color,
                        fontSize: fontSize,
                        fontWeight: fontWeight)))
          ],
        ));
  }

  Widget _longButton(String title, double marginBottom, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().L(15), horizontal: ScreenUtil().L(20)),
        margin: EdgeInsets.only(
            left: ScreenUtil().L(15),
            right: ScreenUtil().L(15),
            bottom: marginBottom),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(title,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400))),
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
        appBar: BlankAppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MineHead(accountBalance),
//              Padding(
//                  padding: EdgeInsets.only(top: ScreenUtil().L(25)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      _IconTextButton("images/icon_browse.png", "我的浏览",
//                          color: Color(0xFF212121),
//                          fontWeight: FontWeight.w500, onTap: () {
//                        routePagerNavigator(context, MyTracksPage());
//                      }),
//                      Container(
//                        color: KColor.dividerColor,
//                        height: ScreenUtil().L(22),
//                        width: 1,
//                      ),
//                      _IconTextButton("images/icon_collect.png", "我的收藏",
//                          color: Color(0xFF212121),
//                          fontWeight: FontWeight.w500, onTap: () {
//                        routePagerNavigator(context, MyCollectionPage());
//                      })
//                    ],
//                  )),
              Container(
                padding: EdgeInsets.all(ScreenUtil().L(20)),
                margin: EdgeInsets.only(
                    top: ScreenUtil().L(25),
                    bottom: ScreenUtil().L(10),
                    left: ScreenUtil().L(15),
                    right: ScreenUtil().L(15)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(bottom: ScreenUtil().L(25)),
                        child: Text("我的订单",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _IconTextButton("images/order_to_be_pay.png", "待付款",
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500, onTap: () {
                          routePagerNavigator(context, OrderPage(0));
                        }),
                        _IconTextButton("images/order_not_deliver.png", "待发货",
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500, onTap: () {
                          routePagerNavigator(context, OrderPage(1));
                        }),
                        _IconTextButton("images/order_not_take.png", "待收货",
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500, onTap: () {
                          routePagerNavigator(context, OrderPage(2));
                        }),
                        _IconTextButton("images/order_all.png", "全部订单",
                            color: Color(0xFF212121),
                            fontWeight: FontWeight.w500, onTap: () {
                          routePagerNavigator(context, OrderPage(3));
                        }),
//                        _IconTextButton("images/order_return.png", "退换货",
//                            color: Color(0xFF212121),
//                            fontWeight: FontWeight.w500, onTap: () {
//                          routePagerNavigator(context, OrderPage(3));
//                        })
                      ],
                    )
                  ],
                ),
              ),
              _longButton("我的地址簿", ScreenUtil().L(10), () {
                routePagerNavigator(
                    context,
                    AddressBook(
                      isMinePageEnter: true,
                    ));
              }),
              _longButton("客服与帮助", 0, () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CommonDialog(
                        message:
                            "尊敬的用户，如有售前售后问题，欢迎拨打65266268或1851823 -9266致电人工客服，我们竭诚为您服务！",
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
              })
            ],
          ),
        ));
  }

  _launchURL(BuildContext context) async {
    const url = 'tel:65266268';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showToast(context, "未能打开拨号页面");
    }
  }
}

class MineHead extends StatefulWidget {
  final double accountBalance;

  MineHead(this.accountBalance); //账户余额

  @override
  _MineHeadState createState() => _MineHeadState();
}

class _MineHeadState extends State<MineHead> {
  UserInfoData userInfo;

  @override
  void initState() {
    super.initState();
    //获取用户信息
    _getUserInfo();
  }

  _getUserInfo() {
    HttpManager.instance.get(context, Api.GET_USER_INFO, (json) {
      UserInfoModel infoModel = UserInfoModel.fromJson(json);
      if (infoModel != null &&
          infoModel.result?.isSuccess == true &&
          infoModel.data != null) {
        userInfo = infoModel.data;
        DataUtils.setUserHeadImg(infoModel.data.userAvatar);
        DataUtils.setCompanyName(infoModel.data.companyName);
      }
      _setUserInfo();
    }, errorCallback: (errorMsg) {
      _setUserInfo();
    });
  }

  _setUserInfo() async {
    String img = await DataUtils.getUserHeadImg();
    String companyName = await DataUtils.getCompanyName();
    userInfo = UserInfoData(img, "", 0, "", 0, companyName, 0, "", "");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/mine_bg.png"), fit: BoxFit.fill)),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().L(22),
                top: ScreenUtil().L(37),
                bottom: ScreenUtil().L(50)),
            child: Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: ScreenUtil().L(13)),
                    child: HeadImage(
                        headUrl: userInfo?.userAvatar,
                        callback: () {
                          _getUserInfo();
                        })),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        //TODO 跳转到个人信息页面
                      },
                      child: Padding(
                          padding: EdgeInsets.only(bottom: ScreenUtil().L(10)),
                          child: Text(
                              userInfo?.companyName != null
                                  ? userInfo?.companyName
                                  : "未知",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20))),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: ScreenUtil().L(20)),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().L(12),
                              vertical: ScreenUtil().L(3)),
                          decoration: BoxDecoration(
                              color: Color(0xFF464646),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().L(100)))),
                          child: Text("余额 ${widget.accountBalance} 元",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14)),
                        ),
                        GestureDetector(
                          onTap: () {
                            routePagerNavigator(
                                context, RechargePage(widget.accountBalance));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().L(6),
                                horizontal: ScreenUtil().L(21)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().L(15))),
                                gradient: LinearGradient(colors: [
                                  Color(0xFFECE936),
                                  Color(0xFFFFCB00)
                                ])),
                            child: Text("充值",
                                style: TextStyle(
                                    color: Color(0xFF212121),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(top: 0, right: 0, child: SettingIconButton())
        ],
      ),
    );
  }
}

class HeadImage extends StatefulWidget {
  String headUrl;
  Function callback;

  HeadImage({this.headUrl, this.callback});

  @override
  _HeadImageState createState() => _HeadImageState();
}

class _HeadImageState extends State<HeadImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeHead(context);
      },
      child: CommonImage(
          type: ImageType.net,
          url: (widget.headUrl == null || widget.headUrl.isEmpty)
              ? "images/headimg.png"
              : widget.headUrl,
          circle: true,
          width: ScreenUtil().L(80),
          height: ScreenUtil().L(80),
          fit: BoxFit.fill),
    );
  }

  void changeHead(BuildContext context) {
    ImagePicker.pickImages(maxImgCount: 1, canCrop: true).then((images) {
      if (images != null && images.length > 0) {
        String filePath = images[images.length - 1];
        _commitImg(filePath);
      }
    });
  }

  _commitImg(String imgPath) {
    File file = File(imgPath);
    String fileName = imgPath.replaceAll(file.parent.path + "/", "");
    FormData formData = new FormData.from({
      "file": new UploadFileInfo(file, fileName),
    });
    HttpManager().put(context, Api.CHANGE_HEAD, formData, (result) {
      BaseResp baseResp = BaseResp.fromJson(result);
      if (baseResp != null &&
          baseResp.result != null &&
          baseResp.result.isSuccess) {
        if (widget.callback != null) {
          widget.callback();
        }
      } else {
        ToastUtil.showToast(context, "头像修改失败");
      }
    }, onError: (error) {
      ToastUtil.showToast(context, "头像修改失败");
    });
  }
}

class SettingIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RawMaterialButton(
          //控件没有margin
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          padding: EdgeInsets.only(left: 13, right: 13, top: 19, bottom: 13),
          onPressed: () {
            routePagerNavigator(context, SettingPage());
          },
          child: Icon(Icons.settings, color: Colors.white, size: 26),
          constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
        ),
//        RawMaterialButton(
//          //控件没有margin
//          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//          splashColor: Colors.transparent,
//          highlightColor: Colors.transparent,
//          padding: EdgeInsets.all(13),
//          onPressed: () {
//            routePagerNavigator(context, MessageCenter()).then((value) {
//              //TODO 重置消息数量
//            });
//          },
//          child: Stack(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(right: 6, top: 6),
//                child: Image.asset("images/notice.png", color: Colors.white),
//              ),
//              Positioned(
//                  top: 0,
//                  right: 0,
//                  child: NumberTip(
//                    nums: 5,
//                  ))
//            ],
//          ),
//          constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
//        )
      ],
    );
  }
}
