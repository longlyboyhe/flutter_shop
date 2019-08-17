import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
///
///
class BrowserImage extends StatelessWidget {
  List<dynamic> list;
  int index;

  BrowserImage(this.list, this.index);




  @override
  Widget build(BuildContext context) {
    List<PhotoViewGalleryPageOptions> optionList = List();
    if (list != null) {
      for (String path in list) {
        PhotoViewGalleryPageOptions pageOptions = PhotoViewGalleryPageOptions(
            imageProvider: FileImage(
              File(path),
            ),
            maxScale: 0.5,
            minScale: 0.1);
        optionList.add(pageOptions);
      }
    }

    return GestureDetector(
      child: Container(
        child: PhotoViewGallery(
          pageOptions: optionList,
          pageController: PageController(
            keepPage: true,
            initialPage: index,
          ),
        ),
        color: Colors.black,
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
