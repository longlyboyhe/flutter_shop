import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// 超过设置的maxLines会回调onFit的text
/// @author longlyboyhe
/// @date 2019/3/13
///
class MaxLineLimitText extends StatefulWidget {
  const MaxLineLimitText(
    this.data, {
    Key key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.onFit,
  })  : assert(data != null),
        textSpan = null,
        super(key: key);

  const MaxLineLimitText.rich(
    this.textSpan, {
    Key key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.onFit,
  })  : assert(textSpan != null),
        data = null,
        super(key: key);

  final String data;
  final TextSpan textSpan;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final ValueChanged<bool> onFit;

  @override
  _MaxLineLimitTextState createState() => _MaxLineLimitTextState();
}

class _MaxLineLimitTextState extends State<MaxLineLimitText> {
  bool fit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback(_onAfterRendering);
  }

  void _onAfterRendering(Duration timeStamp) {
    if (widget.onFit != null) widget.onFit(fit);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, size) {
      DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
      TextStyle effectiveStyle = widget.style;
      if (widget.style == null || widget.style.inherit) {
        effectiveStyle = defaultTextStyle.style.merge(widget.style);
      }
      var effectiveMaxLines = widget.maxLines ?? defaultTextStyle.maxLines;
      var currentScale = 1.0;
      var span =
          widget.textSpan ?? TextSpan(text: widget.data, style: effectiveStyle);
      fit = !checkTextFits(span, widget.locale, currentScale, effectiveMaxLines,
          size.maxWidth, size.maxHeight);
      return _buildText(currentScale, effectiveStyle);
    });
  }

  Widget _buildText(double scale, TextStyle style) {
    if (widget.data != null) {
      return Text(
        widget.data,
        style: style,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: scale,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    } else {
      return Text.rich(
        widget.textSpan,
        style: style,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        locale: widget.locale,
        softWrap: widget.softWrap,
        overflow: widget.overflow,
        textScaleFactor: scale,
        maxLines: widget.maxLines,
        semanticsLabel: widget.semanticsLabel,
      );
    }
  }

  bool checkTextFits(TextSpan text, Locale locale, double scale, int maxLines,
      double maxWidth, double maxHeight) {
    var tp = TextPainter(
      text: text,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
      textScaleFactor: scale ?? 1,
      maxLines: maxLines,
      locale: locale,
    );

    tp.layout(maxWidth: maxWidth);

    return !(tp.didExceedMaxLines ||
        tp.height > maxHeight ||
        tp.width > maxWidth);
  }
}
