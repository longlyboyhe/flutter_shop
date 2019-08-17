import 'package:json_annotation/json_annotation.dart';

part 'logistics_model.g.dart';

@JsonSerializable()
class LogisticsModel extends Object {
  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  LogisticsModel(
    this.result,
    this.data,
    this.success,
    this.version,
  );

  factory LogisticsModel.fromJson(Map<String, dynamic> srcJson) =>
      _$LogisticsModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LogisticsModelToJson(this);
}

@JsonSerializable()
class Result extends Object {
  @JsonKey(name: 'msg')
  String msg;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'is_success')
  bool isSuccess;

  Result(
    this.msg,
    this.code,
    this.isSuccess,
  );

  factory Result.fromJson(Map<String, dynamic> srcJson) =>
      _$ResultFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ResultToJson(this);
}

@JsonSerializable()
class Data extends Object {
  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'data')
  Data2 data;

  Data(
    this.code,
    this.data,
  );

  factory Data.fromJson(Map<String, dynamic> srcJson) =>
      _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Data2 extends Object {
  @JsonKey(name: 'express_num')
  String expressNum;

  @JsonKey(name: 'track_detail_list')
  List<Track_detail_list> trackDetailList;

  @JsonKey(name: 'express_status_str')
  String expressStatusStr;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'version')
  int version;

  @JsonKey(name: 'express_base')
  Express_base expressBase;

  Data2(
    this.expressNum,
    this.trackDetailList,
    this.expressStatusStr,
    this.id,
    this.version,
    this.expressBase,
  );

  factory Data2.fromJson(Map<String, dynamic> srcJson) =>
      _$Data2FromJson(srcJson);

  Map<String, dynamic> toJson() => _$Data2ToJson(this);
}

@JsonSerializable()
class Track_detail_list extends Object {
  @JsonKey(name: 'date')
  String date;

  @JsonKey(name: 'track_id')
  String trackId;

  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'time')
  String time;

  @JsonKey(name: 'version')
  String version;

  @JsonKey(name: 'content')
  String content;

  bool _isDot;

  void setIsDot(bool dot) {
    _isDot = dot;
  }

  bool getIsDot() {
    if (_isDot != null)
      return _isDot;
    else
      return false;
  }

  Track_detail_list(
    this.date,
    this.trackId,
    this.id,
    this.time,
    this.version,
    this.content,
  );

  factory Track_detail_list.fromJson(Map<String, dynamic> srcJson) =>
      _$Track_detail_listFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Track_detail_listToJson(this);
}

@JsonSerializable()
class Express_base extends Object {
  @JsonKey(name: 'name')
  String name;

  Express_base(
    this.name,
  );

  factory Express_base.fromJson(Map<String, dynamic> srcJson) =>
      _$Express_baseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$Express_baseToJson(this);
}
