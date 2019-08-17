import 'package:json_annotation/json_annotation.dart';
import 'result.dart';
part 'my_order_model.g.dart';

@JsonSerializable()
class MyOrderModel extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
   Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  MyOrderModel(
    this.result,
    this.data,
    this.success,
    this.version,
  );

  factory MyOrderModel.fromJson(Map<String, dynamic> srcJson) => _$MyOrderModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyOrderModelToJson(this);

}

@JsonSerializable()
class Data{

  @JsonKey(name: 'total_page')
  int totalPage;

  @JsonKey(name: 'page_no')
  int pageNo;

  @JsonKey(name: 'page_size')
  int pageSize;

  @JsonKey(name: 'data')
  List<Order> data;


  Data(this.totalPage, this.pageNo, this.pageSize, this.data);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);
}

@JsonSerializable()
class Order extends Object {
  @JsonKey(name: 'status_code')
  int statusCode;

  @JsonKey(name: 'real_pay')
  double realPay;

  @JsonKey(name: 'tax')
  double tax;

  @JsonKey(name: 'deliver_fee')
  double deliverFee;

  @JsonKey(name: 'available_api')
  List<String> availableApi;

  @JsonKey(name: 'total_pay')
  double totalPay;

  @JsonKey(name: 'deliver_type')
  int deliverType;

  @JsonKey(name: 'sendtime_type')
  int sendtimeType;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'parent_id')
  int parentId;

  @JsonKey(name: 'spu_id')
  int spuId;

  @JsonKey(name: 'vendor_id')
  int vendorId;

  @JsonKey(name: 'choose_warehouse_id')
  int chooseWarehouseId;

  @JsonKey(name: 'order_item_list')
  List<Order_item_list> orderItemList;

  @JsonKey(name: 'ware_house_name')
  String wareHouseName;

  @JsonKey(name: 'status_msg')
  String statusMsg;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'warehouse_id')
  int warehouseId;

  Order(
    this.statusCode,
    this.realPay,
    this.tax,
    this.deliverFee,
    this.availableApi,
    this.totalPay,
    this.deliverType,
    this.sendtimeType,
    this.userId,
    this.parentId,
    this.vendorId,
    this.chooseWarehouseId,
    this.orderItemList,
    this.wareHouseName,
    this.statusMsg,
    this.id,
    this.warehouseId,
  );

  factory Order.fromJson(Map<String, dynamic> srcJson) =>
      _$OrderFromJson(srcJson);

  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

@JsonSerializable()
class Order_item_list extends Object {
  @JsonKey(name: 'discount_price')
  double discountPrice;

  @JsonKey(name: 'product_brand_id')
  int productBrandId;

  @JsonKey(name: 'product_code')
  String productCode;

  @JsonKey(name: 'product_category_id')
  int productCategoryId;

  @JsonKey(name: 'is_commented')
  int isCommented;

  @JsonKey(name: 'spu_id')
  int spuId;

  @JsonKey(name: 'product_id')
  int productId;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'vendor_type')
  int vendorType;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'tax')
  double tax;

  @JsonKey(name: 'now_price')
  double nowPrice;

  @JsonKey(name: 'area_type')
  int areaType;

  @JsonKey(name: 'presale')
  int presale;

  @JsonKey(name: 'product_name')
  String productName;

  @JsonKey(name: 'product_img')
  String productImg;

  @JsonKey(name: 'vendor_id')
  int vendorId;

  @JsonKey(name: 'order_id')
  int orderId;

  @JsonKey(name: 'sku_spec')
  List<Sku_spec> skuSpec;

  //只取规格里面的两个属性
  String getSpcAttr() {
    String spc = "";
    if (skuSpec != null && skuSpec.length > 0) {
      for (int i = 0; i < skuSpec.length; i++) {
        spc += skuSpec[i].value;
        if (i >= 1) {
          break;
        }
        spc += " | ";
      }
    }
    return spc;
  }

  Order_item_list(
    this.discountPrice,
    this.productBrandId,
    this.productCode,
    this.productCategoryId,
    this.isCommented,
    this.productId,
    this.id,
    this.vendorType,
    this.quantity,
    this.tax,
    this.nowPrice,
    this.areaType,
    this.presale,
    this.productName,
    this.productImg,
    this.vendorId,
    this.orderId,
    this.spuId,
    this.skuSpec,
  );

  factory Order_item_list.fromJson(Map<String, dynamic> srcJson) =>
      _$Order_item_listFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Order_item_listToJson(this);
}

@JsonSerializable()
class Sku_spec extends Object {
  @JsonKey(name: 'spec_value_id')
  int specValueId;

  @JsonKey(name: 'is_affect_img')
  int isAffectImg;

  @JsonKey(name: 'spec_id')
  int specId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'value')
  String value;

  Sku_spec(
    this.specValueId,
    this.isAffectImg,
    this.specId,
    this.name,
    this.value,
  );

  factory Sku_spec.fromJson(Map<String, dynamic> srcJson) =>
      _$Sku_specFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Sku_specToJson(this);
}
