import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/model/address_list.dart';
import 'package:flutter_shop/pages/address/BottomBarListener.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// @author longlyboyhe
/// @date 2019/2/15
///

enum BottomType {
  ///空状态
  empty,

  ///非空状态，不在编辑状态
  noEmptyNoEdit,

  ///非空状态，编辑状态
  noEmptyEdit,

}

class AddressBookBottom extends StatefulWidget {
  // 三种底部栏  1空白页只有新建联系人 2有联系人新增收货人和确认  3有联系人编辑状态全选和删除
  final BottomType bottomType;
  final BottomBarListener listener;
  final AddressListResp addressModel;
  bool isMinePageEnter;

  AddressBookBottom({this.addressModel, this.bottomType, this.listener,this.isMinePageEnter});

  @override
  _AddressBookBottomState createState() => _AddressBookBottomState();
}

class _AddressBookBottomState extends State<AddressBookBottom> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list=List();

    Offstage offstage1= Offstage(
      offstage: widget.bottomType != BottomType.empty,
      child: BottomView1(widget.listener),
    );
    Offstage offstage3 = Offstage(
      offstage: widget.bottomType != BottomType.noEmptyEdit,
      child: BottomView3(widget.listener, widget.addressModel),
    );

    if(widget.isMinePageEnter){
      list.add(offstage1);
      list.add(offstage3);
    }else{
      list.add(offstage1);
      list.add(Offstage(
        offstage: widget.bottomType != BottomType.noEmptyNoEdit,
        child: BottomView2(widget.listener),
      ));

      list.add(offstage3);
    }

    Widget bottomView = Container(
      constraints: BoxConstraints.expand(height: ScreenUtil().L(65),),
      padding: EdgeInsets.only(right: ScreenUtil().L(15), top: ScreenUtil().L(10), bottom: ScreenUtil().L(10)),
      child: Stack(children: list,),
    );
    return bottomView;
  }
}

class BottomView1 extends StatefulWidget {
  final BottomBarListener listener;

  BottomView1(this.listener);

  @override
  _BottomView1State createState() => _BottomView1State();
}

class _BottomView1State extends State<BottomView1> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.listener.addAdress();
      },
      child: Container(
        margin: EdgeInsets.only(left: ScreenUtil().L(15)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.black,
              size: ScreenUtil().L(15),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil().L(5)),
              child: Text(
                KString.addAddress,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomView2 extends StatefulWidget {
  final BottomBarListener listener;

  BottomView2(this.listener);

  @override
  _BottomView2State createState() => _BottomView2State();
}

class _BottomView2State extends State<BottomView2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
              onTap: () {
                widget.listener.addAdress();
              },
              child: Container(
                margin: EdgeInsets.only(left: ScreenUtil().L(15)),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().L(5)),
                        bottomLeft: Radius.circular(ScreenUtil().L(5)))),
                child: Text(
                  KString.addAddress,
                  style: TextStyle(
                      color: Color(0xFF1D1E1F),
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
              )),
        ),
        Expanded(
          child: GestureDetector(
              onTap: () {
                widget.listener.selected();
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(ScreenUtil().L(5)),
                        bottomRight: Radius.circular(ScreenUtil().L(5)))),
                child: Text(
                  KString.ok,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
              )),
        )
      ],
    );
  }
}

class BottomView3 extends StatefulWidget {
  final BottomBarListener listener;
  final AddressListResp addressModel;

  BottomView3(this.listener, this.addressModel);

  @override
  _BottomView3State createState() => _BottomView3State();
}

class _BottomView3State extends State<BottomView3> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
            onTap: () {
              widget.listener.selectAll();
            },
            child: Container(
              color: Colors.white,
              height: double.infinity,
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(15), right: ScreenUtil().L(5)),
              child: Row(
                children: <Widget>[
                  Icon(
                    widget.addressModel?.isAllchecked == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: widget.addressModel?.isAllchecked == true
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
              ),
            )),
        GestureDetector(
          onTap: () {
            widget.listener.delete();
          },
          child: Container(
            width: ScreenUtil().L(170),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
            child: Text(
              KString.deleteAddress,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }
}
