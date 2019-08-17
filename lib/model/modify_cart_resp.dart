import 'package:json_annotation/json_annotation.dart'; 
import 'result.dart';
import 'cart_resp.dart';
part 'modify_cart_resp.g.dart';


@JsonSerializable()
  class ModifyCartResp extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Cart data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  ModifyCartResp(this.result,this.data,this.success,this.version,);

  factory ModifyCartResp.fromJson(Map<String, dynamic> srcJson) => _$ModifyCartRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ModifyCartRespToJson(this);

}


  
