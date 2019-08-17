import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/my_want_model.dart';
import 'package:flutter_shop/pages/message/MessageDetails.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';

///
/// 我的求购
/// @author longlyboyhe
/// @date 2019/3/22
///
class MyWantToBuy extends StatefulWidget {
  @override
  _MyWantToBuyState createState() => _MyWantToBuyState();
}

class _MyWantToBuyState extends State<MyWantToBuy> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey =
      GlobalKey<RefreshHeaderState>();
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  int page = 1;
  bool noMoreData = false; //数据加载完毕
  List<GoodData> goodList = List();
  static final int page_size = 10;

  @override
  void initState() {
    super.initState();
    loadData(1);
  }

  void loadData(int page) async {
    //加载联系人列表
    Map<String, String> params = {
      'page_size': "$page_size",
      "page_no": "$page"
    };
    HttpManager.instance.get(
        context,
        Api.BUYOFFER,
        (json) {
          _easyRefreshKey?.currentState?.callRefreshFinish();
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          MyWantModel model = MyWantModel.fromJson(json);
          if (model.result != null &&
              model.result.isSuccess != null &&
              model.result.isSuccess == true) {
            if (page == 1) {
              goodList.clear();
            }
            if (model != null &&
                model.data != null &&
                model.data.totalPage != null &&
                model.data.pageNo != null &&
                model.data.totalPage < page) {
              //最后一页
              setState(() {
                noMoreData = true;
              });
            } else {
              if (model != null &&
                  model.data != null &&
                  model.data.data != null &&
                  model.data.data.length > 0) {
                setState(() {
                  goodList.addAll(model.data.data);
                  noMoreData = false;
                  isLoading = false;
                  isShowEmptyView = false;
                  isShowLoadError = false;
                });
              } else {
                noMoreData = true;
                if (page == 1) {
                  setState(() {
                    isLoading = false;
                    isShowEmptyView = true;
                    isShowLoadError = false;
                  });
                }
              }
            }
          } else {
            if (page == 1) {
              setState(() {
                isLoading = false;
                isShowEmptyView = true;
                isShowLoadError = false;
              });
            } else {
              page--;
            }
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          _easyRefreshKey?.currentState?.callRefreshFinish();
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          if (page == 1) {
            setState(() {
              isLoading = false;
              isShowEmptyView = false;
              isShowLoadError = true;
            });
          } else {
            page--;
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget footview = CustomBallPulseFooter(
      key: _footerKey,
      size: 20,
    );
    Widget headerView = ClassicsHeader(
      key: _headerKey,
      refreshText: "下拉刷新",
      refreshReadyText: "释放刷新",
      refreshingText: "正在刷新...",
      refreshedText: "刷新完成",
      moreInfo: "",
      bgColor: KColor.bgColor,
      textColor: Colors.black,
    );
    return Expanded(
        child: Container(
      color: Colors.white,
      child: BaseContainer(
        isLoading: isLoading,
        showEmpty: isShowEmptyView,
        showLoadError: isShowLoadError,
        reLoad: () {
          if (page == 1) loadData(1);
        },
        child: EasyRefresh(
            onRefresh: () {
              page = 1;
              loadData(1);
            },
            loadMore: () {
              if (!noMoreData) loadData(++page);
            },
            key: _easyRefreshKey,
            refreshHeader: ConnectorHeader(
              key: _connectorHeaderKey,
              header: headerView,
            ),
            refreshFooter: ConnectorFooter(
              key: _connectorFooterKey,
              footer: footview,
            ),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[headerView])),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final int itemIndex = index ~/ 2;
                        Widget widget;
                        if (index.isOdd) {
                          widget = MyWantItem(
                            model: goodList[itemIndex],
                          );
                        } else {
                          widget = Container(
                            color: KColor.bgColor,
                            height: ScreenUtil().L(10),
                          );
                          assert(() {
                            if (widget == null) {
                              throw FlutterError(
                                  'separatorBuilder cannot return null.');
                            }
                            return true;
                          }());
                        }
                        return widget;
                      },
                      childCount: math.max(0, goodList.length * 2),
                      semanticIndexCallback: (Widget _, int index) {
                        return index.isOdd ? index ~/ 2 : null;
                      }),
                ),
                SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                  goodList != null && goodList.length >= page_size
                      ? noMoreData ? CommonEndLine() : footview
                      : Container()
                ]))
              ],
            )),
      ),
    ));
  }
}

class RowText extends StatelessWidget {
  final String leftText;
  final String rightText;

  RowText(this.leftText, this.rightText);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          leftText != null && leftText != "null" ? leftText : "",
          style: TextStyle(
              color: Color(0xFF949494),
              fontWeight: FontWeight.w300,
              fontSize: 12),
        ),
        Padding(
          padding: EdgeInsets.only(left: ScreenUtil().L(8)),
          child: Text(
            rightText != null && rightText != "null" ? rightText : "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        )
      ],
    );
  }
}

class MyWantItem extends StatefulWidget {
  final GoodData model;

  MyWantItem({this.model});

  @override
  _MyWantItemState createState() => _MyWantItemState();
}

class _MyWantItemState extends State<MyWantItem> {
  int length;
  bool initOpen = false;
  List<List<Props>> attrs = List();

  @override
  void initState() {
    super.initState();
    length = widget.model.goodsInfo != null && widget.model.goodsInfo.length > 0
        ? 1
        : 0;
    if (length > 0) {
      for (var value in widget.model.goodsInfo) {
        attrs.add(value.props);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(ScreenUtil().L(15)),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: ScreenUtil().L(9)),
                child: FadeInImage(
                  placeholder: AssetImage("images/default_good_image.png"),
                  image: NetworkImage(StringUtils.getImageUrl(
                      widget.model.pics != null ? widget.model.pics[0] : "")),
                  width: ScreenUtil().L(70),
                  height: ScreenUtil().L(70),
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RowText("品牌", widget.model.goodsInfo[0].brandName),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(5)),
                    child:
                        RowText("分类", widget.model.goodsInfo[0].categoryName),
                  ),
                  Row(
                    children: <Widget>[
                      RowText(
                          "调货时限",
                          widget.model.buyofferRequirements.expireDay
                              .toString()),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().L(30)),
                        child: RowText(
                            "单品报价", widget.model.goodsInfo[0].price.toString()),
                      ),
                    ],
                  )
                ],
              )),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().L(10)),
            height: 1,
            color: KColor.bgColor,
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                left: ScreenUtil().L(15), right: ScreenUtil().L(13)),
            itemCount: length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => MyWantAttrItem(
                    initOpen,
                    attrs[index],
                    widget.model.goodsInfo != null &&
                            widget.model.goodsInfo.length >= 2 &&
                            index == length - 1
                        ? true
                        : false, (open) {
                  setState(() {
                    length = open ? widget.model.goodsInfo.length : 1;
                    initOpen = open;
                  });
                }),
            separatorBuilder: (context, index) =>
                Container(height: 1, color: KColor.bgColor),
          )
        ],
      ),
    );
  }
}

class MyWantAttrItem extends StatefulWidget {
  final bool initOpen;
  final List<Props> attrs;
  final bool isLast; //是否是两条以上的最后一条
  final ValueChanged<bool> isOpen;

  MyWantAttrItem(this.initOpen, this.attrs, this.isLast, this.isOpen);

  @override
  _MyWantAttrItemState createState() => _MyWantAttrItemState();
}

class _MyWantAttrItemState extends State<MyWantAttrItem> {
  Widget _openButton() {
    return OpenButton(
      (open) {
        if (widget.isOpen != null) widget.isOpen(open);
      },
      openTitle: "更多",
      closeTitle: "收起",
      initOpen: widget.initOpen,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _attrs = List();
    _attrs.add(Padding(
      padding:
          EdgeInsets.only(left: ScreenUtil().L(20), right: ScreenUtil().L(24)),
      child: Text(
        "规格",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
      ),
    ));
    _attrs.add(Container(
      margin: EdgeInsets.only(right: ScreenUtil().L(6)),
      width: 1,
      height: ScreenUtil().L(33),
      color: KColor.bgColor,
    ));
    for (Props value in widget.attrs) {
      _attrs.add(Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().L(9)),
        child: RowText(value.propName, value.propValue),
      ));
    }
    if (widget.isLast) {
      _attrs.add(Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_openButton()],
      )));
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(8)),
      child: Row(
        children: _attrs,
      ),
    );
  }
}
