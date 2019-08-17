import 'package:json_annotation/json_annotation.dart';
part 'address.g.dart';

@JsonSerializable()
class Address {

  @JsonKey(name: 'country')
  String country;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'city')
  String city;

  @JsonKey(name: 'mobile')
  String mobile;

  @JsonKey(name: 'uid')
  int uid;

  @JsonKey(name: 'default_address')
  bool defaultAddress;

  @JsonKey(name: 'province')
  String province;

  @JsonKey(name: 'district')
  String district;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  int id;

  bool isSelected=false;

  Address(this.country,this.address,this.city,this.mobile,this.uid,this.defaultAddress,this.province,this.district,this.name,this.id,);

  factory Address.fromJson(Map<String, dynamic> srcJson) => _$AddressFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}