// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goods_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodsGroupModel _$GoodsGroupModelFromJson(Map<String, dynamic> json) {
  return GoodsGroupModel(
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

Map<String, dynamic> _$GoodsGroupModelToJson(GoodsGroupModel instance) =>
    <String, dynamic>{
      'module_id': instance.moduleId,
      'business_obj': instance.businessObj,
      'comfig_map': instance.comfigMap,
      'module_type': instance.moduleType,
      'region_id': instance.regionId
    };

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return Business((json['goods_group'] as List)
      ?.map((e) =>
          e == null ? null : GoodsGroup.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$BusinessToJson(Business instance) =>
    <String, dynamic>{'goods_group': instance.goodsGroup};

GoodsGroup _$GoodsGroupFromJson(Map<String, dynamic> json) {
  return GoodsGroup(
      (json['goods_list'] as List)
          ?.map((e) =>
              e == null ? null : Goods.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['item_ids'] as String,
      json['time'] as String,
      json['title'] as String);
}

Map<String, dynamic> _$GoodsGroupToJson(GoodsGroup instance) =>
    <String, dynamic>{
      'goods_list': instance.goodsList,
      'item_ids': instance.itemIds,
      'time': instance.time,
      'title': instance.title
    };

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config(
      json['top_tag'] as String,
      json['show_style'] as String,
      json['goods_bg_color'] as String,
      json['group_bg_color'] as String,
      json['selected_group_bg_color'] as String,
      json['group_type'] as String,
      (json['price_style'] as num)?.toDouble());
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'top_tag': instance.topTag,
      'show_style': instance.showStyle,
      'goods_bg_color': instance.goodsBgColor,
      'group_bg_color': instance.groupBgColor,
      'selected_group_bg_color': instance.selectedGroupBgColor,
      'group_type': instance.groupType,
      'price_style': instance.priceStyle
    };
