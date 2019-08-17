import 'package:json_annotation/json_annotation.dart';
part 'Goods.g.dart';

@JsonSerializable()
class Goods extends Object{
  @JsonKey(name: 'quantity')
  num quantity;

  @JsonKey(name: 'img_url')
  String imgUrl;

  @JsonKey(name: 'price')
  num price;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'discount')
  String discount;

  @JsonKey(name: 'spu_id')
  num spuId;

  @JsonKey(name: 'id')
  num id;

  @JsonKey(name: 'area_type')
  num areaType;

  @JsonKey(name: 'market_price')
  num marketPrice;

  @JsonKey(name: 'category')
  Category category;

  @JsonKey(name: 'brand')
  Brand brand;

  @JsonKey(name: 'attrs')
  List<Attrs> attrs;

  Goods(this.imgUrl, this.level, this.name, this.id, this.spuId, this.areaType,
      this.category, this.brand, this.attrs, this.price, this.quantity,this.discount,this.marketPrice);

  factory Goods.fromJson(Map<String, dynamic> srcJson) => _$GoodsFromJson(srcJson);
}

@JsonSerializable()
class Brand extends Object  {
  @JsonKey(name: 'brand_name')
  String brandName;

  @JsonKey(name: 'brand_id')
  num brandId;

  Brand(
      this.brandName,
      this.brandId,
      );

  factory Brand.fromJson(Map<String, dynamic> srcJson) =>
      _$BrandFromJson(srcJson);
}

@JsonSerializable()
class Attrs extends Object  {
  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'value')
  String value;

  Attrs(
      this.name,
      this.value,
      );

  factory Attrs.fromJson(Map<String, dynamic> srcJson) =>
      _$AttrsFromJson(srcJson);
}

@JsonSerializable()
class Category extends Object {
  @JsonKey(name: 'category_name')
  String categoryName;

  @JsonKey(name: 'cate_ids')
  List<int> cateIds;

  Category(
      this.categoryName,
      this.cateIds,
      );

  factory Category.fromJson(Map<String, dynamic> srcJson) =>_$CategoryFromJson(srcJson);
}
