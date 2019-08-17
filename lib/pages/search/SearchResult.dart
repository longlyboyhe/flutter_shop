import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/index.dart';
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
/// 新版搜索结果页
/// @author longlyboyhe
/// @date 2019/3/25
///
class SearchResult extends StatefulWidget {
  final String searchText;
  final SearchType searchType;
  final int id;
  final String conditions;

  SearchResult(
      {this.searchText,
      this.searchType = SearchType.keyword,
      this.id,
      this.conditions});

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  int page = 1;
  bool noMoreData = false; //数据加载完毕
  List<GoodData> goodList = List();
  Map<String, String> params;

  @override
  void initState() {
    super.initState();
    _initSearch();
  }

  _initSearch() {
    params = {
      'page_size': "20",
    };
    if (widget.searchType == SearchType.brand) {
      params["cate_brand_id"] = "${widget.id}";
      loadData(1, type: SearchType.brand, id: widget.id);
    } else if (widget.searchType == SearchType.category) {
      params["cate_id"] = "${widget.id}";
      loadData(1, type: SearchType.category, id: widget.id);
    } else if (widget.searchType == SearchType.categorys) {
      loadData(1, type: SearchType.categorys, conditions: widget.conditions);
    } else {
      params["keyword"] = Uri.encodeComponent(widget.searchText);
      loadData(1,
          type: SearchType.keyword,
          keyword: Uri.encodeComponent(widget.searchText));
    }
  }

  void loadData(int page,
      {SearchType type,
      int id,
      String conditions,
      String keyword,
      int lowPrice,
      int highPrice}) async {
    if (noMoreData) return;

    params["page_no"] = "${page}";
    if (type == SearchType.keyword) {
      params["keyword"] = keyword;
    } else if (type == SearchType.category) {
      params["cate_id"] = "$id";
    } else if (type == SearchType.categorys) {
      params["cate_ids"] = conditions;
    } else if (type == SearchType.brand) {
      params["cate_brand_id"] = "$id";
    } else if (type == SearchType.price) {
      params["sale_price_gte"] = "$lowPrice";
      params["sale_price_lte"] = "$highPrice";
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
              //最后一页
              setState(() {
                noMoreData = true;
              });
            } else {
              if (model != null &&
                  model.data.data != null &&
                  model.data.data.length > 0) {
                //请求成功，有数据
                setState(() {
                  goodList.addAll(model.data.data);
                  noMoreData = false;
                  isLoading = false;
                  isShowEmptyView = false;
                  isShowLoadError = false;
                });
              } else {
                //请求成功，无数据
                noMoreData = true;
                if (page == 1) {
                  setState(() {
                    isLoading = false;
                    isShowEmptyView = true;
                    isShowLoadError = false;
//                    ToastUtil.showToast(context, "未搜索到内容");
                  });
                }
              }
            }
          } else {
            //请求成功，返回不成功码
            if (page == 1) {
              setState(() {
                isLoading = false;
                isShowEmptyView = true;
                isShowLoadError = false;
//                String msg = model?.result?.msg;
//                msg = msg != null && msg.isNotEmpty ? msg : "未搜索到内容";
//                ToastUtil.showToast(context, msg);
              });
            } else {
              page--;
            }
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          //请求失败
          _easyRefreshKey?.currentState?.callLoadMoreFinish();
          if (page == 1) {
            setState(() {
              isLoading = false;
              isShowEmptyView = false;
              isShowLoadError = true;
//              ToastUtil.showToast(context, "未搜索到内容");
            });
          } else {
            page--;
          }
        });
  }

  Widget _searchWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().L(15)),
                padding: EdgeInsets.only(
                    left: ScreenUtil().L(21),
                    top: ScreenUtil().L(5),
                    bottom: ScreenUtil().L(5),
                    right: ScreenUtil().L(21)),
                height: ScreenUtil().L(30),
                decoration: BoxDecoration(
                    color: KColor.bgColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(ScreenUtil().L(15)))),
                child: Text(
                  widget.searchText != null ? widget.searchText : "",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              ))),
      RawMaterialButton(
        onPressed: () {
          Navigator.pop(context);
        },
        padding: EdgeInsets.only(
            left: ScreenUtil().L(12), right: ScreenUtil().L(15)),
        constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
        child: Text(KString.cancel,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Widget footview = OrderUtil.getFooterView();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BlankAppBar(height: ScreenUtil().L(13)),
      bottomNavigationBar: Container(
        height: ScreenUtil.bottomBarHeight,
      ),
      body: Column(
        children: <Widget>[
          _searchWidget(),
          FilterBar(
              hasBrand: true,
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
                _initSearch();
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
                        delegate: SliverChildListDelegate(<Widget>[
                      goodList != null && goodList.length >= 20
                          ? noMoreData ? CommonEndLine() : footview
                          : Container()
                    ])),
                  ],
                )),
          ))
        ],
      ),
    );
  }
}
