import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

import 'classification.dart';

/**
 * 分类页
 * @author longlyboyhe
 * @date 2018/1/30
 */
class Category extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryState();
  }
}

class CategoryState extends State<Category>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlankAppBar(
        brightness: Brightness.light,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: ScreenUtil().L(16), bottom: ScreenUtil().L(10)),
            child: Text(
              "分类",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: ScreenUtil().setSp(18)),
            ),
          ),
          Divider(
            height: 1,
            color: KColor.dividerColor,
          ),
          Expanded(
            child: Classification(),
          ),
        ],
      ),
    );
//    return Container(
//      key: ObjectKey("Category"),
//      color: Colors.white,
//      padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight),
//      child: Column(
//        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.only(
//                top: ScreenUtil().L(16), bottom: ScreenUtil().L(10)),
//            child: Text(
//              "分类",
//              style: TextStyle(
//                  color: Colors.black,
//                  fontWeight: FontWeight.w500,
//                  fontSize: ScreenUtil().setSp(18)),
//            ),
//          ),
//          Divider(
//            height: 1,
//            color: KColor.dividerColor,
//          ),
//          Expanded(
//            child: Classification(),
//          ),
//        ],
//      ),
//    );
  }

  @override
  bool get wantKeepAlive => true;
}
