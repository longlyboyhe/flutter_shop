// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_want_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyWantModel _$MyWantModelFromJson(Map<String, dynamic> json) {
  return MyWantModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$MyWantModelToJson(MyWantModel instance) =>
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
      json['publisher_id'] as String,
      json['created_time'] as String,
      (json['goods_info'] as List)
          ?.map((e) =>
              e == null ? null : Goods_info.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['edit_status'] as int,
      json['buyoffer_requirements'] == null
          ? null
          : Buyoffer_requirements.fromJson(
              json['buyoffer_requirements'] as Map<String, dynamic>),
      json['description'] as String,
      json['title'] as String,
      (json['pics'] as List)?.map((e) => e as String)?.toList(),
      json['status'] as int);
}

Map<String, dynamic> _$GoodDataToJson(GoodData instance) => <String, dynamic>{
      'publisher_id': instance.publisherId,
      'created_time': instance.createdTime,
      'goods_info': instance.goodsInfo,
      'edit_status': instance.editStatus,
      'buyoffer_requirements': instance.buyofferRequirements,
      'description': instance.description,
      'title': instance.title,
      'pics': instance.pics,
      'status': instance.status
    };

Goods_info _$Goods_infoFromJson(Map<String, dynamic> json) {
  return Goods_info(
      json['category_name'] as String,
      json['category_id'] as String,
      (json['price'] as num)?.toDouble(),
      json['num'] as int,
      json['description'] as String,
      json['brand_name'] as String,
      json['item_title'] as String,
      json['brand_id'] as String,
      json['item_no'] as String,
      (json['props'] as List)
          ?.map((e) =>
              e == null ? null : Props.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$Goods_infoToJson(Goods_info instance) =>
    <String, dynamic>{
      'category_name': instance.categoryName,
      'category_id': instance.categoryId,
      'price': instance.price,
      'num': instance.num,
      'description': instance.description,
      'brand_name': instance.brandName,
      'item_title': instance.itemTitle,
      'brand_id': instance.brandId,
      'item_no': instance.itemNo,
      'props': instance.props
    };

Props _$PropsFromJson(Map<String, dynamic> json) {
  return Props(json['prop_name'] as String, json['prop_id'] as int,
      json['prop_value'] as String);
}

Map<String, dynamic> _$PropsToJson(Props instance) => <String, dynamic>{
      'prop_name': instance.propName,
      'prop_id': instance.propId,
      'prop_value': instance.propValue
    };

Buyoffer_requirements _$Buyoffer_requirementsFromJson(
    Map<String, dynamic> json) {
  return Buyoffer_requirements(
      json['gmt_quotation_expire'] as String, json['expire_day'] as int);
}

Map<String, dynamic> _$Buyoffer_requirementsToJson(
        Buyoffer_requirements instance) =>
    <String, dynamic>{
      'gmt_quotation_expire': instance.gmtQuotationExpire,
      'expire_day': instance.expireDay
    };
