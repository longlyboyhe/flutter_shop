import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/MyTracksModel.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/pages/want/WantSinglePage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 我的浏览
/// @author longlyboyhe
/// @date 2019/3/11
///
class MyTracksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyTracksPageState();
  }
}

class _MyTracksPageState extends State<MyTracksPage>
    implements BottomBarListener {
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  MyTracksModel model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    rootBundle.loadString("datas/mytracks.json").then((value) {
      setState(() {
        model = MyTracksModel.fromJson(jsonDecode(value));
        isLoading = false;
        if (model?.isNotEmpty == true) {
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
      backgroundColor: KColor.bgColor,
      appBar: CommonAppBar(
          context: context,
          title: KString.traceTitle,
          bottom: CommonAppBarBottomLine()),
      body: BaseContainer(
        isLoading: isLoading,
        showLoadError: isShowLoadError,
        showEmpty: isShowEmptyView,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemCount: model != null ? model.length : 0,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => MyTrackItem(
                model: model,
                index: index,
                itemModel: model.data[index],
                listener: this,
              ),
          separatorBuilder: (context, index) =>
              Divider(height: ScreenUtil().L(10), color: KColor.bgColor),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TrackBottom(
          listener: this,
          model: model,
        ),
      ),
    );
    // return new Image.asset("images/bg.jpeg");
  }

  @override
  void collect() {
    String selected = model.selected();
    if (selected.isEmpty) {
      ToastUtil.showToast(context, "请先选择需要收藏的数据");
    } else {
      ToastUtil.showToast(context, "收藏${selected}");
      //TODO 重新请求数据以刷新
    }
  }

  @override
  void delete() {
    String selected = model.selected();
    if (selected.isEmpty) {
      ToastUtil.showToast(context, "请先选择需要删除的数据");
    } else {
      ToastUtil.showToast(context, "删除${selected}");
      //TODO 重新请求数据以刷新
    }
  }

  @override
  void refresh() {
    ///刷新 如操作item后刷新通知底部栏
    setState(() {});
  }

  @override
  void selectAll() {
    setState(() {
      model.switchAllCheck();
    });
  }

  @override
  void addCart(MyTracksItemModel model) {
    ToastUtil.showToast(context, "加入进货单");
    //TODO 重新请求数据以刷新
  }

  @override
  void wantToBuy(MyTracksItemModel model) {
    showDialog(
        context: context,
        builder: (context) {
          return CommonDialog(
            message: '该商品已售罄，选择求购?',
            leftButtonText: '取消',
            rightButtonText: '确认求购',
            onLeftPress: () {
              Navigator.pop(context, false);
            },
            onRightPress: () {
              Navigator.pop(context, true);
              routePagerNavigator(context, WantSinglePage());
            },
          );
        });
  }
}

class MyTrackItem extends StatefulWidget {
  final MyTracksModel model;
  final int index;
  final BottomBarListener listener;
  MyTracksItemModel itemModel;

  MyTrackItem({this.model, this.index, this.listener, this.itemModel});

  @override
  _MyTrackItemState createState() => _MyTrackItemState();
}

class _MyTrackItemState extends State<MyTrackItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        routePagerNavigator(context, GoodsDetailsPage(1338576));
      },
      child: Slidable(
        actionExtentRatio: 0.2,
//        delegate: SlidableScrollDelegate(),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              right: ScreenUtil().L(15),
              top: ScreenUtil().L(20),
              bottom: ScreenUtil().L(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.itemModel.isSelected = !widget.itemModel.isSelected;
                    widget.listener.refresh();
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().L(15),
                      right: ScreenUtil().L(6),
                      top: ScreenUtil().L(15),
                      bottom: ScreenUtil().L(15)),
                  child: Icon(
                    widget.itemModel?.isSelected == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: widget.itemModel?.isSelected == true
                        ? Colors.black
                        : Color(0xFFBCBCBC),
                    size: ScreenUtil().L(15),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().L(9)),
                  child: Stack(
                    children: <Widget>[
                      Image.network(
                        StringUtils.getImageUrl(widget.itemModel.img),
                        width: ScreenUtil().L(70),
                        height: ScreenUtil().L(70),
                        fit: BoxFit.fill,
                      ),
                      Offstage(
                        offstage: !widget.itemModel.sellOut,
                        child: Container(
                          alignment: Alignment.center,
                          width: ScreenUtil().L(70),
                          height: ScreenUtil().L(70),
                          color: Colors.black.withOpacity(0.6),
                          child: Text("售罄",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400)),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(widget.itemModel.name,
                      style: TextStyle(
                          color: widget.itemModel.sellOut
                              ? Color(0xFF949494)
                              : Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 12)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(7)),
                    child: widget.itemModel.attrs != null &&
                            widget.itemModel.attrs.isNotEmpty
                        ? Text(widget.itemModel.attrs,
                            style: TextStyle(
                                color: Color(0xFF949494),
                                fontWeight: FontWeight.w300,
                                fontSize: 10))
                        : Container(),
                  ),
                  Row(
                    children: <Widget>[
                      Text("￥${widget.itemModel.price}",
                          style: TextStyle(
                              color: widget.itemModel.sellOut
                                  ? Color(0xFF949494)
                                  : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14)),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().L(10)),
                          child: Text("${widget.itemModel.originalSize}个货源",
                              style: TextStyle(
                                  color: Color(0xFF949494),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.itemModel?.sellOut == true) {
                            widget.listener.wantToBuy(widget.itemModel);
                          } else {
                            widget.listener.addCart(widget.itemModel);
                          }
                        },
                        child: Container(
                            width: ScreenUtil().L(70),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFF313131), width: 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().L(23)))),
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().L(8)),
                            child: Text(
                              widget.itemModel?.sellOut == true
                                  ? "求购"
                                  : "加入进货单",
                              style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            )),
                      )
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
        secondaryActions: <Widget>[
          SlideAction(
            color: Color(0xFFC10000),
            child: Text("删除",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10)),
            onTap: () {
              ToastUtil.showToast(context, "删除${widget.itemModel.name}");
            },
          )
        ],
      ),
    );
  }
}

class TrackBottom extends StatefulWidget {
  final BottomBarListener listener;
  final MyTracksModel model;

  TrackBottom({this.listener, this.model});

  @override
  _TrackBottomState createState() => _TrackBottomState();
}

class _TrackBottomState extends State<TrackBottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: ScreenUtil().L(65),
      ),
      padding: EdgeInsets.only(
        right: ScreenUtil().L(15),
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0xffE5E5E5), offset: Offset(0, -1), blurRadius: 5),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
              child: GestureDetector(
                  onTap: () {
                    widget.listener.selectAll();
                  },
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    padding: EdgeInsets.only(
                        left: ScreenUtil().L(15), right: ScreenUtil().L(5)),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          widget.model?.isAllchecked == true
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: widget.model?.isAllchecked == true
                              ? Colors.black
                              : Color(0xFFBCBCBC),
                          size: ScreenUtil().L(15),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ScreenUtil().L(5)),
                          child: Text(
                            KString.allSelectedTxt,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 10),
                          ),
                        )
                      ],
                    ),
                  ))),
          GestureDetector(
            onTap: () {
              widget.listener.delete();
            },
            child: Container(
              width: ScreenUtil().L(80),
              height: ScreenUtil().L(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFF313131), width: 1),
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenUtil().L(23)))),
              child: Text(
                "删除",
                style: TextStyle(
                    color: Color(0xFF333331),
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.listener.collect();
            },
            child: Container(
              width: ScreenUtil().L(80),
              height: ScreenUtil().L(30),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: ScreenUtil().L(10)),
              decoration: BoxDecoration(
                  color: Color(0xFFECE936),
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenUtil().L(23)))),
              child: Text(
                "收藏",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}

abstract class BottomBarListener {
  void selectAll();

  void collect();

  void delete();

  void addCart(MyTracksItemModel model);

  void wantToBuy(MyTracksItemModel model);

  void refresh();
}
