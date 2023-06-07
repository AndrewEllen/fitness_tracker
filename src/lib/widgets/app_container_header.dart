import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';

class AppHeaderBox extends StatelessWidget {
  AppHeaderBox({Key? key, required this.width, required this.title, this.titleColor = appSecondaryColour, this.largeTitle = false
  }) : super(key: key);
  double width;
  String title;
  Color titleColor;
  bool largeTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: largeTitle ? const BorderSide(width: 0, color: appPrimaryColour) : const BorderSide(width: 1, color: appPrimaryColour),
        ),
      ),
      width: width,
      height: 40,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: largeTitle ? 18 : 15,
            fontWeight: largeTitle ? FontWeight.w900 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
