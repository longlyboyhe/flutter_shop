import 'package:flutter/material.dart';

/**
 * 重新加载布局
 * @author longlyboyhe
 * @date 2018/12/24
 */
class ReloadView extends StatelessWidget {
  //点击重新加载回调
  GestureTapCallback reLoad;

  ReloadView({this.reLoad});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: reLoad,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.wifi,
            size: 100,
          ),
          Text(
            "点击重试",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          )
        ],
      ),
    );
  }
}
