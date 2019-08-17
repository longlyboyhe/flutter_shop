import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/search_result_model.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/home/GoodsItem.dart';
import 'package:flutter_shop/widgets/search/FilterBar.dart';

///
/// 品牌馆-新
/// @author longlyboyhe
/// @date 2019/1/31
///
class BrandHall extends StatefulWidget {
  final int brandId;
  final String brandEnCnName;

  BrandHall({this.brandId, this.brandEnCnName});

  @override
  _BrandHallState createState() => _BrandHallState();
}

class _BrandHallState extends State<BrandHall> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  int page = 1;
  bool noMoreData = false; //数据加载完毕
  List<GoodData> goodList = List();

  @override
  void initState() {
    super.initState();
    loadData(1);
  }

  void loadData(int page,
      {SearchType type,
      int id,
      String keyword,
      int lowPrice,
      int highPrice}) async {
    if (noMoreData) return;

    Map<String, String> params = {
      'page_no': "$page",
      'page_size': "20",
      "cate_brand_id": "${widget.brandId}"
    };
    if (type == SearchType.category) {
      params["cate_id"] = "$id";
    } else if (type == SearchType.brand) {
      params["cate_brand_id"] = "$id";
    } else if (type == SearchType.price) {
    } else if (type == SearchType.volume) {}

    HttpManager.instance.get(
        context,
        Api.SEARCH,
        (json) {
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          SearchResultModel model = SearchResultModel.fromJson(json);
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
              setState(() {
                noMoreData = true;
              });
            } else {
              if (model != null &&
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
    Widget footview = OrderUtil.getFooterView();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          CommonAppBar(context: context, title: "${widget.brandEnCnName}品牌馆"),
      bottomNavigationBar: Container(
        height: ScreenUtil.bottomBarHeight,
      ),
      body: Column(
        children: <Widget>[
          FilterBar(
              hasBrand: false,
              onTap: (type, id, text, lowPrice, highPrice) {
                page = 1;
                loadData(1,
                    type: type,
                    id: id,
                    keyword: text,
                    lowPrice: lowPrice,
                    highPrice: highPrice);
              }),
          Expanded(
              child: BaseContainer(
            isLoading: isLoading,
            showEmpty: isShowEmptyView,
            showLoadError: isShowLoadError,
            reLoad: () {
              if (page == 1) {
                loadData(1);
              }
            },
            child: EasyRefresh(
                loadMore: () {
                  if (!noMoreData) loadData(++page);
                },
                key: _easyRefreshKey,
                refreshFooter: ConnectorFooter(
                  key: _connectorFooterKey,
                  footer: footview,
                ),
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.only(top: ScreenUtil().L(22)),
                      sliver: SliverGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: ScreenUtil().L(26),
                        childAspectRatio: 0.6,
                        children: goodList.length > 0
                            ? goodList.map((goodsItemModel) {
                                return GridViewItem(goodsItemModel);
                              }).toList()
                            : List(),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(
                            <Widget>[goodList != null && goodList.length >= 20
                                ? noMoreData ? CommonEndLine() : footview
                                : Container()])),
                  ],
                )),
          ))
        ],
      ),
    );
  }
}
