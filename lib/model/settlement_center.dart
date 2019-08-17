import 'package:json_annotation/json_annotation.dart'; 
import 'result.dart';
import 'cart_resp.dart';
part 'settlement_center.g.dart';


@JsonSerializable()
  class SettlementCenterResp extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  SettlementData data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  SettlementCenterResp(this.result,this.data,this.success,this.version,);

  factory SettlementCenterResp.fromJson(Map<String, dynamic> srcJson) => _$SettlementCenterRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SettlementCenterRespToJson(this);

}

  
@JsonSerializable()
  class SettlementData extends Object {

  @JsonKey(name: 'total_pay')
  double totalPay;

  @JsonKey(name: 'deliver_type')
  int deliverType;

  @JsonKey(name: 'real_pay')
  double realPay;

  @JsonKey(name: 'deliver_fee')
  int deliverFee;

  @JsonKey(name: 'tax')
  int tax;

  @JsonKey(name: 'item_size')
  int itemSize;

  @JsonKey(name: 'vendor_list')
  List<Vendor> vendorList;

  SettlementData(this.totalPay,this.deliverType,this.realPay,this.deliverFee,this.tax,this.itemSize,this.vendorList,);

  factory SettlementData.fromJson(Map<String, dynamic> srcJson) => _$SettlementDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SettlementDataToJson(this);

}

  
@JsonSerializable()
  class Vendor extends Object {

  @JsonKey(name: 'cart_size')
  int cartSize;

  @JsonKey(name: 'cart_list')
  List<Cart> cartList;

  @JsonKey(name: 'ware_house_name')
  String wareHouseName;

  Vendor(this.cartSize,this.cartList,this.wareHouseName);

  factory Vendor.fromJson(Map<String, dynamic> srcJson) => _$VendorFromJson(srcJson);

  Map<String, dynamic> toJson() => _$VendorToJson(this);

}

 

  
