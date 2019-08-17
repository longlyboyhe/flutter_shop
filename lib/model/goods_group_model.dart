import 'package:json_annotation/json_annotation.dart';
import 'Goods.dart';
part 'goods_group_model.g.dart';

///
/// 商品分组组件数据模型
///
@JsonSerializable()
class GoodsGroupModel extends Object {

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

  GoodsGroupModel(this.moduleId,this.businessObj,this.comfigMap,this.moduleType,this.regionId,);

  factory GoodsGroupModel.fromJson(Map<String, dynamic> srcJson) => _$GoodsGroupModelFromJson(srcJson);

}

  
@JsonSerializable()
  class Business extends Object {

  @JsonKey(name: 'goods_group')
  List<GoodsGroup> goodsGroup;

  Business(this.goodsGroup,);

  factory Business.fromJson(Map<String, dynamic> srcJson) => _$BusinessFromJson(srcJson);

}

  
@JsonSerializable()
  class GoodsGroup extends Object {

  @JsonKey(name: 'goods_list')
  List<Goods> goodsList;

  @JsonKey(name: 'item_ids')
  String itemIds;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'title')
  String title;

  GoodsGroup(this.goodsList,this.itemIds,this.time,this.title,);

  factory GoodsGroup.fromJson(Map<String, dynamic> srcJson) => _$GoodsGroupFromJson(srcJson);

}

@JsonSerializable()
  class Config extends Object{

  @JsonKey(name: 'top_tag')
  String topTag;

  @JsonKey(name: 'show_style')
  String showStyle;

  @JsonKey(name: 'goods_bg_color')
  String goodsBgColor;

  @JsonKey(name: 'group_bg_color')
  String groupBgColor;

  @JsonKey(name: 'selected_group_bg_color')
  String selectedGroupBgColor;

  @JsonKey(name: 'group_type')
  String groupType;

  @JsonKey(name: 'price_style')
  double priceStyle;

  Config(this.topTag,this.showStyle,this.goodsBgColor,this.groupBgColor,this.selectedGroupBgColor,this.groupType,this.priceStyle,);

  factory Config.fromJson(Map<String, dynamic> srcJson) => _$ConfigFromJson(srcJson);

}

