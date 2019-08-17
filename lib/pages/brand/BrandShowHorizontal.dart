import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/SliverAppBarDelegate.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/home/CustomTabBar.dart';
import 'package:flutter_shop/widgets/home/HorizontalGoodsListView.dart';

///
/// 品牌馆-水平选项
/// @author longlyboyhe
/// @date 2019/1/16
///
class BrandShowHorizontal extends StatefulWidget {
  @override
  _BrandShowHorizontalState createState() => _BrandShowHorizontalState();
}

class _BrandShowHorizontalState extends State<BrandShowHorizontal>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  bool isScroll = false;

  ///  获取TabBar，用于调用其中的移动到某一个tab的方法
  GlobalKey<CustomTabBarState> _key = GlobalKey<CustomTabBarState>();

  bool isLoading = true;

  void loadData() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  List<String> filterList = [
    '热销TOP',
    '包袋',
    '服装',
    '鞋靴',
    '配饰',
    '美妆',
    '首饰',
    '母婴',
    '其他'
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (isScroll) tabBarJumpTo(_scrollController.offset);
    });
  }

  void scrollViewMoveTo(int index) {
    double scrollDis = 0;
    if (index == 0) {
      scrollDis = Klength.brand_topBannerHeight;
    } else if (index == 1) {
      scrollDis =
          Klength.brand_topBannerHeight + Klength.brand_firstListItemHeight;
    } else {
      scrollDis = Klength.brand_topBannerHeight +
          Klength.brand_firstListItemHeight +
          (index - 1) * Klength.brand_listItemHeight;
    }
    _scrollController.animateTo(scrollDis,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  void tabBarJumpTo(double offset) {
    double dis2 =
        Klength.brand_topBannerHeight + Klength.brand_firstListItemHeight;
    double dis3 = Klength.brand_topBannerHeight +
        Klength.brand_firstListItemHeight +
        Klength.brand_listItemHeight;
    if (offset <= dis2) {
      _key.currentState.moveToTap(0);
    } else if (offset > dis2 && offset <= dis3) {
      _key.currentState.moveToTap(1);
    } else {
      int index = (offset -
                  Klength.brand_topBannerHeight -
                  Klength.brand_firstListItemHeight) ~/
              Klength.brand_listItemHeight +
          1;
      index = index < 0
          ? 0
          : index >= filterList.length ? filterList.length - 1 : index;
      _key.currentState.moveToTap(index);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _topImage() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            width: ScreenUtil.screenWidth,
            color: Color(0xfff1f1f1),
            height: ScreenUtil().L(30),
          ),
          bottom: 0,
        ),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0x1A000000),
                  offset: Offset(0, 1),
                  blurRadius: 10),
            ],
          ),
          margin:
              EdgeInsets.only(left: ScreenUtil().L(15), top: 15, bottom: 15),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().L(20)),
                    bottomLeft: Radius.circular(ScreenUtil().L(20))),
                child: Image.asset(
                  "images/bg1.jpg",
                  height: 375,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    width: ScreenUtil.screenWidth - ScreenUtil().L(15),
                    height: ScreenUtil().L(60),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(ScreenUtil().L(20))),
                      color: Color(0xCC000000),
                    ),
                    child: Center(
                      child: Text(
                        "Dior/迪奥",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(20),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        )
      ],
    );
  }

  ///筛选
  Widget _filter() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: CustomTabBar(
              key: _key,
              tabs: filterList,
              onTap: (index) {
                isScroll = false;
                scrollViewMoveTo(index);
              },
              height: Klength.brand_filterHeight,
              labelPadding: EdgeInsets.only(
                  top: 0, left: ScreenUtil().L(4), right: ScreenUtil().L(4)),
            ),
          ),
          Container(
            color: Color(0xffD8D8D8),
            height: ScreenUtil().L(1),
          )
        ],
      ),
    );
  }

  Widget _filterName(String name) {
    return Container(
      margin: EdgeInsets.only(bottom: ScreenUtil().L(2)),
      child: Text(
        name,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: ScreenUtil().setSp(20)),
      ),
    );
  }

  Widget _filterTitle(String name, String topImg, int index) {
    if (index == 0) {
      return Container(
        height: 120,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _filterName(name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Color(0xffB2B2B2),
                      margin: EdgeInsets.only(right: ScreenUtil().L(8)),
                      width: ScreenUtil().L(17),
                      height: ScreenUtil().L(2),
                    ),
                    Text(
                      "BEST PICKS",
                      style: TextStyle(
                          color: Color(0xffB2B2B2),
                          fontSize: ScreenUtil().L(12)),
                    ),
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
            Positioned(
              child: Container(
                color: Color(0xffF1F1F1),
                width: ScreenUtil.screenWidth,
                height: ScreenUtil().L(1),
              ),
              bottom: 0,
            )
          ],
        ),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 1,
            color: Color(0xffD8D8D8),
          ),
          Container(
            height: 10,
            color: Color(0xffF1F1F1),
          ),
          Container(
              height: 78,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().L(8)),
                    color: Color(0xffB2B2B2),
                    width: ScreenUtil().L(17),
                    height: ScreenUtil().L(2),
                  ),
                  _filterName(name),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil().L(8)),
                    color: Color(0xffB2B2B2),
                    width: ScreenUtil().L(17),
                    height: ScreenUtil().L(2),
                  )
                ],
              )),
          Image.asset(
            topImg,
            fit: BoxFit.fill,
            width: double.infinity,
            height: 200,
          )
        ],
      );
    }
  }

  Widget _listItem(BuildContext context, int index) {
    List<GoodsItemModel> brandList = List();
    for (int i = 0; i < 5; i++) {
      String name = "DIOR/迪奥 女士LADY DIOR 系列羊皮手提单肩斜挎包";
      String img = i % 2 == 0
          ? "/upload/img/brand/1542100089407.jpg"
          : "/upload/img/brand/1542100098705.jpg";
      double price = i % 2 == 0 ? 15632 : 8850;
      brandList.add(GoodsItemModel(name: name + "$i", img: img, price: price));
    }
    return Column(
      children: <Widget>[
        _filterTitle("包袋", "images/default_good_image.png", index),
        HorizontalGoodsListView(
          brandList,
          height: 223,
          itemWidth: ScreenUtil().L(147),
          nameMaxLine: 2,
          nameStyle: TextStyle(
              color: Colors.black,
              fontSize: ScreenUtil().setSp(9),
              fontWeight: FontWeight.w300),
          priceStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: ScreenUtil().L(14)),
          pricePadding: EdgeInsets.only(top: ScreenUtil().L(5)),
          padding: EdgeInsets.only(
              top: ScreenUtil().L(25),
              bottom: ScreenUtil().L(20),
              left: ScreenUtil().L(10),
              right: ScreenUtil().L(10)),
          itemPadding: EdgeInsets.only(right: ScreenUtil().L(10)),
          onItemClick: (data, int index) {
            ToastUtil.showToast(context, "点击了第$index 的${data.name}");
          },
        )
      ],
    );
  }

  double startDy = 0;

  List<Widget> _actions() {
    return <Widget>[
      IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: Colors.black,
          ),
          onPressed: () {
            ToastUtil.showToast(context, "收藏");
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
            context: context,
            title: "Dior",
            actions: _actions(),
            bottom: CommonAppBarBottomLine()),
        body: BaseContainer(
          isLoading: isLoading,
          child: Listener(
            onPointerDown: (event) {
              isScroll = false;
              startDy = event.position.dy;
            },
            onPointerMove: (event) {
              double dis = event.position.dy - startDy;
              if (dis.abs() > 5) isScroll = true;
            },
            child: CustomScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _topImage(),
                ),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                      child: _filter(), height: Klength.brand_filterHeight),
                  pinned: true,
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return _listItem(context, index);
                }, childCount: 10))
              ],
            ),
          ),
        ));
  }
}
