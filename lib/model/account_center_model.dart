///
/// 结算中心商品列表
/// @author longlyboyhe
/// @date 2019/3/25
///
class AccountCenterModel {
  List<AccountCenterItemModel> result;
  num totalPrice;
  num tax;
  num carriage;
  num otherTotalPrice;

  AccountCenterModel(
      {this.result,
      this.totalPrice,
      this.tax,
      this.carriage,
      this.otherTotalPrice}); //  AccountCenterModel({this.result});

  factory AccountCenterModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['result'] as List;
    List<AccountCenterItemModel> resultData =
        list.map((i) => AccountCenterItemModel.fromJson(i)).toList();
    return AccountCenterModel(
        result: resultData,
        totalPrice: 0,
        tax: 0,
        carriage: 0,
        otherTotalPrice: 0);
  }
}

class AccountCenterItemModel {
  String supplier;
  List<AccountCenterGoodModel> data;

  AccountCenterItemModel({this.supplier, this.data});

  factory AccountCenterItemModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<AccountCenterGoodModel> resultData =
        list.map((i) => AccountCenterGoodModel.fromJson(i)).toList();
    return AccountCenterItemModel(
      supplier: parsedJson['supplier'],
      data: resultData,
    );
  }
}

class AccountCenterGoodModel {
  String good_id;
  String product_name;
  String attr;
  int count;
  String image_url;
  num market_price;

  AccountCenterGoodModel.fromJson(Map<String, dynamic> json)
      : good_id = json['good_id'] == null ? "" : json['good_id'],
        product_name = json['product_name'] == null ? "" : json['product_name'],
        attr = json['attr'] == null ? "" : json['attr'],
        count = json['count'] == null ? 0 : json['count'],
        market_price = json['market_price'] == null ? 0 : json['market_price'],
        image_url = json['image_url'] == null ? "" : json['image_url'];
}
