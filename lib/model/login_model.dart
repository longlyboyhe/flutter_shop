import 'package:json_annotation/json_annotation.dart';
import 'result.dart';
part 'login_model.g.dart';


@JsonSerializable()
  class LoginModel extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'version')
  String version;

  LoginModel(this.result,this.data,this.version,);

  factory LoginModel.fromJson(Map<String, dynamic> srcJson) => _$LoginModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginModelToJson(this);

}


@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'user')
  User user;

  @JsonKey(name: 'token')
  Token token;

  Data(this.user,this.token,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}


@JsonSerializable()
  class User extends Object {

  @JsonKey(name: 'company_id')
  int companyId;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'user_name')
  String userName;

  @JsonKey(name: 'company_name')
  String companyName;

  User(this.companyId,this.userId,this.userName,this.companyName,);

  factory User.fromJson(Map<String, dynamic> srcJson) => _$UserFromJson(srcJson);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}


@JsonSerializable()
  class Token extends Object {

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  @JsonKey(name: 'expiration')
  String expiration;

  @JsonKey(name: 'token_type')
  String tokenType;


  Token(this.accessToken,this.refreshToken,this.expiration,this.tokenType,);

  factory Token.fromJson(Map<String, dynamic> srcJson) => _$TokenFromJson(srcJson);

  Map<String, dynamic> toJson() => _$TokenToJson(this);

}


