import 'package:flutter/material.dart';
import 'package:flutter_shop/utils/ToastUtils.dart';
import 'simple_dialog.dart';
import 'snackbar.dart';

class CommonAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = <Widget>[
      buildClicks(buildContents('SnackBar的使用'), context, new CommonSnackBar()),
      buildClicks(
          buildContents('SimpleDialog的使用'), context, new CommonSimpleDialog()),
      buildClicks(
          buildContents('AlertDialog的使用'), context, new CommonAlertDialog()),
      //      buildClicks(buildContents('BottomSheet的使用'), context, new SnackBarDemo()),
      //      buildClicks(
      //          buildContents('ExpansionPanel的使用'), context, new SnackBarDemo()),
    ];

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              // 返回上一个页面
              Navigator.of(context).pop();
            }),
        title: new Text('各种弹窗&提示控件用法'),
      ),
      body: new ListView(children: widgets),
    );
  }

  Widget buildClicks(Widget child, BuildContext context, Widget page) {
    return new InkWell(
      child: child,
      onTapDown: (details) {
        print('onTapDown');
        ToastUtil.showBottomToast(context, 'onTapDown');
        // 发送路由消息
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) => page));
      },
      onTap: () {
        ToastUtil.showBottomToast(context, 'onTap');
      },
      onLongPress: () {
        ToastUtil.showBottomToast(context, 'onLongPress');
      },
      onDoubleTap: () {
        ToastUtil.showBottomToast(context, 'onDoubleTap');
      },
    );
  }

  Widget buildContents(var text) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      padding: new EdgeInsets.all(5.0),
      alignment: Alignment.center,
      constraints: new BoxConstraints.expand(height: 40.0),
      decoration: new BoxDecoration(
        color: Colors.teal[300],
        borderRadius: new BorderRadius.all(
          //让矩形四个角都变成圆角
          const Radius.circular(8.0),
        ),
        // 阴影
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.teal[100],
            offset: new Offset(0.0, 5.0),
            blurRadius: 8.0,
          ),
          new BoxShadow(
            color: Colors.grey,
            offset: new Offset(0.0, 6.0),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: buildButton(text),
    );
  }

  Widget buildButton(var text) {
    return new Text(
      text,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    );
  }
}
