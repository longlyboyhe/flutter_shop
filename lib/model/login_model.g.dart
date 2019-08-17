// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginModel _$LoginModelFromJson(Map<String, dynamic> json) {
  return LoginModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['version'] as String);
}

Map<String, dynamic> _$LoginModelToJson(LoginModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'version': instance.version
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['token'] == null
          ? null
          : Token.fromJson(json['token'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataToJson(Data instance) =>
    <String, dynamic>{'user': instance.user, 'token': instance.token};

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['company_id'] as int, json['user_id'] as int,
      json['user_name'] as String, json['company_name'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'company_id': instance.companyId,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'company_name': instance.companyName
    };

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(json['access_token'] as String, json['refresh_token'] as String,
      json['expiration'] as String, json['token_type'] as String);
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expiration': instance.expiration,
      'token_type': instance.tokenType
    };
