import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CustomRectSwiperPaginationBuilder.dart';
import 'package:flutter_shop/widgets/home/HorizontalGoodsListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///
/// 首页
/// @author longlyboyhe
/// @date 2019/1/2
///
class HomePage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage1>
    with AutomaticKeepAliveClientMixin<HomePage1> {
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  void loadData() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  //TODO 假数据
  List<GoodsItemModel> topList = List();
  List<GoodsItemModel> list = List();
  List<GoodsItemModel> staggeredList = List();

  Widget _swiperBuilder(BuildContext context, int index) {
    return Image.asset(
      topList[index].img,
      fit: BoxFit.fill,
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
    topList.add(GoodsItemModel(name: "name1", img: "images/bg.jpeg"));
    topList.add(GoodsItemModel(name: "name2", img: "images/bg1.jpg"));
    topList.add(GoodsItemModel(name: "name3", img: "images/bg2.jpg"));
    for (int i = 0; i < 5; i++) {
      list.add(GoodsItemModel(
          name: "name$i", img: "images/bg.jpeg", price: 15632));
    }
    staggeredList.add(GoodsItemModel(name: "name1", img: "images/bg.jpeg"));
    staggeredList
        .add(GoodsItemModel(name: "name1", img: "images/cusomer_service.png"));
    staggeredList.add(
        GoodsItemModel(name: "name1", img: "images/cangxuan_selected.png"));
    staggeredList.add(
        GoodsItemModel(name: "name1", img: "images/category_selected.png"));
    staggeredList.add(GoodsItemModel(name: "name1", img: "images/bg1.jpg"));
    staggeredList.add(
        GoodsItemModel(name: "name1", img: "images/gouwuche_selected.png"));
    staggeredList
        .add(GoodsItemModel(name: "name1", img: "images/home_selected.png"));
    staggeredList.add(GoodsItemModel(name: "name1", img: "images/bg2.jpg"));
    staggeredList.add(GoodsItemModel(name: "name1", img: "images/bg1.jpg"));
    staggeredList.add(GoodsItemModel(name: "name1", img: "images/bg.jpeg"));
    staggeredList
        .add(GoodsItemModel(name: "name1", img: "images/mine_selected.png"));
    staggeredList
        .add(GoodsItemModel(name: "name1", img: "images/home_selected.png"));
    staggeredList.add(
        GoodsItemModel(name: "name1", img: "images/cangxuan_selected.png"));
  }

  Widget _centerSelection() {
    return Container(
      width: MediaQuery.of(context).size.width - 15 - 15,
      color: Colors.white,
      margin: EdgeInsets.only(left: 15, right: 15),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _centerSelectionItem("images/home_selected.png", "箱包手袋"),
          _centerSelectionItem("images/cangxuan_selected.png", "时尚饰品"),
          _centerSelectionItem("images/category_selected.png", "男士服装"),
          _centerSelectionItem("images/gouwuche_selected.png", "服饰配件"),
        ],
      ),
    );
  }

  Widget _centerSelectionItem(String img, String name) {
    return Column(
      children: <Widget>[
        Image.asset(
          img,
          width: 35,
          height: 35,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            name,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
        )
      ],
    );
  }

  Widget _centerTitleItem(String name,
      {bool showRightIcon, GestureTapCallback onTap}) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              name,
              style: TextStyle(color: Colors.black, fontSize: 15),
            )),
            GestureDetector(
              onTap: onTap,
              child: Offstage(
                offstage: showRightIcon != null && !showRightIcon,
                child: Row(
                  children: <Widget>[
                    Text(
                      "ALL",
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget _buildImageItem(GoodsItemModel model) {
    return Container(
      color: Colors.indigoAccent,
      child: Image.asset(model.img),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("homepage build");
    return Scaffold(
      key: ObjectKey("HomePage"),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "DISLUX",
          style: const TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: "AbrilFatface"),
        ),
        actions: <Widget>[
          IconButton(
              icon: Image.asset(
                "images/cusomer_service.png",
                width: 20,
                height: 20,
              ),
              onPressed: () {
                ToastUtil.showToast(context, "点击了服务");
              }),
          IconButton(
              icon: Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () {
                ToastUtil.showToast(context, "点击了搜索");
              })
        ],
      ),
      body: BaseContainer(
        isLoading: isLoading,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 15),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 60),
                    height: (300.0 + 60),
                    color: Colors.grey[200],
                    child: Swiper(
                      itemBuilder: _swiperBuilder,
                      itemWidth: 300,
                      itemCount: topList.length,
                      pagination: SwiperPagination(
                          builder: CustomRectSwiperPaginationBuilder(
                              color: Colors.white,
                              activeColor: Colors.white,
                              size: Size(5, 4),
                              activeSize: Size(12, 4),
                              space: 2),
                          margin: EdgeInsets.only(bottom: 55)),
                      autoplay: true,
                      duration: 150,
                      controller: SwiperController(),
                      scrollDirection: Axis.horizontal,
                      onTap: (index) {
                        routePagerNavigator(context, GoodsDetailsPage(5221406));
                        //ToastUtil.showToast(context, "点击了第$index个条目");
                      },
                    ),
                  ),
                  Positioned(
                    child: _centerSelection(),
                    bottom: 15,
                  )
                ],
              ),
              _centerTitleItem("今日推荐"),
              HorizontalGoodsListView(
                list,
                height: 100,
                itemWidth: 100,
                showMoreButton: true,
                itemPadding: EdgeInsets.only(left: 5, right: 5),
                onItemClick: (data, int index) {
                  ToastUtil.showToast(context, "点击了第$index条数据,${data.name}");
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                color: Colors.grey[200],
                height: 10,
              ),
              _centerTitleItem("品牌动态"),
              Container(
                height: 350,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Swiper(
                  outer: true,
                  layout: SwiperLayout.STACK,
                  itemBuilder: _swiperBuilder,
                  itemWidth: 250,
                  itemCount: topList.length,
                  pagination: SwiperPagination(
                      builder: CustomRectSwiperPaginationBuilder(
                          color: Colors.grey,
                          activeColor: Colors.grey[700],
                          size: Size(5, 4),
                          activeSize: Size(12, 4),
                          space: 2),
                      margin: EdgeInsets.only(top: 15)),
                  autoplay: true,
                  duration: 150,
                  controller: SwiperController(),
                  scrollDirection: Axis.horizontal,
                  onTap: (index) {
                    ToastUtil.showToast(context, "点击了第$index个条目");
                  },
                ),
              ),
              _centerTitleItem("品牌馆", showRightIcon: false),
              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                itemCount: staggeredList.length,
                itemBuilder: (BuildContext context, int index) =>
                    _buildImageItem(staggeredList.elementAt(index)),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
