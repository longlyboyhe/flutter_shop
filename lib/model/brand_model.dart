import 'package:json_annotation/json_annotation.dart'; 
  
part 'brand_model.g.dart';


@JsonSerializable()
  class BrandModel extends Object {

  @JsonKey(name: 'module_id')
  num moduleId;

  @JsonKey(name: 'business_obj')
  Business businessObj;

  @JsonKey(name: 'comfig_map')
  Comfig_map comfigMap;

  @JsonKey(name: 'module_type')
  String moduleType;

  @JsonKey(name: 'region_id')
  num regionId;

  BrandModel(this.moduleId,this.businessObj,this.comfigMap,this.moduleType,this.regionId,);

  factory BrandModel.fromJson(Map<String, dynamic> srcJson) => _$BrandModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

}

  
@JsonSerializable()
  class Business extends Object {

  @JsonKey(name: 'list')
  List<BrandSelection> list;

  Business(this.list,);

  factory Business.fromJson(Map<String, dynamic> srcJson) => _$BusinessFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BusinessToJson(this);

}

  
@JsonSerializable()
class BrandSelection extends Object {

  @JsonKey(name: 'cn_name')
  String cnName;

  @JsonKey(name: 'change_img')
  String changeImg;

  @JsonKey(name: 'background_img')
  String backgroundImg;

  @JsonKey(name: 'en_name')
  String enName;

  @JsonKey(name: 'logo')
  String logo;

  @JsonKey(name: 'brand_config_map')
  BrandConfigMap brandConfigMap;

  @JsonKey(name: 'brand_id')
  int brandId;

  BrandSelection(this.cnName,this.changeImg,this.backgroundImg,this.enName,this.logo,this.brandConfigMap,this.brandId,);

  factory BrandSelection.fromJson(Map<String, dynamic> srcJson) => _$BrandSelectionFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandSelectionToJson(this);

}

  
@JsonSerializable()
  class BrandConfigMap extends Object {

  @JsonKey(name: 'sell_point')
  String sellPoint;

  BrandConfigMap(this.sellPoint,);

  factory BrandConfigMap.fromJson(Map<String, dynamic> srcJson) => _$BrandConfigMapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BrandConfigMapToJson(this);

}

  
@JsonSerializable()
  class Comfig_map extends Object {

  @JsonKey(name: 'bg_color')
  String bgColor;

  @JsonKey(name: 'brand_type')
  int brandType;

  Comfig_map(this.bgColor,this.brandType,);

  factory Comfig_map.fromJson(Map<String, dynamic> srcJson) => _$Comfig_mapFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Comfig_mapToJson(this);

}

  
