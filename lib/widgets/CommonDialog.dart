import 'package:flutter/material.dart';

class CommonDialog extends Dialog {
  String title;
  String message;
  String leftButtonText;
  String rightButtonText;
  VoidCallback onLeftPress;
  VoidCallback onRightPress;

  CommonDialog(
      {this.title,
      this.message,
      this.leftButtonText,
      this.rightButtonText,
      this.onLeftPress,
      this.onRightPress});

  @override
  Widget build(BuildContext context) {
    List<Widget> _body = [];
    if (title != null && title.isNotEmpty) {
      _body.add(Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }
    if (message != null && message.isNotEmpty) {
      _body.add(Padding(
        padding:
            const EdgeInsets.only(left: 30.0, right: 30.0, top: 25, bottom: 25),
        child: Text(
          message,
          style: TextStyle(
              fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.w400),
        ),
      ));
      _body.add(Container(
        color: Color(0xFFEFEFEF),
        height: 0.5,
      ));
    }
    _body.add(_buildBottomButtonGroup());
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(minHeight: 80),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              child: Column(
                children: _body,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup() {
    var widgets = <Widget>[];
    if (leftButtonText != null && leftButtonText.isNotEmpty)
      widgets.add(_buildBottomLeftButton());
    if (rightButtonText != null && rightButtonText.isNotEmpty) {
      if (widgets.length > 0) {
        widgets.add(Container(
          width: 0.5,
          height: 50,
          color: Color(0xFFEFEFEF),
        ));
      }
      widgets.add(_buildBottomRightButton());
    }

    return Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomLeftButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        onPressed: onLeftPress,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          leftButtonText,
          style: TextStyle(
              fontSize: 12.0,
              color: Color(0xFF4B4B4B),
              fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildBottomRightButton() {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        onPressed: onRightPress,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Text(
          rightButtonText,
          style: TextStyle(
              color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
