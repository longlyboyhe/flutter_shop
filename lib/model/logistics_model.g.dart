// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogisticsModel _$LogisticsModelFromJson(Map<String, dynamic> json) {
  return LogisticsModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$LogisticsModelToJson(LogisticsModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      json['msg'] as String, json['code'] as int, json['is_success'] as bool);
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'is_success': instance.isSuccess
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['code'] as int,
      json['data'] == null
          ? null
          : Data2.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'code': instance.code, 'data': instance.data};

Data2 _$Data2FromJson(Map<String, dynamic> json) {
  return Data2(
      json['express_num'] as String,
      (json['track_detail_list'] as List)
          ?.map((e) => e == null
              ? null
              : Track_detail_list.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['express_status_str'] as String,
      json['id'] as int,
      json['version'] as int,
      json['express_base'] == null
          ? null
          : Express_base.fromJson(
              json['express_base'] as Map<String, dynamic>));
}

Map<String, dynamic> _$Data2ToJson(Data2 instance) => <String, dynamic>{
      'express_num': instance.expressNum,
      'track_detail_list': instance.trackDetailList,
      'express_status_str': instance.expressStatusStr,
      'id': instance.id,
      'version': instance.version,
      'express_base': instance.expressBase
    };

Track_detail_list _$Track_detail_listFromJson(Map<String, dynamic> json) {
  return Track_detail_list(
      json['date'] as String,
      json['track_id'] as String,
      json['id'] as int,
      json['time'] as String,
      json['version'] as String,
      json['content'] as String);
}

Map<String, dynamic> _$Track_detail_listToJson(Track_detail_list instance) =>
    <String, dynamic>{
      'date': instance.date,
      'track_id': instance.trackId,
      'id': instance.id,
      'time': instance.time,
      'version': instance.version,
      'content': instance.content
    };

Express_base _$Express_baseFromJson(Map<String, dynamic> json) {
  return Express_base(json['name'] as String);
}

Map<String, dynamic> _$Express_baseToJson(Express_base instance) =>
    <String, dynamic>{'name': instance.name};
