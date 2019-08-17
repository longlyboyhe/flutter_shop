///
/// 今日上新顶部筛选栏品牌
/// @author longlyboyhe
/// @date 2019/1/23
///
class TodayNewBrands {
  String name;
  String count;

  TodayNewBrands({this.name, this.count});

  TodayNewBrands.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        count = json['count'];

  Map<String, dynamic> toJson() => {'name': name, 'count': count};

  @override
  String toString() => "TodayNewBrands{" + " \"name\":\"" + name + "\"" + '}';
}
