// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      json['country'] as String,
      json['address'] as String,
      json['city'] as String,
      json['mobile'] as String,
      json['uid'] as int,
      json['default_address'] as bool,
      json['province'] as String,
      json['district'] as String,
      json['name'] as String,
      json['id'] as int)
    ..isSelected = json['isSelected'] as bool;
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'country': instance.country,
      'address': instance.address,
      'city': instance.city,
      'mobile': instance.mobile,
      'uid': instance.uid,
      'default_address': instance.defaultAddress,
      'province': instance.province,
      'district': instance.district,
      'name': instance.name,
      'id': instance.id,
      'isSelected': instance.isSelected
    };
