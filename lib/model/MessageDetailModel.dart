///
/// 消息详情
/// @author longlyboyhe
/// @date 2019/3/13
///
class MessageDetailModel {
  int result;
  String msg;
  List<MessageDetailItemModel> data;

  MessageDetailModel({this.result, this.msg, this.data});

  factory MessageDetailModel.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    List<MessageDetailItemModel> resultData =
        list.map((i) => MessageDetailItemModel.fromJson(i)).toList();
    return MessageDetailModel(
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

class MessageDetailItemModel {
  String title;
  String detail;
  String time;

  MessageDetailItemModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        detail = json['detail'],
        time = json['time'];

  @override
  String toString() {
    return "title=${title} detail=${detail} time=${time}";
  }
}
