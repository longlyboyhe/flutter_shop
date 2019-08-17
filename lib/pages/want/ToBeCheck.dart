//import 'dart:convert';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_easyrefresh/easy_refresh.dart';
//import 'package:flutter_shop/constants/index.dart';
//import 'package:flutter_shop/utils/StringUtils.dart';
//import 'package:flutter_shop/utils/screen_util.dart';
//import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';
//import 'dart:math' as math;
//
/////
///// 待审核
///// @author longlyboyhe
///// @date 2019/3/21
/////
//class ToBeCheck extends StatefulWidget {
//  @override
//  _ToBeCheckState createState() => _ToBeCheckState();
//}
//
//class _ToBeCheckState extends State<ToBeCheck> {
//  GlobalKey<EasyRefreshState> _easyRefreshKey =
//      new GlobalKey<EasyRefreshState>();
//  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
//  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
//  GlobalKey<RefreshFooterState> _connectorFooterKey =
//      GlobalKey<RefreshFooterState>();
//  GlobalKey<RefreshHeaderState> _connectorHeaderKey =
//      GlobalKey<RefreshHeaderState>();
//  bool isLoading = true; //进入加载
//  bool isShowEmptyView = false; //显示空页面
//  bool isShowLoadError = false; //显示重新加载
//  MyWantModel model;
//
//  @override
//  void initState() {
//    super.initState();
//    loadData();
//  }
//
//  void loadData() async {
//    rootBundle.loadString("datas/my_want.json").then((value) {
//      setState(() {
//        model = MyWantModel.fromJson(jsonDecode(value));
//        isLoading = false;
//        if (model?.isNotEmpty == true) {
//          isShowEmptyView = false;
//        } else {
//          isShowEmptyView = true;
//        }
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Widget footview = CustomBallPulseFooter(
//      key: _footerKey,
//      size: 20,
//    );
//    Widget headerView = ClassicsHeader(
//      key: _headerKey,
//      refreshText: "下拉刷新",
//      refreshReadyText: "释放刷新",
//      refreshingText: "正在刷新...",
//      refreshedText: "刷新完成",
//      moreInfo: "",
//      bgColor: KColor.bgColor,
//      textColor: Colors.black,
//    );
//    int itemCount = model != null ? model.length : 0;
//    return EasyRefresh(
//        onRefresh: () {
//          //TODO 下拉刷新
//          _easyRefreshKey.currentState.callRefreshFinish();
//        },
//        loadMore: () {
//          //TODO 上拉加载
//          _easyRefreshKey.currentState.callLoadMoreFinish();
//        },
//        key: _easyRefreshKey,
//        refreshHeader: ConnectorHeader(
//          key: _connectorHeaderKey,
//          header: headerView,
//        ),
//        refreshFooter: ConnectorFooter(
//          key: _connectorFooterKey,
//          footer: footview,
//        ),
//        child: CustomScrollView(
//          physics: BouncingScrollPhysics(),
//          slivers: <Widget>[
//            SliverList(delegate: SliverChildListDelegate(<Widget>[headerView])),
//            SliverList(
//              delegate: SliverChildBuilderDelegate(
//                  (BuildContext context, int index) {
//                    final int itemIndex = index ~/ 2;
//                    Widget widget;
//                    if (index.isOdd) {
//                      widget = ToBeCheckItem(
//                        model: model.data[itemIndex],
//                      );
//                    } else {
//                      widget = Container(
//                        color: KColor.bgColor,
//                        height: ScreenUtil().L(10),
//                      );
//                      assert(() {
//                        if (widget == null) {
//                          throw FlutterError(
//                              'separatorBuilder cannot return null.');
//                        }
//                        return true;
//                      }());
//                    }
//                    return widget;
//                  },
//                  childCount: math.max(0, itemCount * 2),
//                  semanticIndexCallback: (Widget _, int index) {
//                    return index.isOdd ? index ~/ 2 : null;
//                  }),
//            ),
//            SliverList(delegate: SliverChildListDelegate(<Widget>[footview]))
//          ],
//        ));
//  }
//}
//
//class ToBeCheckItem extends StatefulWidget {
//  final MyWantModelItemModel model;
//
//  ToBeCheckItem({this.model});
//
//  @override
//  _ToBeCheckItemState createState() => _ToBeCheckItemState();
//}
//
//class _ToBeCheckItemState extends State<ToBeCheckItem> {
//  Widget _rowText(String leftText, String rightText) {
//    return Row(
//      children: <Widget>[
//        Text(
//          leftText,
//          style: TextStyle(
//              color: Color(0xFF949494),
//              fontWeight: FontWeight.w300,
//              fontSize: 12),
//        ),
//        Padding(
//          padding: EdgeInsets.only(left: ScreenUtil().L(8)),
//          child: Text(
//            rightText,
//            style: TextStyle(
//                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
//          ),
//        )
//      ],
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Widget _attr = Container();
//    List<Widget> _attrs = List();
//    if (widget.model.attrs != null && widget.model.attrs.length > 0) {
//      _attrs.add(Padding(
//        padding: EdgeInsets.only(
//            left: ScreenUtil().L(20), right: ScreenUtil().L(24)),
//        child: Text(
//          "规格",
//          style: TextStyle(
//              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
//        ),
//      ));
//      _attrs.add(Container(
//        margin: EdgeInsets.only(right: ScreenUtil().L(6)),
//        width: 1,
//        height: ScreenUtil().L(33),
//        color: KColor.bgColor,
//      ));
//      for (AttrsModel value in widget.model.attrs) {
//        _attrs.add(Padding(
//          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().L(9)),
//          child: _rowText(value.name, value.value),
//        ));
//      }
//      _attr = Column(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(8)),
//            child: Row(
//              children: _attrs,
//            ),
//          ),
//          Container(
//            color: KColor.bgColor,
//            height: 1,
//          )
//        ],
//      );
//    }
//
//    return Container(
//      padding: EdgeInsets.all(ScreenUtil().L(15)),
//      child: Column(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Expanded(
//                  child: Text(
//                "2019年3月18日",
//                style: TextStyle(
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold,
//                    fontSize: 10),
//              )),
//              Text(
//                "待审核",
//                style: TextStyle(
//                    color: Color(0xFFDAD710),
//                    fontWeight: FontWeight.bold,
//                    fontSize: 12),
//              )
//            ],
//          ),
//          Container(
//            margin: EdgeInsets.only(
//                top: ScreenUtil().L(19), bottom: ScreenUtil().L(10)),
//            color: KColor.bgColor,
//            height: 1,
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(right: ScreenUtil().L(9)),
//                child: Image.network(
//                  StringUtils.getImageUrl(widget.model.img),
//                  height: ScreenUtil().L(70),
//                  width: ScreenUtil().L(70),
//                ),
//              ),
//              Expanded(
//                  child: Column(
//                children: <Widget>[
//                  _rowText("货号", "88888888888"),
//                  Padding(
//                    padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(6)),
//                    child: Row(
//                      children: <Widget>[
//                        _rowText("品牌", "Dior"),
//                        Padding(
//                          padding: EdgeInsets.only(left: ScreenUtil().L(30)),
//                          child: _rowText("分类", "美妆"),
//                        ),
//                      ],
//                    ),
//                  ),
//                  Row(
//                    children: <Widget>[
//                      _rowText("调货时限", "3天"),
//                      Padding(
//                        padding: EdgeInsets.only(left: ScreenUtil().L(30)),
//                        child: _rowText("单品报价", "¥960"),
//                      ),
//                    ],
//                  ),
//                ],
//              )),
//            ],
//          ),
//          Container(
//            margin: EdgeInsets.only(top: ScreenUtil().L(10)),
//            height: 1,
//            color: KColor.bgColor,
//          ),
//          _attr,
//          Align(
//            alignment: Alignment.centerRight,
//            child: Container(
//              margin: EdgeInsets.only(top: ScreenUtil().L(10)),
//              padding: EdgeInsets.symmetric(
//                  vertical: ScreenUtil().L(6), horizontal: ScreenUtil().L(11)),
//              decoration: BoxDecoration(
//                  color: Colors.white,
//                  border: Border.all(color: Color(0xFF313131), width: 1),
//                  borderRadius:
//                      BorderRadius.all(Radius.circular(ScreenUtil().L(23)))),
//              child: Text(
//                "取消求购",
//                style: TextStyle(
//                    color: Color(0xFF313131),
//                    fontSize: 12,
//                    fontWeight: FontWeight.bold),
//              ),
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}
