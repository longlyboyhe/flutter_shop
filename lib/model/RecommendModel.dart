import 'package:flutter_shop/model/GoodsItemModel.dart';

class RecommendModel {
  int result;
  String msg;
  List<GoodsItemModel> data;

  RecommendModel({this.result, this.msg, this.data});

  factory RecommendModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<GoodsItemModel> resultData =
        list.map((i) => GoodsItemModel.fromJson(i)).toList();
    return RecommendModel(
      result: parsedJson['result'],
      msg: parsedJson['msg'],
      data: resultData,
    );
  }
}
