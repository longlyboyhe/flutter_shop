import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/Goods.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/ad_model.dart';
import 'package:flutter_shop/model/goods_group_model.dart';
import 'package:flutter_shop/model/goods_model.dart';
import 'package:flutter_shop/model/home_resp.dart';
import 'package:flutter_shop/model/link.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/pages/home/GoodsGroupModule.dart';
import 'package:flutter_shop/pages/search/SearchResult.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/home/HorizontalGoodsListView.dart';
import 'package:flutter_shop/widgets/search/FilterBar.dart';

///
/// 首页-主页
/// @author longlyboyhe
/// @date 2019/1/15
///
class HomeItemPage extends StatefulWidget {
  @override
  _HomeItemPageState createState() => _HomeItemPageState();
}

class BottomModel {
  String img;
  List<GoodsItemModel> list;
  Link link;
  BottomModel(this.img, this.list,this.link);
}

class _HomeItemPageState extends State<HomeItemPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeItemPage> {
  TabController _timeTabController;
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  List<Widget> widgets=List();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _connectorHeaderKey = GlobalKey<RefreshHeaderState>();
  var headerView;
  void loadData() {
    HttpManager().get(context,Api.CMS, (json){
      HomeResp resp=HomeResp.fromJson(json);
      if(resp.result!=null && resp.result.isSuccess){
        //成功
        handleResp(resp);
      }
      isShowEmptyView=widgets.isEmpty;
      if(mounted){
        setState(() {
          isLoading = false;
        });
      }
    },params: {
      "page_no":"1",
      "page_type":"1",
      "page_size":"100",
    },errorCallback: (error){
      if(mounted){
        isLoading = false;
        isShowLoadError=true;
      }
    });
  }

  void handleResp(HomeResp resp) {
    if(resp.data!=null &&resp.data.modules!=null){
      widgets.clear();
      for(Map<String,dynamic> map in resp.data.modules){
        switch(map["module_type"]){
          case "c-img-ad":
          //广告图
            handleBanner(map);
            break;
          case "c-group-goods":
          //商品分组
            handleGoodsGroup(map);
            break;
          case "c-goods-module":
            handlerGoodsModule(map);
            break;
        }
      }
    }
  }

  void handleBanner(Map<String, dynamic> map) {
    AdModel adModel= AdModel.fromJson(map);
    if(adModel!=null &&adModel.businessObj!=null && adModel.businessObj.list!=null){
      widgets.add(banner(adModel.businessObj.list));
    }
  }

  void handleGoodsGroup(Map<String, dynamic> map) {
    GoodsGroupModel goodsModel= GoodsGroupModel.fromJson(map);
    if(goodsModel!=null && goodsModel.businessObj!=null && goodsModel.businessObj.goodsGroup!=null){
      widgets.add(GoodsGroupModule(goodsModel.businessObj.goodsGroup));
    }
  }


  ///顶部banner
  Widget banner(List<AdImage> bannerList) {
    if(bannerList==null){
      return null;
    }
    Widget widget;
    if(bannerList.length==1){
      widget=GestureDetector(
        child: FadeInImage(
            placeholder: AssetImage("images/default_good_image.png"),
            fit: BoxFit.cover,
            image: NetworkImage((bannerList[0].imgUrl))),
        onTap: (){
          checkRoute(bannerList[0].link);
        },
      );
    }else{
      widget=Swiper(
        itemBuilder: (BuildContext context, int index) {
          return  FadeInImage(
              placeholder: AssetImage("images/default_good_image.png"),
              fit: BoxFit.cover,
              image: NetworkImage((bannerList[index].imgUrl),));
        },
        itemHeight: ScreenUtil().L(226),
        itemCount: bannerList.length,
        pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Color(0x80000000),
                activeColor: Color(0xff000000),
                size: ScreenUtil().L(10),
                activeSize: ScreenUtil().L(10),
                space: ScreenUtil().L(5)),
            margin: EdgeInsets.only(bottom: ScreenUtil().L(17))),
        autoplay: true,
        duration: 150,
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        onTap: (index) {
          ToastUtil.showToast(context, "点击了第$index个条目");
          checkRoute(bannerList[index].link);
        },
      );
    }


    return Container(
        color: Color(0xfff1f1f1),
        height: ScreenUtil().L(326) + ScreenUtil().L(10),
        padding: EdgeInsets.only(bottom: ScreenUtil().L(10)),
        child: widget);
  }

  void checkRoute(Link link) {
    if(link!=null){
      switch(link.type){
        case "BrandGoodsList":
          //TODO 跳转到品牌馆
          routePagerNavigator(context, SearchResult(searchType:SearchType.brand,id:link.content!=null?int.parse(link.content):0));
          break;
        case "GoodsList":
        //TODO 跳转到分类页面
          routePagerNavigator(context, SearchResult(searchType:SearchType.category,id:link.content!=null?int.parse(link.content):0));
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    headerView = OrderUtil.getRefreshHeaderView();
    loadData();
  }

  @override
  void dispose() {
    _timeTabController?.dispose();
    super.dispose();
  }

  Widget goodsItem(context, i, List<BottomModel> goodsList) {
   Widget widget= HorizontalGoodsListView(
      goodsList[i].list,
      showDiscount: true,
      nameMaxLine: 1,
      itemWidth: ScreenUtil().L(100),
      padding: EdgeInsets.only(
          top: ScreenUtil().L(25),
          bottom: ScreenUtil().L(20),
          left: ScreenUtil().L(10),
          right: ScreenUtil().L(10)),
      itemPadding: EdgeInsets.only(right: ScreenUtil().L(10)),
      onItemClick: (data, int index) {
        routePagerNavigator(context,GoodsDetailsPage(data.id));
      },
    );
    return Column(
      children: <Widget>[
        Container(
          color: Color(0xfff1f1f1),
          height: ScreenUtil().L(10),
        ),
        Offstage(
          offstage: goodsList[i].img==null || goodsList[i].img.isEmpty,
          child: GestureDetector(
            onTap: (){
              //TODO 商品主题图点击
              checkRoute(goodsList[i].link);
            },
            child: FadeInImage(
                placeholder: AssetImage("images/default_good_image.png"),
                fit: BoxFit.cover,
                height:  ScreenUtil().L(160),
                image: NetworkImage(StringUtils.getImageUrl(goodsList[i].img))),
          ),
        ),
        Offstage(
          offstage: goodsList[i].list==null || goodsList[i].list.length==0,
          child: widget,
        )
      ],
    );
  }

  Widget goodsWidget(List<BottomModel> goodsList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemCount: goodsList.length,
      itemBuilder: (context, i) => goodsItem(context, i,goodsList),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseContainer(
      isLoading: isLoading,
      showLoadError: isShowLoadError,
      showEmpty: isShowEmptyView,
      reLoad: (){
        isLoading = true;
        loadData();
      },
      child: EasyRefresh(
        key: _easyRefreshKey,
        onRefresh: (){
          loadData();
        },
        refreshHeader: ConnectorHeader(
          key: _connectorHeaderKey,
          header: headerView,
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(delegate: SliverChildListDelegate(<Widget>[headerView])),
            SliverList(
                delegate: SliverChildListDelegate([Column(children: widgets)]))
          ],
          physics: BouncingScrollPhysics(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void handlerGoodsModule(Map<String, dynamic> map) {
    GoodsModel model=GoodsModel.fromJson(map);
    List<GoodsItemModel> list = List();
    if(model.businessObj.goodsList!=null){
      for(Goods goods in model.businessObj.goodsList){
        list.add(GoodsItemModel(name: goods.name, img: goods.imgUrl, price: goods.price,id: goods.spuId,discount: goods.discount));
      }
    }
    String themeImage;
    if(model.comfigMap!=null && model.comfigMap.isTheme){
      themeImage=model.comfigMap.themeImg;
    }
    List<BottomModel> goodsList = List();
    goodsList.add(BottomModel(themeImage, list,model.comfigMap.link));
    widgets.add(goodsWidget(goodsList));
  }
}
