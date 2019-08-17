import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/MyTracksModel.dart';
import 'package:flutter_shop/pages/mine/MyTracks.dart';
import 'package:flutter_shop/pages/want/WantSinglePage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

class MyCollectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCollectionPageState();
  }
}

class _MyCollectionPageState extends State<MyCollectionPage>
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
        child: CollectBottom(
          listener: this,
          model: model,
        ),
      ),
    );
    // return new Image.asset("images/bg.jpeg");
  }

  @override
  void addCart(MyTracksItemModel model) {
    ToastUtil.showToast(context, "加入进货单");
    //TODO 重新请求数据以刷新
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

  @override
  void collect() {}
}

class CollectBottom extends StatefulWidget {
  final BottomBarListener listener;
  final MyTracksModel model;

  CollectBottom({this.listener, this.model});

  @override
  _CollectBottomState createState() => _CollectBottomState();
}

class _CollectBottomState extends State<CollectBottom> {
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
        ],
      ),
    );
  }
}
