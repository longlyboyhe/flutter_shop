// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdModel _$AdModelFromJson(Map<String, dynamic> json) {
  return AdModel(
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

Map<String, dynamic> _$AdModelToJson(AdModel instance) => <String, dynamic>{
      'module_id': instance.moduleId,
      'business_obj': instance.businessObj,
      'comfig_map': instance.comfigMap,
      'module_type': instance.moduleType,
      'region_id': instance.regionId
    };

Business _$BusinessFromJson(Map<String, dynamic> json) {
  return Business(
      (json['count'] as num)?.toDouble(),
      (json['list'] as List)
          ?.map((e) =>
              e == null ? null : AdImage.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$BusinessToJson(Business instance) =>
    <String, dynamic>{'count': instance.count, 'list': instance.list};

AdImage _$AdImageFromJson(Map<String, dynamic> json) {
  return AdImage(
      json['img_url'] as String,
      json['link'] == null
          ? null
          : Link.fromJson(json['link'] as Map<String, dynamic>),
      json['title'] as String);
}

Map<String, dynamic> _$AdImageToJson(AdImage instance) => <String, dynamic>{
      'img_url': instance.imgUrl,
      'link': instance.link,
      'title': instance.title
    };

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config((json['style_type'] as num)?.toDouble(),
      (json['ratio'] as num)?.toDouble());
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'style_type': instance.styleType,
      'ratio': instance.ratio
    };
