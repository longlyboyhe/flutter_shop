import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/HomeRankModel.dart';
import 'package:flutter_shop/model/goods_model.dart';
import 'package:flutter_shop/model/home_resp.dart';
import 'package:flutter_shop/pages/goods/GoodsDetailsPage.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/CommonEndLine.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';

///
/// 首页-爆款排行
/// @author longlyboyhe
/// @date 2019/1/30
///
class HomeItemRankPage extends StatefulWidget {
  @override
  _HomeItemRankPageState createState() => _HomeItemRankPageState();
}

class _HomeItemRankPageState extends State<HomeItemRankPage>
    with AutomaticKeepAliveClientMixin<HomeItemRankPage> {
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  bool isLoading = true; //筛选
  bool empty = false;

  int page = 1;
  int maxPage=1;
  bool noMoreDataGood = false; //数据加载完毕

  void loadData() async {
    HttpManager().get(context,Api.CMS, (json){
      try{
        HomeResp resp=HomeResp.fromJson(json);
        isLoading = false;
        if(resp.result!=null && resp.result.isSuccess){
          //成功
          handleResp(resp);
        }else{
          //失败
          isShowLoadError=true;
        }
      }catch(e){
        isShowLoadError=true;
      }
      if (mounted) {
        setState(() {
        });
      }
    },params: {
      "page_no":page.toString(),
      "page_type":"3",
      "page_size":"20",
    },errorCallback: (error){
      setState(() {
        isShowLoadError=true;
        isLoading = false;
      });
    });
  }

  ///筛选列表
  List<HomeRankItemModel> goodsList = List();

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  GlobalKey<EasyRefreshState> _easyRefreshKey = GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _connectorFooterKey =GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    super.initState();
    loadData();
  }


  Widget _listItem(HomeRankItemModel model) {
    return GestureDetector(
      onTap: () {
        routePagerNavigator(context, GoodsDetailsPage(model.id));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            boxShadow: [
              BoxShadow(color: Color(0xffd8d8d8), offset: Offset(0, 1), blurRadius: 8),
            ]),
        margin: EdgeInsets.only(bottom: ScreenUtil().L(10)),
        padding: EdgeInsets.only(top: ScreenUtil().L(16), bottom: ScreenUtil().L(20), left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
                placeholder: AssetImage("images/default_good_image.png"),
                fit: BoxFit.cover,
                width: ScreenUtil().L(210),
                height: ScreenUtil().L(210),
                image: NetworkImage(StringUtils.getImageUrl(model.img))
            ),
            Text(
              model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text(
                "￥${model.price}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Color(0xFFC10000), fontWeight: FontWeight.w500, fontSize: 14),
              ),
              model.tipPrice == null
                  ? Container()
                  : Padding(
                  padding: EdgeInsets.only(left: ScreenUtil().L(10)),
                  child: Text(
                    "￥${model.tipPrice}",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12, decoration: TextDecoration.lineThrough),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
            ]),
            Container(
              margin: EdgeInsets.only(top: ScreenUtil().L(5)),
              padding: EdgeInsets.only(left: ScreenUtil().L(53), right: ScreenUtil().L(53), top: ScreenUtil().L(5), bottom: ScreenUtil().L(5)),
              decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black45, width: 1.0)),
              child: Text(
                "SHOP NOW >",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 8),
              ),
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
      showLoadError: isShowLoadError,
      showEmpty: empty,
      reLoad: (){
        loadData();
      },
      child: EasyRefresh(
        key: _easyRefreshKey,
        autoControl: false,
        refreshFooter: ConnectorFooter(key: _connectorFooterKey, footer: footer),
        loadMore: isLoading || noMoreDataGood ? null : () async {
          page++;
          if(page>maxPage){
            _easyRefreshKey.currentState.callLoadMoreFinish();
            if(page==1 ){
              noMoreDataGood=goodsList.length>2;
            }else{
              noMoreDataGood=true;
            }
            setState(() {
            });
            return;
          }
          loadData();
        },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(top: ScreenUtil().L(10), bottom: ScreenUtil().L(15), left: ScreenUtil().L(25), right: ScreenUtil().L(25)),
              sliver: SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                return _listItem(goodsList[index]);
              }, childCount: goodsList.length)),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                goodsList != null && goodsList.length >= 20
                    ? noMoreDataGood ? CommonEndLine() : footer
                    : Container()
              ]),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void handleResp(HomeResp resp) {
    if (resp.data != null && resp.data.modules != null) {
      if(page==1){
        goodsList.clear();
      }
      for (Map<String, dynamic> map in resp.data.modules) {
        switch (map["module_type"]) {
          case "c-goods-module":
            handlerGoodsModule(map);
            break;
        }
      }
      maxPage=resp.data.pageTotal;
      _easyRefreshKey.currentState.callLoadMoreFinish();
      setState(() {
      });
    }
  }

  void handlerGoodsModule(Map<String, dynamic> map) {
    GoodsModel model=GoodsModel.fromJson(map);
    var list = model.businessObj.goodsList;
    if(list!=null){
      list.forEach((goods){
        goodsList.add(HomeRankItemModel(name: goods.name,img: goods.imgUrl,price: goods.price,id: goods.spuId,tipPrice: goods.marketPrice));
      });
    }
    empty=goodsList.length==0;
  }
}
