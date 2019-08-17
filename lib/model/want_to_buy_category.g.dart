// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'want_to_buy_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WantToBuyCategoryResp _$WantToBuyCategoryRespFromJson(
    Map<String, dynamic> json) {
  return WantToBuyCategoryResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Category.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['version'] as String);
}

Map<String, dynamic> _$WantToBuyCategoryRespToJson(
        WantToBuyCategoryResp instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'version': instance.version
    };
