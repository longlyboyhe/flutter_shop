import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/screen_util.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/widgets/CustomBallPulseFooter.dart';

class OrderUtil {
  /*
   * 圆角边框button
   */
  static Widget getCircBoderButton(String text, Function click) {
    return getCircBgButton(text, Color(0xFF313131), Color(0xffffffff), click);
  }

  /*
   * 获取圆角背景的button
   */
  static Widget getCircBgButton(
      String text, Color borderColor, Color bgColor, Function click) {
    ScreenUtil screenUtil = ScreenUtil.getInstance();
    return GestureDetector(
      onTap: click,
      child: Container(
        child: Center(
          child: Text(text,
              style: getTextStyle(12, Color(0xFF313131), FontWeight.bold)),
        ),
        height: screenUtil.L(30),
        padding: EdgeInsets.only(
            left: screenUtil.L(11),
            right: screenUtil.L(11),
            ),
        decoration: BoxDecoration(
            border: Border.all(
              color: borderColor,
              width: screenUtil.L(1),
            ),
            color: bgColor,
            borderRadius: BorderRadius.circular(screenUtil.L(15))),
      ),
    );
  }

  static getDivideLine(Color color, double height) {
    return Container(
      color: color,
      height: ScreenUtil.getInstance().L(height),
    );
  }

  static getTextStyle(double fontSize, Color color, FontWeight wight) {
    return TextStyle(
      fontWeight: wight,
      color: color,
      fontSize: fontSize,
    );
  }

  static getHeaderKey() {
    return new GlobalKey<RefreshHeaderState>();
  }

  static getFooterKey() {
    return GlobalKey<RefreshFooterState>();
  }

  static getRefreshHeaderView() {
    return ClassicsHeader(
      key: getHeaderKey(),
      refreshText: "下拉刷新",
      refreshReadyText: "释放刷新",
      refreshingText: "正在刷新...",
      refreshedText: "刷新完成",
      moreInfo: "",
      bgColor: Color(0xFFF1F1F1),
      textColor: Colors.black,
    );
  }

  static getFooterView() {
    return CustomBallPulseFooter(
      key: getFooterKey(),
      size: 30,
    );
  }
}
