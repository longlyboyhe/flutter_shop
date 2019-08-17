import 'package:json_annotation/json_annotation.dart';

part 'user_info_model.g.dart';


@JsonSerializable()
class UserInfoModel extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  UserInfoData data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  UserInfoModel(this.result,this.data,this.success,this.version,);

  factory UserInfoModel.fromJson(Map<String, dynamic> srcJson) => _$UserInfoModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

}


@JsonSerializable()
class Result extends Object {

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'is_success')
  bool isSuccess;

  Result(this.msg,this.code,this.isSuccess,);

  factory Result.fromJson(Map<String, dynamic> srcJson) => _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);

}


@JsonSerializable()
class UserInfoData extends Object {

  @JsonKey(name: 'user_avatar')
  String userAvatar;

  @JsonKey(name: 'user_email')
  String userEmail;

  @JsonKey(name: 'company_id')
  int companyId;

  @JsonKey(name: 'user_mobile')
  String userMobile;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'company_name')
  String companyName;
  //1线下实体  2线上分销
  @JsonKey(name: 'property')
  int property;

  @JsonKey(name: 'company_code')
  String companyCode;

  @JsonKey(name: 'user_nick')
  String userNick;

  UserInfoData(this.userAvatar,this.userEmail,this.companyId,this.userMobile,this.userId,this.companyName,this.property,this.companyCode,this.userNick,);

  factory UserInfoData.fromJson(Map<String, dynamic> srcJson) => _$UserInfoDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserInfoDataToJson(this);

}


