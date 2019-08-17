///
/// 消息中心
/// @author longlyboyhe
/// @date 2019/2/26
///
class MessageModel {
  int result;
  String msg;
  List<MessageItemModel> data;

  MessageModel({this.result, this.msg, this.data});

  factory MessageModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<MessageItemModel> resultData =
        list.map((i) => MessageItemModel.fromJson(i)).toList();
    return MessageModel(
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
}

class MessageItemModel {
  int type;
  String icon;
  String title;
  String subTitle;
  String time;
  int news;

  MessageItemModel.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        icon = json['icon'],
        title = json['title'],
        subTitle = json['subTitle'],
        time = json['time'],
        news = json['news'];

  @override
  String toString() {
    return "icon=${icon} title=${title} subTitle=${subTitle} time=${time} news=${news}";
  }
}
