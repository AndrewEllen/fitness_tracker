import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';

class DietListHeaderBox extends StatelessWidget {
  DietListHeaderBox({Key? key, required this.width, required this.title,
    this.largeTitle = false, this.color = appSecondaryColour,
  }) : super(key: key);
  double width;
  String title;
  Color color;
  bool largeTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: largeTitle ? const BorderSide(width: 3, color: appPrimaryColour) : const BorderSide(width: 3, color: appPrimaryColour),
          bottom: largeTitle ? const BorderSide(width: 0, color: appPrimaryColour) : const BorderSide(width: 1, color: appPrimaryColour),
        ),
      ),
      width: width,
      height: 40,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: largeTitle ? 18 : 15,
            fontWeight: largeTitle ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
