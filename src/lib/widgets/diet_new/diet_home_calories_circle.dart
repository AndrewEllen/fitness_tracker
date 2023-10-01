import 'dart:ffi';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCircle extends StatelessWidget {
  const CalorieCircle({Key? key, required this.caloriesGoal, required this.calories}) : super(key: key);
  final String caloriesGoal, calories;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            width: 140.h,
            height: 140.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 0.75),
              duration: const Duration(milliseconds: 750),
              builder: (context, value, _) => CircularProgressIndicator(

                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(appSecondaryColour),
                backgroundColor: appSecondaryColourDark,
                strokeWidth: 10.h,
              ),
            ),
          ),
        ),
        Positioned(
          top: 55.h,
          left: 12.h,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "$calories Kcal Remaining",
                  style: boldTextStyle.copyWith(
                    fontSize: 13.h,
                  ),
                ),
                Text(
                  "of $caloriesGoal Kcal",
                  style: boldTextStyle.copyWith(
                    fontSize: 13.h,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
