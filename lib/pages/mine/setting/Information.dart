import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/natives/image_picker.dart';
import 'package:flutter_shop/pages/mine/setting/ChangeBindPhone.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/Image.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 个人中心
/// @author longlyboyhe
/// @date 2019/3/7
///
class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KColor.mineBgColor,
        appBar: CommonAppBar(
            context: context,
            title: KString.infomation,
            bottom: CommonAppBarBottomLine()),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          InformationItem(
              height: ScreenUtil().L(65),
              type: Type.head,
              isHead: true,
              isArrow: true,
              havaMargin: true),
          InformationItem(
              type: Type.name, title: "品上商城", subTitle: "修改", isArrow: false),
          InformationItem(
              type: Type.phone,
              title: "绑定手机号",
              subTitle: "151********",
              isArrow: true,
              havaMargin: true),
          InformationItem(
              type: Type.email,
              title: "电子邮箱",
              subTitle: "yun******@123.com",
              isArrow: true),
        ])));
  }
}

enum Type { head, name, phone, email }

class InformationItem extends StatefulWidget {
  final bool havaMargin;
  final String title;
  final String subTitle;
  final bool isArrow;
  final bool isHead;
  final double height;
  final Type type;

  InformationItem(
      {this.havaMargin,
      this.title,
      this.subTitle,
      this.isArrow,
      this.isHead,
      this.height = 45,
      @required this.type});

  @override
  _InformationItemState createState() => _InformationItemState();
}

class _InformationItemState extends State<InformationItem> {
  ImageType imageType = ImageType.icon;
  File head;

  @override
  Widget build(BuildContext context) {
    List<Widget> _row = List();
    if (widget.type == Type.head) {
      _row.add(
        CommonImage(
            type: imageType,
            url: "images/headimg.png",
            fileHead: head,
            circle: true,
            width: ScreenUtil().L(50),
            height: ScreenUtil().L(50),
            fit: BoxFit.fill),
      );
      _row.add(Expanded(child: Container()));
    } else {
      _row.add(Expanded(
          child: Text(widget.title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12))));
    }
    if (widget.subTitle != null && widget.subTitle.isNotEmpty) {
      _row.add(Text(widget.subTitle,
          style: TextStyle(
              color: Color(0xFFACACAC),
              fontWeight: FontWeight.w400,
              fontSize: 12)));
    }
    if (widget.isArrow) {
      _row.add(Padding(
          padding: EdgeInsets.only(left: ScreenUtil().L(5)),
          child: Icon(Icons.arrow_forward_ios,
              size: ScreenUtil().L(10), color: Color(0xFFACACAC))));
    }
    return GestureDetector(
      onTap: () {
        if (widget.type == Type.head) {
          changeHead(context);
        } else if (widget.type == Type.name) {
          changeName(context);
        } else if (widget.type == Type.phone) {
          changePhone(context);
        } else if (widget.type == Type.email) {
          changeEmail(context);
        }
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().L(10)))),
        padding: EdgeInsets.only(
            left: ScreenUtil().L(20), right: ScreenUtil().L(10)),
        margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().L(15),
            vertical: widget.havaMargin != null && widget.havaMargin
                ? ScreenUtil().L(10)
                : 0),
        child: Row(
          children: _row,
        ),
      ),
    );
  }

  void changeHead(BuildContext context) {
    ImagePicker.pickImages(maxImgCount: 1, canCrop: true).then((images) {
      if (images != null && images.length > 0) {
        setState(() {
          print("回来了回来了${images.length}  ${images[0]}");
          String filePath = images[images.length - 1];
          imageType = ImageType.file;
          head = File(filePath);
        });
      }
    });
  }

  void changeName(BuildContext context) {
    ToastUtil.showToast(context, "修改名称");
  }

  void changePhone(BuildContext context) {
    ToastUtil.showToast(context, "修改手机号");
    routePagerNavigator(context, ChangeBindPhone());
  }

  void changeEmail(BuildContext context) {
    ToastUtil.showToast(context, "修改邮箱");
  }
}
