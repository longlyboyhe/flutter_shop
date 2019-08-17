///

import 'dart:convert';
/// CityPicker 返回的 **Result** 结果函数
class CategoryResult {
  /// provinceId
  String parentId;

  /// cityId
  String secondId;

  /// areaId
  String threeId;

  /// provinceName
  String parentName;

  /// cityName
  String secondName;

  /// areaName
  String threeName;

  CategoryResult({this.parentId,
    this.secondId,
    this.threeId,
    this.parentName,
    this.secondName,
    this.threeName});

}
