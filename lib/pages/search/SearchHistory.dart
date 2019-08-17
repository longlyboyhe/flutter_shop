import 'package:flutter/material.dart';
import 'package:flutter_shop/constants/index.dart';
import 'package:flutter_shop/utils/HistoryDb.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_shop/widgets/CommonDialog.dart';

///
/// 历史搜索
/// @author longlyboyhe
/// @date 2019/2/18
///
class SearchHistory extends StatefulWidget {
  ValueChanged<String> onTap;

  SearchHistory({Key key, this.onTap}) : super(key: key);

  @override
  SearchHistoryState createState() => SearchHistoryState();
}

class SearchHistoryState extends State<SearchHistory> {
  List<String> history = List();

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() async {
    await HistoryDb().create();
    HistoryDb().query().then((histories) {
      if (histories != null && histories.length > 0) {
        setState(() {
          history.clear();
          histories.forEach((map) {
            history.add(map["name"]);
          });
        });
      }
    });
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        widget.onTap(history[index]);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: Color(0xFF979797), width: 1)),
        child: Text(
          history[index],
          style: TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: history.length == 0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: ScreenUtil().L(24)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(left: ScreenUtil().L(15)),
                    child: Text(
                      KString.historyTitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )),
                  RawMaterialButton(
                      onPressed: () {
                        _clearHistory();
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.only(
                          left: ScreenUtil().L(15), right: ScreenUtil().L(15)),
                      constraints: BoxConstraints(minWidth: 10, minHeight: 10),
                      child: Image.asset("images/icon_delete.png")),
                ],
              ),
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: ScreenUtil().L(15),
                  left: ScreenUtil().L(15),
                  right: ScreenUtil().L(72),
                  bottom: ScreenUtil().L(10)),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: ScreenUtil().L(8),
                crossAxisSpacing: ScreenUtil().L(10),
                childAspectRatio: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(context, index);
              },
              itemCount: history.length,
            )
          ],
        ));
  }

  _clearHistory() {
    showDialog(
        context: context,
        builder: (context) {
          return CommonDialog(
            message: '确定要清空所有历史记录吗?',
            leftButtonText: '取消',
            rightButtonText: '确定',
            onLeftPress: () {
              Navigator.pop(context, false);
            },
            onRightPress: () {
              setState(() {
                HistoryDb().clear();
                history.clear();
              });
              Navigator.pop(context, true);
            },
          );
        });
  }
}
