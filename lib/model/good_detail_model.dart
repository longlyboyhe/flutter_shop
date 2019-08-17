import 'package:json_annotation/json_annotation.dart';

part 'good_detail_model.g.dart';

@JsonSerializable()
class GoodDetailModel extends Object {
  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  GoodDetailModel(
    this.result,
    this.data,
    this.success,
    this.version,
  );

  factory GoodDetailModel.fromJson(Map<String, dynamic> srcJson) =>
      _$GoodDetailModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodDetailModelToJson(this);
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
  @JsonKey(name: 'sku_spec')
  List<Sku_spec> skuSpec;

  @JsonKey(name: 'level')
  String level;

  @JsonKey(name: 'image_urls')
  Map imageUrls;

  @JsonKey(name: 'area_type')
  int areaType;

  @JsonKey(name: 'property_map')
  Map propertyMap;

  @JsonKey(name: 'specs')
  List<Specs> specs;

  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'product_detail')
  String productDetail;

  @JsonKey(name: 'market_price')
  double marketPrice;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'spu_id')
  int spuId;

  @JsonKey(name: 'category')
  Category category;

  @JsonKey(name: 'brand')
  Brand brand;

  @JsonKey(name: 'vendor_type')
  int vendorType;

  @JsonKey(name: 'sku_path')
  List<Sku_path> skuPath;

  @JsonKey(name: 'price')
  num price;

  Data(
    this.skuSpec,
    this.level,
    this.imageUrls,
    this.areaType,
    this.propertyMap,
    this.specs,
    this.name,
    this.price,
    this.productDetail,
    this.marketPrice,
    this.id,
    this.spuId,
    this.category,
    this.brand,
    this.vendorType,
    this.skuPath,
  );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Sku_spec extends Object {
  @JsonKey(name: 'spec_id')
  int specId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'value')
  String value;

  Sku_spec(
    this.specId,
    this.name,
    this.value,
  );

  factory Sku_spec.fromJson(Map<String, dynamic> srcJson) =>
      _$Sku_specFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Sku_specToJson(this);
}

@JsonSerializable()
class Specs extends Object {
  @JsonKey(name: 'spec_values')
  List<Spec_values> specValues;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'id')
  int id;

  Specs(
    this.specValues,
    this.name,
    this.id,
  );

  factory Specs.fromJson(Map<String, dynamic> srcJson) =>
      _$SpecsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SpecsToJson(this);
}

@JsonSerializable()
class Spec_values extends Object {
  @JsonKey(name: 'vid')
  int vid;

  @JsonKey(name: 'value')
  String value;

  Spec_values(
    this.vid,
    this.value,
  );

  factory Spec_values.fromJson(Map<String, dynamic> srcJson) =>
      _$Spec_valuesFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Spec_valuesToJson(this);
}

@JsonSerializable()
class Category extends Object {
  @JsonKey(name: 'category_name')
  String categoryName;

  @JsonKey(name: 'category_id')
  int categoryId;

  Category(
    this.categoryName,
    this.categoryId,
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

@JsonSerializable()
class Sku_path extends Object {
  @JsonKey(name: 'inventory_list')
  List<Inventory_list> inventoryList;

  @JsonKey(name: 'spe_path')
  String spePath;

  @JsonKey(name: 'sku_id')
  int skuId;

  Sku_path(
    this.inventoryList,
    this.spePath,
    this.skuId,
  );

  factory Sku_path.fromJson(Map<String, dynamic> srcJson) =>
      _$Sku_pathFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Sku_pathToJson(this);
}

@JsonSerializable()
class Inventory_list extends Object {
  @JsonKey(name: 'area')
  String area;

  @JsonKey(name: 'vendor_code')
  String vendorCode;

  @JsonKey(name: 'product_id')
  int productId;

  @JsonKey(name: 'vendor_id')
  int vendorId;

  @JsonKey(name: 'vendor_name')
  String vendorName;

  @JsonKey(name: 'sale_price')
  double salePrice;

  @JsonKey(name: 'sell_stock')
  int sellStock;

  @JsonKey(name: 'vendor_type')
  int vendorType;

  int _orderNum;

  int getOrderNum() {
    if (_orderNum != null) {
      return _orderNum;
    } else {
      return 0;
    }
  }

  void setOrderNum(int num) {
    _orderNum = num;
  }

  Inventory_list(
    this.area,
    this.vendorCode,
    this.productId,
    this.vendorId,
    this.vendorName,
    this.salePrice,
    this.sellStock,
    this.vendorType,
  );

  factory Inventory_list.fromJson(Map<String, dynamic> srcJson) =>
      _$Inventory_listFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Inventory_listToJson(this);
}
