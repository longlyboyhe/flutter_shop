// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResp _$CartRespFromJson(Map<String, dynamic> json) {
  return CartResp(
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$CartRespToJson(CartResp instance) => <String, dynamic>{
      'result': instance.result,
      'success': instance.success,
      'version': instance.version,
      'data': instance.data
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      json['total'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Cart.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['total_page'] as int,
      json['page_no'] as int,
      json['page_size'] as int);
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'total': instance.total,
      'data': instance.data,
      'total_page': instance.totalPage,
      'page_no': instance.pageNo,
      'page_size': instance.pageSize
    };

Cart _$CartFromJson(Map<String, dynamic> json) {
  return Cart(
      (json['original_price'] as num)?.toDouble(),
      json['original_quantity'] as int,
      (json['sku_spec'] as List)
          ?.map((e) =>
              e == null ? null : SkuSpec.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['sku_id'] as int,
      json['cate_id'] as int,
      json['title'] as String,
      json['brand_id'] as int,
      json['uid'] as int,
      json['vendor_id'] as int,
      json['id'] as int,
      json['spu_id'] as int,
      (json['pic_url'] as List)?.map((e) => e as String)?.toList(),
      json['status'] as int)
    ..createDate = json['create_date'] as int
    ..creator = json['creator'] as String
    ..areaType = json['area_type'] as int
    ..isSelected = json['isSelected'] as bool;
}

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'original_price': instance.originalPrice,
      'title': instance.title,
      'uid': instance.uid,
      'id': instance.id,
      'create_date': instance.createDate,
      'spu_id': instance.spuId,
      'creator': instance.creator,
      'original_quantity': instance.originalQuantity,
      'sku_id': instance.skuId,
      'cate_id': instance.cateId,
      'area_type': instance.areaType,
      'brand_id': instance.brandId,
      'vendor_id': instance.vendorId,
      'pic_url': instance.picUrl,
      'status': instance.status,
      'sku_spec': instance.skuSpec,
      'isSelected': instance.isSelected
    };

SkuSpec _$SkuSpecFromJson(Map<String, dynamic> json) {
  return SkuSpec(
      json['spec_id'] as int, json['name'] as String, json['value'] as String)
    ..specValueId = json['spec_value_id'] as int;
}

Map<String, dynamic> _$SkuSpecToJson(SkuSpec instance) => <String, dynamic>{
      'spec_value_id': instance.specValueId,
      'spec_id': instance.specId,
      'name': instance.name,
      'value': instance.value
    };
