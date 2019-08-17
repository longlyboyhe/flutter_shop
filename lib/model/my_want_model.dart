import 'package:json_annotation/json_annotation.dart'; 
  
part 'my_want_model.g.dart';


@JsonSerializable()
  class MyWantModel extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  MyWantModel(this.result,this.data,this.success,this.version,);

  factory MyWantModel.fromJson(Map<String, dynamic> srcJson) => _$MyWantModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$MyWantModelToJson(this);

}

  
@JsonSerializable()
  class Result extends Object {

  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'is_success')
  bool isSuccess;

  Result(this.msg,this.code,this.isSuccess,);

  factory Result.fromJson(Map<String, dynamic> srcJson) => _$ResultFromJson(srcJson);

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

  Data(this.total,this.data,this.totalPage,this.pageNo,this.pageSize,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
@JsonSerializable()
  class GoodData extends Object {

  @JsonKey(name: 'publisher_id')
  String publisherId;

  @JsonKey(name: 'created_time')
  String createdTime;

  @JsonKey(name: 'goods_info')
  List<Goods_info> goodsInfo;

  @JsonKey(name: 'edit_status')
  int editStatus;

  @JsonKey(name: 'buyoffer_requirements')
  Buyoffer_requirements buyofferRequirements;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'pics')
  List<String> pics;

  @JsonKey(name: 'status')
  int status;

  GoodData(this.publisherId,this.createdTime,this.goodsInfo,this.editStatus,this.buyofferRequirements,this.description,this.title,this.pics,this.status,);

  factory GoodData.fromJson(Map<String, dynamic> srcJson) => _$GoodDataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GoodDataToJson(this);

}

  
@JsonSerializable()
  class Goods_info extends Object {

  @JsonKey(name: 'category_name')
  String categoryName;

  @JsonKey(name: 'category_id')
  String categoryId;

  @JsonKey(name: 'price')
  double price;

  @JsonKey(name: 'num')
  int num;

  @JsonKey(name: 'description')
  String description;

  @JsonKey(name: 'brand_name')
  String brandName;

  @JsonKey(name: 'item_title')
  String itemTitle;

  @JsonKey(name: 'brand_id')
  String brandId;

  @JsonKey(name: 'item_no')
  String itemNo;

  @JsonKey(name: 'props')
  List<Props> props;

  Goods_info(this.categoryName,this.categoryId,this.price,this.num,this.description,this.brandName,this.itemTitle,this.brandId,this.itemNo,this.props,);

  factory Goods_info.fromJson(Map<String, dynamic> srcJson) => _$Goods_infoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Goods_infoToJson(this);

}

  
@JsonSerializable()
  class Props extends Object {

  @JsonKey(name: 'prop_name')
  String propName;

  @JsonKey(name: 'prop_id')
  int propId;

  @JsonKey(name: 'prop_value')
  String propValue;

  Props(this.propName,this.propId,this.propValue,);

  factory Props.fromJson(Map<String, dynamic> srcJson) => _$PropsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PropsToJson(this);

}

  
@JsonSerializable()
  class Buyoffer_requirements extends Object {

  @JsonKey(name: 'gmt_quotation_expire')
  String gmtQuotationExpire;

  @JsonKey(name: 'expire_day')
  int expireDay;

  Buyoffer_requirements(this.gmtQuotationExpire,this.expireDay,);

  factory Buyoffer_requirements.fromJson(Map<String, dynamic> srcJson) => _$Buyoffer_requirementsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Buyoffer_requirementsToJson(this);

}

  
