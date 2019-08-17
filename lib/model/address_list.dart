import 'package:json_annotation/json_annotation.dart';
import 'result.dart';
import 'address.dart';
part 'address_list.g.dart';


@JsonSerializable()
  class AddressListResp extends Object {

  @JsonKey(name: 'result')
  Result result;

  @JsonKey(name: 'data')
  List<Address> data;

  @JsonKey(name: 'success')
  bool success;

  @JsonKey(name: 'version')
  String version;

  AddressListResp(this.result,this.data,this.success,this.version,);

  factory AddressListResp.fromJson(Map<String, dynamic> srcJson) => _$AddressListRespFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AddressListRespToJson(this);


  int get length {
    if (data.isNotEmpty) {
      return data.length;
    } else {
      return 0;
    }
  }

  bool get isNotEmpty {
    return data.isNotEmpty;
  }

  bool get isAllchecked {
    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        Address model = data[i];
        if (model.isSelected == false) {
          return false;
        }
      }
      return true;
    } else {
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

  ///单选
  switchSelecte(Address model) {
    bool isSelected = model.isSelected==null?false:model.isSelected;
    if (!isSelected) {
      data.forEach((item) {
        ///手机号唯一
        if (item.mobile == model.mobile) {
          item.isSelected = true;
        } else {
          item.isSelected = false;
        }
      });
    }
  }

  ///初始化，全不选
  initSelecte() {
    data.forEach((item) {
      item.isSelected = false;
    });
  }

  ///选择的数据（多选）
  String selected() {
    String selected = "";
    data.forEach((item) {
      if (item.isSelected) selected = selected + item.name;
    });
    return selected;
  }

  ///获取选择的地址（单选）
  Address getSelected() {
    Address model = null;
    data.forEach((item) {
      if (item.isSelected) {
        model = item;
        return;
      }
    });
    return model;
  }

  String getSelectedAllId() {
    String id="";
    data.forEach((item) {
      if (item.isSelected) {
        id+=item.id.toString()+",";
      }
    });
    return id.substring(0,id.length-1<0?0:id.length-1);
  }

}

  
