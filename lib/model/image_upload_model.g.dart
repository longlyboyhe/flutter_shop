// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadModel _$ImageUploadModelFromJson(Map<String, dynamic> json) {
  return ImageUploadModel(
      json['result'] == null
          ? null
          : Result.fromJson(json['result'] as Map<String, dynamic>),
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : PhotoInfo.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['success'] as bool,
      json['version'] as String);
}

Map<String, dynamic> _$ImageUploadModelToJson(ImageUploadModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
      'success': instance.success,
      'version': instance.version
    };

PhotoInfo _$PhotoInfoFromJson(Map<String, dynamic> json) {
  return PhotoInfo(json['file_name'] as String, json['url'] as String);
}

Map<String, dynamic> _$PhotoInfoToJson(PhotoInfo instance) =>
    <String, dynamic>{'file_name': instance.fileName, 'url': instance.url};
