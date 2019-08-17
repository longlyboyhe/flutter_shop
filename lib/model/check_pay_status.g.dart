// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_pay_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckPayStatus _$CheckPayStatusFromJson(Map<String, dynamic> json) {
  return CheckPayStatus(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : PayStatus.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CheckPayStatusToJson(CheckPayStatus instance) =>
    <String, dynamic>{'result': instance.result, 'data': instance.data};

PayStatus _$PayStatusFromJson(Map<String, dynamic> json) {
  return PayStatus(
      json['have_pwd'] as bool,
      (json['balance_amount'] as num)?.toDouble(),
      (json['total_pay'] as num)?.toDouble());
}

Map<String, dynamic> _$PayStatusToJson(PayStatus instance) => <String, dynamic>{
      'have_pwd': instance.havePwd,
      'balance_amount': instance.balanceAmount,
      'total_pay': instance.totalPay
    };
