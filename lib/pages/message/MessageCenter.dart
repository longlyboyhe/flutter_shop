import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/MessageModel.dart';
import 'package:flutter_shop/pages/message/MessageDetails.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/NumberTip.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 消息中心
/// @author longlyboyhe
/// @date 2019/2/26
///
class MessageCenter extends StatefulWidget {
  @override
  _MessageCenterState createState() => _MessageCenterState();
}

class _MessageCenterState extends State<MessageCenter> {
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  MessageModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    rootBundle.loadString("datas/message.json").then((value) {
      setState(() {
        model = MessageModel.fromJson(jsonDecode(value));
        isLoading = false;
        if (model?.length > 0) {
          isShowEmptyView = false;
        } else {
          isShowEmptyView = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: "消息中心"),
      body: BaseContainer(
        isLoading: isLoading,
        showEmpty: isShowEmptyView,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.only(
              left: ScreenUtil().L(15), right: ScreenUtil().L(13)),
          itemCount: model != null ? model.length : 0,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => MessageItem(
                model.data[index],
                onTap: () {
                  routePagerNavigator(
                      context, MessageDetails(model.data[index].type));
                },
              ),
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: KColor.bgColor),
        ),
      ),
    );
  }
}

class MessageItem extends StatefulWidget {
  MessageItemModel itemModel;
  VoidCallback onTap;

  MessageItem(this.itemModel, {this.onTap});

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child: Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().L(13), bottom: ScreenUtil().L(13)),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                    backgroundColor: Color(0xFF909090),
                    radius: ScreenUtil().L(22),
                    child: Image.asset(widget.itemModel.icon,
                        fit: BoxFit.contain, color: Colors.white)),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().L(14)),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(widget.itemModel.title,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14))),
                                Text(widget.itemModel.time,
                                    style: TextStyle(
                                        color: Color(0xFFD1D1D1),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: ScreenUtil().L(4)),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      widget.itemModel.subTitle,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                    NumberTip(
                                      alwaysShow:
                                          widget.itemModel.news != null &&
                                              widget.itemModel.news > 0,
                                      radius: 4,
                                      margin: EdgeInsets.only(
                                          left: ScreenUtil().L(14)),
                                    )
                                  ],
                                ))
                          ],
                        )))
              ],
            )));
  }
}
