import 'result.dart';
import 'category.dart';
import 'package:json_annotation/json_annotation.dart';

part 'want_to_buy_category.g.dart';

@JsonSerializable()
class WantToBuyCategoryResp{

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  List<Category> data;

  @JsonKey(name: 'version')
  String version;

  WantToBuyCategoryResp(this.result,this.data,this.version,);

  factory WantToBuyCategoryResp.fromJson(Map<String, dynamic> srcJson) => _$WantToBuyCategoryRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$WantToBuyCategoryRespToJson(this);

}