import 'package:json_annotation/json_annotation.dart';

part 'result.g.dart';

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

  
