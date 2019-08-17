class GoodsItemModel {
  String name;
  int id;
  String conditions;
  double price;
  double originalPrice;
  String img;
  String discount;
  int originalSize; //货源
  bool showMoreButton; //是否是查看更多按钮
  List<String> sizes;
  String en_cn_name;

  GoodsItemModel(
      {this.name,
      this.id,
      this.conditions,
      this.en_cn_name,
      this.price,
      this.originalPrice,
      this.img,
      this.discount,
      this.sizes,
      this.originalSize,
      this.showMoreButton = false}); //原价

  factory GoodsItemModel.fromJson(Map<String, dynamic> json) {
    var list = json['sizes'] as List;
    List<String> sizes =
        list != null ? list.map((i) => i.toString()).toList() : null;
    int originalPrice1 = json['originalPrice'];
    int price1 = json['price'];
    return GoodsItemModel(
        name: json['name'],
        en_cn_name: json['en_cn_name'],
        id: json['id'],
        conditions: json['conditions'],
        originalPrice: originalPrice1?.toDouble(),
        img: json['img'],
        discount: json['discount'],
        sizes: sizes,
        originalSize: json['originalSize'],
        price: price1?.toDouble());
  }

//      : name = json['name'],
//        id = json['id'],
//        originalPrice = json['originalPrice'],
//        img = json['img'],
//        discount = json['discount'],
//        sizes = json['sizes'],
//        originalSize = json['originalSize'],
//        price = json['price'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'en_cn_name': en_cn_name,
        'id': id,
        'conditions': conditions,
        'discount': discount,
        'originalSize': originalSize,
        'originalPrice': originalPrice,
        'img': img,
        'sizes': sizes,
        'price': price,
      };
}
