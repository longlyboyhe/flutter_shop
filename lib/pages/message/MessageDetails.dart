import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/MessageDetailModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/MaxLineLimitText.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 最新消息列表/系统消息列表/求购消息列表
/// @author longlyboyhe
/// @date 2019/3/13
///
class MessageDetails extends StatefulWidget {
  final int type;

  MessageDetails(this.type);

  @override
  _MessageDetailsState createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  MessageDetailModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    rootBundle.loadString("datas/message_details.json").then((value) {
      setState(() {
        model = MessageDetailModel.fromJson(jsonDecode(value));
        isLoading = false;
      });
    });
  }

  Widget _item(int index) {
    if (model != null && model.data != null) {
      if (widget.type == 0) {
        return PreferMessageItem(model.data[index]);
      } else {
        return MessageItem(model.data[index]);
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: CommonAppBar(
          context: context, title: KString.messageDetailTitles[widget.type]),
      body: BaseContainer(
        isLoading: isLoading,
        showEmpty: isShowEmptyView,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(ScreenUtil().L(10)),
          itemCount: model != null ? model.length : 0,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => _item(index),
        ),
      ),
    );
  }
}

///优惠消息item
class PreferMessageItem extends StatelessWidget {
  final MessageDetailItemModel model;

  PreferMessageItem(this.model);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ToastUtil.showToast(context, "${model.title} 跳转到活动页面");
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
        margin: EdgeInsets.only(bottom: ScreenUtil().L(10)),
        padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(17)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().L(6)),
              child: Text(model.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(model.time,
                        style: TextStyle(
                            color: Color(0xFFD1D1D1),
                            fontWeight: FontWeight.bold,
                            fontSize: 12))),
                Icon(Icons.arrow_forward_ios,
                    size: ScreenUtil().L(10), color: Colors.black)
              ],
            )
          ],
        ),
      ),
    );
  }
}

///系统消息/求购消息item
class MessageItem extends StatefulWidget {
  final MessageDetailItemModel model;

  MessageItem(this.model);

  @override
  _MessageItemState createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  int _maxLines = 2;
  TextOverflow overflow = TextOverflow.ellipsis;

  ///是否显示打开查看更多按钮
  bool hideOpenButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
      margin: EdgeInsets.only(bottom: ScreenUtil().L(10)),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(17)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: ScreenUtil().L(5)),
              child: Text(widget.model.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14))),
          Offstage(
            offstage:
                widget.model.detail == null || widget.model.detail.isEmpty,
            child: Padding(
                padding: EdgeInsets.only(bottom: ScreenUtil().L(5)),
                child: MaxLineLimitText(
                  widget.model.detail,
                  softWrap: true,
                  maxLines: _maxLines,
                  overflow: overflow,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 10),
                  onFit: (fit) {
                    setState(() {
                      if (fit == true) {
                        hideOpenButton = false;
                      } else {
                        hideOpenButton = true;
                      }
                    });
                  },
                )),
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(widget.model.time,
                      style: TextStyle(
                          color: Color(0xFFD1D1D1),
                          fontWeight: FontWeight.bold,
                          fontSize: 12))),
              Offstage(
                offstage: hideOpenButton,
                child: OpenButton((open) {
                  setState(() {
                    if (open) {
                      _maxLines = null;
                      overflow = null;
                    } else {
                      _maxLines = 2;
                      overflow = TextOverflow.ellipsis;
                    }
                  });
                }),
              )
            ],
          )
        ],
      ),
    );
  }
}

///打开查看更多
class OpenButton extends StatefulWidget {
  final ValueChanged<bool> open;
  final String openTitle;
  final String closeTitle;
  bool initOpen; //开关状态

  OpenButton(this.open,
      {this.openTitle = "打开查看更多",
      this.closeTitle = "收起",
      this.initOpen = false});

  @override
  _OpenButtonState createState() => _OpenButtonState();
}

class _OpenButtonState extends State<OpenButton> {
  bool open = false;

  @override
  void initState() {
    super.initState();
    open = widget.initOpen;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          open = !open;
          if (widget.open != null) widget.open(open);
        });
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().L(5)),
            child: Text(open ? widget.closeTitle : widget.openTitle,
                style: TextStyle(
                    color: Color(0xFFD1D1D1),
                    fontWeight: FontWeight.bold,
                    fontSize: 10)),
          ),
          Icon(open ? Icons.expand_less : Icons.expand_more,
              size: ScreenUtil().L(15), color: Colors.black)
        ],
      ),
    );
  }
}
