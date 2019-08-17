import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/category/classification.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/widgets/good/PopupWindow.dart';
import 'package:flutter_shop/widgets/good/SelectorArrowDown.dart';
import 'package:flutter_shop/widgets/right_sheet.dart';

///
/// TODO 目前固定四个，有下拉弹窗的，之后根据类型做横划列表
/// @author longlyboyhe
/// @date 2019/2/21
///
typedef SearchSelected = void Function(
    SearchType type, int id, String text, int lowPrice, int highPrice);
enum SearchType {
  ///销量
  volume,
  price,
  brand,
  category,
  categorys, //三级类目
  keyword
}

class FilterBar extends StatefulWidget {
  SearchSelected onTap;
  bool hasBrand;

  FilterBar({this.hasBrand = true, this.onTap});

  @override
  _FilterBarState createState() => _FilterBarState();
}

class SearchPrice {
  int lowPrice;
  int highPrice;

  SearchPrice(this.lowPrice, this.highPrice);

  @override
  String toString() {
    return 'SearchPrice{lowPrice: $lowPrice, highPrice: $highPrice}';
  }
}

class _FilterBarState extends State<FilterBar> {
  ///-1不做任何选择 0销量 1价格 2库存 3筛选
  int selectedType = -1;
  List<GlobalKey<SelectorArrowDownState>> _selectorArrowKey = [
    GlobalKey(),
    GlobalKey()
  ];

//  List<String> priceFilters = [
//    "¥300一以下",
//    "¥300-¥2000",
//    "¥2001-¥5000",
//    "¥5001-10000",
//    "¥10001-¥100000",
//    "¥100000以上"
//  ];

//  List<String> stockFilters = ["1-5", "6-10", "大于10"];
  List<SearchPrice> priceFilters = [
    SearchPrice(-1, 300),
    SearchPrice(300, 2000),
    SearchPrice(2001, 5000),
    SearchPrice(5001, 10000),
    SearchPrice(10001, 100000),
    SearchPrice(100000, -1),
  ];

  Widget _buildItem(BuildContext context, SearchPrice price) {
    String title = "";
    if (price.lowPrice == -1) {
      title = "￥${price.highPrice}以下";
    } else if (price.highPrice == -1) {
      title = "￥${price.lowPrice}以上";
    } else {
      title = "￥${price.lowPrice}-￥${price.highPrice}";
    }
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (widget.onTap != null)
          widget.onTap(
              SearchType.price, 0, "", price.lowPrice, price.highPrice);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            border: Border.all(color: Color(0xFFE5E5E5), width: 1)),
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xFF545454),
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _filterButton(int filterType, List<SearchPrice> filters) {
    GlobalKey<SelectorArrowDownState> _key = _selectorArrowKey[filterType - 1];
    return PopupWindow(
        elevation: 0,
        padding: EdgeInsets.all(0),
        offset: Offset(0.0, 50.0),
        onOpened: () {
          setState(() {
            _key.currentState.update();
            selectedType = filterType;
          });
        },
        onSelected: (String text) {
          setState(() {
            print("点击了${text}");
//            widget.onTap(text);
            _key.currentState.update();
            selectedType = -1;
          });
        },
        onCanceled: () {
          setState(() {
            _key.currentState.update();
            selectedType = -1;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(filterType),
            SelectorArrowDown(
              key: _key,
              color: filterType == selectedType
                  ? KColor.orangleColor
                  : Colors.black,
              padding: EdgeInsets.only(left: ScreenUtil().L(10)),
            ),
          ],
        ),
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(
                      top: ScreenUtil().L(20),
                      left: ScreenUtil().L(15),
                      right: ScreenUtil().L(15),
                      bottom: ScreenUtil().L(30)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: ScreenUtil().L(15),
                    crossAxisSpacing: ScreenUtil().L(10),
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(context, filters[index]);
                  },
                  itemCount: filters.length,
                ),
                Container(height: 1, color: KColor.dividerColor)
              ],
            ),
          );
        });
  }

  Widget _title(int filterType) {
    return Center(
        child: Text(
      KString.filterTitles[filterType],
      style: TextStyle(
          color: filterType == selectedType ? KColor.yellowColor : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold),
    ));
  }

  Widget _drawer() {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: ScreenUtil().L(16)),
        child: Scaffold(
          appBar: CommonAppBar(
              context: context,
              existBackIcon: false,
              title: "筛选",
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
              bottom: CommonAppBarBottomLine()),
          body: Classification(
            hasBrand: widget.hasBrand,
            isFilter: true,
            selectedId:
                (type, int id, String text, int lowPrice, int highPrice) {
              //TODO 根据id筛选
              if (widget.onTap != null) widget.onTap(type, id, "", 0, 0);
              Navigator.pop(context);
            },
          ),
        ));
  }

  Widget _filterBar() {
    return GestureDetector(
        onTap: () {
          showModalRightSheet(
              context: context,
              builder: (context) {
                return _drawer();
              });
        },
        child: Row(
          children: <Widget>[
            _title(2),
            Padding(
              padding: EdgeInsets.only(
                left: 5,
              ),
              child: Image.asset("images/filter.png"),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().L(50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
              onTap: () {
                setState(() {
                  widget.onTap(SearchType.volume, 0, "", 0, 0);
                  selectedType = selectedType == 0 ? -1 : 0;
                });
              },
              child: _title(0)),
          _filterButton(1, priceFilters),
//          _filterButton(2, stockFilters),
          _filterBar()
        ],
      ),
    );
  }
}
