import 'package:json_annotation/json_annotation.dart'; 
import 'result.dart';
part 'image_upload_model.g.dart';

@JsonSerializable()
  class ImageUploadModel extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  List<PhotoInfo> data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  ImageUploadModel(this.result,this.data,this.success,this.version,);

  factory ImageUploadModel.fromJson(Map<String, dynamic> srcJson) => _$ImageUploadModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ImageUploadModelToJson(this);

}


@JsonSerializable()
  class PhotoInfo extends Object {

  @JsonKey(name: 'file_name')
  String fileName;

  @JsonKey(name: 'url')
  String url;

  PhotoInfo(this.fileName,this.url,);

  factory PhotoInfo.fromJson(Map<String, dynamic> srcJson) => _$PhotoInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$PhotoInfoToJson(this);

}





  
