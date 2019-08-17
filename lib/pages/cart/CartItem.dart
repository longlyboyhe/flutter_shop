import 'package:flutter/material.dart';
import 'package:flutter_shop/model/cart_resp.dart';
import 'package:flutter_shop/pages/cart/CartBottom.dart';
import 'package:flutter_shop/pages/cart/CartListener.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 进货单item
/// @author longlyboyhe
/// @date 2019/3/24
///
class CartItem extends StatefulWidget {
  final List<Cart> model;
  final int index;
  final CartListener listener;
  final BottomType bottomType;
  Cart itemModel;

  CartItem(
      {this.model, this.index, this.listener, this.bottomType, this.itemModel});

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    Color color =widget.itemModel.originalQuantity == 0 ? Color(0xffB5B5B5) : Colors.black;
    Color addColor = widget.itemModel.originalQuantity == 0 || widget.itemModel.status == -1
        ? Color(0xffB5B5B5)
        : Colors.black;
    Color minuColor = widget.itemModel.originalQuantity == 0 || widget.itemModel.status == -1
        ? Color(0xffB5B5B5)
        : Colors.black;
    TextStyle style = TextStyle(
        color: color,
        fontSize: ScreenUtil().setSp(10),
        fontWeight: FontWeight.w300);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          right: ScreenUtil().L(15),
          top: ScreenUtil().L(10),
          bottom: ScreenUtil().L(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                widget.itemModel.isSelected = !(widget.itemModel.isSelected==null?false:widget.itemModel.isSelected);
                widget.listener.refresh();
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(15),
                  right: ScreenUtil().L(6),
                  top: ScreenUtil().L(15),
                  bottom: ScreenUtil().L(15)),
              child: Icon(
                widget.itemModel?.isSelected == true
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: widget.itemModel?.isSelected == true
                    ? Colors.black
                    : Color(0xFFBCBCBC),
                size: ScreenUtil().L(15),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(right: ScreenUtil().L(9)),
              child: Stack(
                children: <Widget>[
                  FadeInImage(
                    placeholder: AssetImage("images/default_good_image.png"),
                    image: NetworkImage(StringUtils.getImageUrl(widget.itemModel.picUrl==null || widget.itemModel.picUrl.length==0? "" :widget.itemModel.picUrl[0]),),
                    width: ScreenUtil().L(70),
                    height: ScreenUtil().L(70),
                    fit: BoxFit.cover,
                  ),
                  Offstage(
                    offstage: widget.itemModel.status!= -1,
                    child: Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().L(70),
                      height: ScreenUtil().L(70),
                      color: Colors.black.withOpacity(0.6),
                      child: Text("售罄",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w400)),
                    ),
                  )
                ],
              )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.itemModel.title,
                  style: TextStyle(
                      color: widget.itemModel.status== -1
                          ? Color(0xFF949494)
                          : Colors.black,
                      fontWeight: FontWeight.w300,
                      fontSize: 12)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ScreenUtil().L(7)),
                child: widget.itemModel.getSpcAttr() != null
                    ? Text(widget.itemModel.getSpcAttr(),
                        style: TextStyle(color: Color(0xFF949494), fontWeight: FontWeight.w300, fontSize: 10))
                    : Container(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: Text("￥${widget.itemModel.originalPrice}",
                        style: TextStyle(
                            color: widget.itemModel.status== -1
                                ? Color(0xFF949494)
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 14)),
                  ),
                  widget.itemModel?.status == -1
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(
                              right: ScreenUtil().L(8),
                              bottom: ScreenUtil().L(3)),
                          child: Text(
                            "数量",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 8),
                          ),
                        ),
                  widget.itemModel?.status == -1
                      ? GestureDetector(
                          onTap: () {
                            widget.listener.wantToBuy(widget.itemModel);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().L(70),
                            height: ScreenUtil().L(30),
                            decoration: BoxDecoration(
                                color: Color(0xFFECE936),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().L(23)))),
                            child: Text(
                              "求购",
                              style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFB5B5B5))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  widget.listener.changeNum(widget.itemModel, -1);
                                },
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().L(15),
                                      left: ScreenUtil().L(15),
                                      top: ScreenUtil().L(7),
                                      bottom: ScreenUtil().L(7)),
                                  child: Icon(
                                    Icons.remove,
                                    color: minuColor,
                                    size: ScreenUtil().L(10),
                                  ),
                                ),
                              ),
                              Text(
                                "${widget.itemModel.originalQuantity}",
                                style: style,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    widget.listener.changeNum(widget.itemModel, 1);
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(
                                        right: ScreenUtil().L(15),
                                        left: ScreenUtil().L(15),
                                        top: ScreenUtil().L(7),
                                        bottom: ScreenUtil().L(7)),
                                    child: Icon(
                                      Icons.add,
                                      color: addColor,
                                      size: ScreenUtil().L(10),
                                    ),
                                  )),
                            ],
                          ),
                        )
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
