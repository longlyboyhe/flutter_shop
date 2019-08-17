import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_shop/model/link.dart';
  
part 'ad_model.g.dart';

///
/// 广告组件的数据模型
///

@JsonSerializable()
  class AdModel extends Object{

  @JsonKey(name: 'module_id')
  int moduleId;

  @JsonKey(name: 'business_obj')
  Business businessObj;

  @JsonKey(name: 'comfig_map')
  Config comfigMap;

  @JsonKey(name: 'module_type')
  String moduleType;

  @JsonKey(name: 'region_id')
  int regionId;

  AdModel(this.moduleId,this.businessObj,this.comfigMap,this.moduleType,this.regionId,);

  factory AdModel.fromJson(Map<String, dynamic> srcJson) => _$AdModelFromJson(srcJson);

}

  
@JsonSerializable()
  class Business extends Object {

  @JsonKey(name: 'count')
  double count;

  @JsonKey(name: 'list')
  List<AdImage> list;

  Business(this.count,this.list,);

  factory Business.fromJson(Map<String, dynamic> srcJson) => _$BusinessFromJson(srcJson);

}

  
@JsonSerializable()
  class AdImage extends Object {

  @JsonKey(name: 'img_url')
  String imgUrl;

  @JsonKey(name: 'link')
  Link link;

  @JsonKey(name: 'title')
  String title;

  AdImage(this.imgUrl,this.link,this.title,);

  factory AdImage.fromJson(Map<String, dynamic> srcJson) => _$AdImageFromJson(srcJson);

}

  


  
@JsonSerializable()
  class Config extends Object{

  @JsonKey(name: 'style_type')
  double styleType;

  @JsonKey(name: 'ratio')
  double ratio;

  Config(this.styleType,this.ratio,);

  factory Config.fromJson(Map<String, dynamic> srcJson) => _$ConfigFromJson(srcJson);

}

  
