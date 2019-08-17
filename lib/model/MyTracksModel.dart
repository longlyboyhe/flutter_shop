///
/// 我的浏览
/// @author longlyboyhe
/// @date 2019/3/12
///
class MyTracksModel {
  int result;
  String msg;
  List<MyTracksItemModel> data;

  MyTracksModel({this.result, this.msg, this.data});

  factory MyTracksModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<MyTracksItemModel> resultData =
        list.map((i) => MyTracksItemModel.fromJson(i)).toList();
    return MyTracksModel(
      result: parsedJson['result'],
      msg: parsedJson['msg'],
      data: resultData,
    );
  }

  int get length {
    if (data.isNotEmpty) {
      return data.length;
    } else {
      return 0;
    }
  }

  bool get isNotEmpty {
    return data.isNotEmpty;
  }

  bool get isAllchecked {
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        MyTracksItemModel model = data[i];
        if (model.isSelected == false) {
          return false;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  switchAllCheck() {
    if (this.isAllchecked) {
      data.forEach((item) {
        item.isSelected = false;
      });
    } else {
      data.forEach((item) {
        item.isSelected = true;
      });
    }
  }

  ///选择的数据
  String selected() {
    String selected = "";
    data.forEach((item) {
      if (item.isSelected) selected = selected + item.name;
    });
    return selected;
  }
}

class MyTracksItemModel {
  String img;
  String name;
  num price;
  int originalSize;
  String attrs;
  bool sellOut;
  bool isSelected;

  MyTracksItemModel.fromJson(Map<String, dynamic> json)
      : img = json['img'],
        name = json['name'],
        price = json['price'],
        originalSize = json['originalSize'],
        attrs = json['attrs'],
        sellOut = json['sellOut'] == true ? true : false,
        isSelected = json['isSelected'] == true ? true : false;
}
