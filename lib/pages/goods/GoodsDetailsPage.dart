import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/good_detail_model.dart';
import 'package:flutter_shop/model/search_result_model.dart';
import 'package:flutter_shop/model/settlement_center.dart';
import 'package:flutter_shop/pages/accountcenter/SettlementCenter.dart';
import 'package:flutter_shop/pages/cart/CartSinglePage.dart';
import 'package:flutter_shop/pages/goods/SharePage.dart';
import 'package:flutter_shop/pages/message/MessageCenter.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/NumberTip.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/good/SizeSelector.dart';
import 'package:flutter_shop/widgets/home/GoodsItem.dart';

///
/// TODO 点击查看大图
/// 商品详情页
/// @author longlyboyhe
/// @date 2019/1/25
///
class GoodsDetailsPage extends StatefulWidget {
  final int spuId;

  GoodsDetailsPage(this.spuId);

  @override
  State<StatefulWidget> createState() {
    return GoodsDetailsPageState();
  }
}

class GoodsDetailsPageState extends State<GoodsDetailsPage> {
  ScrollController _scrollController;
  bool isCollected = false; //是否已经收藏
  int goodsSize = 0; //下单商品数量

  int page = 1;
  bool noMoreData = false; //数据加载完毕
  List<GoodData> recommendList = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();

  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  //货源位置，加入进货单的时候如果没有选择货源时列表滚动到货源位置
  double supplysHeight = 0;
  GlobalKey _swiperKey = GlobalKey();
  GlobalKey _deadLineKey = GlobalKey();
  GlobalKey _priceKey = GlobalKey();
  GlobalKey _goodsDescKey = GlobalKey();
  GlobalKey _selectColorKey = GlobalKey();
  GlobalKey _selectSizeKey = GlobalKey();

  GoodDetailModel model;
  List<String> productImgs = List();

  //点击选择的尺寸
  Spec_values selectColor;
  Spec_values selectedSize;
  List<Inventory_list> selectedSupplys = List();
  List<String> spe_path = List(); //供应商spe_path集合，用于判断是否可选

  void loadData() async {
    Map<String, String> params = {'spu_id': "${widget.spuId}"}; //1306131
    rootBundle.loadString("datas/goodsdetail.json").then((json) {
      model = GoodDetailModel.fromJson(jsonDecode(json));
      if (model != null && model.data != null) {
        setState(() {
          isLoading = false;
          isShowLoadError = false;
          isShowEmptyView = false;

          if (model.data.imageUrls != null &&
              model.data.imageUrls.length > 0) {
              model.data.imageUrls.forEach((k, v) {
              productImgs.add(v);
            });
          }
          if (model.data.skuPath != null && model.data.skuPath.length > 0) {
            for (var value in model.data?.skuPath) {
              spe_path.add(value.spePath);
            }
          }
          if (model.data.specs != null && model.data.specs.length > 0) {
            selectColor = model.data.specs[0].specValues[0];
            //TODO 默认选择第一个颜色之后尺码列表是否可选（不可选跳求购）
            String path = "${model.data.specs[0].id}:${selectColor.vid}";
            if (model.data.specs.length > 1) {
              path = path +
                  ";${model.data.specs[1].id}:${model.data.specs[1].specValues[0].vid}";
              if (spe_path.contains(path)) {
                selectedSize = model.data.specs[1].specValues[0];
              }
            }
            _getSuppier();
          }
        });
        WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
        getCommend(1);
      } else {
        setState(() {
          isLoading = false;
          isShowLoadError = false;
          isShowEmptyView = true;
        });
      }
    });
//    HttpManager.instance.get(
//        context,
//        Api.GOOD_DETAIL,
//        (json) {
//          model = GoodDetailModel.fromJson(json);
//          if (model != null && model.data != null) {
//            setState(() {
//              isLoading = false;
//              isShowLoadError = false;
//              isShowEmptyView = false;
//
//              if (model.data.imageUrls != null &&
//                  model.data.imageUrls.length > 0) {
//                model.data.imageUrls.forEach((k, v) {
//                  productImgs.add(v);
//                });
//              }
//              if (model.data.skuPath != null && model.data.skuPath.length > 0) {
//                for (var value in model.data?.skuPath) {
//                  spe_path.add(value.spePath);
//                }
//              }
//              if (model.data.specs != null && model.data.specs.length > 0) {
//                selectColor = model.data.specs[0].specValues[0];
//                //TODO 默认选择第一个颜色之后尺码列表是否可选（不可选跳求购）
//                String path = "${model.data.specs[0].id}:${selectColor.vid}";
//                if (model.data.specs.length > 1) {
//                  path = path +
//                      ";${model.data.specs[1].id}:${model.data.specs[1].specValues[0].vid}";
//                  if (spe_path.contains(path)) {
//                    selectedSize = model.data.specs[1].specValues[0];
//                  }
//                }
//                _getSuppier();
//              }
//            });
//            WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
//            getCommend(1);
//          } else {
//            setState(() {
//              isLoading = false;
//              isShowLoadError = false;
//              isShowEmptyView = true;
//            });
//          }
//        },
//        params: params,
//        errorCallback: (errorMsg) {
//          setState(() {
//            isLoading = false;
//            isShowLoadError = true;
//            isShowEmptyView = false;
//          });
//        });
  }

  void getCommend(int page) async {
    if (model != null && model.data != null) {
      if (noMoreData) return;
      rootBundle.loadString("datas/recommends.json").then((json) {
        _easyRefreshKey?.currentState?.callLoadMoreFinish();
        SearchResultModel searchResultModel =
        SearchResultModel.fromJson(jsonDecode(json));
        if (model.result != null &&
            model.result.isSuccess != null &&
            model.result.isSuccess == true) {
          if (page == 1) {
            recommendList.clear();
          }
          if (searchResultModel != null &&
              searchResultModel.data != null &&
              searchResultModel.data.totalPage != null &&
              searchResultModel.data.pageNo != null &&
              searchResultModel.data.totalPage < page) {
            setState(() {
              noMoreData = true;
            });
          } else {
            if (searchResultModel != null &&
                searchResultModel.data.data != null &&
                searchResultModel.data.data.length > 0) {
              setState(() {
                recommendList.addAll(searchResultModel.data.data);
                noMoreData = false;
              });
            } else {
              noMoreData = true;
            }
          }
        } else {
          if (page > 1) page--;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  void _onAfterRendering(Duration timeStamp) {
    supplysHeight = getHeight(_swiperKey) +
        getHeight(_deadLineKey) +
        ScreenUtil().L(40) +
        getHeight(_priceKey) +
        getHeight(_goodsDescKey) +
        getHeight(_selectColorKey) +
        getHeight(_selectSizeKey);
    print("_swiperKey=${getHeight(_swiperKey)} "
        " _deadLineKey=${getHeight(_deadLineKey)} "
        " _priceKey=${getHeight(_priceKey)} "
        " _goodsDescKey=${getHeight(_goodsDescKey)} "
        " _selectColorKey=${getHeight(_selectColorKey)} "
        " _selectSizeKey=${getHeight(_selectSizeKey)} "
        " supplysHeight=$supplysHeight");
  }

  double getHeight(GlobalKey key) {
    if (key.currentContext != null) {
      return key.currentContext.size.height;
    } else {
      return 0;
    }
  }

  @override
  void didUpdateWidget(GoodsDetailsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  } //  @override

  Widget _price() {
    return Row(
      key: _priceKey,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
                right: ScreenUtil().L(5), bottom: ScreenUtil().L(4)),
            child: Text(
              "￥",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.w500),
            )),
        Text(
          model != null && model.data != null && model.data.price != null
              ? "${model?.data?.price}"
              : "0",
          style: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(25),
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _goodsDesc() {
    return Padding(
      key: _goodsDescKey,
      padding: EdgeInsets.only(
          left: ScreenUtil().L(54),
          right: ScreenUtil().L(54),
          bottom: ScreenUtil().L(33),
          top: ScreenUtil().L(6)),
      child: Text(
        model != null && model.data != null && model.data.name != null
            ? model?.data?.name
            : "",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(15)),
      ),
    );
  }

  Widget _selectTitle(String title, String subTitle, bool isSize) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().L(15),
          right: ScreenUtil().L(14),
          bottom: ScreenUtil().L(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().L(10)),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(14)),
            ),
          ),
          Expanded(
              child: Text(
            subTitle,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: ScreenUtil().setSp(11)),
          )),
          isSize
              ? GestureDetector(
                  onTap: () {
                    ToastUtil.showToast(context, "尺码对照表");
                  },
                  child: Text(
                    "尺码对照表",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: ScreenUtil().setSp(11),
                        decoration: TextDecoration.underline),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

//  Widget _selectColor() {
//    return Column(
//      key: _selectColorKey,
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        SelectTitle(model.data.specs[0].name, selectColor, false),
//        ColorSelector(
//          goods: model.data.specs[0].specValues,
//          margin: EdgeInsets.only(left: 54, top: 11, bottom: 33),
//          onTap: (item) {
//            //TODO 选择的颜色
//            setState(() {
//              ToastUtil.showBottomToast(context, "选择了${item.name}");
//              selectColor = item.name;
//            });
//          },
//        )
////        Container(
////            width: 40,
////            height: 40,
////            margin: EdgeInsets.only(left: 54, top: 11, bottom: 33),
////            decoration: BoxDecoration(
////              shape: BoxShape.circle,
////              image: DecorationImage(
////                  image: NetworkImage(
////                      Api.BASE_IMG + "/upload/img/brand/1542100581739.jpg"),
////                  fit: BoxFit.contain),
////              border: Border.all(
////                color: KColor.yellowColor,
////                width: 1.0,
////              ),
////            ))
//      ],
//    );
//  }

  Widget _itemTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil().L(15),
              top: ScreenUtil().L(27),
              bottom: ScreenUtil().L(14)),
          child: Text(title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.bold))),
    );
  }

  Widget _logistics() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            _itemTitle("物流说明"),
            Padding(
                padding: EdgeInsets.only(
                    left: ScreenUtil().L(13),
                    top: ScreenUtil().L(27),
                    bottom: ScreenUtil().L(14)),
                child: Text("预计14至19天到达",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(12),
                        fontWeight: FontWeight.bold)))
          ],
        ),
        Logistics()
      ],
    );
  }

  Widget _goodsInfos() {
    List<Widget> childs = List();
    model?.data?.propertyMap?.forEach((k, v) {
      childs.add(_goodsInfo(k, v));
    });
    childs.insert(0, _itemTitle("商品信息"));
    //底部padding
    childs.add(Container(
      height: ScreenUtil().L(29),
    ));
    return childs.length > 2
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: childs,
          )
        : Container();
  }

  Widget _goodsInfo(String leftText, String rightText,
      {double paddingBotton = 10.0}) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().L(15),
          right: ScreenUtil().L(15),
          bottom: ScreenUtil().L(paddingBotton)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(leftText,
                  style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontSize: ScreenUtil().setSp(11),
                      fontWeight: FontWeight.w300))),
          Expanded(
            flex: 4,
            child: Text(rightText,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(11),
                    fontWeight: FontWeight.w300)),
          ),
        ],
      ),
    );
  }

  Widget _goodsImages() {
    return model != null &&
            model.data != null &&
            model.data.productDetail != null
        ? Html(data: model.data.productDetail)
        : Container();
  }

  List<Widget> _actions() {
    return <Widget>[
      RawMaterialButton(
        //控件没有margin
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        padding: EdgeInsets.only(left: 10, right: 8),
        onPressed: () {
          routePagerNavigator(
              context,
              SharePage(
                images: productImgs,
              ));
        },
        child: Image.asset("images/share.png"),
        constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
      ),
      RawMaterialButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onPressed: () {
          routePagerNavigator(context, MessageCenter());
        },
        constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 12, top: 6, left: 8, bottom: 6),
              child: Text(
                "消息",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Positioned(
                top: 2,
                right: 7,
                child: NumberTip(
                  radius: 4,
                  alwaysShow: 5 > 0,
                ))
          ],
        ),
      )
    ];
  }

  Widget _divider({EdgeInsetsGeometry margin}) {
    return Container(
      margin: margin,
      height: 10,
      color: KColor.bgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("goodsDetailsPage  build");
    Widget footview = OrderUtil.getFooterView();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
          context: context,
          title: model?.data?.brand?.brandName != null
              ? model?.data?.brand?.brandName
              : ""),
      body: Stack(
        children: <Widget>[
          BaseContainer(
            isLoading: isLoading,
            showLoadError: isShowLoadError,
            showEmpty: isShowEmptyView,
            reLoad: () {
              loadData();
            },
            child: EasyRefresh(
                loadMore: () {
                  if (!noMoreData) getCommend(++page);
                },
                key: _easyRefreshKey,
                refreshFooter: ConnectorFooter(
                  key: _connectorFooterKey,
                  footer: footview,
                ),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //轮询图
                          productImgs.length > 0
                              ? GoodsImagesSwiper(
                                  productImgs,
                                  key: _swiperKey,
                                )
                              : Container(),
                          _divider(
                              margin:
                                  EdgeInsets.only(bottom: ScreenUtil().L(30))),
                          //价格
                          _price(),
                          //商品信息
                          _goodsDesc(),
                          //选择颜色
                          //_selectColor(),
                          model != null &&
                                  model.data != null &&
                                  model.data.specs != null &&
                                  model.data.specs.length != null &&
                                  model.data.specs.length > 0
                              ? SelectSize(
                                  model.data.specs[0],
                                  selectColor,
                                  key: _selectColorKey,
                                  isSize: false,
                                  onTap: (size) {
                                    selectColor = size;
                                    _getSuppier();
                                  },
                                )
                              : Container(),
                          model != null &&
                                  model.data != null &&
                                  model.data.specs != null &&
                                  model.data.specs.length != null &&
                                  model.data.specs.length > 1
                              ? SelectSize(
                                  model.data.specs[1],
                                  selectedSize,
                                  key: _selectSizeKey,
                                  isSize: false,
                                  spe_path: spe_path,
                                  selectPath: selectedSize != null
                                      ? "${model.data.specs[0].id}:${selectColor.vid};${model.data.specs[1].id}:${selectedSize.vid}"
                                      : "",
                                  onTap: (size) {
                                    selectedSize = size;
                                    _getSuppier();
                                  },
                                )
                              : Container(),
                          _divider(),
                          //货源
                          GoodsSupplys(selectedSupplys),
                          _divider(),
                          //物流
                          //_logistics(),
                          //商品信息
                          _goodsInfos(),
                          //分割线
                          _divider(),
                          _itemTitle("商品详情"),
                          _goodsImages(),
                          _divider(
                              margin: EdgeInsets.only(top: ScreenUtil().L(15))),
                          _itemTitle("相似商品"),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(top: ScreenUtil().L(22)),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: ScreenUtil().L(26),
                        childAspectRatio: 0.6,
                        children: recommendList.length > 0
                            ? recommendList.map((goodsItemModel) {
                                return GridViewItem(goodsItemModel);
                              }).toList()
                            : List(),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                      recommendList != null && recommendList.length >= 20
                          ? noMoreData ? CommonEndLine() : footview
                          : Container()
                    ])),
                  ],
                )),
          ),
          Positioned(
            right: ScreenUtil().L(10),
            bottom: ScreenUtil().L(100),
            child: BackTopButton(_scrollController),
          )
        ],
      ),
      bottomNavigationBar: model != null && model.data != null
          ? BottomAppBar(
              child: BottomView(_scrollController, supplysHeight, model, () {
                setState(() {
                  for (var value in model.data.skuPath) {
                    for (var value1 in value.inventoryList) {
                      value1.setOrderNum(0);
                    }
                  }
                });
              }),
            )
          : Container(
              height: ScreenUtil.bottomBarHeight,
            ),
    );
  }

  //修改尺码或者规格后供应商变化
  _getSuppier() {
    String path = "";
    if (model.data.specs.length > 0 && selectColor != null) {
      path = "${model.data.specs[0].id}:${selectColor.vid}";
    }
    if (model.data.specs.length > 1 && selectedSize != null) {
      path = path + ";${model.data.specs[1].id}:${selectedSize.vid}";
    }

    for (var value in model.data.skuPath) {
      if (value.spePath == path) {
        setState(() {
          selectedSupplys = value.inventoryList;
        });
      }
    }
//    if (model.data.specs.length > 1) {
//      //两种规格才能拼接
//      for (var value in model.data.skuPath) {
//        if (value.spePath ==
//            "${model.data.specs[0].id}:${selectColor.vid};${model.data.specs[1].id}:${selectedSize.vid}") {
//          setState(() {
//            selectedSupplys = value.inventoryList;
//          });
//        }
//      }
//    }
  }
}

class BottomView extends StatefulWidget {
//  final List<Inventory_list> supplys;
  final ScrollController _scrollController;
  final double supplysHeight;
  final VoidCallback refreshOrderNum;
  GoodDetailModel model;

  BottomView(this._scrollController, this.supplysHeight, this.model,
      this.refreshOrderNum);

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  bool isCollected = false; //是否已经收藏
  int goodsSize = 0; //下单商品数量
  int totalGoodsSize = 0; //总下单商品数量

  @override
  Widget build(BuildContext context) {
    Widget _bottomButton(
        String text,
        Color color,
        double topLeft,
        double topRight,
        double bottomRight,
        double bottomLeft,
        GestureTapCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().L(11), bottom: ScreenUtil().L(9)),
          width: ScreenUtil().L(105),
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(topLeft),
                  bottomLeft: Radius.circular(bottomLeft),
                  topRight: Radius.circular(topRight),
                  bottomRight: Radius.circular(bottomRight))),
          padding: EdgeInsets.only(top: 15, bottom: 15),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      );
    }

    return Container(
      height: ScreenUtil().L(65),
      padding: EdgeInsets.only(right: ScreenUtil().L(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Color(0xffE5E5E5), offset: Offset(0, -1), blurRadius: 0),
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
//                GestureDetector(
//                  onTap: () {
//                    setState(() {
//                      isCollected = !isCollected;
//                      ToastUtil.showToast(
//                          context, isCollected ? "收藏成功" : "取消收藏成功");
//                    });
//                  },
//                  child: Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        Padding(
//                            padding: EdgeInsets.only(top: 6, bottom: 5),
//                            child: Image.asset(
//                                isCollected
//                                    ? "images/collect_pressed.png"
//                                    : "images/collect.png",
//                                width: 20,
//                                height: 20)),
//                        Text(
//                          "收藏",
//                          style: TextStyle(
//                              color: Colors.black,
//                              fontSize: 10,
//                              fontWeight: FontWeight.w400),
//                        )
//                      ]),
//                ),
                Expanded(
                    child: GestureDetector(
                        onTap: () {
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
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 6, bottom: 5),
                                    child: Image.asset(
                                        "images/customer_service.png",
                                        width: 20,
                                        height: 20)),
                                Text(
                                  "客服",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400),
                                )
                              ]),
                        ))),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    routePagerNavigator(context, CartSinglePage());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 6, right: 6, bottom: 5, left: 6),
                                child: Image.asset(
                                  "images/cart.png",
                                  width: 20,
                                  height: 20,
                                  color: Colors.black,
                                ),
                              ),
                              Positioned(
                                  top: 0,
                                  right: 0,
                                  child: NumberTip(
                                    nums: totalGoodsSize,
//                                  nums: goodsSize,
                                  )),
                            ],
                          ),
                          Text(
                            "进货单",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          )
                        ]),
                  ),
                ))
              ],
            ),
          ),
          _bottomButton("加入进货单", Colors.black, 5, 0, 0, 5, () {
//            setState(() {
            goodsSize = 0;
            if (widget.model != null &&
                widget.model.data != null &&
                widget.model.data.skuPath != null) {
              for (var value in widget.model.data.skuPath) {
                if (value.inventoryList != null) {
                  for (var value1 in value.inventoryList) {
                    goodsSize = goodsSize + value1.getOrderNum();
                    totalGoodsSize = totalGoodsSize + value1.getOrderNum();
                  }
                }
              }
            }
//              widget.model.forEach((model) {
//                goodsSize = goodsSize + model.getOrderNum();
//              });
            if (goodsSize <= 0 && widget.supplysHeight != 0) {
              ToastUtil.showToast(context, "请选择货源和下单数量");
              widget._scrollController.animateTo(widget.supplysHeight,
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            } else {
              addGoods();
            }
//            });
          }),
          _bottomButton("立即购买", Color(0xFFECE936), 0, 5, 5, 0, () {
//            setState(() {
            goodsSize = 0;
            if (widget.model != null &&
                widget.model.data != null &&
                widget.model.data.skuPath != null) {
              for (var value in widget.model.data.skuPath) {
                if (value.inventoryList != null) {
                  for (var value1 in value.inventoryList) {
                    goodsSize = goodsSize + value1.getOrderNum();
                    totalGoodsSize = totalGoodsSize + value1.getOrderNum();
                  }
                }
              }
            }
//              widget.supplys.forEach((model) {
//                goodsSize = goodsSize + model.getOrderNum();
//              });
            if (goodsSize <= 0 && widget.supplysHeight != 0) {
              ToastUtil.showToast(context, "请选择货源和下单数量");
              widget._scrollController.animateTo(widget.supplysHeight,
                  duration: Duration(milliseconds: 300), curve: Curves.linear);
            } else {
              orderBuy();
            }
//            });
          }),
        ],
      ),
    );
  }

  //立即购买
  void orderBuy() {
    List list = getRequestParams(false);
    if (list != null && list.length > 0) {
      HttpManager().postForm(context, Api.ORDER_NOW, {
        "itemList": list,
      }, (json) {
        SettlementCenterResp resp = SettlementCenterResp.fromJson(json);
        if (resp.result != null && resp.result.isSuccess) {
          routePagerNavigator(
              context,
              SettlementCenter(
                  resp.data, widget.model.data.spuId.toString(), true,
                  detailsOrderInfo: getOrderInfo()));
        } else {
          ToastUtil.showToast(context, "网络异常，请重试");
        }
      }, onError: (error) {
        ToastUtil.showToast(context, "网络异常，请重试");
      });
    }
  }

  //添加商品到购物车
  void addGoods() {
    List list = getRequestParams(true);
    if (list != null && list.length > 0) {
      HttpManager().postForm(context, Api.ADD_CART_GOODS, {
        "cartList": list,
      }, (json) {
        BaseResp baseResp = BaseResp.fromJson(json);
        if (baseResp.result.isSuccess) {
          ToastUtil.showToast(context, "商品添加成功");
          //添加成功后下单数量置0
          if (widget.refreshOrderNum != null) {
            widget.refreshOrderNum();
          }
          setState(() {});
        } else {
          ToastUtil.showToast(context, baseResp.result.msg);
        }
      }, onError: (error) {
        ToastUtil.showToast(context, "网络异常，请重试");
      });
    }
  }

  getOrderInfo() {
    var tempModel = widget.model;
    if (tempModel != null &&
        tempModel.data != null &&
        tempModel.data.skuPath != null) {
      int spuid = tempModel.data.spuId;
      List list = List();
      for (Sku_path path in tempModel.data.skuPath) {
        var inventoryList = path.inventoryList;
        if (inventoryList != null &&
            inventoryList.length > 0 &&
            inventoryList[0].getOrderNum() > 0) {
          list.add({
            "skuId": path.skuId,
            "brandId": tempModel.data.brand.brandId,
            "vendorId": inventoryList[0].vendorId,
            "vendorType": inventoryList[0].vendorType,
            "areaType": tempModel.data.areaType,
            "originalPrice": tempModel.data.price,
            "originalQuantity": inventoryList[0].getOrderNum(),
            "spuId": spuid,
            "cateId": tempModel.data.category.categoryId,
          });
        }
      }
      return list;
    }
    return null;
  }

  List getRequestParams(bool isAddCart) {
    var tempModel = widget.model;
    if (tempModel != null &&
        tempModel.data != null &&
        tempModel.data.skuPath != null) {
      int spuid = tempModel.data.spuId;
      List list = List();
      for (Sku_path path in tempModel.data.skuPath) {
        var inventoryList = path.inventoryList;
        if (inventoryList != null &&
            inventoryList.length > 0 &&
            inventoryList[0].getOrderNum() > 0) {
          if (isAddCart) {
            list.add({
              "skuId": path.skuId,
              "spuId": spuid,
              "vendorId": inventoryList[0].vendorId,
              "vendorType": inventoryList[0].vendorType,
              "originalPrice": tempModel.data.price,
              "originalQuantity": inventoryList[0].getOrderNum()
            });
          } else {
            list.add({
              "skuId": path.skuId,
              "spuId": spuid,
              "vendorId": inventoryList[0].vendorId,
              "num": inventoryList[0].getOrderNum()
            });
          }
        }
      }
      return list;
    }
    return null;
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

class Logistics extends StatelessWidget {
  Widget _text(String text, bool small) {
    return Text(text,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: small ? 10 : 12));
  }

  Widget _dotLine(String name) {
    return Expanded(
        child: Column(
      children: <Widget>[
        _text(name, true),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "----------------------",
            style: TextStyle(color: Color(0xFF979797)),
          ),
        )
      ],
    ));
  }

  Widget _image(String name) {
    return Padding(
        padding:
            EdgeInsets.only(top: ScreenUtil().L(15), bottom: ScreenUtil().L(7)),
        child: Image.asset(name));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().L(13),
          right: ScreenUtil().L(13),
          bottom: ScreenUtil().L(27)),
      child: Column(
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _image("images/logistics_order.png"),
                _dotLine("0~2工作日"),
                _image("images/logistics_sure.png"),
                _dotLine("1~3工作日"),
                _image("images/logistics_cart.png"),
                _dotLine("10工作日"),
                _image("images/logistics_location.png")
              ]),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _text("下单", false)),
                Expanded(child: _text("买手店\n确认", false)),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _text("买手店\n发货", false),
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(right: ScreenUtil().L(4)),
                            child: Image.asset("images/logistics_air.png")),
                        _text("经香港", true)
                      ],
                    )),
                  ],
                )),
                _text("目的地", false)
              ])
        ],
      ),
    );
  }
}

///供应商
class GoodsSupplys extends StatefulWidget {
  final List<Inventory_list> supplys;

  GoodsSupplys(this.supplys);

  @override
  _GoodsSupplysState createState() => _GoodsSupplysState();
}

class _GoodsSupplysState extends State<GoodsSupplys> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().L(15),
          right: ScreenUtil().L(14),
          top: ScreenUtil().L(30),
          bottom: ScreenUtil().L(30)),
      child: Column(
        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              ToastUtil.showToast(context, "弹出收货方式");
//            },
//            child: Padding(
//              padding: EdgeInsets.only(
//                  top: ScreenUtil().L(27), bottom: ScreenUtil().L(17)),
//              child: Row(
//                children: <Widget>[
//                  Text(
//                    "收货方式",
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 14,
//                        fontWeight: FontWeight.bold),
//                  ),
//                  Expanded(
//                      child: Text(
//                    "已选: 香港自提",
//                    textAlign: TextAlign.right,
//                    style: TextStyle(
//                        color: Colors.black,
//                        fontSize: 12,
//                        fontWeight: FontWeight.w300),
//                  )),
//                  Icon(
//                    Icons.arrow_forward_ios,
//                    color: Colors.black,
//                    size: 10,
//                  )
//                ],
//              ),
//            ),
//          ),
//          Container(
//            margin: EdgeInsets.only(bottom: ScreenUtil().L(16)),
//            height: 1,
//            color: KColor.bgColor,
//          ),
          Row(
            children: <Widget>[
              _supplysTitle(3, '货源', false),
              _supplysTitle(2, '报价', true),
              _supplysTitle(2, '库存', true),
              _supplysTitle(3, '下单数量', true),
            ],
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: ScreenUtil().L(7)),
            shrinkWrap: true,
            itemCount: widget.supplys.length,
            itemBuilder: (context, i) =>
                _buildSupplyItem(context, widget.supplys[i]),
          )
        ],
      ),
    );
  }

  Widget _supplysTitle(int flex, String title, bool center) {
    return Expanded(
        flex: flex,
        child: center
            ? Center(
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.w500),
                ),
              )
            : Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: ScreenUtil().setSp(12),
                    fontWeight: FontWeight.w500),
              ));
  }

  Widget _buildSupplyItem(BuildContext context, Inventory_list model) {
    Color color = model.sellStock == 0 ? Color(0xffB5B5B5) : Colors.black;
    Color addColor =
        model.sellStock == 0 || model.getOrderNum() == model.sellStock
            ? Color(0xffB5B5B5)
            : Colors.black;
    Color minuColor = model.sellStock == 0 || model.getOrderNum == 0
        ? Color(0xffB5B5B5)
        : Colors.black;
    TextStyle style = TextStyle(
        color: color,
        fontSize: ScreenUtil().setSp(10),
        fontWeight: FontWeight.w300);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _supplysContent(3, false, "${model.area}|${model.vendorCode}", style),
        _supplysContent(2, true, "￥${model.salePrice}", style),
        _supplysContent(2, true, "${model.sellStock}", style),
        Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: ScreenUtil().L(5)),
              decoration:
                  BoxDecoration(border: Border.all(color: Color(0xFFB5B5B5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      if (model.sellStock > 0 && model.getOrderNum() > 0) {
                        setState(() {
                          model.setOrderNum(model.getOrderNum() - 1);
                        });
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          right: ScreenUtil().L(15),
                          left: ScreenUtil().L(15),
                          top: ScreenUtil().L(7),
                          bottom: ScreenUtil().L(7)),
                      child: Icon(
                        Icons.remove,
                        color: minuColor,
                        size: ScreenUtil().L(10),
                      ),
                    ),
                  ),
                  Text(
                    "${model.getOrderNum()}",
                    style: style,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (model.sellStock > 0 &&
                            model.getOrderNum() < model.sellStock) {
                          setState(() {
                            model.setOrderNum(model.getOrderNum() + 1);
                          });
                        }
                      },
                      child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(
                            right: ScreenUtil().L(15),
                            left: ScreenUtil().L(15),
                            top: ScreenUtil().L(7),
                            bottom: ScreenUtil().L(7)),
                        child: Icon(
                          Icons.add,
                          color: addColor,
                          size: ScreenUtil().L(10),
                        ),
                      )),
                ],
              ),
            ))
      ],
    );
  }

  Widget _supplysContent(int flex, bool center, String title, TextStyle style) {
    return Expanded(
        flex: flex,
        child: center
            ? Center(
                child: Text(
                  title,
                  style: style,
                ),
              )
            : Text(
                title,
                style: style,
              ));
  }
}

///选择尺码
class SelectSize extends StatefulWidget {
//  final List<GoodsSize> sizes;
  final Specs specs;
  final List<String> spe_path; //供应商spe_path集合，用于判断是否可选
  //点击选择的尺寸
  Spec_values selectedSize;
  final String selectPath;
  final bool isSize;
  final ValueChanged<Spec_values> onTap;

  SelectSize(this.specs, this.selectedSize,
      {Key key,
      this.isSize = false,
      this.onTap,
      this.spe_path,
      this.selectPath})
      : super(key: key);

  @override
  _SelectSizeState createState() => _SelectSizeState();
}

class _SelectSizeState extends State<SelectSize> {
  String selectString = "";

  @override
  void initState() {
    super.initState();
    selectString =
        widget.selectedSize != null ? "已选${widget.selectedSize.value}" : "";
//    if (widget.spe_path != null && widget.spe_path.length > 0) {
//      if (!widget.spe_path.contains(widget.selectPath)) {
//        setState(() {
//          selectString = "";
//        });
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectTitle(widget.specs.name, selectString, widget.isSize),
        SizeSelector(
            sizes: widget.specs.specValues,
            spe_path: widget.spe_path,
            selectedPath: widget.selectPath,
//            currentIndex: selectString != "" ? 1 : -1,
            margin: EdgeInsets.only(
                top: ScreenUtil().L(13),
                left: ScreenUtil().L(15),
                right: ScreenUtil().L(35),
                bottom: ScreenUtil().L(30)),
            onTap: (Spec_values size) {
              setState(() {
//                widget.selectedSize = size;
                if (widget.onTap != null) widget.onTap(size);
              });
            })
      ],
    );
  }
}

///选择颜色或尺码title
class SelectTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool isSize;

  SelectTitle(this.title, this.subTitle, this.isSize);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().L(15),
          right: ScreenUtil().L(14),
          bottom: ScreenUtil().L(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: ScreenUtil().L(10)),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(14)),
            ),
          ),
          Expanded(
              child: Text(
            subTitle,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: ScreenUtil().setSp(11)),
          )),
          isSize
              ? GestureDetector(
                  onTap: () {
                    ToastUtil.showToast(context, "尺码对照表");
                  },
                  child: Text(
                    "尺码对照表",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: ScreenUtil().setSp(11),
                        decoration: TextDecoration.underline),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

///商品图片展示（TODO 点击看大图）
class GoodsImagesSwiper extends StatelessWidget {
  final List<String> productImgs;

  GoodsImagesSwiper(this.productImgs, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().L(375),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return FadeInImage(
              fit: BoxFit.fill,
              placeholder: AssetImage("images/default_good_image.png"),
              image: NetworkImage(StringUtils.getImageUrl(productImgs[index])));
        },
        itemCount: productImgs.length,
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(
                right: ScreenUtil().L(15), bottom: ScreenUtil().L(20)),
            builder: FractionPaginationBuilder(
              color: Color(0xFFC1C1C1),
              activeColor: Color(0xFFC1C1C1),
              fontSize: 10,
              activeFontSize: 10,
            )),
        autoplay: true,
        duration: 150,
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        onTap: (index) {},
      ),
    );
  }
}

///
/// 把返回顶部按钮但抽出来，防止_scrollController一直刷新整个页面导致卡顿
/// @author longlyboyhe
/// @date 2019/2/26
///
class BackTopButton extends StatefulWidget {
  ScrollController _scrollController;

  BackTopButton(this._scrollController);

  @override
  _BackTopButtonState createState() => _BackTopButtonState();
}

class _BackTopButtonState extends State<BackTopButton> {
  double scrollDis = 0;
  double showBackTopBar = ScreenUtil.screenHeight;

  @override
  void initState() {
    super.initState();
    widget._scrollController.addListener(() {
      scrollDis = widget._scrollController.offset;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: scrollDis < showBackTopBar,
        child: GestureDetector(
          onTap: () {
            widget._scrollController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.linear);
          },
          child: Container(
            width: ScreenUtil().L(55),
            height: ScreenUtil().L(55),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Color(0xffd8d8d8),
                    offset: Offset(0, 1),
                    blurRadius: 8),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.arrow_upward,
                  color: Colors.black,
                ),
                Text(
                  "返回顶部",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ));
  }
}
