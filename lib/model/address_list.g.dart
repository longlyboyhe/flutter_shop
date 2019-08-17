// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressListResp _$AddressListRespFromJson(Map<String, dynamic> json) {
  return AddressListResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Address.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$AddressListRespToJson(AddressListResp instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };
