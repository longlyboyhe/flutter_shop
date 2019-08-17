import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/index_bar.dart';
import 'package:flutter_shop/pages/category/model/brand_model.dart';
import 'package:flutter_shop/widgets/suspension_listview.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter/material.dart';

/**
 * 分类->品牌（字母索引）
 * @author longlyboyhe
 * @date 2018/12/19
 */
class Brand extends StatefulWidget {
  //是否是筛选（点击条目变色）
  bool isFilter = false;

  Brand({this.isFilter});

  @override
  State<StatefulWidget> createState() {
    return _BrandListRouteState();
  }
}

class _BrandListRouteState extends State<Brand>
    with AutomaticKeepAliveClientMixin<Brand> {
  List<BrandInfo> _contacts = List();

  int _suspensionHeight = 50;
  int _itemHeight = 40;
  String _suspensionTag = ""; //分割线

  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    //加载联系人列表
    HttpManager.instance.post(context,Api.BRAND_LIST_FORCHAR, (json) {
      int code = json['result'];
      String msg = json['msg'];
      List data = json['data'];

      if (data != null && data.length > 0) {
        data.forEach((value) {
          _contacts.add(BrandInfo(
              brandName: value['brandName'],
              firstChar: value['firstChar'],
              brandId: value['brandId']));
        });
      } else {
        print("code=$code  msg=$msg  ");
        isShowEmptyView = true;
      }

      setState(() {
        _suspensionTag = _contacts[0].getSuspensionTag();
        isLoading = false;
      });
    }, errorCallback: (errorMsg) {
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
              style: TextStyle(
                  color: model.isSelected == true
                      ? Colors.black
                      : Color(0xFFBCBCBC),
                  fontWeight: FontWeight.w400,
                  fontSize: ScreenUtil().Sp(12)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () {
              //是打开筛选进入的
              if (widget.isFilter != null && widget.isFilter) {
                setState(() {
                  setSelected(model);
                });
              } else {
                ToastUtil.showToast(context, "OnItemClick: ${model.brandName}");
              }
            },
          ),
        )
      ],
    );
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
      child: QuickSelectListView(
        data: _contacts,
        itemBuilder: (context, model) => _buildListItem(model),
        isUseRealIndex: false,
        itemHeight: _itemHeight,
        suspensionHeight: _suspensionHeight,
        //保留分割线
        onSusTagChanged: _onSusTagChanged,
        suspensionWidget: _buildSusWidget(_suspensionTag),
        indexBarBuilder: (BuildContext context, List<String> tags,
            IndexBarTouchCallback onTouch, String curTag) {
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
            child: Text(hint,
                style: TextStyle(color: Colors.white, fontSize: 30.0)),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
