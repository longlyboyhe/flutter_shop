// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Goods.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goods _$GoodsFromJson(Map<String, dynamic> json) {
  return Goods(
      json['img_url'] as String,
      json['level'] as String,
      json['name'] as String,
      json['id'] as num,
      json['spu_id'] as num,
      json['area_type'] as num,
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>),
      (json['attrs'] as List)
          ?.map((e) =>
              e == null ? null : Attrs.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['price'] as num,
      json['quantity'] as num,
      json['discount'] as String,
      json['market_price'] as num);
}

Map<String, dynamic> _$GoodsToJson(Goods instance) => <String, dynamic>{
      'quantity': instance.quantity,
      'img_url': instance.imgUrl,
      'price': instance.price,
      'name': instance.name,
      'level': instance.level,
      'discount': instance.discount,
      'spu_id': instance.spuId,
      'id': instance.id,
      'area_type': instance.areaType,
      'market_price': instance.marketPrice,
      'category': instance.category,
      'brand': instance.brand,
      'attrs': instance.attrs
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand(json['brand_name'] as String, json['brand_id'] as num);
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'brand_id': instance.brandId
    };

Attrs _$AttrsFromJson(Map<String, dynamic> json) {
  return Attrs(json['name'] as String, json['value'] as String);
}

Map<String, dynamic> _$AttrsToJson(Attrs instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category(json['category_name'] as String,
      (json['cate_ids'] as List)?.map((e) => e as int)?.toList());
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_name': instance.categoryName,
      'cate_ids': instance.cateIds
    };
