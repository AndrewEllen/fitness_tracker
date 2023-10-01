import 'dart:ffi';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCircle extends StatelessWidget {
  const CalorieCircle({Key? key, required this.caloriesGoal, required this.calories}) : super(key: key);
  final double caloriesGoal, calories;

  double barProgress(double progress, double goal) {
    double barProgressDouble;
    try {
      barProgressDouble = progress / goal;
    } catch (error) {
      barProgressDouble = 0;
    }
    return barProgressDouble;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            width: 170.h,
            height: 170.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: barProgress(calories, caloriesGoal) - 1),
              duration: const Duration(milliseconds: 750),
              builder: (context, value, _) => CircularProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(streakColourOrange),
                strokeWidth: 14.h,
                backgroundColor: appSecondaryColour,
              ),
            ),
          ),
        ),
        Positioned(
          child: SizedBox(
            width: 170.h,
            height: 170.h,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: barProgress(calories, caloriesGoal)),
              duration: const Duration(milliseconds: 750),
              builder: (context, value, _) => value < 1 ? CircularProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(appSecondaryColour),
                backgroundColor: appSecondaryColourDark,
                strokeWidth: 14.h,
              ) : const SizedBox.shrink(),
            ),
          ),
        ),
        Positioned(
          top: 72.h,
          left: 22.h,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "${(caloriesGoal - calories).toStringAsFixed(0)} Kcal Remaining",
                  style: boldTextStyle.copyWith(
                    fontSize: 14.h,
                  ),
                ),
                Text(
                  "of ${caloriesGoal.toStringAsFixed(0)} Kcal",
                  style: boldTextStyle.copyWith(
                    fontSize: 14.h,
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
