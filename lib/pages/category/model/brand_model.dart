import 'package:flutter_shop/widgets/suspension_listview.dart';

class BrandInfo extends ISuspensionBean {
  String firstChar;
  String brandName;
  int brandId;
  bool isSelected;

  BrandInfo({
    this.firstChar,
    this.brandName,
    this.brandId,
  });

  BrandInfo.fromJson(Map<String, dynamic> json)
      : firstChar = json['firstChar'],
        brandName = json['brandName'],
        isSelected = json['isSelected'],
        brandId = json['brandId'];

  Map<String, dynamic> toJson() => {
        'firstChar': firstChar,
        'brandName': brandName,
        'brandId': brandId,
        'isSelected': isSelected,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => firstChar;

  @override
  String toString() =>
      "BrandBean {" + " \"brandName\":\"" + brandName + "\"" + '}';
}
