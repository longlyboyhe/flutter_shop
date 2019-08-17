import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_shop/model/link.dart';
import 'Goods.dart';
part 'goods_model.g.dart';

///
/// 商品组件数据模型
///
@JsonSerializable()
class GoodsModel extends Object{

  @JsonKey(name: 'module_id')
  int moduleId;

  @JsonKey(name: 'business_obj')
  Business businessObj;

  @JsonKey(name: 'comfig_map')
  Config comfigMap;

  @JsonKey(name: 'module_type')
  String moduleType;

  @JsonKey(name: 'region_id')
  int regionId;

  GoodsModel(this.moduleId,this.businessObj,this.comfigMap,this.moduleType,this.regionId,);

  factory GoodsModel.fromJson(Map<String, dynamic> srcJson) => _$GoodsModelFromJson(srcJson);

}


@JsonSerializable()
  class Business extends Object{

  @JsonKey(name: 'goods_list')
  List<Goods> goodsList;

  @JsonKey(name: 'search_data')
  SearchData searchData;

  Business(this.goodsList,this.searchData,);

  factory Business.fromJson(Map<String, dynamic> srcJson) => _$BusinessFromJson(srcJson);

}


@JsonSerializable()
class SearchData extends Object {

  @JsonKey(name: 'item_ids')
  String itemIds;

  SearchData(this.itemIds,);

  factory SearchData.fromJson(Map<String, dynamic> srcJson) => _$SearchDataFromJson(srcJson);

}


@JsonSerializable()
class Config extends Object {

  @JsonKey(name: 'top_tag')
  String topTag;

  @JsonKey(name: 'is_theme')
  bool isTheme;

  @JsonKey(name: 'theme_img')
  String themeImg;

  @JsonKey(name: 'show_style')
  String showStyle;

  @JsonKey(name: 'goods_bg_color')
  String goodsBgColor;

  @JsonKey(name: 'link')
  Link link;

  @JsonKey(name: 'price_style')
  double priceStyle;

  Config(this.topTag,this.isTheme,this.themeImg,this.showStyle,this.goodsBgColor,this.priceStyle,);

  factory Config.fromJson(Map<String, dynamic> srcJson) => _$ConfigFromJson(srcJson);

}





