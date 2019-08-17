import 'package:flutter_shop/widgets/share/dragablegridviewbin.dart';

class ShareImageModel extends DragAbleGridViewBin {
  String img;

  ///是否是自定义属性
  bool isCustom;
  String attr;
  String name;

  ShareImageModel({this.img, this.attr, this.name, this.isCustom});

  @override
  String toString() =>
      "ShareImageModel{ img: $img attr: $attr name: $name isCustom: $isCustom}";
}
