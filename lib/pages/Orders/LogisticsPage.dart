import 'package:flutter/material.dart';
import 'package:flutter_shop/http/Api.dart';
import 'package:flutter_shop/http/HttpManager.dart';
import 'package:flutter_shop/model/logistics_model.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'package:flutter_shop/widgets/BaseContainer.dart';
import 'package:flutter_shop/widgets/app_bar.dart';
import 'package:flutter_shop/utils/OrderUtil.dart';
import 'package:flutter_shop/utils/screen_util.dart';

/*
 * 物流页面
 */
class LogisticsPage extends StatefulWidget {
  final int order_no;

  LogisticsPage(this.order_no);

  @override
  _LogisticsPageState createState() => _LogisticsPageState();
}

class _LogisticsPageState extends State<LogisticsPage> {
  List<Track_detail_list> trackDetailList = new List();
  ScreenUtil screenUtil = ScreenUtil.getInstance();

  bool isLoading = true; //进入加载
  bool isShowEmptyView = false; //显示空页面
  bool isShowLoadError = false; //显示重新加载

  void loadData() async {
    Map<String, String> bodyParm = {'order_no': "${widget.order_no}"};
    //加载联系人列表
    HttpManager.instance.get(
        context,
        Api.ORDER_LOGISTICS,
        (json) {
          LogisticsModel logisticModel = LogisticsModel.fromJson(json);
          if (logisticModel != null &&
              logisticModel.result != null &&
              logisticModel.result.isSuccess == true) {
            var data = logisticModel.data;
            if (data.data != null) {
              if (data.data.trackDetailList != null) {
                //todo 获取物流信息
                trackDetailList = data.data.trackDetailList;
              }
            } else {
              isLoading = false;
              isShowLoadError = false;
              isShowEmptyView = true;
            }
          } else {
            isLoading = false;
            isShowLoadError = false;
            isShowEmptyView = true;
            ToastUtil.showToast(context, '暂无物流信息');
          }
          setState(() {});
        },
        params: bodyParm,
        errorCallback: (error) {
          isLoading = false;
          isShowLoadError = true;
          isShowEmptyView = false;
          ToastUtil.showToast(context, error);
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
//    loadData('5018213094302');
  }

  @override
  Widget build(BuildContext context) {
    print("_LogisticsPageState_LogisticsPageState");
    return Scaffold(
      appBar: CommonAppBar(context: context, title: "物流信息"),
      body: BaseContainer(
          isLoading: isLoading,
          showEmpty: isShowEmptyView,
          showLoadError: isShowLoadError,
          reLoad: () {
            loadData();
          },
          child: Container(
            color: Color(0xFFF1F1F1),
//        height: ScreenUtil.screenWidthDp,
//        width: double.maxFinite,
            padding: EdgeInsets.only(left: 17, top: 10, bottom: 10, right: 13),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Padding(
                padding:
                    EdgeInsets.only(left: 18, top: 26, bottom: 26, right: 18),
                child: ListView.builder(
                    itemCount:
                        trackDetailList != null && trackDetailList.length > 0
                            ? trackDetailList.length
                            : 0,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return getItem(trackDetailList[index], index);
                    }),
              ),
            ),
          )),
    );
  }

  getItem(Track_detail_list model, int index) {
    return Stack(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 3),
              width: screenUtil.L(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(model.date,
                      style: OrderUtil.getTextStyle(
                          10, Color(0xFF949494), FontWeight.w500)),
                  Text(model.time,
                      style: OrderUtil.getTextStyle(
                          8, Color(0xFF949494), FontWeight.w500)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                padding: EdgeInsets.only(
                    bottom: 33,
                    left: screenUtil.L(20),
                    right: screenUtil.L(10)),
                decoration: index == trackDetailList.length - 1
                    ? null
                    : BoxDecoration(
                        border:
                            Border(left: BorderSide(color: Color(0xFFF1F1F1)))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Text(model.state, style: OrderUtil.getTextStyle(12, Color(0xFF000000), FontWeight.w500)),
                    Text(model.content,
                        style: OrderUtil.getTextStyle(
                            10, Color(0xFF949494), FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: model.getIsDot()
              ? 5
              : (index == 0 || index == trackDetailList.length - 1) ? -15 : -12,
          left: model.getIsDot() ? screenUtil.L(49) : screenUtil.L(28.5),
          child: model.getIsDot()
              ? getDotWidget()
              : IconButton(
                  onPressed: null,
                  icon: Icon(Icons.ac_unit),
                  iconSize: screenUtil.L(20)),
        )
      ],
    );
  }

  getDotWidget() {
    return Container(
      width: screenUtil.L(5),
      height: screenUtil.L(5),
      decoration: BoxDecoration(
          color: Color(0xFFE3E3E3),
          borderRadius: BorderRadius.all(Radius.circular(screenUtil.L(2.5)))),
    );
  }
}
