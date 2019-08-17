import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/ShareImageModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 分享预览
/// @author longlyboyhe
/// @date 2019/2/26
///
class SharePreview extends StatefulWidget {
  List<ShareImageModel> images = List();

  SharePreview(this.images);

  @override
  _SharePreviewState createState() => _SharePreviewState();
}

class _SharePreviewState extends State<SharePreview>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SharePreview> {
  List<Widget> tabs = [Tab(text: "主图"), Tab(text: "多图")];
  TabController _tabController;
  GlobalKey previewContainer = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, initialIndex: 0, length: tabs.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _body = [];
    Widget _image(String url) {
      return Image.network(url, fit: BoxFit.fill);
    }

    if (widget.images != null && widget.images.length > 0) {
      if (_tabController.index == 0) {
        _body.add(_image(widget.images[0].img));
      } else {
        widget.images.forEach((model) {
          _body.add(_image(model.img));
        });
      }
    }
    _body.add(Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg1.jpg"), fit: BoxFit.fill)),
        child: Padding(
            padding: EdgeInsets.only(
                left: ScreenUtil().L(25),
                right: ScreenUtil().L(18),
                top: ScreenUtil().L(15),
                bottom: ScreenUtil().L(18)),
            child: Column(
              children: <Widget>[
                Text("¥4100.00",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                Padding(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().L(10), bottom: ScreenUtil().L(5)),
                    child: Text("Gucci古驰 女士 单肩包/斜挎包 欧洲 原价 5折 运费 ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14))),
                Text("¥4100.00",
                    style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontWeight: FontWeight.w400,
                        fontSize: 12)),
              ],
            ))));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:
            CommonAppBar(context: context, title: KString.sharePreviewTitle),
        body: Column(
          children: <Widget>[
            TabBar(
              labelPadding: EdgeInsets.all(0),
              tabs: tabs,
              controller: _tabController,
              isScrollable: false,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              indicatorColor: KColor.yellowColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: ScreenUtil().L(3),
              indicatorPadding: EdgeInsets.only(bottom: 0.5),
              labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
              unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w300),
            ),
            Expanded(
              child: Container(
                color: Color(0xFFFAFAFA),
                padding: EdgeInsets.only(
                    top: ScreenUtil().L(21),
                    left: ScreenUtil().L(52),
                    right: ScreenUtil().L(52)),
                child: RepaintBoundary(
                    key: previewContainer,
                    child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: ScreenUtil().L(21)),
                        child: Column(
                          children: _body,
                        ))),
              ),
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: ButtomBar(previewContainer),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class ButtomBar extends StatelessWidget {
  final GlobalKey previewContainer;

  ButtomBar(this.previewContainer);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().L(122),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0xFFE5E5E5), offset: Offset(0, -1), blurRadius: 5.0)
      ]),
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().L(25), bottom: ScreenUtil().L(20)),
              child: Text("- 分享到 -",
                  style: TextStyle(
                      color: Color(0xFFACACAC),
                      fontWeight: FontWeight.w300,
                      fontSize: 12))),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _imageButton("images/icon_wechat.png", () {
                _takeScreenShot(context, 0);
              }),
              _imageButton("images/icon_wechat.png", () {
                _takeScreenShot(context, 1);
              }),
              _imageButton("images/icon_qq.png", () {
                _takeScreenShot(context, 2);
              })
            ],
          )
        ],
      ),
    );
  }

  void _takeScreenShot(BuildContext context, int type) async {
    File imgFile;
    try {
      RenderRepaintBoundary boundary =
          previewContainer.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage();

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print("_takeScreenShot $pngBytes");

//      String filePath = await ImagePickerSaver.saveFile(fileData: pngBytes);
//      print("_takeScreenShot filePath=$filePath");

    } catch (e) {
      print(e.toString());
      print("_takeScreenShot 异常了异常了");
    }
    if (type == 0) {
      ToastUtil.showToast(context, "微信分享");
    } else if (type == 1) {
      ToastUtil.showToast(context, "朋友圈分享");
    } else {
      ToastUtil.showToast(context, "QQ分享");
    }
  }

  Widget _imageButton(String img, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        img,
        width: ScreenUtil().L(30),
        height: ScreenUtil().L(30),
        fit: BoxFit.fill,
      ),
    );
  }
}
