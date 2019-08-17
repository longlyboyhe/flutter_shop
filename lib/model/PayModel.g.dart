// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PayModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayModel _$PayModelFromJson(Map<String, dynamic> json) {
  return PayModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : PayData.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$PayModelToJson(PayModel instance) =>
    <String, dynamic>{'result': instance.result, 'data': instance.data};

PayData _$PayDataFromJson(Map<String, dynamic> json) {
  return PayData(
      json['have_pwd'] as bool,
      json['order_id'] as int,
      json['pay_available'] as bool,
      (json['balance_amount'] as num)?.toDouble());
}

Map<String, dynamic> _$PayDataToJson(PayData instance) => <String, dynamic>{
      'have_pwd': instance.havePwd,
      'order_id': instance.orderId,
      'pay_available': instance.payAvailable,
      'balance_amount': instance.balanceAmount
    };
