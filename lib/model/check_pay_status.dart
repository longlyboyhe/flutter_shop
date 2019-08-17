import 'package:json_annotation/json_annotation.dart';
import 'result.dart';

part 'check_pay_status.g.dart';

@JsonSerializable()
class CheckPayStatus{

  @JsonKey(name: "result")
  Result result;

  @JsonKey(name: "data")
  PayStatus data;

  CheckPayStatus(this.result, this.data);
  factory CheckPayStatus.fromJson(Map<String, dynamic> srcJson) => _$CheckPayStatusFromJson(srcJson);

}

@JsonSerializable()
class PayStatus{
  @JsonKey(name: "have_pwd")
  bool havePwd;

  @JsonKey(name: "balance_amount")
  double balanceAmount;

  @JsonKey(name: "total_pay")
  double totalPay;

  PayStatus(this.havePwd, this.balanceAmount, this.totalPay);

  factory PayStatus.fromJson(Map<String, dynamic> srcJson) => _$PayStatusFromJson(srcJson);
}