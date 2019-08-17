import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/want/StockModel.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

class StockWidget extends StatefulWidget {
  Map<int,StockModel> dataMap;
  StockWidget(this.dataMap);

  @override
  _StockWidgetState createState() => _StockWidgetState();
}
class _StockWidgetState extends State<StockWidget> {

  int itemSize=1;

  @override
  Widget build(BuildContext context) {
    List<Widget> list=List();
    if(itemSize>0){
      for(int i=1;i<=itemSize;i++){
        bool isAdd=i==1;
        list.add(buildItem(i,isAdd,isAdd?"增加":"删除"));
      }
    }
    return Column(
      children: list,
    );
  }

  Column buildItem(int pos,bool isAdd,String text) {
    TextEditingController controller;
    if(widget.dataMap.containsKey(pos)){
      controller=widget.dataMap[pos].controller;
    }else{
      controller= TextEditingController();
      StockModel stockModel=StockModel(1,controller);
      widget.dataMap[pos]=stockModel;
    }
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  getInputWidget(
                      "尺寸${pos}", "请输入尺码", TextInputType.number, controller,
                      isShowStar: true),
                  getStockWidget(pos,controller)
                ],
              ),
            ),
            Divider(
              height: 100,
              color: Color(0xFFF1F1F1),
            ),
            GestureDetector(
              onTap: () {
                if(isAdd){
                  itemSize++;
                  if(itemSize>5){
                    ToastUtil.showToast(context, "最多只能加5个");
                    return;
                  }
                }else{
                  itemSize--;
                  widget.dataMap.remove(pos);
                }
                setState(() {
                });
              },
              child: Container(
                height: 95,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    border: Border(
                        left: BorderSide(color: Color(0xFFF1F1F1), width: 0.5))
                ),
                padding: EdgeInsets.only(left: 30, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.only(bottom: 5),
                      child: Icon(isAdd?Icons.add:Icons.remove, size: 20, color: isAdd?Colors.black:Colors.red),
                      decoration: BoxDecoration(
                          border: Border.all(color: isAdd?Colors.black:Colors.red),
                          shape: BoxShape.circle
                      ),
                    ),
                    Text(text, style: TextStyle(color: isAdd?Colors.black:Colors.red, fontSize: 12),),
                  ],
                ),
              ),
            )
          ],
        ),
        buildDivider()
      ],
    );
  }

  ///
  /// 库存widget
  ///
  Padding getStockWidget(int pos,TextEditingController controller) {
    int num=1;
    if(widget.dataMap.containsKey(pos)){
      num=widget.dataMap[pos].stockNumber;
    }
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: getTilteWidget("库存${pos}"),
          ),
          Container(
            height: ScreenUtil().L(30),
            width: ScreenUtil().L(90),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color:Color(0xFFB5B5B5),width: 1 ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Icon(Icons.remove,size: 15,color: num==1?Color(0xFFB5B5B5):Colors.black,),),
                  onTap:(){
                    //TODO 更改库存量
                    if(widget.dataMap.containsKey(pos)){
                      int num=widget.dataMap[pos].stockNumber;
                      if(num>1){
                        num--;
                        widget.dataMap[pos].stockNumber=num;
                        setState(() {
                        });
                      }
                    }
                  },
                ),
                Expanded(child: Center(child: Text("${num}",style: TextStyle(fontSize: 12,color: Colors.black),))),
                GestureDetector(
                  child: Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Icon(Icons.add,size: 15),),
                  onTap: (){
                    if(widget.dataMap.containsKey(pos)){
                      widget.dataMap[pos].stockNumber++;
                    }else{
                      widget.dataMap[pos].stockNumber=2;
                    }
                    setState(() {
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Divider buildDivider() {
    return Divider(
      height: 1,
      color: Color(0xFFF1F1F1),
    );
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
}


