// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResp _$HomeRespFromJson(Map<String, dynamic> json) {
  return HomeResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$HomeRespToJson(HomeResp instance) => <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['total'] as int,
      json['page_total'] as int,
      json['page_no'] as int,
      (json['modules'] as List)
          ?.map((e) => e as Map<String, dynamic>)
          ?.toList(),
      json['page_size'] as int);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'total': instance.total,
      'page_total': instance.pageTotal,
      'page_no': instance.pageNo,
      'modules': instance.modules,
      'page_size': instance.pageSize
    };
