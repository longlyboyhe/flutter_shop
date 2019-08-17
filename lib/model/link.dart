import 'package:json_annotation/json_annotation.dart';
part 'link.g.dart';
@JsonSerializable()
class Link extends Object{

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'content')
  String content;

  Link(this.name,this.type,this.content,);

  factory Link.fromJson(Map<String, dynamic> srcJson) => _$LinkFromJson(srcJson);

}