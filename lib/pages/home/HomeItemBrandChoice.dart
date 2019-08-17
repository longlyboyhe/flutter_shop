import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/brand_model.dart';
import 'package:flutter_shop/model/home_resp.dart';
import 'package:flutter_shop/pages/brand/BrandHall.dart';
import 'package:flutter_shop/pages/brand/BrandShowHorizontal.dart';
import 'package:flutter_shop/pages/category/brand.dart';
import 'package:flutter_shop/pages/search/SearchResult.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/right_sheet.dart';

///
/// 首页-品牌精选
/// @author longlyboyhe
/// @date 2019/1/16
///
class HomeItemBrandChoice extends StatefulWidget {
  @override
  _HomeItemBrandChoiceState createState() => _HomeItemBrandChoiceState();
}

class _HomeItemBrandChoiceState extends State<HomeItemBrandChoice>
    with AutomaticKeepAliveClientMixin<HomeItemBrandChoice> {
  bool isLoading = true;
  int page = 1;
  int maxPage = 1;
  bool noMoreData = false; //数据加载完毕
  List<GoodsItemModel> brandList = List();

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
  GlobalKey<RefreshFooterState>();

  bool error = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    HttpManager().get(
        context,
        Api.CMS,
            (json) {
          try {
            HomeResp resp = HomeResp.fromJson(json);
            isLoading = false;
            if (resp.result != null && resp.result.isSuccess) {
              //成功
              error = false;
              handleResp(resp);
            } else {
              //失败
              error = true;
            }
          } catch (e) {
            error = true;
          }
          _easyRefreshKey.currentState.callLoadMoreFinish();
          if (mounted) {
            setState(() {});
          }
        },
        params: {
          "page_no": page.toString(),
          "page_type": "2",
          "page_size": "20",
        },
        errorCallback: (error) {
          setState(() {
            isLoading = false;
            if (brandList.length == 0) {
              this.error = true;
            }
            _easyRefreshKey.currentState.callLoadMoreFinish();
          });
        });
  }

  void handleResp(HomeResp resp) {
    if (resp.data != null && resp.data.modules != null) {
      for (Map<String, dynamic> map in resp.data.modules) {
        switch (map["module_type"]) {
          case "c-brand-module":
          //品牌
            if (page == 1) {
              brandList.clear();
            }
            maxPage = resp.data.pageTotal;
            handleBrand(map);
            break;
        }
      }
    }
  }

  void handleBrand(Map<String, dynamic> map) {
    if (map != null) {
      BrandModel brandModel = BrandModel.fromJson(map);
      if (brandModel != null &&
          brandModel.businessObj != null &&
          brandModel.businessObj.list != null) {
        List<BrandSelection> brands = brandModel.businessObj.list;
        for (BrandSelection brandSelection in brands) {
          GoodsItemModel goodsItemModel = GoodsItemModel(
              id: brandSelection.brandId,
              en_cn_name: "${brandSelection.enName}/${brandSelection.cnName}",
              name: brandSelection.cnName,
              img: brandSelection.changeImg);
          brandList.add(goodsItemModel);
        }
      }
    }
  }

  Widget _brandItem(GoodsItemModel model) {
    return GestureDetector(
      onTap: () {
        //TODO 测试品牌馆
        routePagerNavigator(
            context,
            BrandHall(
              brandId: model.id,
              brandEnCnName: model.en_cn_name,
            ));
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: FadeInImage(
                placeholder: AssetImage("images/default_good_image.png"),
                fit: BoxFit.cover,
                image: NetworkImage(model.img)),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenUtil().L(6)),
            child: Text(
              model.name,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: ScreenUtil().setSp(14),
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  Widget _drawer() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: ScreenUtil().L(16)),
        child: Scaffold(
          appBar: CommonAppBar(
              context: context,
              existBackIcon: false,
              title: "筛选",
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              bottom: CommonAppBarBottomLine()),
          body: Brand(),
        ));
  }

  Widget _filterBar() {
    return GestureDetector(
      onTap: () {
        showModalRightSheet(
            context: context,
            builder: (context) {
              return _drawer();
            });
      },
      child: Container(
        width: ScreenUtil().L(55),
        height: ScreenUtil().L(55),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color(0xffd8d8d8), offset: Offset(0, 1), blurRadius: 5)
            ],
            gradient:
            LinearGradient(colors: [Color(0xFFECE936), Color(0xFFFFCB00)])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/filter.png"),
            Text(
              "筛选",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget footer = CustomBallPulseFooter(
      key: _footerKey,
      size: 20,
    );
    return BaseContainer(
      isLoading: isLoading,
      showLoadError: error,
      reLoad: () {
        isLoading = true;
        loadData();
      },
      child: Stack(
        children: <Widget>[
          EasyRefresh(
            key: _easyRefreshKey,
            autoControl: false,
            refreshFooter: ConnectorFooter(
              key: _connectorFooterKey,
              footer: footer,
            ),
            loadMore: isLoading || noMoreData
                ? null
                : () async {
              page++;
              if (page > maxPage) {
                noMoreData = true;
                setState(() {});
                return;
              }
              loadData();
            },
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().L(10),
                        color: KColor.bgColor,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().L(20), bottom: ScreenUtil().L(2)),
                        child: Text(
                          "全部品牌",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: ScreenUtil().setSp(20)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Color(0xffB2B2B2),
                            margin: EdgeInsets.only(right: ScreenUtil().L(8)),
                            width: ScreenUtil().L(17),
                            height: ScreenUtil().L(2),
                          ),
                          Text("ALL",
                              style: TextStyle(
                                  color: Color(0xffB2B2B2),
                                  fontSize: ScreenUtil().L(12))),
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil().L(8)),
                            color: Color(0xffB2B2B2),
                            width: ScreenUtil().L(17),
                            height: ScreenUtil().L(2),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(ScreenUtil().L(15)),
                  sliver: SliverGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: ScreenUtil().L(22),
                    childAspectRatio: 0.85,
                    crossAxisSpacing: ScreenUtil().L(22),
                    children: brandList.map((goodsItemModel) {
                      return _brandItem(goodsItemModel);
                    }).toList(),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    brandList != null && brandList.length >= 20
                        ? noMoreData ? CommonEndLine() : footer
                        : Container()
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
