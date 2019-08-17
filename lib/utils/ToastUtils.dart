import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * 居中吐司
 * @author longlyboyhe
 * @date 2018/12/19
 */

class ToastUtil {
  static void showToast(BuildContext context, String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor:Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0
    );

//    Toast.show(
//      msg,
//      context,
//      duration: Toast.LENGTH_SHORT,
//      gravity: Toast.CENTER,
//      backgroundColor: Colors.black.withOpacity(0.8),
//      backgroundRadius: 5.0,
//      textColor: Colors.white,
//    );
  }

  static void showBottomToast(BuildContext context, String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor:Colors.black.withOpacity(0.8),
        textColor: Colors.white,
        fontSize: 16.0
    );

//    Toast.show(
//      msg,
//      context,
//      duration: Toast.LENGTH_SHORT,
//      gravity: Toast.BOTTOM,
//      backgroundColor: Colors.black.withOpacity(0.8),
//      backgroundRadius: 5.0,
//      textColor: Colors.white,
//    );
  }
//  static void showToast(String msg) {
//    Fluttertoast.showToast(
//        msg: msg,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER,
//        timeInSecForIos: 1,
//        backgroundColor: Color(0xCC000000),
//        textColor: Colors.white);
//  }
}
