import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/string.dart';
import 'package:flutter_shop/model/Goods.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/goods_group_model.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/home/HorizontalGoodsListView.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
///
/// 分组商品组件
///
class GoodsGroupModule extends StatefulWidget {
  List<GoodsGroup> goodsGroupList;

  GoodsGroupModule(this.goodsGroupList);

  @override
  _GoodsGroupModuleState createState() => _GoodsGroupModuleState();
}

class _GoodsGroupModuleState extends State<GoodsGroupModule> with SingleTickerProviderStateMixin {
  TabController _timeTabController;
  List<Tab> timeTabs=List();
  int timeIndex=0;
  @override
  void initState() {
    super.initState();
    for(GoodsGroup group in widget.goodsGroupList){
      timeTabs.add(_timeTabBarItem(group.time));
    }
    _timeTabController =TabController(vsync: this, initialIndex: 0, length: widget.goodsGroupList.length);
    _timeTabController.animation.addListener(() {
      if (_timeTabController.indexIsChanging) {
        timeIndex=_timeTabController.index;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timeTabController.dispose();
    super.dispose();
  }


  ///今日秒杀
  Widget _spike() {
    return Container(
      color: Colors.white,
      height: ScreenUtil().L(80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(right: ScreenUtil().L(10)), child: Image.asset("images/clock.png"),),
              Text(KString.spike, style: TextStyle(color: Colors.black, fontSize: ScreenUtil().L(22), fontWeight: FontWeight.bold),)
            ],
          ),
          Text("SALE", style: TextStyle(letterSpacing: ScreenUtil().L(10), fontSize: ScreenUtil().L(12), color: Color(0xff7d7d7d)),)
        ],
      ),
    );
  }

  Widget _timeTabBarItem(String title) {
    return Tab(child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18),));
  }

  ///秒杀时间选择
  Widget _timeSelection() {
    return Stack(
      alignment: Alignment.topLeft,
      children: <Widget>[
        Container(height: ScreenUtil().L(55),),
        Container(height: ScreenUtil().L(55) - ScreenUtil().L(5), color: Colors.black,),
        Positioned(
          width: ScreenUtil.screenWidth / 6,
          height: ScreenUtil().L(55),
          left: _timeTabController.animation.value * ScreenUtil.screenWidth / 6,
          child: Image.asset(
            "images/time_selected_bg.png",
            fit: BoxFit.fill,
          ),
        ),
        TabBar(
          labelPadding: EdgeInsets.all(0),
          tabs: timeTabs,
          controller: _timeTabController,
          isScrollable: false,
          indicatorColor: Colors.transparent,
        )
      ],
    );
  }


  Widget _timeSelectionContent(int timeIndex) {
    List<Widget> widgets = List();
    widget.goodsGroupList.forEach((list) {
      List<GoodsItemModel> goodsList=List();
      if(list.goodsList!=null){
        for(Goods model in list.goodsList){
          goodsList.add(GoodsItemModel(name: model.name,id: model.id,img: model.imgUrl,discount: model.discount,price: model.price,));
        }
      }
      widgets.add(HorizontalGoodsListView(
        goodsList,
        itemWidth: ScreenUtil().L(100),
        showDiscount: true,
        nameMaxLine: 1,
        padding: EdgeInsets.only(
            top: ScreenUtil().L(25),
            bottom: ScreenUtil().L(20),
            left: ScreenUtil().L(10),
            right: ScreenUtil().L(10)),
        itemPadding: EdgeInsets.only(right: ScreenUtil().L(10)),
        onItemClick: (data, int index) {
          routePagerNavigator(context, GoodsDetailsPage(data.id));
        },
      ));
    });
    return ConstrainedBox(constraints: BoxConstraints(maxHeight: 250),
      child: IndexedStack(
        index: timeIndex,
        children: widgets,
      ),);
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _spike(),
        _timeSelection(),
        _timeSelectionContent(timeIndex)
      ],
    );
  }
}
