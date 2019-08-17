import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/address.dart';
import 'package:flutter_shop/model/address_list.dart';
import 'package:flutter_shop/pages/address/AddOrEditAddress.dart';
import 'package:flutter_shop/pages/address/AddressBookBottom.dart';
import 'package:flutter_shop/pages/address/AddressBookItem.dart';
import 'package:flutter_shop/pages/address/BottomBarListener.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/app_bar.dart';

///
/// 地址簿
/// @author longlyboyhe
/// @date 2019/2/14
///
class AddressBook extends StatefulWidget {
  bool isMinePageEnter;

  AddressBook({this.isMinePageEnter = false});

  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook>
    implements BottomBarListener {
  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载
  AddressListResp addressListResp;
  BottomType bottomType;
  List<Address> addressList;

  Widget _manage() {
    return GestureDetector(
        onTap: () {
          setState(() {
            if (widget.isMinePageEnter) {
              bottomType = bottomType == BottomType.empty
                  ? BottomType.noEmptyEdit
                  : BottomType.empty;
            } else {
              bottomType = bottomType == BottomType.noEmptyNoEdit
                  ? BottomType.noEmptyEdit
                  : BottomType.noEmptyNoEdit;
            }
            addressListResp.initSelecte();
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
          child: Text(
            KString.addressManage,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (widget.isMinePageEnter) {
      bottomType = BottomType.empty;
    } else {
      bottomType = BottomType.noEmptyNoEdit;
    }
    loadData();
  }

  void loadData() async {
    HttpManager().get(context, Api.ADDRESS_LIST, (result) {
      addressListResp = AddressListResp.fromJson(result);
      if (addressListResp != null &&
          addressListResp.result != null &&
          addressListResp.result.isSuccess) {
        if (addressListResp.data != null && addressListResp.data.length > 0) {
          addressList = addressListResp.data;
          isShowEmptyView = false;
        } else {
          bottomType = BottomType.empty;
          isShowEmptyView = true;
        }
      } else {
        bottomType = BottomType.empty;
        isShowEmptyView = true;
      }
      isLoading = false;
      setState(() {});
    }, errorCallback: (error) {
      isShowLoadError = true;
      isLoading = false;
      bottomType = BottomType.empty;
      setState(() {});
    });
  }

  void setType() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColor.bgColor,
      appBar: CommonAppBar(
          context: context,
          title: KString.addressTitle,
          actions: <Widget>[
            widget.isMinePageEnter
                ? _manage()
                : (bottomType == BottomType.empty ? Container() : _manage()),
          ],
          bottom: CommonAppBarBottomLine()),
      body: BaseContainer(
        isLoading: isLoading,
        showLoadError: isShowLoadError,
        reLoad: (){
          loadData();
        },
        showEmpty: isShowEmptyView,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          itemCount: addressList != null ? addressList.length : 0,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => AddressBookItem(
              addressListResp, index, this, bottomType, widget.isMinePageEnter),
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: KColor.dividerColor),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: AddressBookBottom(
          bottomType: bottomType,
          listener: this,
          addressModel: addressListResp,
          isMinePageEnter: widget.isMinePageEnter,
        ),
      ),
    );
  }

  @override
  void addAdress({Address model}) {
    goToAddOrEditAddress(model: model);
  }

  void goToAddOrEditAddress({Address model}) {
    routePagerNavigator(context,
        AddOrEditAddress(isAdd: model == null ? true : false, model: model))
        .then((value) {
      if (value != null && value == true) {
        loadData();
      }
    });
  }

  @override
  void delete() {
    String ids = addressListResp.getSelectedAllId();
    if (ids == null || ids.isEmpty) {
      ToastUtil.showToast(context, "请先选择要删除的地址");
    } else {
      HttpManager().delete(context, Api.DELETE_MUTIL_ADDRESS, (result) {
        BaseResp baseResp = BaseResp.fromJson(result);
        if (baseResp != null &&
            baseResp.result != null &&
            baseResp.result.isSuccess) {
          ToastUtil.showToast(context, "删除成功");
          loadData();
        } else {
          ToastUtil.showToast(context, "删除失败");
        }
      }, onError: (error) {
        ToastUtil.showToast(context, "删除失败");
      }, params: {"ids": ids});
    }
  }

  @override
  void selectAll() {
    setState(() {
      addressListResp.switchAllCheck();
    });
  }

  @override
  void selected() {
    Address model = addressListResp.getSelected();
    if (model != null) {
      Navigator.pop(context, model);
    } else {
      ToastUtil.showToast(context, "请选择");
    }
  }

  @override
  void refresh() {
    ///刷新 如操作item后刷新通知底部栏
    setState(() {});
  }
}
