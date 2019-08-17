import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';
import 'package:flutter_shop/widgets/SliverAppBarDelegate.dart';
import 'package:flutter_shop/widgets/home/FilterBar.dart';
import 'package:flutter_shop/widgets/home/GoodsItem1.dart';

///
/// 首页-爆款排行
/// @author longlyboyhe
/// @date 2019/1/15
///
class HomeItemRankPage extends StatefulWidget {
  @override
  _HomeItemRankPageState createState() => _HomeItemRankPageState();
}

class _HomeItemRankPageState extends State<HomeItemRankPage>
    with AutomaticKeepAliveClientMixin<HomeItemRankPage> {
  bool allPageIsLoading = true; //进入加载
  bool allPageIsShowEmptyView = false; //显示空页面
  bool allPageIsShowLoadError = false; //显示重新加载

  bool isLoading = true; //筛选

  int page = 1;
  bool noMoreData = false; //数据加载完毕

  void loadData() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        allPageIsLoading = false;
        isLoading = false;
        getBottomData(curFilterIndex + 1, page);
      });
    });
  }

  ///排序
  List<String> topList = ['综合排序', '热度', '新品', '折扣'];

  ///筛选列表
  List<GoodsItemModel> bottomList = List();

  ///当前排序
  int curFilterIndex = 0;

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =
      GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void getBottomData(int index, int page) {
    if (page == 1) {
      bottomList.clear();
    }
    if (page >= 3) {
      noMoreData = true;
      return;
    }
    int initCount = (page - 1) * 12;
    for (int i = initCount; i < initCount + 12; i++) {
      String name = i % index == 0 ? "GUCCI$i" : "LONGINES$i";
      String img = i % index == 0
          ? "/upload/img/brand/1542100089407.jpg"
          : "/upload/img/brand/1542100098705.jpg";
      double price = i % index == 0 ? 25632 : 9850;
      double oldprice = i % index == 0 ? 15632 : 8850;
      String discount = i % index == 0 ? "7.5折" : "限时折扣限时折扣限时折扣限时折扣";
      List<String> size =
          i % index == 0 ? ['XXS', 'XS', 'S', 'M', 'XXL'] : ['S', 'M'];
      GoodsItemModel goodsItemModel = GoodsItemModel(
          name: name,
          img: img,
          price: price,
          sizes: size,
          originalPrice: oldprice,
          discount: discount);
      bottomList.add(goodsItemModel);
    }

    if (page > 1) {
      _easyRefreshKey.currentState.callLoadMoreFinish();
    }
  }

  Widget _banner() {
    return GestureDetector(
      onTap: () {
        ToastUtil.showToast(context, "点击了banner");
      },
      child: Image.asset(
        "images/bg2.jpg",
        width: double.infinity,
        height: Klength.home_rankBannerHeight,
        fit: BoxFit.fill,
      ),
    );
  }

  ///筛选
  Widget _filter() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 0,
              child: Container(
                width: ScreenUtil.screenWidth,
                color: Color(0xFFD8D8D8),
                height: ScreenUtil().L(1),
              )),
          Row(
            children: <Widget>[
              Expanded(
                  child: FilterBar(
                topList,
                itemWidth: (ScreenUtil.screenWidth - ScreenUtil().L(55)) /
                    topList.length,
                height: Klength.home_rankFilterHeight,
                changed: (index) {
                  curFilterIndex = index;
                  loadData();
//              setState(() {});
                },
              )),
              Container(
                width: ScreenUtil().L(1),
                color: Color(0xFFF1F1F1),
              ),
              GestureDetector(
                onTap: () {
                  ToastUtil.showToast(context, "打开筛选");
                },
                child: Container(
                  width: ScreenUtil().L(55),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: ScreenUtil().L(3),
                        ),
                        child: Image.asset("images/filter.png"),
                      ),
                      Text(
                        "筛选",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(8),
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _appBarHeight = Klength.home_rankBannerHeight -
        kToolbarHeight -
        ScreenUtil.statusBarHeight;

    Widget footer = CustomBallPulseFooter(
      key: _footerKey,
      size: 20,
    );

    return BaseContainer(
      isLoading: allPageIsLoading,
      child: EasyRefresh(
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
                loadData();
              },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              bottom: PreferredSize(
                  child: Container(),
                  preferredSize: Size.fromHeight(_appBarHeight)),
              flexibleSpace: Column(
                children: <Widget>[_banner()],
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                  child: _filter(), height: Klength.home_rankFilterHeight),
              pinned: true,
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Container(
                      height: Klength.home_rankContentHeight,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(top: 15, bottom: 15),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: ScreenUtil().L(25),
                      children: bottomList.map((goodsItemModel) {
                        return GridViewItem(goodsItemModel);
                      }).toList(),
                    ),
                  ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                noMoreData
                    ? Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil().L(30),
                            top: ScreenUtil().L(10)),
                        alignment: Alignment.center,
                        child: Text(
                          "数据加载完毕",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: ScreenUtil().L(12)),
                        ),
                      )
                    : footer
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
