import 'package:flutter_shop/model/GoodsItemModel.dart';
import 'package:flutter_shop/natives/umengshare.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/home/HorizontalGoodsListView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/**
 * 商品详情页
 * @author longlyboyhe
 * @date 2018/12/28
 */
class GoodsDetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GoodsDetailsPageState();
  }
}

class GoodsDetailsPageState extends State<GoodsDetailsPage> {
  Future<bool> _requestPop() {
    ToastUtil.showToast(context, "点击物理按键返回了");
    return new Future.value(false);
  }

  ScrollController _controller;

  double titleOpacity = 0;

  bool isCollected = false; //是否已经收藏
  int goodsSize = 0; //商品数量

  Widget _title() {
    return Opacity(
      opacity: titleOpacity,
      child: Text(
        "BURBERRY",
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontFamily: "AbrilFatface"),
      ),
    );
  }

  //TODO 假数据
  List<GoodsItemModel> list = List();
  List<String> imgs = List();
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  void loadData() async {
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();

    _controller = ScrollController();
    //kToolbarHeight ： appbar高度
    _controller.addListener(() {
      double offset = _controller.offset;
      setState(() {
        if (offset <= kToolbarHeight) {
          titleOpacity = offset / kToolbarHeight;
        }
        titleOpacity = titleOpacity <= 0 ? 0 : titleOpacity;
      });
    });

    for (int i = 0; i < 5; i++) {
      list.add(GoodsItemModel(
          name: "name$i", img: "images/bg.jpeg", price: 15632));
      imgs.add("images/bg.jpeg");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/bg.jpeg",
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: Text(
            "第$index张图片",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }

  //分享按钮
  Widget _shareButton() {
    return GestureDetector(
      onTap: () {
//        UMengShare.shareMediaWithMenu(
//            UMShareMediaType.WebUrl,
//            "分享分享测试",
//            "分享的是desc",
//            "http://img.dislux.com/upload/img/brand/1542100089407.jpg",
//            "https://www.baidu.com");
        UMengShare.checkInstall(UMPlatform.QQ, onResult: (bool isInstall) {
          print("是否安装了QQ =$isInstall");
        });
      },
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.only(top: 100, bottom: 15, right: 15),
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
            BoxShadow(
                color: Colors.grey[300], offset: Offset(1, 1), blurRadius: 5),
            BoxShadow(
                color: Colors.grey[300], offset: Offset(-1, -1), blurRadius: 5),
            BoxShadow(
                color: Colors.grey[300], offset: Offset(1, -1), blurRadius: 5),
            BoxShadow(
                color: Colors.grey[300], offset: Offset(-1, 1), blurRadius: 5)
          ]),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.launch,
                  color: Colors.black87,
                  size: 20,
                ),
                Text(
                  "分享",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _goodsAttr() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 5),
          child: Text(
            "BURBERRY",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12),
          child: Text(
            "女士棕色红色双色包包斜挎包单肩包424589",
            style: TextStyle(color: Colors.black, fontSize: 13),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "￥",
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
            Text(
              "16,543",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            Text(
              "62543",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 5, bottom: 8),
          child: Text(
            "香港交货",
            style: TextStyle(color: Colors.orange, fontSize: 10),
          ),
          padding: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
//                              color: Colors.orange,
              border: Border.all(color: Colors.orange, width: 1)),
        ),
        Text(
          "库存12",
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _swiper() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 200,
      color: Colors.grey,
      child: Swiper(
        itemBuilder: _swiperBuilder,
        itemCount: 5,
        pagination: SwiperPagination(
            alignment: Alignment.bottomRight,
            builder: FractionPaginationBuilder(
              color: Colors.grey[400],
              activeColor: Colors.grey[400],
              fontSize: 10,
              activeFontSize: 10,
            )),
        autoplay: true,
        duration: 150,
        controller: SwiperController(),
        scrollDirection: Axis.horizontal,
        onTap: (index) {
          ToastUtil.showToast(context, "点击了第$index个条目");
        },
      ),
    );
  }

  Widget _chatacterItem(IconData icon, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        )
      ],
    );
  }

  Widget _character() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              ToastUtil.showToast(context, "海外直购");
            },
            child: _chatacterItem(Icons.error, "海外直购"),
          ),
          GestureDetector(
            onTap: () {
              ToastUtil.showToast(context, "售后承诺");
            },
            child: _chatacterItem(Icons.pan_tool, "售后承诺"),
          ),
          GestureDetector(
            onTap: () {
              ToastUtil.showToast(context, "正品保障");
            },
            child: _chatacterItem(Icons.widgets, "正品保障"),
          ),
          GestureDetector(
            onTap: () {
              ToastUtil.showToast(context, "海量货源");
            },
            child: _chatacterItem(Icons.hd, "海量货源"),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Divider(
        height: 1,
        color: Colors.grey,
      ),
    );
  }

  Widget _selectAttr() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(top: 50, bottom: 50),
                child: Text("选择尺寸/颜色"),
              );
            });
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Text(
              "请选择",
              style: TextStyle(color: Colors.black87, fontSize: 13),
            )),
            Text(
              "尺寸/颜色",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  //选择优惠券
  Widget _selectCoupon() {
    return GestureDetector(
      onTap: () {
        ToastUtil.showToast(context, "优惠券");
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20),
        child: Row(
          children: <Widget>[
            Text(
              "优惠券",
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Container(
                width: 80,
                height: 25,
                child: Image.asset(
                  "images/bg.jpeg",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
                width: 80,
                height: 25,
                child: Image.asset(
                  "images/bg.jpeg",
                  fit: BoxFit.fill,
                )),
            Expanded(child: Text("")),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black87,
            )
          ],
        ),
      ),
    );
  }

  //参数
  Widget _selectParam() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            "参数",
            style: TextStyle(color: Colors.black87, fontSize: 13),
          )),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black87,
          )
        ],
      ),
    );
  }

  //拍前必读
  Widget _selectNotice() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            "拍前必读",
            style: TextStyle(color: Colors.black87, fontSize: 13),
          )),
          Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.black87,
          )
        ],
      ),
    );
  }

  Widget _recommendTitle() {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 10, top: 20, bottom: 5),
        child: Row(
          children: <Widget>[
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Burrberry/宝巴莉",
                  style: TextStyle(color: Colors.black87, fontSize: 15),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 5,
                  ),
                  child: Text(
                    "共879件",
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                )
              ],
            )),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.black87,
            )
          ],
        ));
  }

  Widget _goodsImages() {
    List<Widget> images = List();
    imgs.forEach((imgUrl) {
      images.add(Container(
        margin: EdgeInsets.only(bottom: 10),
        width: MediaQuery.of(context).size.width * 2 / 3,
        height: 200,
        child: Image.asset(
          imgUrl,
          fit: BoxFit.fill,
        ),
      ));
    });
    return Column(
      children: images,
    );
  }

  Widget _bottomView() {
    return Column(
      children: <Widget>[
        Divider(
          height: 1,
          color: Colors.grey[700],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          ToastUtil.showToast(context, "客服");
                        },
                        child: Column(children: <Widget>[
                          Image.asset(
                            "images/cusomer_service.png",
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            "客服",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          )
                        ])),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        ToastUtil.showToast(context, "收藏");
                        setState(() {
                          isCollected = !isCollected;
                        });
                      },
                      child: Column(children: <Widget>[
                        Icon(
                          Icons.favorite_border,
                          color: isCollected ? Colors.orange : Colors.black,
                          size: 20,
                        ),
                        Text(
                          "收藏",
                          style: TextStyle(color: Colors.black, fontSize: 10),
                        )
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Image.asset("images/gouwuche.png",
                              width: 20, height: 20),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: Offstage(
                                offstage: goodsSize <= 0,
                                child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 6,
                                    child: Text(
                                      "$goodsSize",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.white,
                                      ),
                                    )),
                              )),
                        ],
                      ),
                      Text(
                        "购物车",
                        style: TextStyle(color: Colors.black, fontSize: 10),
                      )
                    ]),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  goodsSize++;
                });
              },
              child: Container(
                width: 100,
                padding: EdgeInsets.only(top: 15, bottom: 15),
                color: Colors.black,
                child: Center(
                  child: Text(
                    "加入购物车",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ToastUtil.showToast(context, "立即购买");
              },
              child: Container(
                width: 100,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                color: Colors.orange,
                child: Center(
                  child: Text(
                    "立即购买",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 0,
            centerTitle: true,
            title: _title(),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: BaseContainer(
            isLoading: isLoading,
            child: Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 15),
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //轮询图
                      _swiper(),
                      //商品信息
                      Stack(
                        children: <Widget>[_goodsAttr(), _shareButton()],
                      ),
                      _character(),
                      //请选择
                      _selectAttr(),
                      _divider(),
                      //优惠券
                      _selectCoupon(),
                      _divider(),
                      _selectParam(),
                      _divider(),
                      _selectNotice(),
                      Container(
                        height: 10,
                        color: Colors.grey[200],
                      ),
                      _recommendTitle(),
                      HorizontalGoodsListView(
                        list,
                        height: 100,
                        itemWidth: 80,
                        showMoreButton: true,
                        itemPadding:
                            EdgeInsets.only(left: 5, right: 5, bottom: 10),
                        onItemClick: (data, int index) {
                          ToastUtil.showToast(context, "点击了第$index条数据,${data.name}");
                        },
                        padding: EdgeInsets.only(left: 10, right: 10),
                      ),
                      Container(
                        height: 10,
                        color: Colors.grey[200],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 20),
                              child: Text("商品详情",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 13)))
                        ],
                      ),
                      _goodsImages()
                    ],
                  ),
                )),
                _bottomView()
              ],
            ),
          )),
    );
  }
}
