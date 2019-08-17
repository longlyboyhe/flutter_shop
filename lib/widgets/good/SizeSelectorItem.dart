import 'package:flutter/material.dart';

///
/// 尺寸选择item -- 不可选有斜对角线
/// @author longlyboyhe
/// @date 2019/2/1
///
class SizeSelector extends CustomPainter {
  bool enable = true;
  bool selected = false;
  Color normalColor = Color(0xFFB5B5B5);
  Color selectedColor = Color(0xFFFF9B00);
  Color disableColor = Color(0xFFB5B5B5);
  String text;
  TextStyle textStyle;

  SizeSelector(@required this.text, this.enable, this.selected,
      this.normalColor, this.selectedColor, this.disableColor, this.textStyle);

  @override
  void paint(Canvas canvas, Size size) {
    /// 文字的TextPainter
    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 1,
    );

    // 文字画笔 风格定义
    TextPainter _newVerticalAxisTextPainter() {
      return textPainter
        ..text = TextSpan(
          text: text,
          style:
              textStyle.apply(color: enable ? textStyle.color : disableColor),
        );
    }

    var tp = _newVerticalAxisTextPainter()..layout();
    double dx = (size.width - tp.width) / 2;
    double dy = (size.height - tp.height) / 2;
    tp.paint(canvas, Offset(dx, dy));

    final Paint mPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = enable && selected
          ? selectedColor
          : enable ? normalColor : disableColor;
    final Rect mRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(mRect, mPaint);
    if (!enable) {
      final Paint linePaint = Paint()
        ..strokeWidth = 1
        ..color = disableColor;
      canvas.drawLine(Offset(0, 0), Offset(size.width, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SizeSelectorItem extends StatefulWidget {
  final bool enable;

  final bool selected;

  final Color normalColor;

  final Color selectedColor;

  final Color disableColor;

  final String text;
  final TextStyle textStyle;

  SizeSelectorItem(
      {@required this.text,
      this.enable = true,
      this.selected = false,
      this.normalColor = const Color(0xFFB5B5B5),
      this.selectedColor = const Color(0xFFEBE700),
      this.disableColor = const Color(0xFFB5B5B5),
      this.textStyle = const TextStyle(
        color: Colors.black,
        fontSize: 10.0,
      )});

  @override
  _SizeSelectorItemState createState() => _SizeSelectorItemState();
}

class _SizeSelectorItemState extends State<SizeSelectorItem> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SizeSelector(
          widget.text,
          widget.enable,
          widget.selected,
          widget.normalColor,
          widget.selectedColor,
          widget.disableColor,
          widget.textStyle),
    );
  }
}
