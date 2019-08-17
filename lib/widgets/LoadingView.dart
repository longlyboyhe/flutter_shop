import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/**
 * 加载loading
 * @author longlyboyhe
 * @date 2018/12/24
 */
class LoadingView extends StatelessWidget {
  String msg;

  LoadingView({this.msg});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SpinKitThreeBounce(
          color: Colors.blue,
          size: 30,
        ),
        Offstage(
          offstage: msg == null,
          child: Text(
            msg == null ? "" : msg,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        )
      ],
    );
  }
}
