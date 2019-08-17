import 'result.dart';
import 'package:json_annotation/json_annotation.dart';
part 'PayModel.g.dart';

@JsonSerializable()
class PayModel extends Object{

  @JsonKey(name: "result")
  Result result;

  @JsonKey(name: "data")
  PayData data;

  PayModel(this.result, this.data);

  factory PayModel.fromJson(Map<String, dynamic> srcJson) => _$PayModelFromJson(srcJson);
}


@JsonSerializable()
class  PayData extends Object{

  //是否有密码
  @JsonKey(name: "have_pwd")
  bool havePwd;

  @JsonKey(name: "order_id")
  int orderId;

  //余额是不是足够
  @JsonKey(name: "pay_available")
  bool payAvailable;

  @JsonKey(name: "balance_amount")
  double balanceAmount;

  PayData(this.havePwd, this.orderId, this.payAvailable,this.balanceAmount);

  factory PayData.fromJson(Map<String, dynamic> srcJson) => _$PayDataFromJson(srcJson);
}