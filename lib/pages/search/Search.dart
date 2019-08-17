import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/pages/search/SearchHistory.dart';
import 'package:flutter_shop/pages/search/SearchHot.dart';
import 'package:flutter_shop/pages/search/SearchResult.dart';
import 'package:flutter_shop/utils/HistoryDb.dart';
import 'package:flutter_shop/utils/PageRouteUtils.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 搜索
/// @author longlyboyhe
/// @date 2019/2/18
///
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchText = "";
  TextEditingController _controller;
  GlobalKey<SearchHistoryState> _historyKey = GlobalKey();

  ///联想词
//  List<String> searchWordList = List();

  Widget _searchWidget() {
    _controller = TextEditingController.fromValue(TextEditingValue(
        text: _searchText,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: _searchText.length))));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: ScreenUtil().L(15)),
            height: ScreenUtil().L(30),
            child: TextField(
              controller: _controller,
              onChanged: (string) {
                _searchText = string;
//                if (_searchText.trim().isNotEmpty) {
//                  setState(() {
//                    //TODO 搜索联想词
////                    _search(_searchText);
//                    if (_searchText.length > 2) {
//                      for (int i = 0; i < 15; i++) {
//                        searchWordList.add("联想词$i");
//                      }
//                    } else {
//                      searchWordList.clear();
//                    }
//                  });
//                }
              },
              onSubmitted: (string) {
                //TODO 点击键盘搜索
                _search(string);
              },
              textInputAction: TextInputAction.search,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      ///搜索框内清除按钮
                      setState(() {
                        _searchText = "";
//                        searchWordList.clear();
                      });
                    },
                    child: Image.asset(
                      _searchText.isEmpty
                          ? "images/search_search.png"
                          : "images/icon_clear.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  fillColor: KColor.bgColor,
                  filled: true,
                  hintText: '站内搜索',
                  contentPadding: EdgeInsets.only(
                      left: ScreenUtil().L(21),
                      top: ScreenUtil().L(5),
                      bottom: ScreenUtil().L(5),
                      right: ScreenUtil().L(21)),
                  border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(ScreenUtil().L(15))),
                      borderSide: BorderSide.none),
                  hintStyle: TextStyle(
                      color: Color(0xFFA9A9A9),
                      fontWeight: FontWeight.w400,
                      fontSize: 12)),
            ),
          ),
        ),
        RawMaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.only(
              left: ScreenUtil().L(12), right: ScreenUtil().L(15)),
          constraints: BoxConstraints(minWidth: 10.0, minHeight: 10.0),
          child: Text(KString.cancel,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
          padding: EdgeInsets.only(top: ScreenUtil.statusBarHeight + 13),
          child: Column(children: <Widget>[
            _searchWidget(),
            Expanded(
                child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        SearchHistory(
                            key: _historyKey,
                            onTap: (string) {
                              _search(string);
                            })
                      ],
                    ),
                    SearchHot(
                      onTap: (string) {
                        _search(string);
                      },
                    )
                  ],
                ),
//                Stack(children: <Widget>[
//                  Offstage(
//                    offstage: searchWordList.length == 0,
//                    child: Container(
//                      height: double.infinity,
//                      color: Colors.white,
//                      padding: EdgeInsets.only(
//                          top: ScreenUtil().L(12),
//                          left: ScreenUtil().L(15),
//                          right: ScreenUtil().L(15)),
//                      child: ListView.separated(
//                        shrinkWrap: true,
//                        padding: EdgeInsets.all(0),
//                        itemCount: searchWordList.length,
//                        physics: BouncingScrollPhysics(),
//                        itemBuilder: (context, index) => GestureDetector(
//                              onTap: () {
//                                //TODO 搜索联想词
//                                _search(searchWordList[index]);
//                              },
//                              child: Padding(
//                                  padding: EdgeInsets.only(
//                                      top: ScreenUtil().L(12),
//                                      bottom: ScreenUtil().L(10)),
//                                  child: Text(
//                                    searchWordList[index],
//                                    style: TextStyle(
//                                        color: Color(0xFF545454),
//                                        fontWeight: FontWeight.w400,
//                                        fontSize: 12),
//                                  )),
//                            ),
//                        separatorBuilder: (context, index) =>
//                            Divider(height: 1, color: KColor.dividerColor),
//                      ),
//                    ),
//                  )
//                ]),
              ],
            ))
          ])),
    );
  }

  _search(String text) {
    HistoryDb().add(text);
    routePagerNavigator(
        context,
        SearchResult(
          searchText: text,
        )).then((value) {
      _historyKey.currentState.refreshData();
    });
  }

//  void loadData(String text) async {
//    rootBundle.loadString("datas/recommends.json").then((value) {
//      setState(() {
//        RecommendModel recommendModel =
//            RecommendModel.fromJson(jsonDecode(value));
//        List<GoodsItemModel> result = List();
//        result.addAll(recommendModel.data);
//        routePagerNavigator(context, SearchResult(text, result)).then((value) {
//          _historyKey.currentState.refreshData();
//        });
//      });
//    });
//  }
}
