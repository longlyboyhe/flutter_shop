import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/address.dart';
import 'package:flutter_shop/model/address_list.dart';
import 'package:flutter_shop/pages/address/AddressBookBottom.dart';
import 'package:flutter_shop/pages/address/BottomBarListener.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 地址簿item
/// @author longlyboyhe
/// @date 2019/2/15
///
class AddressBookItem extends StatefulWidget {
  final AddressListResp model;
  final int index;
  final BottomBarListener listener;
  final BottomType bottomType;
  Address itemModel;
  bool isMinePageEnter;

  AddressBookItem(this.model, this.index, this.listener, this.bottomType, this.isMinePageEnter){
    if(model!=null && model.data!=null && model.data.length>0){
      itemModel = model?.data[index];
    }
  }

  @override
  _AddressBookItemState createState() => _AddressBookItemState();
}

class _AddressBookItemState extends State<AddressBookItem> {
  Widget _itemText(String text, {EdgeInsetsGeometry padding}) {
    Widget child = Text(text != null ? text : "",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12));
    if (padding != null) {
      child = Padding(padding: padding, child: child);
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(right: ScreenUtil().L(15), top: ScreenUtil().L(18), bottom: ScreenUtil().L(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                if (widget.bottomType == BottomType.noEmptyNoEdit) {
                  widget.model.switchSelecte(widget.itemModel);
                } else {
                  widget.itemModel.isSelected = !widget.itemModel.isSelected;
                }
                widget.listener.refresh();
              });
            },
            child: Container(
              color: Colors.white,
              height: 30,
              width: 50,
              child: Offstage(
                offstage: widget.isMinePageEnter && widget.bottomType==BottomType.empty,
                child: Icon(
                  widget.itemModel?.isSelected == true ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: widget.itemModel?.isSelected == true ? Colors.black : Color(0xFFBCBCBC),
                  size: ScreenUtil().L(15),
                ),
              ),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: _itemText(widget.itemModel?.name,padding: EdgeInsets.only(right: 10)),
                  ),
                  _itemText(widget.itemModel?.mobile),
                  GestureDetector(
                    onTap: () {
                      widget.listener.addAdress(model: widget.itemModel);
                    },
                    child: Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
                        child: Text(
                          KString.cartTitleRightText,
                          style: TextStyle(color: Color(0xFFC4C4C4), fontWeight: FontWeight.w400, fontSize: 10),
                        )),
                  )
                ],
              ),
              _itemText(widget.itemModel?.address,padding: EdgeInsets.only(top: 5))
            ],
          ))
        ],
      ),
    );
  }
}
