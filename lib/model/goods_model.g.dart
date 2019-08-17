// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsModel _$GoodsModelFromJson(Map<String, dynamic> json) {
  return GoodsModel(
      json['module_id'] as int,
      json['business_obj'] == null
          ? null
          : Business.fromJson(json['business_obj'] as Map<String, dynamic>),
      json['comfig_map'] == null
          ? null
          : Config.fromJson(json['comfig_map'] as Map<String, dynamic>),
      json['module_type'] as String,
      json['region_id'] as int);
}

Map<String, dynamic> _$GoodsModelToJson(GoodsModel instance) =>
    <String, dynamic>{
      'module_id': instance.moduleId,
      'business_obj': instance.businessObj,
      'comfig_map': instance.comfigMap,
      'module_type': instance.moduleType,
      'region_id': instance.regionId
    };

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return Business(
      (json['goods_list'] as List)
          ?.map((e) =>
              e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['search_data'] == null
          ? null
          : SearchData.fromJson(json['search_data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$BusinessToJson(Business instance) => <String, dynamic>{
      'goods_list': instance.goodsList,
      'search_data': instance.searchData
    };

SearchData _$SearchDataFromJson(Map<String, dynamic> json) {
  return SearchData(json['item_ids'] as String);
}

Map<String, dynamic> _$SearchDataToJson(SearchData instance) =>
    <String, dynamic>{'item_ids': instance.itemIds};

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
      json['top_tag'] as String,
      json['is_theme'] as bool,
      json['theme_img'] as String,
      json['show_style'] as String,
      json['goods_bg_color'] as String,
      (json['price_style'] as num)?.toDouble())
    ..link = json['link'] == null
        ? null
        : Link.fromJson(json['link'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'top_tag': instance.topTag,
      'is_theme': instance.isTheme,
      'theme_img': instance.themeImg,
      'show_style': instance.showStyle,
      'goods_bg_color': instance.goodsBgColor,
      'link': instance.link,
      'price_style': instance.priceStyle
    };
