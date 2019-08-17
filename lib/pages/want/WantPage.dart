import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/want/MyWantToBuy.dart';
import 'package:flutter_shop/pages/want/WantToBuy.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 求购
/// @author longlyboyhe
/// @date 2019/1/3
///
class SelectionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectionPageState();
  }
}

class SelectionPageState extends State<SelectionPage>
    with AutomaticKeepAliveClientMixin<SelectionPage> {
  bool isStartBuy = true;
  bool changeMyWantToBuy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: BlankAppBar(
        brightness: Brightness.light,
      ),
      body: Column(
        children: <Widget>[
          TopTitleButton((startBuy) {
            setState(() {
              changeMyWantToBuy=false;
              isStartBuy = startBuy;
            });
          },changeMyWantToBuy: changeMyWantToBuy,),
          isStartBuy ? WantToBuy(commitSuccessCallBack: (){
            //求购提交成功，切换到我的求购页面
            setState(() {
              isStartBuy=false;
              changeMyWantToBuy=true;
            });
          }) : MyWantToBuy()
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///发起求购/我的求购
class TopTitleButton extends StatefulWidget {
  final ValueChanged<bool> startBuy;
  bool changeMyWantToBuy;
  TopTitleButton(this.startBuy,{this.changeMyWantToBuy});

  @override
  _TopTitleButtonState createState() => _TopTitleButtonState();
}

class _TopTitleButtonState extends State<TopTitleButton> {
  bool startBuy = true;

  @override
  Widget build(BuildContext context) {
    return Container(
//      padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(10)),
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (!startBuy) startBuy = !startBuy;
                    if (widget.startBuy != null) widget.startBuy(true);
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: ScreenUtil().L(10)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().L(36),
                      vertical: ScreenUtil().L(6)),
                  decoration: BoxDecoration(
                      color: widget.changeMyWantToBuy ? Colors.white:(startBuy ? Colors.black : Colors.white),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().L(5)),
                          bottomLeft: Radius.circular(ScreenUtil().L(5))),
                      border: Border.all(color: Colors.black)),
                  child: Text(
                    "发起求购",
                    style: TextStyle(
                        color: widget.changeMyWantToBuy ? Colors.black:(startBuy ? Colors.white : Colors.black),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (startBuy) startBuy = !startBuy;
                    if (widget.startBuy != null) widget.startBuy(false);
                  });
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: ScreenUtil().L(10)),
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().L(36),
                      vertical: ScreenUtil().L(6)),
                  decoration: BoxDecoration(
                      color: widget.changeMyWantToBuy?Colors.black:(!startBuy ? Colors.black : Colors.white),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(ScreenUtil().L(5)),
                          bottomRight: Radius.circular(ScreenUtil().L(5))),
                      border: Border.all(color: Colors.black)),
                  child: Text(
                    "我的求购",
                    style: TextStyle(
                        color: widget.changeMyWantToBuy?Colors.white:(!startBuy ? Colors.white : Colors.black),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
          Container(
            color: KColor.dividerColor,
            height: 1,
          )
        ],
      ),
    );
  }
}
