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
import 'package:flutter_shop/widgets/address/CustomeCupertinoPicker.dart';
import 'package:flutter_shop/widgets/address/modal/base_citys.dart';
import 'package:flutter_shop/widgets/address/src/mod/inherit_process.dart';

import '../../modal/point.dart';
import '../../modal/result.dart';
import '../show_types.dart';

class BaseView extends StatefulWidget {
  final double progress;
  final String locationCode;
  final ShowType showType;
  final Map<String, dynamic> provincesData;
  final Map<String, dynamic> citiesData;

  // 容器高度
  final double height;

  BaseView({
    this.progress,
    this.showType,
    this.height,
    this.locationCode,
    this.citiesData,
    this.provincesData,
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
  List<Point> provinces;
  CityTree cityTree;

  Point targetProvince;
  Point targetCity;
  Point targetArea;

  @override
  void initState() {
    super.initState();
    provinces = new Provinces(metaInfo: widget.provincesData).provinces;
    cityTree = new CityTree(metaInfo: widget.citiesData);
    _initLocation(widget.locationCode);
    _initController();
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
    provinceController = new FixedExtentScrollController(
        initialItem:
            provinces.indexWhere((Point p) => p.code == targetProvince.code));

    cityController = new FixedExtentScrollController(
        initialItem: targetProvince.child
            .indexWhere((Point p) => p.code == targetCity.code));

    areaController = new FixedExtentScrollController(
        initialItem: targetCity.child
            .indexWhere((Point p) => p.code == targetArea.code));
  }

  // 重置Controller的原因在于, 无法手动去更改initialItem, 也无法通过
  // jumpTo or animateTo去更改, 强行更改, 会触发 _onProvinceChange  _onCityChange 与 _onAreacChange
  // 只为覆盖初始化化的参数initialItem
  void _resetController() {
    if (_resetControllerOnce) return;
    provinceController = new FixedExtentScrollController(initialItem: 0);

    cityController = new FixedExtentScrollController(initialItem: 0);
    areaController = new FixedExtentScrollController(initialItem: 0);
    _resetControllerOnce = true;
  }

  // initialize tree by locationCode
  void _initLocation(String locationCode) {
    int _locationCode;
    if (locationCode != null) {
      try {
        _locationCode = int.parse(locationCode);
      } catch (e) {
        print(ArgumentError(
            "The Argument locationCode must be valid like: '100000' but get '$locationCode' "));
        return;
      }

      targetProvince = cityTree.initTreeByCode(_locationCode);

      targetProvince.child.forEach((Point _city) {
        if (_city.code == _locationCode) {
          targetCity = _city;
          targetArea = _city.child.first ?? null;
        }
        _city.child.forEach((Point _area) {
          if (_area.code == _locationCode) {
            targetCity = _city;
            targetArea = _area;
          }
        });
      });
    } else {
      targetProvince = cityTree.initTreeByCode(110000);
    }

    if (targetCity == null) {
      targetCity = targetProvince.child.first ?? Point();
    }
    if (targetArea == null) {
      targetArea = targetCity.child.first ?? Point();
    }
  }

  // 通过选中的省份, 构建以省份为根节点的树型结构
  List<String> getCityItemList() {
    List<String> result = [];
    if (targetProvince != null) {
      result.addAll(targetProvince.child.toList().map((p) => p.name).toList());
    }
    return result;
  }

  List<String> getAreaItemList() {
    List<String> result = [];

    if (targetCity != null) {
      result.addAll(targetCity.child.toList().map((p) => p.name).toList());
    }
    return result;
  }

  // province change handle
  // 加入延时处理, 减少构建树的消耗
  _onProvinceChange(Point _province) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      Point _provinceTree =
          cityTree.initTree(int.parse(_province.code.toString()));
      setState(() {
        targetProvince = _provinceTree;
        if (_provinceTree.child.isNotEmpty) {
          targetCity = _provinceTree.child.first;
        }
        if (targetCity.child.isNotEmpty) {
          targetArea = targetCity.child.first;
        }
        _resetController();
      });
    });
  }

  _onCityChange(Point _targetCity) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        targetCity = _targetCity;
      });
    });
    _resetController();
  }

  _onAreaChange(Point _targetArea) {
    if (_changeTimer != null && _changeTimer.isActive) {
      _changeTimer.cancel();
    }
    _changeTimer = new Timer(Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() {
        targetArea = _targetArea;
      });
    });
  }

  Result _buildResult() {
    Result result = Result();
    ShowType showType = widget.showType;
    if (showType.contain(ShowType.p)) {
      result.provinceId = targetProvince.code.toString();
      result.provinceName = targetProvince.name;
    }
    if (showType.contain(ShowType.c)) {
      result.provinceId = targetProvince.code.toString();
      result.provinceName = targetProvince.name;
      result.cityId = targetCity.code.toString();
      result.cityName = targetCity.name;
    }
    if (showType.contain(ShowType.a)) {
      result.provinceId = targetProvince.code.toString();
      result.provinceName = targetProvince.name;
      result.cityId = targetCity.code.toString();
      result.cityName = targetCity.name;
      result.areaId = targetArea.code.toString();
      result.areaName = targetArea.name;
    }
    // 台湾异常数据. 需要过滤
    if (result.provinceId == "710000") {
      result.cityId = null;
      result.cityName = null;
      result.areaId = null;
      result.areaName = null;
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
                      child: Text('确定',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                      constraints:
                          BoxConstraints(minWidth: 10.0, minHeight: 10.0),
                    ))),
            Padding(
              //TODO 左右距离个50，小手机可能会出现截断（待测试）
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Row(
                children: <Widget>[
                  _MyCityPicker(
                    key: Key('province'),
                    isShow: widget.showType.contain(ShowType.p),
                    height: widget.height,
                    controller: provinceController,
                    value: targetProvince.name,
                    itemList: provinces.toList().map((v) => v.name).toList(),
                    changed: (index) {
                      _onProvinceChange(provinces[index]);
                    },
                  ),
                  _MyCityPicker(
                    key: Key('citys $targetProvince'),
                    // 这个属性是为了强制刷新
                    isShow: widget.showType.contain(ShowType.c),
                    controller: cityController,
                    height: widget.height,
                    value: targetCity.name,
                    itemList: getCityItemList(),
                    changed: (index) {
                      _onCityChange(targetProvince.child[index]);
                    },
                  ),
                  _MyCityPicker(
                    key: Key('towns $targetCity'),
                    isShow: widget.showType.contain(ShowType.a),
                    controller: areaController,
                    value: targetArea.name,
                    height: widget.height,
                    itemList: getAreaItemList(),
                    changed: (index) {
                      _onAreaChange(targetCity.child[index]);
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
    return new AnimatedBuilder(
      animation: route.animation,
      builder: (BuildContext context, Widget child) {
        return new CustomSingleChildLayout(
          delegate: _WrapLayout(
              progress: route.animation.value, height: widget.height),
          child: new GestureDetector(
            child: new Material(
              color: Colors.transparent,
              child:
                  new Container(width: double.infinity, child: _bottomBuild()),
            ),
          ),
        );
      },
    );
  }
}

class _MyCityPicker extends StatefulWidget {
  final List<String> itemList;
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    '${widget.itemList[index]}',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
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
