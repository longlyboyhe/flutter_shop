// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'good_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GoodDetailModel _$GoodDetailModelFromJson(Map<String, dynamic> json) {
  return GoodDetailModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$GoodDetailModelToJson(GoodDetailModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

Result _$ResultFromJson(Map<String, dynamic> json) {
  return Result(
      json['msg'] as String, json['code'] as int, json['is_success'] as bool);
}

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'is_success': instance.isSuccess
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
      (json['sku_spec'] as List)
          ?.map((e) =>
              e == null ? null : Sku_spec.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['level'] as String,
      json['image_urls'] as Map<String, dynamic>,
      json['area_type'] as int,
      json['property_map'] as Map<String, dynamic>,
      (json['specs'] as List)
          ?.map((e) =>
              e == null ? null : Specs.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['name'] as String,
      json['price'] as num,
      json['product_detail'] as String,
      (json['market_price'] as num)?.toDouble(),
      json['id'] as int,
      json['spu_id'] as int,
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>),
      json['vendor_type'] as int,
      (json['sku_path'] as List)
          ?.map((e) =>
              e == null ? null : Sku_path.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'sku_spec': instance.skuSpec,
      'level': instance.level,
      'image_urls': instance.imageUrls,
      'area_type': instance.areaType,
      'property_map': instance.propertyMap,
      'specs': instance.specs,
      'name': instance.name,
      'product_detail': instance.productDetail,
      'market_price': instance.marketPrice,
      'id': instance.id,
      'spu_id': instance.spuId,
      'category': instance.category,
      'brand': instance.brand,
      'vendor_type': instance.vendorType,
      'sku_path': instance.skuPath,
      'price': instance.price
    };

Sku_spec _$Sku_specFromJson(Map<String, dynamic> json) {
  return Sku_spec(
      json['spec_id'] as int, json['name'] as String, json['value'] as String);
}

Map<String, dynamic> _$Sku_specToJson(Sku_spec instance) => <String, dynamic>{
      'spec_id': instance.specId,
      'name': instance.name,
      'value': instance.value
    };

Specs _$SpecsFromJson(Map<String, dynamic> json) {
  return Specs(
      (json['spec_values'] as List)
          ?.map((e) => e == null
              ? null
              : Spec_values.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['name'] as String,
      json['id'] as int);
}

Map<String, dynamic> _$SpecsToJson(Specs instance) => <String, dynamic>{
      'spec_values': instance.specValues,
      'name': instance.name,
      'id': instance.id
    };

Spec_values _$Spec_valuesFromJson(Map<String, dynamic> json) {
  return Spec_values(json['vid'] as int, json['value'] as String);
}

Map<String, dynamic> _$Spec_valuesToJson(Spec_values instance) =>
    <String, dynamic>{'vid': instance.vid, 'value': instance.value};

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(json['category_name'] as String, json['category_id'] as int);
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_name': instance.categoryName,
      'category_id': instance.categoryId
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(json['brand_name'] as String, json['brand_id'] as int);
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'brand_id': instance.brandId
    };

Sku_path _$Sku_pathFromJson(Map<String, dynamic> json) {
  return Sku_path(
      (json['inventory_list'] as List)
          ?.map((e) => e == null
              ? null
              : Inventory_list.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['spe_path'] as String,
      json['sku_id'] as int);
}

Map<String, dynamic> _$Sku_pathToJson(Sku_path instance) => <String, dynamic>{
      'inventory_list': instance.inventoryList,
      'spe_path': instance.spePath,
      'sku_id': instance.skuId
    };

Inventory_list _$Inventory_listFromJson(Map<String, dynamic> json) {
  return Inventory_list(
      json['area'] as String,
      json['vendor_code'] as String,
      json['product_id'] as int,
      json['vendor_id'] as int,
      json['vendor_name'] as String,
      (json['sale_price'] as num)?.toDouble(),
      json['sell_stock'] as int,
      json['vendor_type'] as int);
}

Map<String, dynamic> _$Inventory_listToJson(Inventory_list instance) =>
    <String, dynamic>{
      'area': instance.area,
      'vendor_code': instance.vendorCode,
      'product_id': instance.productId,
      'vendor_id': instance.vendorId,
      'vendor_name': instance.vendorName,
      'sale_price': instance.salePrice,
      'sell_stock': instance.sellStock,
      'vendor_type': instance.vendorType
    };
