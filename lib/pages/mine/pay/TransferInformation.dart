import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/image_upload_model.dart';
import 'package:flutter_shop/natives/image_picker.dart';
import 'package:flutter_shop/pages/mine/pay/TransferAccount.dart';
import 'package:flutter_shop/pages/photo/BrowseImage.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/mine/AppButton.dart';
import 'package:flutter_shop/widgets/mine/InputView.dart';

///
/// 转账信息
/// @author longlyboyhe
/// @date 2019/3/11
///
class TransferInformation extends StatefulWidget {
  @override
  _TransferInformationState createState() => _TransferInformationState();
}

class _TransferInformationState extends State<TransferInformation> {
  GlobalKey<AppButtonState> _appButtonKey = GlobalKey();
  String remitNo = "";
  String remitName = "";
  String remitPhone = "";
  String remitMoney = "";
  String imgPath = "";

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil().L(25)),
      color: KColor.dividerColor,
      height: 0.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
          context: context, title: "对公转账", bottom: CommonAppBarBottomLine()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TransferContent(),
            Container(
              color: KColor.bgColor,
              height: ScreenUtil().L(10),
            ),
            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(25),
                  top: ScreenUtil().L(15),
                  bottom: ScreenUtil().L(15)),
              alignment: Alignment.centerLeft,
              color: Color(0xFFD4D4D4),
              child: Text("汇款方信息",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ),
//            Container(
//              padding: EdgeInsets.symmetric(
//                  horizontal: ScreenUtil().L(25), vertical: ScreenUtil().L(16)),
//              child: Row(
//                children: <Widget>[
//                  Text("充值类型",
//                      style: TextStyle(
//                          color: Colors.black,
//                          fontSize: 12,
//                          fontWeight: FontWeight.w400)),
//                  Expanded(
//                      child: Padding(
//                    padding: EdgeInsets.only(left: ScreenUtil().L(10)),
//                    child: Text("对公转账",
//                        maxLines: 2,
//                        textAlign: TextAlign.right,
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyle(
//                            color: Colors.black,
//                            fontSize: 14,
//                            fontWeight: FontWeight.w500)),
//                  )),
//                ],
//              ),
//            ),
//            _divider(),
            PassWordInput(
              inputType: InputType.text,
              textDirection: TextDirection.rtl,
              margin: EdgeInsets.only(left: ScreenUtil().L(25)),
              padding: EdgeInsets.zero,
              lableText: "汇款单号",
              hintText: "请输入",
              inputStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              getInputText: (string) {
                remitNo = string;
                setButtonEnable();
              },
            ),
            _divider(),
            PassWordInput(
              inputType: InputType.text,
              textDirection: TextDirection.rtl,
              margin: EdgeInsets.only(left: ScreenUtil().L(25)),
              padding: EdgeInsets.zero,
              lableText: "汇款人姓名",
              hintText: "请输入",
              inputStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              getInputText: (string) {
                remitName = string;
                setButtonEnable();
              },
            ),
            _divider(),
            PassWordInput(
              inputType: InputType.phone,
              textDirection: TextDirection.rtl,
              margin: EdgeInsets.only(left: ScreenUtil().L(25)),
              padding: EdgeInsets.zero,
              lableText: "汇款人联系方式",
              hintText: "请输入",
              inputStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              getInputText: (string) {
                remitPhone = string;
                setButtonEnable();
              },
            ),
            _divider(),
            PassWordInput(
              inputType: InputType.text,
              textDirection: TextDirection.rtl,
              margin: EdgeInsets.only(left: ScreenUtil().L(25)),
              padding: EdgeInsets.zero,
              lableText: "汇款金额",
              hintText: "请输入",
              inputStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              getInputText: (string) {
                remitMoney = string;
                setButtonEnable();
              },
            ),
            _divider(),
//            PassWordInput(
//              inputType: InputType.number,
//              textDirection: TextDirection.rtl,
//              margin: EdgeInsets.only(
//                  left: ScreenUtil().L(25), bottom: ScreenUtil().L(10)),
//              padding: EdgeInsets.zero,
//              lableText: "交易流水号",
//              hintText: "请输入",
//              inputStyle: TextStyle(
//                  color: Colors.black,
//                  fontSize: 14,
//                  fontWeight: FontWeight.w500),
//              getInputText: (string) {
//                tradeNum = string;
//                setButtonEnable();
//              },
//            )
            Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().L(25), top: ScreenUtil().L(16)),
              child: Text(
                "汇款单",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
            ),
            Container(
              height: ScreenUtil().L(108),
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: ScreenUtil().L(25),
                  right: ScreenUtil().L(25),
                  top: ScreenUtil().L(7),
                  bottom: ScreenUtil().L(20)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: KColor.bgColor, width: 1)),
              child: imgPath.isEmpty
                  ? GestureDetector(
                      onTap: () {
                        ImagePicker.pickImages(maxImgCount: 1, canCrop: false)
                            .then((images) {
                          if (images != null && images.length > 0) {
                            setState(() {
                              imgPath = images[images.length - 1];
                              setButtonEnable();
                            });
                          }
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: ScreenUtil().L(30),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: ScreenUtil().L(6)),
                            height: ScreenUtil().L(30),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().L(5)))),
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                              size: ScreenUtil().L(6),
                            ),
                          ),
                          Text(
                            "上传图片",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 12),
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        routePagerNavigator(
                            context, BrowserImage([imgPath], 0));
                      },
                      child: Stack(
                        children: <Widget>[
                          Image.file(
                            File(imgPath),
                            fit: BoxFit.fill,
                            width: ScreenUtil().L(130),
                            height: ScreenUtil().L(80),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              child: Container(
                                child: Icon(Icons.close,
                                    color: Colors.black54, size: 15),
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF1F1F1),
                                    shape: BoxShape.circle),
                              ),
                              onTap: () {
                                imgPath = "";
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Color(0xffE5E5E5), offset: Offset(0, -1), blurRadius: 5),
          ]),
          child: AppButton(
            key: _appButtonKey,
            title: "提交",
            margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().L(15), vertical: ScreenUtil().L(10)),
            onTap: () {
              _commitImg();
            },
          ),
        ),
      ),
    );
  }

  _commitImg() {
    _appButtonKey.currentState.setStartLoadding(false);
    LoadingDialogUtil.showLoading(context, msg: "正在提交");

    HttpManager().uploadMultiImageFile(context, [imgPath], (result) {
      ImageUploadModel uploadModel = ImageUploadModel.fromJson(result);
      if (uploadModel != null &&
          uploadModel.data != null &&
          uploadModel.data.length > 0) {
        _commit(uploadModel.data[0].url);
      } else {
        Navigator.pop(context);
        ToastUtil.showToast(context, "提交失败，请重新尝试");
      }
    }, onErr: (error) {
      Navigator.pop(context);
      ToastUtil.showToast(context, "提交失败，请重新尝试");
    });
  }

  _commit(String img) async {
    Map params = {
      'bank_serial_number': remitNo,
      'payer_name': remitName,
      'user_mobile': remitPhone,
      'order_amt': remitMoney,
      'pic_url': [img],
      'source_from': "0",
    };
    HttpManager.instance.post(
        context,
        Api.PAYCENTER_CHARGE,
        (json) {
          Map result = json["result"];
          bool isSuccess = result["is_success"];
          if (isSuccess) {
            ToastUtil.showToast(context, "提交成功");
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          } else {
            Navigator.pop(context);
            ToastUtil.showToast(context, "提交失败，请重新尝试");
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          Navigator.pop(context);
          ToastUtil.showToast(context, "提交失败，请重新尝试");
        });
  }

  void setButtonEnable() {
    if (remitNo.isNotEmpty &&
        remitName.isNotEmpty &&
        remitPhone.isNotEmpty &&
        remitMoney.isNotEmpty &&
        imgPath.isNotEmpty) {
      _appButtonKey.currentState.setEnable(true);
    } else {
      _appButtonKey.currentState.setEnable(false);
    }
  }
}
