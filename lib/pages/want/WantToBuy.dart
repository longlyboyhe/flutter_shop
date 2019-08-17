import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/BaseResp.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/model/image_upload_model.dart';
import 'package:flutter_shop/model/want_to_buy_category.dart';
import 'package:flutter_shop/natives/image_picker.dart';
import 'package:flutter_shop/pages/category/model/brand_model.dart';
import 'package:flutter_shop/pages/photo/BrowseImage.dart';
import 'package:flutter_shop/pages/want/BrandFilterPage.dart';
import 'package:flutter_shop/pages/want/StockModel.dart';
import 'package:flutter_shop/utils/LoadingDialogUtil.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import "package:flutter_shop/utils/ToastUtils.dart";
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/address/modal/category_result.dart';
import 'package:flutter_shop/widgets/address/src/category_picker.dart';
import 'package:flutter_shop/widgets/address/src/show_types.dart';
import 'package:flutter_shop/widgets/bottom_sheet.dart';

import 'stock_widget.dart';
///
/// 发起求购
/// @author longlyboyhe
/// @date 2019/3/12
///
class WantToBuy extends StatefulWidget {
  Function commitSuccessCallBack;
  bool showBackBtn;

  WantToBuy({this.commitSuccessCallBack,this.showBackBtn=true});

  @override
  _WantToBuyState createState() => _WantToBuyState();
}

class _WantToBuyState extends State<WantToBuy> {
  TextEditingController goodsNumberController;
  TextEditingController goodsColorController;
  TextEditingController goodsTimeController;
  TextEditingController goodsPriceController;
  TextEditingController descriptionController;
  List<String> uploadImageUrlList;
  List<dynamic> imageList=List();
  int selectTimePosition=-1;
  Map<int,StockModel> dataMap=Map();
  List<Category> categoryList;
  CategoryResult category;
  String categoryName="";
  BrandInfo brandInfo;
  int day=0;

  @override
  void initState() {
    super.initState();
    goodsNumberController= TextEditingController();
    goodsColorController= TextEditingController();
    goodsTimeController= TextEditingController();
    goodsPriceController= TextEditingController();
    descriptionController= TextEditingController();

    loadCategory(false);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Color(0xFFF1F1F1),
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListView(
                padding: EdgeInsets.only(bottom: 120),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Card(
                    margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          arroRightView("品牌", brandInfo==null?"":brandInfo.brandName,(){
                            //TODO 品牌
                            routePagerNavigator(context, BrandFilterPage()).then((result){
                              brandInfo=result;
                              setState(() {
                              });
                            });
                          }),
                          buildDivider(),
                          arroRightView("分类", categoryName,(){
                            //TODO 分类
                            showCategory();
                          }),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(top: 10, right: 0, left: 0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          getInputWidget("货号","请输入型号",TextInputType.text,goodsNumberController,isShowStar: false),
                          buildDivider(),
                          getInputWidget("颜色","请输入色号",TextInputType.text,goodsColorController,isShowStar: true),
                          buildDivider(),
                          StockWidget(dataMap)
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(top: 10, right: 0, left: 0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          arroRightView("调货时限",day>0?"$day天":"",(){
                            selectTimeDialog();
                          }),
                          buildDivider(),
                          getInputWidget("单品报价","请输入",TextInputType.number,goodsPriceController,isShowStar: false),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.only(top: 10, right: 0, left: 0,bottom:20 ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getTilteWidget("添加图片",isShowStar: true),
                          Padding(
                            padding: EdgeInsets.only(top: 10,bottom: 10),
                            child: GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              physics: NeverScrollableScrollPhysics(),
                              children: getImageList(),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 15,bottom: 10),
                            child:  Text("商品描述",style: TextStyle(fontSize: 12, color: Colors.black),),
                          ),
                          TextField(
                            maxLength: 300,
                            autofocus: false,
                            maxLines: 5,
                            controller: descriptionController,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black
                            ),
                            decoration: InputDecoration(
                                hintText: "请输入商品描述信息",
                                contentPadding: EdgeInsets.only(top: 0,left: 0),
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFD8D8D8),
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFF1F1F1),width: 0.5))
            ),
            child: Row(
              mainAxisAlignment: widget.showBackBtn?MainAxisAlignment.end:MainAxisAlignment.center,
              children: <Widget>[
                Offstage(
                  offstage: widget.showBackBtn,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: ScreenUtil.getInstance().L(45),
                      width: ScreenUtil.getInstance().L(140),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1,color:Colors.black,style: BorderStyle.solid),
                          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().L(23))),
                          shape: BoxShape.rectangle
                      ),
                      child: Text("返回",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    commitData();
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().L(42),right: widget.showBackBtn?30:0,),
                    alignment: Alignment.center,
                    height: ScreenUtil.getInstance().L(45),
                    width: ScreenUtil.getInstance().L(140),
                    decoration: BoxDecoration(
                        color: Color(0xFFECE936),
                        borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().L(23))),
                        shape: BoxShape.rectangle
                    ),
                    child: Text("提交",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

   addImage() {
    return GestureDetector(
      onTap: (){
        ImagePicker.pickImages(maxImgCount: 6, canCrop: false).then((images) {
          if (images != null && images.length > 0) {
            imageList.addAll(images);
            if(imageList.length>6){
              imageList.removeRange(5, imageList.length);
            }
            setState(() {
              print(imageList.length);
            });
          }
        });
      },
      child:  Card(
        elevation: 0.1,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFFF1F1F1)),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Icon(Icons.add, color: Color(0xFFF1F1F1), size: 50,)),
      ),
    );
  }

  getImageList(){
    List<Widget> list=List();
    if(imageList!=null){
      for(String path in imageList){
        Widget widget=GestureDetector(
          child: Stack(
            children: <Widget>[
              Card(
                elevation: 0.1,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 5,right: 5),
                shape: RoundedRectangleBorder(side: BorderSide(color: Color(0xFFF1F1F1)),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Image.file(File(path),height: 100,width: 100,fit: BoxFit.cover,),
              ),
              Positioned(
                right: 0,
                top:0,
                child: GestureDetector(
                  child: Container(
                    child: Icon(Icons.close,color: Colors.black54,size: 10),
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Color(0xFFF1F1F1),shape: BoxShape.circle),
                  ),
                  onTap: (){
                    imageList.remove(path);
                    setState(() {
                    });
                  },
                ),
              )
            ],
          ),
          onTap: (){
            routePagerNavigator(context,BrowserImage(imageList, imageList.indexOf(path)));
          },
        );
        list.add(widget);
      }
      if(imageList.length<6){
        list.add(addImage());
      }
    }else{
      list.add(addImage());
    }
    return list;
  }


  Divider buildDivider() {
    return Divider(
      height: 1,
      color: Color(0xFFF1F1F1),
    );
  }

  Widget arroRightView(String title, String desc,Function callBack) {
    return GestureDetector(
      onTap: callBack,
      child: Padding(
        padding: EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          children: <Widget>[
            getTilteWidget(title),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  desc,
                  style: TextStyle(color: Color(0xFF000000), fontSize: 12),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF000000),
              size: 14,
            )
          ],
        ),
      ));
  }

  Text getTilteWidget(String title, {bool isShowStar}) {
    return Text.rich(TextSpan(
        text: title,
        style: TextStyle(color: Color(0xFF000000), fontSize: 12),
        children: [
          TextSpan(
              text: isShowStar == null || isShowStar == true ? ' *' : " ",
              style: TextStyle(color: Color(0xFFD04747)))
        ]));
  }

  getInputWidget(String title,String hint,TextInputType inputType,TextEditingController controller,{bool isShowStar}) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        children: <Widget>[
          getTilteWidget(title,isShowStar: isShowStar),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextField(
                keyboardType: inputType,
                textAlign: TextAlign.left,
                controller: controller,
                autofocus: false,
                style: TextStyle(fontSize: 12.0, color: Colors.black),
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintStyle:TextStyle(color: Color(0xFFD8D8D8), fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
    );
  }


  selectTimeDialog(){
    ScrollController scrollController=ScrollController();
    showMyBottomSheet(context: context, builder: (context){
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
        ),
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xFFF1F1F1),
              child:Row(
                children: <Widget>[
                  Expanded(child: Text("调货时限",textAlign:TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w500 ),)),
                  IconButton(icon: Icon(Icons.clear,color:  Colors.black,size: 20,), onPressed: (){
                    Navigator.pop(context);
                  })
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 3,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemBuilder:(context,posion){
                    return GestureDetector(
                      onTap: (){
                        selectTimePosition=posion;
                        day = posion == 0 ? 7 : posion == 1 ? 10 : 15;
                        Navigator.pop(context);
                        setState(() {
                        });
                      },
                      child: Container(
                        height: 45,
                        width: 300,
                        color: Colors.white,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child: Row(
                          children: <Widget>[
                            Text(posion==0 ? "7天":posion==1? "10天":"15天",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w400),),
                            Offstage(
                              offstage: selectTimePosition!=posion,
                              child: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Icon(Icons.check,size: 15,color: Colors.black,),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      );
    });
  }

  void commitData() {
    if(brandInfo==null){
      ToastUtil.showToast(context, "请选择品牌");
      return;
    }
    if(category==null){
      ToastUtil.showToast(context, "请选择所属分类");
      return;
    }
    String goodNumber=goodsNumberController.text;
    String color=goodsColorController.text;
    if(color==null || color.isEmpty){
      ToastUtil.showToast(context, "请输入颜色");
      return;
    }

    if(dataMap!=null){
      List list=dataMap.values.toList();
      for( int i=0;i<list.length;i++){
        StockModel model=list[i];
        String size=model.controller.text;
        if(size==null || size.isEmpty){
          ToastUtil.showToast(context, "请输入尺寸${i+1}");
          return;
        }
        int stockNumber=model.stockNumber;
        if(stockNumber<1){
          ToastUtil.showToast(context, "库存${i+1}不能为0");
          return;
        }

      }
    }
    if(day<=0){
      ToastUtil.showToast(context, "请选择调货时间");
      return;
    }
    if(imageList==null || imageList.isEmpty){
      ToastUtil.showToast(context, "请添加商品图片信息");
      return;
    }

    LoadingDialogUtil.showLoading(context,msg:"正在提交",barrierDismissible: false);

    if(uploadImageUrlList==null){
      HttpManager().uploadMultiImageFile(context,imageList,(result){
        ImageUploadModel uploadModel=ImageUploadModel.fromJson(result);
        if(uploadModel!=null && uploadModel.data!=null){
          uploadImageUrlList=List();
          for(PhotoInfo info in uploadModel.data){
            uploadImageUrlList.add(info.url);
          }
          createOrder(getRequestMap(goodNumber, color));
        }else{
          Navigator.pop(context);
          ToastUtil.showToast(context, "提交失败，请重新尝试");
        }
      },onErr: (error){
        Navigator.pop(context);
        ToastUtil.showToast(context, "提交失败，请重新尝试");
      });
    }else{
      createOrder(getRequestMap(goodNumber, color));
    }
  }


  Map<String,dynamic> getRequestMap(String goodNumber, String color) {
    Map<String,dynamic> requestParamsMap=Map();
    List goodsList=List();
    for(StockModel model  in dataMap.values){
      Map goodsMap=Map();
      goodsMap["brand_id"]=brandInfo.brandId;
      goodsMap["brand_name"]=brandInfo.brandName;
      goodsMap["category_id"]=category.threeId==null?(category.secondId==null?category.parentId:category.secondId):category.threeId;
      goodsMap["category_name"]=categoryName;
      goodsMap["item_no"]=goodNumber;
      goodsMap["num"]=model.stockNumber.toString();
      goodsMap["props"]=[{"prop_name":"尺寸","prop_value":model.controller.text},{"prop_name":"颜色","prop_value":color}];
      goodsMap["price"]=goodsPriceController.text==null?"":goodsPriceController.text.toString();
      goodsList.add(goodsMap);
    }
    requestParamsMap["pics"]=uploadImageUrlList;
    requestParamsMap["description"]=descriptionController.text.toString();
    requestParamsMap["buyoffer_requirements"]={"expire_day":day};
    requestParamsMap["goods_info"]=goodsList;
    jsonEncode(requestParamsMap);
    return requestParamsMap;
  }

  void createOrder(Map<String,dynamic> params){
    try{
      HttpManager().postForm(context,Api.WANT_BUY_OFFER,params, (result){
        BaseResp baseResp=BaseResp.fromJson(result);
        Navigator.pop(context);
        if(baseResp.result.isSuccess){
          ToastUtil.showToast(context, "提交成功");
          if(widget.commitSuccessCallBack!=null){
            widget.commitSuccessCallBack();
          }
          resetData();
        }else{
          ToastUtil.showToast(context, baseResp.result.msg);
        }
      },onError: (error){
        Navigator.pop(context);
        ToastUtil.showToast(context, "提交失败，请重新尝试");
      });
    }catch(e){
      Navigator.pop(context);
      ToastUtil.showToast(context, e.toString());
    }
  }

  void loadCategory(bool isShowCategoryDialog) {
    HttpManager().get(context,Api.category, (map){
      WantToBuyCategoryResp resp=WantToBuyCategoryResp.fromJson(map);
      if(resp!=null) {
        if (resp.data != null) {
          categoryList = resp.data;
          if(isShowCategoryDialog){
            CategoryPickers.showCategoryPicker(
                context: context,
                categoryList:categoryList,
                showType: ShowType.pca,
                barrierOpacity: 0.5,
                barrierDismissible: true).then((result){
                category=result;
                categoryName=(category.parentName==null?"":category.parentName)+" "
                    +(category.secondName==null?"":category.secondName)+" "
                    +(category.threeName==null?"":category.threeName);
                setState(() {
                });
            });
          }
        }else{
          if(isShowCategoryDialog){
            ToastUtil.showToast(context, "网络异常，请重试");
          }
        }
      }
    },errorCallback: (error){
      if(isShowCategoryDialog){
        ToastUtil.showToast(context, "网络异常，请重试");
      }
    });
  }

  void showCategory() async{
    if(categoryList==null){
      loadCategory(true);
    }else{
      CategoryPickers.showCategoryPicker(
          context: context,
          categoryList:categoryList,
          showType: ShowType.pca,
          barrierOpacity: 0.5,
          barrierDismissible: true).then((result){
          category=result;
          categoryName=(category.parentName==null?"":category.parentName)+" "
              +(category.secondName==null?"":category.secondName)+" "
              +(category.threeName==null?"":category.threeName);
        setState(() {
        });
      });
    }
  }

  /**
   * 提交成功重置数据
   */
  void resetData(){
    goodsNumberController.text="";
    goodsTimeController.text="";
    goodsPriceController.text="";
    goodsColorController.text="";
    descriptionController.text="";
    uploadImageUrlList=null;
    imageList.clear();
    selectTimePosition=-1;
    dataMap.clear();
    category=null;
    categoryName="";
    brandInfo=null;
    day=0;
    setState(() {
    });
  }
}
