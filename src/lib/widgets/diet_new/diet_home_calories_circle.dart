import 'dart:ffi';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCircle extends StatelessWidget {
  const CalorieCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 100.w,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: 0.75),
        duration: const Duration(milliseconds: 750),
        builder: (context, value, _) => CircularProgressIndicator(
          value: value,
          valueColor: AlwaysStoppedAnimation<Color>(appSecondaryColour),
          backgroundColor: appSecondaryColourDark,
          strokeWidth: 10,
        ),
      ),
    );
  }
}
