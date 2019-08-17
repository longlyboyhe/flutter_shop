// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modify_cart_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifyCartResp _$ModifyCartRespFromJson(Map<String, dynamic> json) {
  return ModifyCartResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Cart.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$ModifyCartRespToJson(ModifyCartResp instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };
