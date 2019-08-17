import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/pages/category/brand.dart';
import 'package:flutter_shop/pages/category/model/ClassificationModel.dart';
import 'package:flutter_shop/pages/search/SearchResult.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/home/BrandGoodsItem.dart';
import 'package:flutter_shop/widgets/search/FilterBar.dart';

/**
 * 分类->分类
 * @author longlyboyhe
 * @date 2018/12/19
 */
class Classification extends StatefulWidget {
  bool isFilter = false;
  final SearchSelected selectedId;
  bool hasBrand;

  Classification(
      {this.isFilter = false, this.selectedId, this.hasBrand = true});

  @override
  State<StatefulWidget> createState() {
    return ClassificationState();
  }
}

class ClassificationState extends State<Classification>
    with AutomaticKeepAliveClientMixin<Classification> {
  var _body;
  int _tabIndex = 0;

  //左边目录列表
  List<ClassificationModel> leftList = List();

  //右边目录列表
  List<List<ClassificationModel>> rightList = List();

  //右边ListView集合
  List<Widget> contentPage = List();

  final tabTextStyleNormal = new TextStyle(
      color: const Color(0xFF000000),
      fontSize: 14,
      fontWeight: FontWeight.w400);
  final tabTextStyleSelected = new TextStyle(
      color: const Color(0xFF000000),
      fontSize: 14,
      fontWeight: FontWeight.w500);

  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getDataPage() {
    _body = Padding(
        padding: EdgeInsets.only(left: 10, top: 10, right: 5, bottom: 5),
        child: IndexedStack(
          children: contentPage,
          index: _tabIndex,
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() {
    Map<String, String> params = {'parent_id': '0'};
    HttpManager.instance.get(
        context,
        Api.CATEGORY,
        (json) {
          List data = json['data'];

          if (data != null && data.length > 0) {
            if (widget.hasBrand) {
              //添加品牌
              leftList.add(ClassificationModel(gcName: "品牌", gcId: -1));
              rightList.add(null);
            }
            data.forEach((value) {
              leftList.add(ClassificationModel(
                  gcName: value['cat_name'], gcId: value['cat_id']));
              rightList.add(null);
            });

            getRightData(leftList[0].gcId);
          } else {
            print("没有一级类目数据");
            if (widget.hasBrand) {
              //添加品牌
              leftList.add(ClassificationModel(gcName: "品牌", gcId: -1));
              rightList.add(null);
            }
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          setState(() {
            isLoading = false;
            isShowLoadError = true;
          });
        });
  }

  void getRightData(int parentId) {
    isLoading = true;
    isShowLoadError = false;
    isShowEmptyView = false;
    if (parentId == -1) {
      contentPage.add(Brand(
        isFilter: widget.isFilter,
        selectedId: (id) {
          if (widget.selectedId != null)
            widget.selectedId(SearchType.brand, id, "", 0, 0);
        },
      ));
      setState(() {
        isLoading = false;
      });
    } else {
      getRightListView(index) {
        if (widget.hasBrand && index == 0) {
          return Brand(
            isFilter: widget.isFilter,
            selectedId: (id) {
              if (widget.selectedId != null)
                widget.selectedId(SearchType.brand, id, "", 0, 0);
            },
          );
        } else {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: 1,
            itemBuilder: (context, i) => buildRightItem(context, i, index),
          );
        }
      }

      Map<String, String> params = {'parent_id': "$parentId"};
      List<ClassificationModel> subLists = List();

      HttpManager.instance.get(
          context,
          Api.CATEGORY_TREE,
          (json) {
            List data = json['data'];

            if (data != null && data.length > 0) {
              data.forEach((value) {
                subLists.add(ClassificationModel(
                    gcName: value['cat_name'],
                    gcId: value['cat_id'],
                    classList: value['list']));
              });
              rightList[_tabIndex] = subLists;

              contentPage.clear();
              for (int i = 0; i < rightList.length; i++) {
                contentPage.add(getRightListView(i));
              }
            } else {
              print("没有二级类目数据");
              isShowEmptyView = true;
            }

            setState(() {
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
  }

  buildRightItem(BuildContext context, int i, int index) {
    var widgets = List<Widget>();
    var contentList = rightList[index];
    if (contentList != null && contentList.length > 0) {
      for (int i = 0; i < contentList.length; i++) {
        ClassificationModel model = contentList[i];
        widgets.add(rightListTitle(model));
//        if (model.classList != null && model.classList.length > 0) {
//          widgets.add(rightListTitle(model));
//        }
      }
    }
    return Column(
      children: widgets,
    );
  }

  Widget rightListTitle(ClassificationModel rightList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            rightList.gcName,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
        rightList.classList != null && rightList.classList.length > 0
            ? GridView.count(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: rightList.classList.map((classificationlistmodel) {
                  return _getGridViewItem(context, classificationlistmodel);
                }).toList(),
              )
            : Container(),
      ],
    );
  }

  Widget _getGridViewItem(BuildContext context, classificationlistmodel) {
    GoodsItemModel model = GoodsItemModel(
        id: classificationlistmodel['cat_id'],
        conditions: classificationlistmodel['conditions'],
        name: classificationlistmodel['cat_name'],
        img: classificationlistmodel['image_url']);
    return BrandGoodsItem(
      model,
      onlyImg: false,
      showOldPrice: false,
      onTap: (data, index) {
        //是打开筛选进入的
        if (widget.isFilter != null && widget.isFilter) {
          setState(() {
            // 回调选择的品牌
            if (widget.selectedId != null)
              widget.selectedId(SearchType.category, model.id, "", 0, 0);
          });
        } else {
          //类目有三级类目
          routePagerNavigator(
              context,
              SearchResult(
                searchType: SearchType.categorys,
                searchText: model.name,
                conditions: model.conditions,
              ));
        }
      },
    );
  }

  Widget buildLeftItem(context, i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tabIndex = i;
          //防止重复请求数据
          if (i == 0 ||
              rightList != null &&
                  rightList[i] != null &&
                  rightList[i].length > 0) {
            isShowEmptyView = false;
            isShowLoadError = false;
          } else {
            getRightData(leftList[i].gcId);
          }
        });
      },
      child: Container(
        height: ScreenUtil().L(50),
        color: _tabIndex == i ? Colors.white : KColor.bgColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(leftList[i].gcName,
                    style: _tabIndex == i
                        ? tabTextStyleSelected
                        : tabTextStyleNormal),
                _tabIndex == i
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        width: 25,
                        height: 3,
                        color: KColor.yellowColor,
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 5),
                        width: 25,
                        height: 3,
                        color: KColor.bgColor,
                      ),
              ],
            ),
            Positioned(
                width: ScreenUtil().L(70),
                bottom: 0,
                child: Container(
                  height: 1,
                  color: KColor.dividerColor,
                ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getDataPage();
    Widget leftListView = ListView.builder(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(0),
      itemCount: leftList.length,
      itemBuilder: (context, i) => buildLeftItem(context, i),
    );
    return BaseContainer(
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenUtil().L(70),
            color: Colors.grey[200],
            child: leftListView,
          ),
          Expanded(
            flex: 1,
            child: BaseContainer(
              isLoading: isLoading,
              showEmpty: isShowEmptyView,
              showLoadError: isShowLoadError,
              reLoad: () {
                if (leftList != null &&
                    leftList.length > 0 &&
                    leftList.length >= _tabIndex) {
                  isLoading = true;
                  isShowLoadError = false;
                  getRightData(leftList[_tabIndex].gcId);
                } else {
                  isLoading = true;
                  isShowLoadError = false;
                  getData();
                }
              },
              child: _body,
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
