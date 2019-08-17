class ClassificationModel {
  int gcId; //左边id
  String gcName; //左边名称
//  List<ClassificationListModel> classList;
  List classList;

  ClassificationModel({this.gcName, this.gcId, this.classList});

  ClassificationModel.fromJson(Map<String, dynamic> json)
      : gcId = json['gcId'],
        gcName = json['gcName'],
        classList = json['classList'];

  Map<String, dynamic> toJson() => {
        'gcId': gcId,
        'gcName': gcName,
        'classList': classList,
      };
}

class ClassificationListModel {
  String typename; //右边顶部栏------女士上装
  String gcpic; //图片
  String gcName;
  String gcId;

  ClassificationListModel({this.typename, this.gcpic, this.gcName, this.gcId});

  ClassificationListModel.fromJson(Map<String, dynamic> json)
      : typename = json['typename'],
        gcpic = json['gcpic'],
        gcName = json['gcName'],
        gcId = json['gcId'];

  Map<String, dynamic> toJson() => {
        'typename': typename,
        'gcpic': gcpic,
        'gcName': gcName,
        'gcId': gcId,
      };
}
