import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/constants/length.dart';
import 'package:flutter_shop/pages/home/HomeItemBrandChoice.dart';
import 'package:flutter_shop/pages/home/HomeItemPage.dart';
import 'package:flutter_shop/pages/home/HomeItemRankPage.dart';
import 'package:flutter_shop/pages/message/MessageCenter.dart';
import 'package:flutter_shop/pages/search/Search.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/NumberTip.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 首页
/// @author longlyboyhe
/// @date 2019/1/10
///
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Widget _tabBarItem(String title, {bool showRightImage = true}) {
  return Tab(
      child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Expanded(
        child: Center(
          child: Text(title),
        ),
      ),
      showRightImage
          ? Text('/', style: TextStyle(color: Color(0xffd0d0d0), fontSize: 23))
          : Text(' ', style: TextStyle(color: Color(0xffd0d0d0), fontSize: 23))
    ],
  ));
}

class _HomePageState extends State<HomePage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<HomePage> {
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    _tabBarItem(KString.homeAppBarTitles[0]),
    _tabBarItem(KString.homeAppBarTitles[1]),
    _tabBarItem(KString.homeAppBarTitles[2], showRightImage: false),
    _tabBarItem(KString.homeAppBarTitles[3], showRightImage: false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _searchWidget() {
    return GestureDetector(
      onTap: () {
        routePagerNavigator(context, Search());
      },
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().L(23))),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xffd8d8d8),
                      offset: Offset(0, 1),
                      blurRadius: 8),
                ]),
            margin: EdgeInsets.only(
                left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
            padding: EdgeInsets.only(
                left: ScreenUtil().L(16),
                top: ScreenUtil().L(12),
                bottom: ScreenUtil().L(12),
                right: ScreenUtil().L(15)),
            height: Klength.home_searchtHeight,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    KString.homeSearchText,
                    style: TextStyle(
                        color: Color(0xffCFCFCF), fontSize: ScreenUtil().L(14)),
                  ),
                ),
                Image.asset("images/icon_search.png")
              ],
            ),
          )),
          RawMaterialButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: () {
              goToMessageCenter();
            },
            constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(right: 12, top: 6, left: 8, bottom: 6),
                  child: Text(
                    "消息",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Positioned(
                    top: 2,
                    right: 8,
                    child: NumberTip(
                      radius: 4,
                      alwaysShow: 5 > 0,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void goToMessageCenter() {
    routePagerNavigator(context, MessageCenter()).then((value) {
      //TODO 重置消息数量
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: BlankAppBar(
        brightness: Brightness.light,
        backgroundColor: KColor.bgColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 13),
            child: _searchWidget(),
          ),
          TabBar(
            labelPadding: EdgeInsets.only(bottom: 7),
            tabs: myTabs,
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.black,
            indicatorColor: KColor.yellowColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorPadding: EdgeInsets.only(left: 10, bottom: 11, right: 17),
            unselectedLabelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Expanded(
              child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  children: <Widget>[
                Container(
                  color: Colors.white,
                  child: HomeItemPage(),
                ),
//                HomeItemNew(),
                Container(
                  color: Colors.white,
                  child: HomeItemBrandChoice(),
                ),
                Container(
                  color: Colors.white,
                  child: HomeItemRankPage(),
                ),
              ])),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
