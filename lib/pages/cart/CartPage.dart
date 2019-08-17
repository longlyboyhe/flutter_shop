import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/RecommendModel.dart';
import 'package:flutter_shop/model/cart_resp.dart';
import 'package:flutter_shop/model/modify_cart_resp.dart';
import 'package:flutter_shop/model/settlement_center.dart';
import 'package:flutter_shop/pages/accountcenter/SettlementCenter.dart';
import 'package:flutter_shop/pages/cart/CartBottom.dart';
import 'package:flutter_shop/pages/cart/CartItem.dart';
import 'package:flutter_shop/pages/cart/CartListener.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/pages/want/WantSinglePage.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';

///
/// 进货单
/// @author longlyboyhe
/// @date 2019/3/23
///
class CartPage extends StatefulWidget {
  final bool existBackIcon;

  CartPage({this.existBackIcon = false, Key key}) : super(key: key);

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage>
    with WidgetsBindingObserver
    implements CartListener {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey =
      GlobalKey<RefreshHeaderState>();
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  int page = 1;
  int maxPage = 1;
  bool noMoreData = false; //数据加载完毕

  BottomType bottomType;

//  bool showCommont = false; //是否开始加载推荐
  List<GoodsItemModel> commentList = List();
  List<Cart> cartGoodsList = List();
  Data cartModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    bottomType = BottomType.noEdit;
    loadData(false);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadData(false);
    }
  }

  void loadData(bool isEasyRefresh) async {
    HttpManager().get(context,Api.CARD_GOODS_LIST, (result){
      CartResp cartResp=CartResp.fromJson(result);
      if(cartResp!=null && cartResp.result!=null){
        if(page==1){
          cartGoodsList.clear();
        }
        cartModel= cartResp.data;
        if(cartModel!=null){
          page=cartModel.pageNo;
          maxPage=cartModel.totalPage;
          var cartList = cartModel.data;
          if(cartList!=null && cartList.length>0){
            cartGoodsList.addAll(cartList);
          }
        }
      }
      if(cartModel!=null){
        cartModel.data=cartGoodsList;
      }
      isLoading = false;
      isShowEmptyView=cartGoodsList.length==0;
      isShowLoadError=false;
      if(isEasyRefresh){
        _easyRefreshKey.currentState?.callRefreshFinish();
        _easyRefreshKey.currentState?.callLoadMoreFinish();
      }else{
        setState(() {
        });
      }
    },errorCallback: (error){
      isLoading = false;
      isShowLoadError = cartGoodsList.length==0;
      if(isEasyRefresh){
        _easyRefreshKey.currentState?.callRefreshFinish();
        _easyRefreshKey.currentState?.callLoadMoreFinish();
      }else{
        setState(() {
        });
      }
      if(page>1){
        page--;
      }
    },params: {
      "page_no":page.toString(),
      "page_size":"20",
    });
  }

  void loadCommentData(int page) async {
    rootBundle.loadString("datas/recommends.json").then((value) {
      setState(() {
        RecommendModel recommendModel =RecommendModel.fromJson(jsonDecode(value));
        commentList.addAll(recommendModel.data);
      });
    });
  }

  Widget _manage() {
    return GestureDetector(
        onTap: () {
          setState(() {
            bottomType = bottomType == BottomType.noEdit
                ? BottomType.edit
                : BottomType.noEdit;
          });
        },
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          padding: EdgeInsets.only(
              left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
          child: Text(
            bottomType == BottomType.edit ? "完成" : "编辑",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ));
  }

  Widget _appBar({List<Widget> actions}) {
    return AppBar(
      title: Text(
        KString.cartTitle,
        style: TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      centerTitle:  true,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      leading: widget.existBackIcon
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              })
          : Container(),
      elevation: 1,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
//    Widget footview = OrderUtil.getFooterView();
//    Widget headerView = OrderUtil.getRefreshHeaderView();
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
    int itemCount = cartGoodsList.length;
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: _appBar(actions: <Widget>[
        cartGoodsList.length > 0 ? _manage() : Container()
      ]),
      body: Column(
        children: <Widget>[
          Expanded(
              child: BaseContainer(
            isLoading: isLoading,
            showEmpty: isShowEmptyView,
            showLoadError: isShowLoadError,
            reLoad: () {
              noMoreData = false;
              loadData(false);
            },
            child: EasyRefresh(
                onRefresh: () {
                  page = 1;
                  noMoreData = false;
                  loadData(true);
                },
                loadMore: () {
                  page++;
                  if (page > maxPage) {
                    noMoreData = true;
                    _easyRefreshKey.currentState.callLoadMoreFinish();
                    return;
                  }
                  loadData(true);
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
                        delegate:
                            SliverChildListDelegate(<Widget>[headerView])),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == 0) {
                            return Container(
                              color: KColor.bgColor,
                              height: ScreenUtil().L(10),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                routePagerNavigator(context, GoodsDetailsPage(cartGoodsList[index - 1].spuId)).then((value){
                                    loadData(false);
                                });
                              },
                              child: CartItem(
                                model: cartGoodsList,
                                itemModel: cartGoodsList[index - 1],
                                listener: this,
                                bottomType: bottomType,
                                index: index - 1,
                              ),
                            );
                          }
                        },
                        childCount: itemCount + 1,
                      ),
                    ),
//                  showCommont
//                      ? SliverToBoxAdapter(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                color: KColor.bgColor,
//                                height: ScreenUtil().L(10),
//                              ),
//                              Padding(
//                                padding: EdgeInsets.only(
//                                    left: ScreenUtil().L(15),
//                                    top: ScreenUtil().L(30),
//                                    bottom: ScreenUtil().L(25)),
//                                child: Text(
//                                  "为您推荐",
//                                  style: TextStyle(
//                                      color: Colors.black,
//                                      fontSize: 14,
//                                      fontWeight: FontWeight.w500),
//                                ),
//                              )
//                            ],
//                          ),
//                        )
//                      : SliverToBoxAdapter(
//                          child: Container(),
//                        ),
//                  showCommont
//                      ? SliverGrid.count(
//                          crossAxisCount: 2,
//                          mainAxisSpacing: ScreenUtil().L(26),
//                          childAspectRatio: 0.7,
//                          children: commentList.map((goodsItemModel) {
//                            return GridViewItem(goodsItemModel);
//                          }).toList(),
//                        )
//                      : SliverToBoxAdapter(
//                          child: Container(),
//                        ),
                    SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                      cartGoodsList != null && cartGoodsList.length >= 20
                          ? noMoreData ? CommonEndLine() : footview
                          : Container()
                    ])),
                  ],
                )),
          )),
          cartGoodsList.length > 0
              ? CartBottom(
                  bottomType: bottomType,
                  cartModel: cartModel,
                  listener: this,
                )
              : Container()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void collect() {
    String selected = cartModel.getSelectedSkuid();
    if (selected.isEmpty) {
      ToastUtil.showToast(context, "请先选择需要收藏的数据");
    } else {
      ToastUtil.showToast(context, "收藏${selected}");
      //TODO 重新请求数据以刷新
    }
  }

  @override
  void delete() {
    String selectedIds = cartModel.getSelectedCartId();
    if (selectedIds.isEmpty) {
      ToastUtil.showToast(context, "请先选择要删除的商品");
    } else {
      if (cartModel.isAllchecked) {
        //清空购物车
        HttpManager().delete(context, Api.CLEAR_CARD_GOODS, (json) {
          page=1;
          loadData(false);
        }, onError: (eror) {
          ToastUtil.showToast(context, "删除失败");
        });
      } else {
        HttpManager().delete(context, Api.DELTE_CARD_GOODS, (json) {
          BaseResp baseResp = BaseResp.fromJson(json);
          if (baseResp.result != null && baseResp.result.isSuccess) {
            ToastUtil.showToast(context, "删除成功");
            _easyRefreshKey.currentState.callRefresh();
          }
        }, onError: (eror) {
          ToastUtil.showToast(context, "删除失败");
        }, params: {"ids": selectedIds});
      }
    }
  }

  @override
  void order() {
    String cartIds = cartModel.getSelectedCartId();
    if (cartIds.isEmpty) {
      ToastUtil.showToast(context, "您没有选择商品信息");
    } else {
      LoadingDialogUtil.showLoading(context,barrierDismissible: false);
      HttpManager().get(context, Api.CART_TO_SETTLEMENT, (result) {
        Navigator.pop(context);
        SettlementCenterResp centerResp = SettlementCenterResp.fromJson(result);
        if (centerResp.result != null && centerResp.result.isSuccess && centerResp.data != null) {
          routePagerNavigator(context, SettlementCenter(centerResp.data, cartIds, false)).then((value){
            loadData(false);
          });
        } else {
          ToastUtil.showToast(context, centerResp.result.msg==null || centerResp.result.msg.isEmpty?"网络异常,请重新":centerResp.result.msg);
        }
      }, errorCallback: (error) {
        ToastUtil.showToast(context, "网络异常,请重新");
        Navigator.pop(context);
      }, params: {"cart_ids": cartIds});
    }
  }

  @override
  void refresh() {
    setState(() {});
  }

  @override
  void selectAll() {
    setState(() {
      cartModel.switchAllCheck();
    });
  }

  @override
  void wantToBuy(Cart model) {
    routePagerNavigator(context, WantSinglePage());
  }

  @override
  void changeNum(Cart model, int num) {
    int goodsNumber = model.originalQuantity;
    if (num > 0) {
      goodsNumber++;
    } else {
      if (goodsNumber > 1) {
        goodsNumber--;
      } else {
        return;
      }
    }
    Map map = {
      "skuId": model.skuId,
      "vendorId": model.vendorId,
      "num": num > 0 ? 1 : -1,
      "price": model.originalPrice
    };
    HttpManager().put(context, Api.EDIT_CARD_GOODS_NUBER, map, (json) {
      ModifyCartResp modifyCartResp = ModifyCartResp.fromJson(json);
      if (modifyCartResp.result.isSuccess) {
        if (modifyCartResp.data != null) {
          model.originalQuantity = modifyCartResp.data.originalQuantity;
          setState(() {});
        }
      } else {
        ToastUtil.showToast(context, modifyCartResp.result.msg);
      }
    }, onError: (error) {
      ToastUtil.showToast(context, error);
    });
  }
}
