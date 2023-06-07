import 'package:flutter/material.dart';
import '../constants.dart';

class ScreenWidthExpandingContainer extends StatelessWidget {
  ScreenWidthExpandingContainer({Key? key,
    required this.minHeight,
    required this.child,
    this.customMargin = false,
    this.margin = 0,
    this.top = 0,
    this.bottom = 0,
    this.left = 0,
    this.right = 0,
  }) : super(key: key);

  late final double
  minHeight,
      margin,
      top,
      bottom,
      left,
      right;
  late Widget child;
  late final customMargin;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        margin: customMargin ? EdgeInsets.only(top: top, bottom: bottom, left: left, right: right) : EdgeInsets.only(top: margin),
        decoration: homeBoxDecoration,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: ((width / 100) * 97),
            maxWidth: ((width / 100) * 97),
            minHeight: minHeight,
            //maxHeight: maxHeight,
          ),
          child: child,
        ),
      ),
    );
  }
}
