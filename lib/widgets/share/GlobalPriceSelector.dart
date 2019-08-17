import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/StringUtils.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 设置全局加价，一行3个
/// @author longlyboyhe
/// @date 2019/3/14
///
class GlobalPriceSelector extends StatefulWidget {
  final Color selectedBorderColor;
  final Color borderColor;
  final ValueChanged<String> onTap;
  final double curPrice;

  GlobalPriceSelector(
      {Key key,
      this.selectedBorderColor = const Color(0xFFECE936),
      this.borderColor = const Color(0xFF979797),
      this.onTap,
      this.curPrice})
      : super(key: key);

  @override
  _GlobalPriceSelectorState createState() => _GlobalPriceSelectorState();
}

class _GlobalPriceSelectorState extends State<GlobalPriceSelector> {
  int curIndex = -1;
  List<String> prices = ["200", "500", "800", "1000", "1500", "自定义"];
  String inputText = "";

  @override
  void initState() {
    super.initState();
    if (widget.curPrice != null && widget.curPrice > 0) {
      for (int i = 1; i < prices.length; i++) {
        if (StringUtils.str2Double(prices[i]) == widget.curPrice) {
          curIndex = i;
          break;
        }
      }
      if (curIndex == -1) {
        curIndex = prices.length - 1;
        prices[prices.length - 1] = "自定义+${widget.curPrice}";
      }
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (index == prices.length - 1) {
          ///自定义
          widget.onTap("自定义");
        } else if (curIndex != index) {
          setState(() {
            curIndex = index;
            inputText = prices[index];
          });
        }
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
                color:
                    curIndex != index ? Color(0xFFEFEFEF) : Color(0xFFECE936),
                width: 1)),
        child: Text(
          index != prices.length - 1 ? "+¥${prices[index]}" : prices[index],
          maxLines: 2,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _body = [];
    _body.add(Expanded(
        child: Padding(
      padding:
          const EdgeInsets.only(left: 30.0, right: 5.0, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Text("商品全局加价",
              style: TextStyle(
                  color: Color(0xFFACACAC),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
          Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Text("如果单品已经设置分享价，全局价设置不受影响",
                  style: TextStyle(
                      color: Color(0xFFC10000),
                      fontSize: 10,
                      fontWeight: FontWeight.w300))),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: ScreenUtil().L(30)),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().L(15),
              crossAxisSpacing: ScreenUtil().L(15),
              childAspectRatio: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(context, index);
            },
            itemCount: prices.length,
          ),
          RawMaterialButton(
            //控件没有margin
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            elevation: 0,
            fillColor: Color(0xFFEFEFEF),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            onPressed: () {
              if (inputText.isEmpty) {
                ToastUtil.showToast(context, "请选择");
              } else {
                widget.onTap(inputText);
              }
            },
            child: Text("保存",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
            constraints: BoxConstraints(
                minHeight: 45,
                maxHeight: 45,
                minWidth: double.infinity,
                maxWidth: double.infinity),
          )
        ],
      ),
    )));
    _body.add(RawMaterialButton(
      //控件没有margin
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: const EdgeInsets.only(
          left: 5.0, right: 10.0, top: 10.0, bottom: 10.0),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Icon(Icons.clear, size: 15, color: Colors.black),
      constraints: BoxConstraints(minWidth: 10, minHeight: 10),
    ));
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minHeight: 80),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _body,
                ),
              )
            ],
          ),
        ));
  }
}
