import 'dart:io';

import 'package:flutter/material.dart';

///
/// 即可加载本地图像又能加载网络图片
/// @author longlyboyhe
/// @date 2019/3/7
///
enum ImageType {
  ///本地文件
  file,

  ///网络图片
  net,

  ///本地assert图片
  icon
}

class CommonImage extends StatelessWidget {
  final String url;
  final double width;
  final double height;
  final BoxFit fit;
  ImageType type;
  final File fileHead;
  final bool circle;

  CommonImage(
      {@required this.type,
      this.url,
      this.width,
      this.height,
      this.fit = BoxFit.fill,
      this.fileHead,
      this.circle = false})
      : assert(type == ImageType.file || fileHead == null),
        assert(type != ImageType.file || url != null);

  @override
  Widget build(BuildContext context) {
    Widget image;
    if (url != null && !url.startsWith("http")) {
      type = ImageType.icon;
    }
    if (type == ImageType.net) {
      image = FadeInImage(
        placeholder: AssetImage("images/headimg.png"),
        image: NetworkImage(url),
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    } else if (type == ImageType.file) {
      image = Image.file(
        fileHead,
        fit: BoxFit.fill,
        width: width,
        height: height,
      );
    } else {
      image = Image.asset(
        url,
        fit: fit,
        width: width,
        height: height,
      );
    }
    if (circle) {
      image = ClipOval(
        child: image,
      );
    }
    return image;
  }
}
