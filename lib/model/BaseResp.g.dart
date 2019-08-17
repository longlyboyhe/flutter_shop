// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResp _$BaseRespFromJson(Map<String, dynamic> json) {
  return BaseResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$BaseRespToJson(BaseResp instance) => <String, dynamic>{
      'result': instance.result,
      'success': instance.success,
      'version': instance.version
    };
