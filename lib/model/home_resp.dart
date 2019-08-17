import 'package:json_annotation/json_annotation.dart'; 
import 'result.dart';
part 'home_resp.g.dart';


@JsonSerializable()
  class HomeResp extends Object{

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  Data data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  HomeResp(this.result,this.data,this.success,this.version,);

  factory HomeResp.fromJson(Map<String, dynamic> srcJson) => _$HomeRespFromJson(srcJson);

}

  
@JsonSerializable()
  class Data extends Object{

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'page_total')
  int pageTotal;

  @JsonKey(name: 'page_no')
  int pageNo;

  @JsonKey(name: 'modules')
  List<Map<String,dynamic>> modules;

  @JsonKey(name: 'page_size')
  int pageSize;

  Data(this.total,this.pageTotal,this.pageNo,this.modules,this.pageSize,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);
}


  
