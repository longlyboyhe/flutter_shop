import 'package:flutter_shop/widgets/address/modal/point.dart';

import '../meta/province.dart';
import '../src/util.dart';
//import 'package:lpinyin/lpinyin.dart';

/// tree point

class CityTree {
  /// build cityTrees's meta, it can be changed bu developers
  Map<String, dynamic> metaInfo;
  Cache _cache = new Cache();
  Point tree;

  /// @param metaInfo city and areas meta describe
  CityTree({this.metaInfo = citiesData});

  /// build tree by int provinceId,
  /// @param provinceId this is province id
  /// @return tree
  initTree(int provinceId) {
    String _cacheKey = provinceId.toString();
    if (_cache.has(_cacheKey)) {
      return tree = _cache.get(_cacheKey);
    }

    String name = provincesData[provinceId.toString()];
    var root =
        new Point(code: provinceId, child: [], name: name);
    tree = _buildTree(root, metaInfo[provinceId.toString()], metaInfo);
    _cache.set(_cacheKey, tree);
    return tree;
  }

  /// this is a private function, used the return to get a correct tree contain cities and areas
  /// @param code one of province city or area id;
  /// @return provinceId return id which province's child contain code
  int _getProvinceByCode(int code) {
    String _code = code.toString();
    List<String> keys = citiesData.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String key = keys[i];
      Map<String, dynamic> child = citiesData[key];
      if (child.containsKey(_code)) {
        // 当前元素的父key在省份内
        if (provincesData.containsKey(key)) {
          return int.parse(key);
        }
        return _getProvinceByCode(int.parse(key));
      }
    }
    return null;
  }

  /// build tree by any code provinceId or cityCode or areaCode
  /// @param code build a tree
  /// @return Point a province with its cities and areas tree
  Point initTreeByCode(int code) {
    String _code = code.toString();
    if (provincesData[_code] != null) {
      return initTree(code);
    }
    int provinceId = _getProvinceByCode(code);
    if (provinceId != null) {
      return initTree(provinceId);
    }
    return null;
  }

  /// private function
  /// recursion to build tree
  Point _buildTree(Point target, Map citys, Map meta) {
    if (citys == null || citys.isEmpty) {
      return target;
    } else {
      List<String> keys = citys.keys.toList();

      for (int i = 0; i < keys.length; i++) {
        String key = keys[i];
        Map value = citys[key];
        Point _point = new Point(
          code: int.parse(key),
          child: [],
          name: value['name'],
        );
        if (citys.keys.length == 1) {
          if (target.code.toString() == citys.keys.first) {
            continue;
          }
        }

        _point = _buildTree(_point, meta[key], meta);
        target.addChild(_point);
      }
    }
    return target;
  }
}

/// Province Class
class Provinces {
  Map<String, String> metaInfo;

  Provinces({this.metaInfo = provincesData});

  // 获取省份数据
  get provinces {
    List<Point> provList = [];
    List<String> keys = metaInfo.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      String name = metaInfo[keys[i]];
      provList.add(Point(
          code: int.parse(keys[i]),
          name: name));
    }
    return provList;
  }
}
