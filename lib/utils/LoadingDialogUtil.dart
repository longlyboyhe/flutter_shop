import 'package:flutter/material.dart';
import 'package:flutter_shop/widgets/LoadingView.dart';


class LoadingDialogUtil{
  static void showLoading(BuildContext context,{String msg,bool barrierDismissible=true}){
    showDialog(context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              height: 100,
              width: 100,
              child: LoadingView(msg:msg),
            ),
          )
        ],
      );
    });
  }
}