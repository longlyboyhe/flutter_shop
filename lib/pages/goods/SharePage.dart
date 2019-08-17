import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/ShareImageModel.dart';
import 'package:flutter_shop/natives/umengshare.dart';
import 'package:flutter_shop/utils/DataUtils.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/Image.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/share/DragableFlow.dart';
import 'package:flutter_shop/widgets/share/GlobalPriceSelector.dart';
import 'package:flutter_shop/widgets/share/InputDialog.dart';
import 'package:flutter_shop/widgets/share/OptionFlow.dart';
import 'package:flutter_shop/widgets/share/dragablegridview.dart';


///
/// 分享页面
/// @author longlyboyhe
/// @date 2019/2/21
///
class SharePage extends StatefulWidget {
  List<String> images;

  SharePage({this.images});

  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  ScrollPhysics _physics = BouncingScrollPhysics();
  static const int maxImageSize = 9;
  List<ShareImageModel> images = List();
  List<ShareImageModel> changedImages = List();

  List<ShareImageModel> selected = [
    ShareImageModel(attr: "品牌", name: "Gucci古驰"),
    ShareImageModel(attr: "品类", name: "女士 单肩包/斜挎包"),
    ShareImageModel(attr: "货号", name: "GX6789301"),
    ShareImageModel(attr: "折扣", name: "5折"),
    ShareImageModel(attr: "人民币售价", name: "¥3600"),
    ShareImageModel(attr: "适用性别", name: "女士"),
    ShareImageModel(attr: "转发价", name: "¥4100"),
  ];

  //最多五个
  List<ShareImageModel> attrs = [
    ShareImageModel(attr: "老花", name: "老花"),
    ShareImageModel(attr: "双Glogo", name: "双Glogo")
  ];

  //最多自定义5个备选
  static final maxCustomNum = 5;
  int customAttrSize = maxCustomNum;

  String shareGoodsTitle = "";

  ///单价设置
  double unitPrice = 0;

  ///全局加价
  double globalPrice = 0;
  double sharePrice = 0;
  double goodPrice = 3600.00;

  @override
  void initState() {
    super.initState();
    widget.images?.forEach((img) {
      images.add(ShareImageModel(img: img));
    });
    getGoodsTitle();
    DataUtils.getGlobalPrice().then((price) {
      setState(() {
        globalPrice = price;
        sharePrice = goodPrice + globalPrice;
      });
    });
  }

  String getGoodsTitle() {
    shareGoodsTitle = "";
    selected.forEach((model) {
      shareGoodsTitle = shareGoodsTitle + model.name + " ";
    });
  }

  void _showGlobalPrice(BuildContext context) {
    BuildContext mContext = context;
    showDialog(
        context: mContext,
        builder: (context) {
          return GlobalPriceSelector(
              curPrice: globalPrice,
              onTap: (String price) {
                if (price == "自定义") {
                  Navigator.pop(context);
                  showDialog(
                      context: mContext,
                      builder: (context) {
                        return InputDialog(
                          message: '自定义全局加价',
                          buttonText: '保存',
                          hintText: '请输入价格',
                          isMoney: true,
                          onSave: (String text) {
                            _setGlobalPrice(text, context);
                          },
                        );
                      });
                } else {
                  _setGlobalPrice(price, context);
                }
              });
        });
  }

  void _setGlobalPrice(String text, BuildContext context) {
    if (unitPrice == 0) {
      setState(() {
        globalPrice = StringUtils.str2Double(text, defaultDouble: globalPrice);
        DataUtils.setGlobalPrice(globalPrice);
        sharePrice = goodPrice + globalPrice;
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
          existBackIcon: false,
          context: context,
          title: KString.shareTitle,
          actions: [
            Button(
                child: Icon(Icons.clear,
                    color: Colors.black, size: ScreenUtil().L(20)),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.only(right: ScreenUtil().L(15)))
          ],
          bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        physics: _physics,
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 9, right: 9, top: 3, bottom: 3),
            margin: EdgeInsets.only(
                top: ScreenUtil().L(20), bottom: ScreenUtil().L(5)),
            decoration: BoxDecoration(
                color: KColor.yellowColor,
                borderRadius: BorderRadius.all(Radius.circular(3.0))),
            child: Text(
              KString.relayPrice,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Center(
            child: Text("¥${sharePrice.toStringAsFixed(2)}",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 24)),
          ),
          Text("售价：¥2989.00",
              style: TextStyle(
                  color: Color(0xFF8F8F8F),
                  fontWeight: FontWeight.w300,
                  fontSize: 14)),
          Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().L(21), bottom: ScreenUtil().L(23)),
            margin: EdgeInsets.only(top: ScreenUtil().L(23)),
            decoration: BoxDecoration(color: Color(0xFFFAFAFA), boxShadow: [
              BoxShadow(
                  color: Color(0xFFD1D1D1),
                  offset: Offset(0, 1),
                  blurRadius: 8),
            ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MarkupButton(
                    img: "images/icon_unit_price.png",
                    title: KString.unitPrice,
                    setUp: unitPrice != null && unitPrice > 0,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return InputDialog(
                              message: '自定义分享价格',
                              buttonText: '保存',
                              hintText: '请输入价格',
                              isMoney: true,
                              onSave: (String text) {
                                setState(() {
                                  unitPrice = StringUtils.str2Double(text,
                                      defaultDouble: sharePrice);
                                  sharePrice = unitPrice;
                                });
                                Navigator.pop(context);
                              },
                            );
                          });
                    }),
                Container(
                  color: Color(0xFFEFEFEF),
                  height: ScreenUtil().L(40),
                  width: 1,
                ),
                MarkupButton(
                    img: "images/icon_global_price.png",
                    title: KString.globalPrice,
                    setUp: globalPrice != null && globalPrice > 0,
                    onTap: () {
                      _showGlobalPrice(context);
                    })
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().L(13),
                  right: ScreenUtil().L(18),
                  left: ScreenUtil().L(15)),
              child: Row(children: <Widget>[
                Expanded(
                    child: Text(KString.edit1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 14))),
                Text("${widget.images.length}/$maxImageSize",
                    style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontWeight: FontWeight.w500,
                        fontSize: 10))
              ])),
          DragAbleGridView(
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 14.0,
            childAspectRatio: 1,
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                left: ScreenUtil().L(15),
                right: ScreenUtil().L(15),
                top: ScreenUtil().L(13),
                bottom: ScreenUtil().L(12)),
            itemBins: images,
            isOpenDragAble: true,
            animationDuration: 50,
            longPressDuration: 50,
            deleteIcon: Padding(
                padding: EdgeInsets.all(5),
                child: Image.asset("images/icon_clear.png",
                    width: 18.0, height: 18.0)),
            child: (int position) {
              return Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Color(0xFFDFDFDF),
                      offset: Offset(-1, 0),
                      blurRadius: 10)
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: CommonImage(
                      type: ImageType.net,
                      url: images[position].img,
                      width: ScreenUtil().L(108),
                      height: ScreenUtil().L(108)),
                ),
              );
            },
            onChanged: (List<ShareImageModel> list) {
              if (list != null) {
                setState(() {
                  changedImages.clear();
                  changedImages.addAll(list);
                  print("changedImages=${changedImages.toString()}");
                });
              }
            },
            setScrollable: (canScroll) {
              setState(() {
                _physics = canScroll
                    ? BouncingScrollPhysics()
                    : NeverScrollableScrollPhysics();
              });
            },
          ),
          Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().L(18),
                  left: ScreenUtil().L(15),
                  bottom: ScreenUtil().L(11)),
              child: Row(children: <Widget>[
                Text(KString.edit2,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14)),
                Text("（可在分享时粘贴）",
                    style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontWeight: FontWeight.w400,
                        fontSize: 14))
              ])),
          Offstage(
            offstage: selected.length == 0,
            child: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(15),
                  bottom: ScreenUtil().L(11),
                  right: ScreenUtil().L(15)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text("已选：",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12)),
                  ),
                  Expanded(
                      child: DragableFlow(
                    selected,
                    onDelete: (item, index) {
                      setState(() {
                        ToastUtil.showToast(context, "删除了$item $index");
                        selected.removeAt(index);
                        attrs.add(item);
                        getGoodsTitle();
                      });
                    },
                  ))
                ],
              ),
            ),
          ),
          Offstage(
            offstage: attrs.length == 0 && customAttrSize == 1,
            child: Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(15),
                  bottom: ScreenUtil().L(20),
                  right: ScreenUtil().L(15)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text("备选：",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 12)),
                  ),
                  Expanded(
                      child: OptionFlow(
                    attrs,
                    maxCustomNum: maxCustomNum,
                    onSelected: (item, index) {
                      setState(() {
                        ToastUtil.showToast(context, "选择了$item $index");
                        attrs.removeAt(index);
                        selected.add(item);
                        getGoodsTitle();
                      });
                    },
                    onCustom: (model, size) {
                      setState(() {
                        ToastUtil.showToast(context, "自定义了$model  $size");
                        customAttrSize = size;
                        selected.add(model);
                        getGoodsTitle();
                      });
                    },
                  ))
                ],
              ),
            ),
          ),
          Offstage(
            offstage: shareGoodsTitle.isEmpty,
            child: Padding(
                padding: EdgeInsets.only(
                    right: ScreenUtil().L(18), left: ScreenUtil().L(15)),
                child: Row(children: <Widget>[
                  Text("商品描述预览",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14)),
                  Text("（已复制）",
                      style: TextStyle(
                          color: Color(0xFFACACAC),
                          fontWeight: FontWeight.w400,
                          fontSize: 14))
                ])),
          ),
          Offstage(
            offstage: shareGoodsTitle.isEmpty,
            child: Padding(
              padding: EdgeInsets.only(
                  right: ScreenUtil().L(15),
                  left: ScreenUtil().L(15),
                  top: ScreenUtil().L(7),
                  bottom: ScreenUtil().L(30)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(shareGoodsTitle,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14)),
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: BottomBar(images),
      ),
    );
  }
}

class MarkupButton extends StatefulWidget {
  String img;
  String title;
  bool setUp;
  VoidCallback onTap;

  MarkupButton(
      {this.img, @required this.title, this.setUp = false, this.onTap});

  @override
  _MarkupButtonState createState() => _MarkupButtonState();
}

class _MarkupButtonState extends State<MarkupButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: ScreenUtil().L(10)),
              child: Image.asset(widget.img)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 16)),
              Text(widget.setUp ? KString.setUp : KString.notSetUp,
                  style: TextStyle(
                      color:
                          widget.setUp ? Color(0xFF8F8F8F) : Color(0xFFC10000),
                      fontWeight: FontWeight.w400,
                      fontSize: 14))
            ],
          )
        ],
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  List<ShareImageModel> images;

  BottomBar(this.images);

  Widget _button(String text, Color textColor, Color bgColor, double height,
      VoidCallback onPressed) {
    return Button(
      child: Text(text,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w400, fontSize: 12)),
      onPressed: onPressed,
      fillColor: bgColor,
      constraints: BoxConstraints(minHeight: height, maxHeight: height),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: _button(KString.downLoadImages, Colors.white, Colors.black,
                ScreenUtil().L(50), () {
          _downLoadImages(context);
        })),
        Expanded(
            child: _button(KString.shareProduct, Colors.black,
                KColor.yellowColor, ScreenUtil().L(50), () {
          _share(context);
        }))
      ],
    );
  }

  _downLoadImages(BuildContext context) async {
//    images.forEach((model) async {
//      var response = await http.get(model.img);
//      var filePath = await ImagePicker.saveFile(fileData: response.bodyBytes);
//      print("_takeScreenShot filePath=$filePath");
//    });
    ToastUtil.showToast(context, "图片已下载到相册");
  }

  _share(context) {
//    routePagerNavigator(context, SharePreview(images));

    List<String> stringImages = List();
    for (var value in images) {
      stringImages.add(value.img);
    }
    UMengShare.share("¥4100.00", "Gucci古驰 女士 单肩包/斜挎包 欧洲 原价 5折 运费 ", "红绿条/棕色/M",
        stringImages);
//    UMengShare.shareText(UMSharePlatform.QQ, "你好");
  }
}
