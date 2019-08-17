import 'package:json_annotation/json_annotation.dart';
import 'result.dart';

part 'ModifyAddress.g.dart';

@JsonSerializable()
class ModifyAddress{

  @JsonKey(name: "result")
  Result result;

  ModifyAddress(this.result);

  factory ModifyAddress.fromJson(Map<String, dynamic> srcJson) => _$ModifyAddressFromJson(srcJson);
}