import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/cart_resp.dart';
import 'package:flutter_shop/pages/cart/CartListener.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 购物车底部
/// @author longlyboyhe
/// @date 2019/3/24
///
///
enum BottomType {
  ///不在编辑状态
  noEdit,

  ///编辑状态
  edit,
}

class CartBottom extends StatefulWidget {
  final BottomType bottomType;
  final CartListener listener;
  final Data cartModel;

  CartBottom({this.bottomType, this.listener, this.cartModel});

  @override
  _CartBottomState createState() => _CartBottomState();
}

class _CartBottomState extends State<CartBottom> {
  @override
  Widget build(BuildContext context) {
    Widget bottomView = Container(
      constraints: BoxConstraints.expand(
        height: ScreenUtil().L(65),
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Color(0xffE5E5E5), offset: Offset(0, -1), blurRadius: 5),
      ]),
      padding: EdgeInsets.only(
          right: ScreenUtil().L(15),
          top: ScreenUtil().L(10),
          bottom: ScreenUtil().L(10)),
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: widget.bottomType != BottomType.edit,
            child: CartBottomNoEditWidget(
              listener: widget.listener,
              cartModel: widget.cartModel,
            ),
          ),
          Offstage(
            offstage: widget.bottomType != BottomType.noEdit,
            child: CartBottomEditWidget(
              listener: widget.listener,
              cartModel: widget.cartModel,
            ),
          )
        ],
      ),
    );
    return bottomView;
  }
}

///非编辑状态
class CartBottomNoEditWidget extends StatefulWidget {
  final CartListener listener;
  final Data cartModel;

  CartBottomNoEditWidget({this.listener, this.cartModel});

  @override
  State<StatefulWidget> createState() => _CartBottomNoEditWidgetState();
}

class _CartBottomNoEditWidgetState extends State<CartBottomNoEditWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: InkWell(
              onTap: () => widget.listener.selectAll(),
              child: Container(
                  color: Colors.white,
                  height: double.infinity,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().L(15), right: ScreenUtil().L(5)),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        widget.cartModel?.isAllchecked == true
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: widget.cartModel?.isAllchecked == true
                            ? Colors.black
                            : Color(0xFFBCBCBC),
                        size: ScreenUtil().L(15),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ScreenUtil().L(5)),
                        child: Text(
                          KString.allSelectedTxt,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w300,
                              fontSize: 10),
                        ),
                      )
                    ],
                  ))),
        ),
        Offstage(
          offstage: true,
          child: InkWell(
            onTap: () => widget.listener.collect(),
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: ScreenUtil().L(6),
                    left: ScreenUtil().L(10),
                    bottom: ScreenUtil().L(6)),
                decoration: BoxDecoration(
                  color: Color(0xFFECE936),
                  borderRadius:
                  BorderRadius.all(Radius.circular(ScreenUtil().L(23))),
                ),
                width: ScreenUtil().L(80),
                child: Text(
                  "移入收藏",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                )),
          ),
        ),
        InkWell(
          onTap: () => widget.listener.delete(),
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: ScreenUtil().L(6),
                  left: ScreenUtil().L(10),
                  bottom: ScreenUtil().L(6)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenUtil().L(23))),
                  border: Border.all(color: Colors.black, width: 1)),
              width: ScreenUtil().L(80),
              child: Text(
                "删除",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              )),
        )
      ],
    );
  }
}

///非编辑状态
class CartBottomEditWidget extends StatefulWidget {
  final CartListener listener;
  final Data cartModel;

  CartBottomEditWidget({this.listener, this.cartModel});

  @override
  _CartBottomEditWidgetState createState() => _CartBottomEditWidgetState();
}

class _CartBottomEditWidgetState extends State<CartBottomEditWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                  onTap: () => widget.listener.selectAll(),
                  child: Container(
                      color: Colors.white,
                      height: double.infinity,
                      padding: EdgeInsets.only(
                          left: ScreenUtil().L(15), right: ScreenUtil().L(5)),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            widget.cartModel?.isAllchecked == true
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: widget.cartModel?.isAllchecked == true
                                ? Colors.black
                                : Color(0xFFBCBCBC),
                            size: ScreenUtil().L(15),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: ScreenUtil().L(5)),
                            child: Text(
                              KString.allSelectedTxt,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10),
                            ),
                          )
                        ],
                      ))),
              Expanded(
                child: _TotalWidget(
                  totalPrice: widget.cartModel.sumTotal,
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () => widget.listener.order(),
          child: Container(
              decoration: BoxDecoration(
                  color: Color(0xFFECE936),
                  borderRadius:
                      BorderRadius.all(Radius.circular(ScreenUtil().L(23)))),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10),
              width: ScreenUtil().L(120),
              child: Text(
                KString.generatPurchaseOrders,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              )),
        )
      ],
    );
  }
}

///进货单底部总价，带动画
class _TotalWidget extends StatefulWidget {
  final double totalPrice;

  _TotalWidget({Key key, this.totalPrice}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<_TotalWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween(begin: 0, end: widget.totalPrice).animate(_controller);
    _controller.forward();
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(_TotalWidget oldWidget) {
    animation = Tween(begin: oldWidget.totalPrice, end: widget.totalPrice)
        .animate(_controller);
    _controller.forward(from: 0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: KString.totalSumTxt + ":  ",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: '￥${animation.value.toStringAsFixed(2)}',
                    style: KfontConstant.cartBottomTotalPriceStyle)
              ]),
        )
      ],
    );
  }
}
