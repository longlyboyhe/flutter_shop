import 'package:json_annotation/json_annotation.dart';
import 'result.dart';

part 'BaseResp.g.dart';

@JsonSerializable()
class BaseResp{

  @JsonKey(name: "result")
  Result result;

  @JsonKey(name: "success")
  bool success;

  @JsonKey(name: "version")
  String version;

  BaseResp(this.result,this.success,this.version);

  factory BaseResp.fromJson(Map<String, dynamic> srcJson) => _$BaseRespFromJson(srcJson);

}