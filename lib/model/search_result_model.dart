import 'package:json_annotation/json_annotation.dart';

part 'search_result_model.g.dart';

@JsonSerializable()
class SearchResultModel extends Object {
  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  SearchResultModel(
    this.result,
    this.data,
    this.success,
    this.version,
  );

  factory SearchResultModel.fromJson(Map<String, dynamic> srcJson) =>
      _$SearchResultModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SearchResultModelToJson(this);
}

@JsonSerializable()
class Result extends Object {
  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'is_success')
  bool isSuccess;

  Result(
    this.msg,
    this.code,
    this.isSuccess,
  );

  factory Result.fromJson(Map<String, dynamic> srcJson) =>
      _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Data extends Object {
  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<GoodData> data;

  @JsonKey(name: 'total_page')
  int totalPage;

  @JsonKey(name: 'page_no')
  int pageNo;

  @JsonKey(name: 'page_size')
  int pageSize;

  Data(
    this.total,
    this.data,
    this.totalPage,
    this.pageNo,
    this.pageSize,
  );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class GoodData extends Object {
  @JsonKey(name: 'item_skus')
  List<Item_skus> itemSkus;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'area_type')
  int areaType;

  @JsonKey(name: 'img_url')
  String imgUrl;

  @JsonKey(name: 'discount')
  String discount;

  @JsonKey(name: 'price')
  num price;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'market_price')
  num marketPrice;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'spu_id')
  int spuId;

  @JsonKey(name: 'category')
  Category category;

  @JsonKey(name: 'brand')
  Brand brand;

  GoodData(
    this.itemSkus,
    this.quantity,
    this.level,
    this.areaType,
    this.imgUrl,
    this.discount,
    this.price,
    this.name,
    this.marketPrice,
    this.id,
    this.spuId,
    this.category,
    this.brand,
  );

  factory GoodData.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodDataToJson(this);
}

@JsonSerializable()
class Item_skus extends Object {
  @JsonKey(name: 'seller_size')
  int sellerSize;

  @JsonKey(name: 'seller_info')
  List<Seller_info> sellerInfo;

  @JsonKey(name: 'sku_id')
  int skuId;

  Item_skus(
    this.sellerSize,
    this.sellerInfo,
    this.skuId,
  );

  factory Item_skus.fromJson(Map<String, dynamic> srcJson) =>
      _$Item_skusFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Item_skusToJson(this);
}

@JsonSerializable()
class Seller_info extends Object {
  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'price')
  num price;

  @JsonKey(name: 'seller_id')
  int sellerId;

  Seller_info(
    this.quantity,
    this.price,
    this.sellerId,
  );

  factory Seller_info.fromJson(Map<String, dynamic> srcJson) =>
      _$Seller_infoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Seller_infoToJson(this);
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

  factory Category.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Brand extends Object {
  @JsonKey(name: 'brand_name')
  String brandName;

  @JsonKey(name: 'brand_id')
  int brandId;

  Brand(
    this.brandName,
    this.brandId,
  );

  factory Brand.fromJson(Map<String, dynamic> srcJson) =>
      _$BrandFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandToJson(this);
}
