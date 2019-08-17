// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) {
  return BrandModel(
      json['module_id'] as num,
      json['business_obj'] == null
          ? null
          : Business.fromJson(json['business_obj'] as Map<String, dynamic>),
      json['comfig_map'] == null
          ? null
          : Comfig_map.fromJson(json['comfig_map'] as Map<String, dynamic>),
      json['module_type'] as String,
      json['region_id'] as num);
}

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'module_id': instance.moduleId,
      'business_obj': instance.businessObj,
      'comfig_map': instance.comfigMap,
      'module_type': instance.moduleType,
      'region_id': instance.regionId
    };

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return Business((json['list'] as List)
      ?.map((e) =>
          e == null ? null : BrandSelection.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$BusinessToJson(Business instance) =>
    <String, dynamic>{'list': instance.list};

BrandSelection _$BrandSelectionFromJson(Map<String, dynamic> json) {
  return BrandSelection(
      json['cn_name'] as String,
      json['change_img'] as String,
      json['background_img'] as String,
      json['en_name'] as String,
      json['logo'] as String,
      json['brand_config_map'] == null
          ? null
          : BrandConfigMap.fromJson(
              json['brand_config_map'] as Map<String, dynamic>),
      json['brand_id'] as int);
}

Map<String, dynamic> _$BrandSelectionToJson(BrandSelection instance) =>
    <String, dynamic>{
      'cn_name': instance.cnName,
      'change_img': instance.changeImg,
      'background_img': instance.backgroundImg,
      'en_name': instance.enName,
      'logo': instance.logo,
      'brand_config_map': instance.brandConfigMap,
      'brand_id': instance.brandId
    };

BrandConfigMap _$BrandConfigMapFromJson(Map<String, dynamic> json) {
  return BrandConfigMap(json['sell_point'] as String);
}

Map<String, dynamic> _$BrandConfigMapToJson(BrandConfigMap instance) =>
    <String, dynamic>{'sell_point': instance.sellPoint};

Comfig_map _$Comfig_mapFromJson(Map<String, dynamic> json) {
  return Comfig_map(json['bg_color'] as String, json['brand_type'] as int);
}

Map<String, dynamic> _$Comfig_mapToJson(Comfig_map instance) =>
    <String, dynamic>{
      'bg_color': instance.bgColor,
      'brand_type': instance.brandType
    };
