import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter/material.dart';

import 'brand1.dart';
import 'classification.dart';

/**
 * 分类页
 * @author longlyboyhe
 * @date 2018/12/19
 */
class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryState();
  }
}

//搜索框
class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: FlatButton(
        onPressed: () {
          ToastUtil.showToast(context, "点击搜索啦");
        },
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
            Text(
              "分类 品牌 系列 商品",
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryState extends State<Category>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Category> {
  TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    new Tab(text: '分类'),
    new Tab(text: '品牌'),
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

  @override
  Widget build(BuildContext context) {
    print("category build");
    return Container(
      key: ObjectKey("Category"),
      color: Colors.white,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15),
          ),
          //头部tabbar
          Container(
            width: 130,
            height: 40.0,
            child: TabBar(
              tabs: myTabs,
              controller: _tabController,
              isScrollable: false,
              labelColor: Colors.black,
              indicatorColor: Color(0xFFF8A120),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              indicatorPadding: EdgeInsets.only(bottom: 5),
              unselectedLabelColor: Colors.black26,
              labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          // 搜索框
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 20),
            child: SearchWidget(),
          ),

          //Content
          Expanded(
            child: TabBarView(controller: _tabController, children: <Widget>[
              Classification(),
              Brand(),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
