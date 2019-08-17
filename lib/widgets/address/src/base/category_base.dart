/**
 * Created with Android Studio.
 * User: 三帆
 * Date: 28/01/2019
 * Time: 18:20
 * email: sanfan.hx@alibaba-inc.com
 * tartget:  xxx
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/widgets/address/CustomeCupertinoPicker.dart';
import 'package:flutter_shop/widgets/address/modal/category_result.dart';
import 'package:flutter_shop/widgets/address/src/mod/inherit_process.dart';

import '../../modal/result.dart';
import '../show_types.dart';

class BaseView extends StatefulWidget {
  final double progress;
  final String locationCode;
  final ShowType showType;
  final List<Category> datasList;

  // 容器高度
  final double height;

  BaseView({
    this.progress,
    this.showType,
    this.height,
    this.locationCode,
    this.datasList,
  });

  _BaseView createState() => _BaseView();
}

class _BaseView extends State<BaseView> {
  Timer _changeTimer;
  bool _resetControllerOnce = false;
  FixedExtentScrollController provinceController;
  FixedExtentScrollController cityController;
  FixedExtentScrollController areaController;

  // 所有省的列表. 因为性能等综合原因,
  // 没有一次性构建整个以国为根的树. 动态的构建以省为根的树, 效率高.
//  List<Point> provinces;
//  CityTree cityTree;

  Category targetProvince;
  Category targetCity;
  Category targetArea;

  @override
  void initState() {
    super.initState();
    _initController();
    targetProvince = widget.datasList[0];
    if(targetProvince!=null && targetProvince.list!=null && targetProvince.list.length>0){
      targetCity = targetProvince.list[0];
    }
    if(targetCity!=null && targetCity.list!=null && targetCity.list.length>0){
      targetArea = targetCity.list[0];
    }

  }

  void dispose() {
    provinceController.dispose();
    cityController.dispose();
    areaController.dispose();
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    super.dispose();
  }

  // 初始化controller, 为了使给定的默认值, 在选框的中心位置
  void _initController() {
    provinceController = new FixedExtentScrollController(initialItem: 0);
    cityController = new FixedExtentScrollController(initialItem: 0);
    areaController = new FixedExtentScrollController(initialItem: 0);
  }

  // 重置Controller的原因在于, 无法手动去更改initialItem, 也无法通过
  // jumpTo or animateTo去更改, 强行更改, 会触发 _onProvinceChange  _onCityChange 与 _onAreacChange
  // 只为覆盖初始化化的参数initialItem
  void _resetController() {
    if (_resetControllerOnce) return;
//    provinceController = new FixedExtentScrollController(initialItem: 0);
    cityController = new FixedExtentScrollController(initialItem: 0);
    areaController = new FixedExtentScrollController(initialItem: 0);
    _resetControllerOnce = true;
  }

  // 通过选中的省份, 构建以省份为根节点的树型结构
  List<Category> getCityItemList() {
    List<Category> result = [];
    if (targetProvince != null && targetProvince.list != null) {
      print("_MyCityPickerState  ${targetProvince.list.toString()}");
      result.addAll(targetProvince.list);
    }
    return result;
  }

  List<Category> getAreaItemList() {
    List<Category> result = [];
    if (targetCity != null && targetCity.list != null) {
      result.addAll(targetCity.list);
    }
    return result;
  }

  // province change handle
  // 加入延时处理, 减少构建树的消耗
  _onProvinceChange(Category _province) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      setState(() {
        targetProvince = _province;
        var list = targetProvince.list;
        if (list != null && list.length > 0) {
          targetCity = list.first;
        }else{
          targetCity=null;
        }
        if (targetCity != null && targetCity.list != null && targetCity.list.length > 0) {
          targetArea = targetCity.list.first;
        }else{
          targetArea=null;
        }
        _resetController();
      });
    });
  }

  _onCityChange(Category _targetCity) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      setState(() {
        targetCity = _targetCity;
      });
    });
    _resetController();
  }

  _onAreaChange(Category _targetArea) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        targetArea = _targetArea;
      });
    });
  }

  CategoryResult _buildResult() {
    CategoryResult result = CategoryResult();
    ShowType showType = widget.showType;
    if(showType==ShowType.pca){
      result.parentId =targetProvince != null ? targetProvince.id.toString() : "";
      result.parentName = targetProvince != null ? targetProvince.name : "";
      result.secondId = targetCity != null ? targetCity.id.toString() : "";
      result.secondName = targetCity != null ? targetCity.name : "";
      result.threeId = targetArea != null ? targetArea.id.toString() : "";
      result.threeName = targetArea != null ? targetArea.name : "";
    }else{
      if (showType.contain(ShowType.p)) {
        result.parentId =targetProvince != null ? targetProvince.id.toString() : "";
        result.parentName = targetProvince != null ? targetProvince.name : "";
      }
      if (showType.contain(ShowType.c)) {
        result.parentId =targetProvince != null ? targetProvince.id.toString() : "";
        result.parentName = targetProvince != null ? targetProvince.name : "";
        result.secondId = targetCity != null ? targetCity.id.toString() : "";
        result.secondName = targetCity != null ? targetCity.name : "";
      }
      if (showType.contain(ShowType.a)) {
        result.parentId =targetProvince != null ? targetProvince.id.toString() : "";
        result.parentName = targetProvince != null ? targetProvince.name : "";
        result.secondId = targetCity != null ? targetCity.id.toString() : "";
        result.secondName = targetCity != null ? targetCity.name : "";
        result.threeId = targetArea != null ? targetArea.id.toString() : "";
        result.threeName = targetArea != null ? targetArea.name : "";
      }
    }
    return result;
  }

  Widget _bottomBuild() {
    return new Container(
        width: double.infinity,
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Container(
                    color: Color(0xFFEBEBEB),
                    alignment: Alignment.centerRight,
                    height: 30,
                    child: RawMaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      onPressed: () {
                        Navigator.pop(context, _buildResult());
                      },
                      child: Text('确定',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12)),
                      constraints:BoxConstraints(minWidth: 10.0, minHeight: 10.0),
                    ))),
            Padding(
              //TODO 左右距离个50，小手机可能会出现截断（待测试）
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  _MyCityPicker(
                    key: Key('province'),
                    isShow: widget.showType.contain(ShowType.p),
                    height: widget.height,
                    controller: provinceController,
                    value: targetProvince.name,
                    itemList: widget.datasList,
                    changed: (index) {
                      _onProvinceChange(widget.datasList[index]);
                    },
                  ),
                  _MyCityPicker(
                    key: Key('citys $targetProvince'),
                    // 这个属性是为了强制刷新
                    isShow: widget.showType.contain(ShowType.c),
                    controller: cityController,
                    height: widget.height,
                    value: targetCity!=null?targetCity.name:"",
                    itemList: getCityItemList(),
                    changed: (index) {
                      var list = targetProvince.list;
                      if (list != null && list.length > 0) {
                        _onCityChange(list[index]);
                      }
                    },
                  ),
                  _MyCityPicker(
                    key: Key('towns $targetCity'),
                    isShow: widget.showType.contain(ShowType.a),
                    controller: areaController,
                    value: targetArea!=null?targetArea.name:"",
                    height: widget.height,
                    itemList: getAreaItemList(),
                    changed: (index) {
                      var list = targetCity.list;
                      if (list != null && list.length > 0) {
                        _onAreaChange(list[index]);
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ));
  }

  Widget build(BuildContext context) {
    final route = InheritRouteWidget.of(context).router;
    return AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) {
        return CustomSingleChildLayout(
          delegate: _WrapLayout(progress: route.animation.value, height: widget.height),
          child: GestureDetector(
            child: Material(
              color: Colors.transparent,
              child: Container(width: double.infinity, child: _bottomBuild()),
            ),
          ),
        );
      },
    );
  }
}

class _MyCityPicker extends StatefulWidget {
  final List<Category> itemList;
  final Key key;
  final String value;
  final bool isShow;
  final FixedExtentScrollController controller;
  final ValueChanged<int> changed;
  final double height;

  _MyCityPicker(
      {this.key,
      this.controller,
      this.isShow = false,
      this.changed,
      this.height,
      this.itemList,
      this.value});

  @override
  State createState() {
    return new _MyCityPickerState();
  }
}

class _MyCityPickerState extends State<_MyCityPicker> {
  List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!widget.isShow) {
      return Container();
    }
    return new Expanded(
      child: new Container(
          height: widget.height - 40,
          alignment: Alignment.center,
          child: CustomeCupertinoPicker.builder(
              magnification: 1.0,
              itemExtent: 30.0,
              diameterRatio: 5,
              showBorder: false,
              backgroundColor: Colors.white,
              scrollController: widget.controller,
              onSelectedItemChanged: (index) {
                widget.changed(index);
              },
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    '${widget.itemList[index].name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                );
              },
              childCount: widget.itemList.length)),
      flex: 1,
    );
  }
}

class _WrapLayout extends SingleChildLayoutDelegate {
  _WrapLayout({
    this.progress,
    this.height,
  });

  final double progress;
  final double height;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = height;

    return new BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_WrapLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
