// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrderModel _$MyOrderModelFromJson(Map<String, dynamic> json) {
  return MyOrderModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$MyOrderModelToJson(MyOrderModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['total_page'] as int,
      json['page_no'] as int,
      json['page_size'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Order.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'total_page': instance.totalPage,
      'page_no': instance.pageNo,
      'page_size': instance.pageSize,
      'data': instance.data
    };

Order _$OrderFromJson(Map<String, dynamic> json) {
  return Order(
      json['status_code'] as int,
      (json['real_pay'] as num)?.toDouble(),
      (json['tax'] as num)?.toDouble(),
      (json['deliver_fee'] as num)?.toDouble(),
      (json['available_api'] as List)?.map((e) => e as String)?.toList(),
      (json['total_pay'] as num)?.toDouble(),
      json['deliver_type'] as int,
      json['sendtime_type'] as int,
      json['user_id'] as int,
      json['parent_id'] as int,
      json['vendor_id'] as int,
      json['choose_warehouse_id'] as int,
      (json['order_item_list'] as List)
          ?.map((e) => e == null
              ? null
              : Order_item_list.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['ware_house_name'] as String,
      json['status_msg'] as String,
      json['id'] as int,
      json['warehouse_id'] as int)
    ..spuId = json['spu_id'] as int;
}

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'status_code': instance.statusCode,
      'real_pay': instance.realPay,
      'tax': instance.tax,
      'deliver_fee': instance.deliverFee,
      'available_api': instance.availableApi,
      'total_pay': instance.totalPay,
      'deliver_type': instance.deliverType,
      'sendtime_type': instance.sendtimeType,
      'user_id': instance.userId,
      'parent_id': instance.parentId,
      'spu_id': instance.spuId,
      'vendor_id': instance.vendorId,
      'choose_warehouse_id': instance.chooseWarehouseId,
      'order_item_list': instance.orderItemList,
      'ware_house_name': instance.wareHouseName,
      'status_msg': instance.statusMsg,
      'id': instance.id,
      'warehouse_id': instance.warehouseId
    };

Order_item_list _$Order_item_listFromJson(Map<String, dynamic> json) {
  return Order_item_list(
      (json['discount_price'] as num)?.toDouble(),
      json['product_brand_id'] as int,
      json['product_code'] as String,
      json['product_category_id'] as int,
      json['is_commented'] as int,
      json['product_id'] as int,
      json['id'] as int,
      json['vendor_type'] as int,
      json['quantity'] as int,
      (json['tax'] as num)?.toDouble(),
      (json['now_price'] as num)?.toDouble(),
      json['area_type'] as int,
      json['presale'] as int,
      json['product_name'] as String,
      json['product_img'] as String,
      json['vendor_id'] as int,
      json['order_id'] as int,
      json['spu_id'] as int,
      (json['sku_spec'] as List)
          ?.map((e) =>
              e == null ? null : Sku_spec.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$Order_item_listToJson(Order_item_list instance) =>
    <String, dynamic>{
      'discount_price': instance.discountPrice,
      'product_brand_id': instance.productBrandId,
      'product_code': instance.productCode,
      'product_category_id': instance.productCategoryId,
      'is_commented': instance.isCommented,
      'spu_id': instance.spuId,
      'product_id': instance.productId,
      'id': instance.id,
      'vendor_type': instance.vendorType,
      'quantity': instance.quantity,
      'tax': instance.tax,
      'now_price': instance.nowPrice,
      'area_type': instance.areaType,
      'presale': instance.presale,
      'product_name': instance.productName,
      'product_img': instance.productImg,
      'vendor_id': instance.vendorId,
      'order_id': instance.orderId,
      'sku_spec': instance.skuSpec
    };

Sku_spec _$Sku_specFromJson(Map<String, dynamic> json) {
  return Sku_spec(json['spec_value_id'] as int, json['is_affect_img'] as int,
      json['spec_id'] as int, json['name'] as String, json['value'] as String);
}

Map<String, dynamic> _$Sku_specToJson(Sku_spec instance) => <String, dynamic>{
      'spec_value_id': instance.specValueId,
      'is_affect_img': instance.isAffectImg,
      'spec_id': instance.specId,
      'name': instance.name,
      'value': instance.value
    };
