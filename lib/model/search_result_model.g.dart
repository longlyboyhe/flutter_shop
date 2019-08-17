// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResultModel _$SearchResultModelFromJson(Map<String, dynamic> json) {
  return SearchResultModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$SearchResultModelToJson(SearchResultModel instance) =>
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
      json['total'] as int,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : GoodData.fromJson(e as Map<String, dynamic>))
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

GoodData _$GoodDataFromJson(Map<String, dynamic> json) {
  return GoodData(
      (json['item_skus'] as List)
          ?.map((e) =>
              e == null ? null : Item_skus.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['quantity'] as int,
      json['level'] as String,
      json['area_type'] as int,
      json['img_url'] as String,
      json['discount'] as String,
      json['price'] as num,
      json['name'] as String,
      json['market_price'] as num,
      json['id'] as int,
      json['spu_id'] as int,
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>));
}

Map<String, dynamic> _$GoodDataToJson(GoodData instance) => <String, dynamic>{
      'item_skus': instance.itemSkus,
      'quantity': instance.quantity,
      'level': instance.level,
      'area_type': instance.areaType,
      'img_url': instance.imgUrl,
      'discount': instance.discount,
      'price': instance.price,
      'name': instance.name,
      'market_price': instance.marketPrice,
      'id': instance.id,
      'spu_id': instance.spuId,
      'category': instance.category,
      'brand': instance.brand
    };

Item_skus _$Item_skusFromJson(Map<String, dynamic> json) {
  return Item_skus(
      json['seller_size'] as int,
      (json['seller_info'] as List)
          ?.map((e) => e == null
              ? null
              : Seller_info.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['sku_id'] as int);
}

Map<String, dynamic> _$Item_skusToJson(Item_skus instance) => <String, dynamic>{
      'seller_size': instance.sellerSize,
      'seller_info': instance.sellerInfo,
      'sku_id': instance.skuId
    };

Seller_info _$Seller_infoFromJson(Map<String, dynamic> json) {
  return Seller_info(
      json['quantity'] as int, json['price'] as num, json['seller_id'] as int);
}

Map<String, dynamic> _$Seller_infoToJson(Seller_info instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'price': instance.price,
      'seller_id': instance.sellerId
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(json['category_name'] as String,
      (json['cate_ids'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_name': instance.categoryName,
      'cate_ids': instance.cateIds
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(json['brand_name'] as String, json['brand_id'] as int);
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'brand_id': instance.brandId
    };
