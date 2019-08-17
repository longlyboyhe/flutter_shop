// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) {
  return UserInfoModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : UserInfoData.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
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

UserInfoData _$UserInfoDataFromJson(Map<String, dynamic> json) {
  return UserInfoData(
      json['user_avatar'] as String,
      json['user_email'] as String,
      json['company_id'] as int,
      json['user_mobile'] as String,
      json['user_id'] as int,
      json['company_name'] as String,
      json['property'] as int,
      json['company_code'] as String,
      json['user_nick'] as String);
}

Map<String, dynamic> _$UserInfoDataToJson(UserInfoData instance) =>
    <String, dynamic>{
      'user_avatar': instance.userAvatar,
      'user_email': instance.userEmail,
      'company_id': instance.companyId,
      'user_mobile': instance.userMobile,
      'user_id': instance.userId,
      'company_name': instance.companyName,
      'property': instance.property,
      'company_code': instance.companyCode,
      'user_nick': instance.userNick
    };
