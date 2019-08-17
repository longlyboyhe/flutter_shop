import 'package:flutter/material.dart';
import 'package:flutter_shop/widgets/ColorfulDivider.dart';

class ColorfulDividerWidget extends StatefulWidget {
  @override
  _ColorfulDividerWidgetState createState() => _ColorfulDividerWidgetState();
}

class _ColorfulDividerWidgetState extends State<ColorfulDividerWidget> {
  final List<Color> _colors = [
    Color(0xFFFFB3C4),
    Colors.white,
    Color(0xFFA3D8FF),
    Colors.white,
  ];
  final List<double> _stops = [
    15,
    15,
    15,
    15,
  ];

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      height: 6.0,
      width: screenwidth,
      child: SyColorfulDivider(
        colors: _colors,
        stops: _stops,
        skewX: 1,
      ),
    );
  }
}
