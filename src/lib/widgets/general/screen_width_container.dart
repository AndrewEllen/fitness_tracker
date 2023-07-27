import 'package:flutter/material.dart';
import '../../constants.dart';

class ScreenWidthContainer extends StatelessWidget {
  const ScreenWidthContainer({Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.height,
    required this.child,
    this.customMargin = false,
    this.margin = 0,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  }) : super(key: key);

  final double
      minHeight,
      maxHeight,
      margin,
      height,
      top,
      bottom,
      left,
      right;
  final Widget child;
  final bool customMargin;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          maxHeight: maxHeight,
        ),
        child: Container(
          margin: customMargin ? EdgeInsets.only(top: top, bottom: bottom, left: left, right: right) : EdgeInsets.only(top: margin),
          height: height,
          width: (width / 100) * 97,
          decoration: homeBoxDecoration,
          child: child,
        ),
      ),
    );
  }
}
