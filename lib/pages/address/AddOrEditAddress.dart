import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/ModifyAddress.dart';
import 'package:flutter_shop/model/address.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/address/city_pickers.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
///
/// 添加或者编辑地址
/// @author longlyboyhe
/// @date 2019/2/15
///
class AddOrEditAddress extends StatefulWidget {
  //true添加地址 false编辑地址
  bool isAdd;
  final Address model;

  AddOrEditAddress({@required this.isAdd = true, this.model});

  @override
  _AddOrEditAddressState createState() => _AddOrEditAddressState();
}

class _AddOrEditAddressState extends State<AddOrEditAddress> {
  Result checkCityAddressResult;
  String userName = "";
  String phone = "";
  String detailAddress = "";
  String address="";
  TextEditingController nameController;
  TextEditingController photoEditingController;
  TextEditingController addressController;
  @override
  void initState() {
    super.initState();
    Address model = widget.model;
    userName = model != null ? model.name : "";
    phone = model != null ? model.mobile : "";
    if(model!=null){
      if(model.province!=null){
        address+=model.province+" ";
      }
      if(model.city!=null){
        address+=model.city+" ";
      }
      if(model.district!=null){
        address+=model.district;
      }
      detailAddress = model.address;
    }

    nameController= TextEditingController.fromValue(
        TextEditingValue(
          text: widget.isAdd ? "" : widget.model.name==null?"":widget.model.name,
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.isAdd ? 0 : (widget.model.name == null ? 0: widget.model.name.length))),

        )
    );
    photoEditingController = TextEditingController.fromValue(
        TextEditingValue(
          text: widget.isAdd ? "" : widget.model.mobile==null?"":widget.model.mobile,
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.isAdd ? 0 : (widget.model.mobile == null? 0:widget.model.mobile.length))),

        )
    );

    addressController=TextEditingController.fromValue(
        TextEditingValue(
          text: widget.isAdd?"":widget.model.address==null?"":widget.model.address,
          selection: TextSelection.fromPosition(TextPosition(
              affinity: TextAffinity.downstream,
              offset: widget.isAdd ? 0 : (widget.model.address == null ? 0 : widget.model.address.length))),

        )
    );
  }

  Widget _text(String text, {EdgeInsetsGeometry padding}) {
    Widget returnText = Text(text,
        style: TextStyle(
            color: Color(0xFFBCBCBC),
            fontWeight: FontWeight.w400,
            fontSize: 12));
    if (padding != null) {
      returnText = Padding(padding: padding, child: returnText);
    }
    return returnText;
  }

  Widget _rowName() {
    String hintName = widget.model == null ? "请输入姓名" : widget.model.name;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 5,
            child: _text('收货人姓名', padding: EdgeInsets.only(left: ScreenUtil().L(15), top: ScreenUtil().L(15), bottom: ScreenUtil().L(15)))),
        Expanded(
            flex: 14,
            child: TextField(
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
              onChanged: (value) {
                userName = value;
                if(!widget.isAdd){
                  widget.model.name=userName;
                  setState(() {
                  });
                }
              },
              controller: nameController,
              decoration: InputDecoration(
                  hintText: hintName,
                  contentPadding: EdgeInsets.only(right: 15),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: widget.model == null ? Color(0xFFBCBCBC) : Colors.black, fontWeight: FontWeight.w400, fontSize: 12)
              ),
            ))
      ],
    );
  }

  Widget _rowPhone() {
    String hintPhone = widget.model == null ? "请输入电话" : widget.model.mobile;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 5,
            child: _text('收货人电话', padding: EdgeInsets.only(left: ScreenUtil().L(15), top: ScreenUtil().L(15), bottom: ScreenUtil().L(15)))),
        Expanded(
            flex: 14,
            child: TextField(
              onChanged: (value) {
                phone = value;
                if(!widget.isAdd){
                  widget.model.mobile=phone;
                  setState(() {
                  });
                }
              },
              controller: photoEditingController,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(11),
                WhitelistingTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  hintText: hintPhone,
                  contentPadding: EdgeInsets.only(right: 15),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: widget.model == null ? Color(0xFFBCBCBC) : Colors.black, fontWeight: FontWeight.w400, fontSize: 12)),
            ))
      ],
    );
  }

  Widget _rowAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(flex: 5,child: _text('收货人地址',padding: EdgeInsets.only(left: ScreenUtil().L(15), top: ScreenUtil().L(15), bottom: ScreenUtil().L(15)))),
        Expanded(
          flex: 14,
          child: GestureDetector(
              onTap: () {
                selectedAddress();
              },
              child: Row(
                children: <Widget>[
                  Expanded(child: Text(address, style: TextStyle(color: address==null|| address.isEmpty ? Color(0xFFBCBCBC) : Colors.black, fontWeight: FontWeight.w400, fontSize: 12),)),
                  Padding(
                      padding: EdgeInsets.only(right: ScreenUtil().L(15)),
                      child: Icon(Icons.arrow_forward_ios,color: Colors.black, size: ScreenUtil().L(10)))
                ],
              )),
        ),
      ],
    );
  }

  selectedAddress() async {
    Result tempResult = await CityPickers.showCityPicker(
        context: context,
        showType: ShowType.pca,
        barrierOpacity: 0.5,
        barrierDismissible: true);
    if (tempResult == null) {
      return;
    }
    this.setState(() {
      checkCityAddressResult=tempResult;
      address ="${tempResult.provinceName}  ${tempResult.cityName}  ${tempResult.areaName}";
      if(!widget.isAdd){
        widget.model.province=tempResult.provinceName;
        widget.model.city=tempResult.cityName;
        widget.model.district=tempResult.areaName;
      }
    });
  }

  Widget _rowDetailAddress() {
    String hintDetailAddress =widget.model == null ? "请输入详细地址" : widget.model.address;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
            flex: 5,
            child: _text('详细地址', padding: EdgeInsets.only(left: ScreenUtil().L(15), top: ScreenUtil().L(15), bottom: ScreenUtil().L(15)))),
        Expanded(
            flex: 14,
            child: TextField(
              onChanged: (value) {
                detailAddress = value;
                if(!widget.isAdd){
                  widget.model.address=detailAddress;
                  setState(() {
                  });
                }
              },
              controller:addressController,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: hintDetailAddress,
                  contentPadding: EdgeInsets.only(right: 15),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: widget.model == null ? Color(0xFFBCBCBC) : Colors.black, fontWeight: FontWeight.w400, fontSize: 12)),
            ))
      ],
    );
  }

  save() {
    if (userName.isEmpty) {
      ToastUtil.showToast(context, "请输入收货人姓名");
      return false;
    }
    if (phone.isEmpty) {
      ToastUtil.showToast(context, "请输入收货人电话");
      return false;
    }
    if (!StringUtils.verifyPhone(phone)) {
      ToastUtil.showToast(context, "请输入正确的手机号");
      return false;
    }

    if(widget.isAdd){
      if(checkCityAddressResult==null){
        ToastUtil.showToast(context, "请选择收货地址");
        return false;
      }
    }else if(widget.model==null){
      ToastUtil.showToast(context, "请选择收货地址");
      return false;
    }

    if (detailAddress.isEmpty) {
      ToastUtil.showToast(context, "请输入详细地址");
      return false;
    }

    if(widget.isAdd){
      addAddress();
    }else{
      editAddress();
    }
  }

  void addAddress() {
    Map map={
    "name": userName,
    "mobile": phone,
    "country": "中国",
    "province": checkCityAddressResult.provinceName,
    "city": checkCityAddressResult.cityName,
    "district": checkCityAddressResult.areaName,
    "address": detailAddress,
    };
    HttpManager().postForm(context,Api.ADD_ADDRESS, map,(result){
      ToastUtil.showToast(context, "添加成功");
      Navigator.pop(context,true);
    },onError: (error){
      ToastUtil.showToast(context, "添加失败，请重试");
    });
  }

  void editAddress() {
    Map<String,dynamic> map={
      "id": widget.model.id.toString(),
      "name": userName,
      "mobile": phone,
      "country": widget.model.country,
      "province": widget.model.province,
      "city": widget.model.city,
      "district": widget.model.district,
      "address": widget.model.address,
      "default_address":false
    };
   try{
     HttpManager().put(context,Api.EDIT_ADDRESS, map, (result){
       ModifyAddress modifyAddress=ModifyAddress.fromJson(result);
       if(modifyAddress!=null && modifyAddress.result!=null && modifyAddress.result.isSuccess){
         ToastUtil.showToast(context, "修改成功");
         Navigator.pop(context,true);
       }else{
         ToastUtil.showToast(context, "修改失败，请重试");
       }
     },onError: (error){
       ToastUtil.showToast(context, "修改失败，请重试");
     }, );
   }catch(e){
     print(e.toString());
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: CommonAppBar(
          context: context,
          title: widget.isAdd ? KString.addAddress : KString.editAddress,
          bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(bottom: ScreenUtil().L(15)),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _rowName(),
            Divider(height: 1, color: KColor.dividerColor),
            _rowPhone(),
            Divider(height: 1, color: KColor.dividerColor),
            _rowAddress(),
            Divider(height: 1, color: KColor.dividerColor),
            _rowDetailAddress(),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: GestureDetector(
          onTap: () {
            save();
          },
          child: Container(
            height: ScreenUtil().L(45),
            margin: EdgeInsets.only(
                left: ScreenUtil().L(15),
                right: ScreenUtil().L(15),
                top: ScreenUtil().L(10),
                bottom: ScreenUtil().L(10)),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenUtil().L(5)))),
            child: Text(
              KString.save,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }


}
