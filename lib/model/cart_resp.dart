import 'package:json_annotation/json_annotation.dart'; 
import 'result.dart';
import 'BaseResp.dart';
part 'cart_resp.g.dart';


@JsonSerializable()
  class CartResp extends BaseResp {

  @JsonKey(name: 'data')
  Data data;

  CartResp(this.data,Result result,bool success,String version):super(result,success,version);

  factory CartResp.fromJson(Map<String, dynamic> srcJson) => _$CartRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CartRespToJson(this);

}


@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'total')
  int total;

  @JsonKey(name: 'data')
  List<Cart> data;

  @JsonKey(name: 'total_page')
  int totalPage;

  @JsonKey(name: 'page_no')
  int pageNo;

  @JsonKey(name: 'page_size')
  int pageSize;

  Data(this.total,this.data,this.totalPage,this.pageNo,this.pageSize,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);


  bool get isAllchecked {
    if(data.isNotEmpty){
      bool isCheckAll=true;
      for(int i=0;i<data.length;i++){
        Cart model = data[i];
        if(model.isSelected==false || model.isSelected==null){
          return false;
        }
      }
      return isCheckAll;
    }else{
      return false;
    }
  }

  switchAllCheck() {
    if (this.isAllchecked) {
      data.forEach((item) {
        item.isSelected = false;
      });
    } else {
      data.forEach((item) {
        item.isSelected = true;
      });
    }
  }

  double get sumTotal {
    double total = 0;
    data.forEach((item) {
      if (item.isSelected == true) {
        total = item.originalQuantity * item.originalPrice + total;
      }
    });
    return total;
  }

  String getSelectedSkuid() {
    String id="";
    data.forEach((item) {
      if(item.isSelected==true){
        id+=item.skuId.toString()+",";
      }
    });
    if(id.length>1){
      return id.substring(0,id.length-1);
    }
    return id;
  }

  String getSelectedCartId() {
    String id="";
    data.forEach((item) {
      if(item.isSelected==true){
        id+=item.id.toString()+",";
      }
    });
    if(id.length>1){
      return id.substring(0,id.length-1);
    }
    return id;
  }

}

  
@JsonSerializable()
  class Cart extends Object {
  //价格
  @JsonKey(name: 'original_price')
  double originalPrice;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'uid')
  int uid;

  ////购物车ID
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'create_date')
  int createDate;

  @JsonKey(name: 'spu_id')
  int spuId;

  @JsonKey(name: 'creator')
  String creator;

  //购买数量
  @JsonKey(name: 'original_quantity')
  int originalQuantity;

  @JsonKey(name: 'sku_id')
  int skuId;

  @JsonKey(name: 'cate_id')
  int cateId;

  @JsonKey(name: 'area_type')
  int areaType;

  @JsonKey(name: 'brand_id')
  int brandId;

  //供应商ID
  @JsonKey(name: 'vendor_id')
  int vendorId;

  @JsonKey(name: 'pic_url')
  List<String> picUrl;

  //商品状态，1有库存,-1没有库存
  @JsonKey(name: 'status')
  int status;

  @JsonKey(name: 'sku_spec')
  List<SkuSpec> skuSpec;

  bool isSelected;

  Cart(this.originalPrice,this.originalQuantity,this.skuSpec,this.skuId,this.cateId,this.title,this.brandId,this.uid,this.vendorId,this.id,this.spuId,this.picUrl,this.status,);

  factory Cart.fromJson(Map<String, dynamic> srcJson) => _$CartFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CartToJson(this);


  //只取规格里面的两个属性
  String getSpcAttr(){
    String spc="";
    if(skuSpec!=null && skuSpec.length>0){
      for(int i=0;i<skuSpec.length;i++){
        spc+=skuSpec[i].value;
        if(i>=1){
          break;
        }
        spc+=" | ";
      }
    }
    return spc;
  }

}

@JsonSerializable()
class SkuSpec extends Object {
  @JsonKey(name: 'spec_value_id')
  int specValueId;

  @JsonKey(name: 'spec_id')
  int specId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'value')
  String value;

  SkuSpec(this.specId,this.name,this.value,);

  factory SkuSpec.fromJson(Map<String, dynamic> srcJson) => _$SkuSpecFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SkuSpecToJson(this);

}



  
