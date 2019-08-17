import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/SearchHotModel.dart';
import 'package:flutter_shop/utils/screen_util.dart';

///
/// 热门标签
/// @author longlyboyhe
/// @date 2019/2/18
///
class SearchHot extends StatefulWidget {
  ValueChanged<String> onTap;

  SearchHot({this.onTap});

  @override
  _SearchHotState createState() => _SearchHotState();
}

class _SearchHotState extends State<SearchHot> {
  List<SearchHotModel> hot = List();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    //加载联系人列表
    Map<String, String> params = {'top_num': "9"};
    HttpManager.instance.get(context,
        Api.KEYWORD,
        (json) {
          List data = json['data'];

          if (data != null && data.length > 0) {
            data.forEach((value) {
              hot.add(SearchHotModel(
                  name: value['keyword'],
                  sign: value['commend_status'] == 0 ? false : true));
            });

            setState(() {});
          }
        },
        params: params,
        errorCallback: (errorMsg) {
          setState(() {});
        });
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        widget.onTap(hot[index].name);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xFFF1F1F1),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Text(
          hot[index].name,
          style: TextStyle(
              color: hot[index].sign ? Color(0xFFC10000) : Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return hot.length == 0
        ? Container()
        : Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().L(24)),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil().L(15), right: ScreenUtil().L(3)),
                      child: Text(
                        KString.hotTitle,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Image.asset("images/icon_fire.png")
                  ],
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.all(ScreenUtil().L(15)),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: ScreenUtil().L(8),
                  crossAxisSpacing: ScreenUtil().L(8),
                  childAspectRatio: 3.5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return _buildItem(context, index);
                },
                itemCount: hot.length,
              )
            ],
          );
  }
}
