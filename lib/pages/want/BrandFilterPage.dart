import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/category/model/brand_model.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'want_to_buy_brand.dart';

class BrandFilterPage extends StatefulWidget {
  @override
  _BrandFilterPageState createState() => _BrandFilterPageState();
}

class _BrandFilterPageState extends State<BrandFilterPage> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(context: context, title: "品牌"),
      body: Column(
        children: <Widget>[
          Divider(height: 2,color: Color(0xFFD8D8D8),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 15),
               child: WantToBuyBrand(isFilter: true,showInput:true,selectedId: (BrandInfo info){
                  Navigator.pop(context,info);
                })
            ),
          )
        ],
      ),
    );
  }


}
