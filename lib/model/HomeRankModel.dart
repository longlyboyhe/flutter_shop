///
/// 爆款排行
/// @author longlyboyhe
/// @date 2019/2/21
///
class HomeRankModel {
  int result;
  String msg;
  List<HomeRankItemModel> data;

  HomeRankModel({this.result, this.msg, this.data});

  factory HomeRankModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<HomeRankItemModel> resultData =
        list.map((i) => HomeRankItemModel.fromJson(i)).toList();
    return HomeRankModel(
      result: parsedJson['result'],
      msg: parsedJson['msg'],
      data: resultData,
    );
  }
}

class HomeRankItemModel {
  String name;
  String title;
  String subTitle;
  String img;
  num price;
  num tipPrice;
  int id;

  HomeRankItemModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        title = json['title'],
        subTitle = json['subTitle'],
        img = json['img'],
        price = json['price'],
        tipPrice = json['tipPrice'];

  HomeRankItemModel({this.name, this.title, this.subTitle, this.img, this.price,
      this.tipPrice,this.id});


}
