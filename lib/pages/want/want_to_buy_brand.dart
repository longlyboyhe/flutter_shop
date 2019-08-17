import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/model/RecommendModel.dart';
import 'package:flutter_shop/pages/category/model/brand_model.dart';
import 'package:flutter_shop/pages/search/SearchResult.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/index_bar.dart';
import 'package:flutter_shop/widgets/suspension_listview.dart';

/**
 * 分类->品牌（字母索引）
 * @author longlyboyhe
 * @date 2018/12/19
 */
class WantToBuyBrand extends StatefulWidget {
  //是否是筛选（点击条目变色）
  bool isFilter;
  final ValueChanged<BrandInfo> selectedId;
  final bool showInput;

  WantToBuyBrand({this.isFilter = false, this.selectedId,this.showInput=false});

  @override
  State<StatefulWidget> createState() {
    return _BrandListRouteState();
  }
}

class _BrandListRouteState extends State<WantToBuyBrand> with AutomaticKeepAliveClientMixin<WantToBuyBrand> {
  List<BrandInfo> _contacts = List();
  List<BrandInfo> tempList = List();

  int _suspensionHeight = 50;
  int _itemHeight = 40;
  String _suspensionTag = ""; //分割线

  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载

  TextEditingController controller;
  @override
  void initState() {
    super.initState();
    if(widget.showInput){
      controller=TextEditingController();
    }
    loadData();
  }

  void onTextChange(String value) {
    if(value.isEmpty){
      tempList=_contacts;
    }else{
      //输入框变化
      tempList=_contacts.where((BrandInfo info){
        return info.brandName.contains(value);
      }).toList();
    }
    setState(() {
    });
  }

  void loadData() async {
    //加载联系人列表
    Map<String, String> params = {'ids': ""};
    HttpManager.instance.get(context,Api.BRAND_LIST_FORCHAR, (json) {
          List data = json['data'];
          if (data != null && data.length > 0) {
            data.forEach((value) {
              _contacts.add(BrandInfo(
                  brandName: "${value['cn_name']}/${value['en_name']}",
                  firstChar: value['initial'],
                  brandId: value['id']));
            });
          } else {
            isShowEmptyView = true;
          }
          tempList=_contacts;
          setState(() {
            _suspensionTag = _contacts[0].getSuspensionTag();
            isLoading = false;
          });
        },
        params: params,
        errorCallback: (errorMsg) {
          setState(() {
            isLoading = false;
            isShowLoadError = true;
          });
        });
  }

  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  //分割线
  Widget _buildSusWidget(String susTag) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().L(20)),
        color: Colors.white,
        height: _suspensionHeight.toDouble(),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$susTag',
                softWrap: false,
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(20),
                  color: Color(0xff1D1E1F),
                ),
              ),
            )),
            Container(
              height: 1,
              color: KColor.bgColor,
            )
          ],
        ));
  }

  Container getInput() {
    return Container(
      height: ScreenUtil().L(30),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 13),
      child: TextField(
        autofocus: false,
        controller: controller,
        onChanged: onTextChange,
        style: TextStyle(
            fontSize: 12,
            color: Colors.black
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 15, top: 6, bottom: 6, right: 15),
          hintText: "搜索品牌",
          fillColor: Color(0xFFF1F1F1),
          filled: true,
          suffixIcon: Icon(Icons.search, color: Colors.black54, size: 20,),
          hintStyle: TextStyle(
              color: Color(0xFFA9A9A9),
              fontSize: 12
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(
              color: Color(0xFFF1F1F1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                color: Color(0xFFF1F1F1),
              )),
        ),
      ),
    );
  }

  Widget _buildListItem(BrandInfo model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(
              model.brandName,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: ScreenUtil().Sp(12)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () {
              //是打开筛选进入的
              if (widget.isFilter != null && widget.isFilter) {
                setState(() {
                  //TODO 回调选择的品牌
                  if (widget.selectedId != null)
                    widget.selectedId(model);
                });
              } else {
                searchData(model.brandName);
              }
            },
          ),
        )
      ],
    );
  }

  void searchData(String text) async {
    rootBundle.loadString("datas/recommends.json").then((value) {
      setState(() {
        RecommendModel recommendModel =RecommendModel.fromJson(jsonDecode(value));
        List<GoodsItemModel> result = List();
        result.addAll(recommendModel.data);
        routePagerNavigator(context, SearchResult(searchText: text));
      });
    });
  }

  void setSelected(BrandInfo model) {
    _contacts.forEach((brand) {
      if (model.brandName == brand.brandName) {
        brand.isSelected = true;
      } else {
        brand.isSelected = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> list=List();
    if(widget.showInput){
      list.add(getInput());
    }
    list.add(getContentWidget());
    return BaseContainer(
      isLoading: isLoading,
      showEmpty: isShowEmptyView,
      showLoadError: isShowLoadError,
      reLoad: () {
        setState(() {
          isLoading = true;
          loadData();
        });
      },
      child: Column(
        children: list,
      )
    );
  }

  Expanded getContentWidget() {
    return Expanded(
      child:QuickSelectListView(
        data: tempList,
        itemBuilder: (context, model) => _buildListItem(model),
        isUseRealIndex: false,
        itemHeight: _itemHeight,
        suspensionHeight: _suspensionHeight,
        //保留分割线
        onSusTagChanged: _onSusTagChanged,
        suspensionWidget: _buildSusWidget(_suspensionTag),
        indexBarBuilder: (BuildContext context, List<String> tags,IndexBarTouchCallback onTouch, String curTag) {
          return Container(
            padding: EdgeInsets.only(top: _suspensionHeight.toDouble()),
            child: IndexBar(
              data: tags,
              curTag: curTag,
              onTouch: (details) {
                onTouch(details);
              },
            ),
          );
        },
        indexHintBuilder: (context, hint) {
          return Container(
            alignment: Alignment.center,
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: Colors.grey[700].withAlpha(200),
              shape: BoxShape.circle,
            ),
            child: Text(hint, style: TextStyle(color: Colors.white, fontSize: 30.0)),
          );
        },
      )
  );
  }

  @override
  bool get wantKeepAlive => true;
}
