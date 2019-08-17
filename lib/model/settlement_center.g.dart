// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_center.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettlementCenterResp _$SettlementCenterRespFromJson(Map<String, dynamic> json) {
  return SettlementCenterResp(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : SettlementData.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$SettlementCenterRespToJson(
        SettlementCenterResp instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

SettlementData _$SettlementDataFromJson(Map<String, dynamic> json) {
  return SettlementData(
      (json['total_pay'] as num)?.toDouble(),
      json['deliver_type'] as int,
      (json['real_pay'] as num)?.toDouble(),
      json['deliver_fee'] as int,
      json['tax'] as int,
      json['item_size'] as int,
      (json['vendor_list'] as List)
          ?.map((e) =>
              e == null ? null : Vendor.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SettlementDataToJson(SettlementData instance) =>
    <String, dynamic>{
      'total_pay': instance.totalPay,
      'deliver_type': instance.deliverType,
      'real_pay': instance.realPay,
      'deliver_fee': instance.deliverFee,
      'tax': instance.tax,
      'item_size': instance.itemSize,
      'vendor_list': instance.vendorList
    };

Vendor _$VendorFromJson(Map<String, dynamic> json) {
  return Vendor(
      json['cart_size'] as int,
      (json['cart_list'] as List)
          ?.map((e) =>
              e == null ? null : Cart.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['ware_house_name'] as String);
}

Map<String, dynamic> _$VendorToJson(Vendor instance) => <String, dynamic>{
      'cart_size': instance.cartSize,
      'cart_list': instance.cartList,
      'ware_house_name': instance.wareHouseName
    };
