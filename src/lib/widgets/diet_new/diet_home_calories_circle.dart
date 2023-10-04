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
      if (barProgressDouble > 2) {
        barProgressDouble = 2;
      }
    } catch (error) {
      barProgressDouble = 0;
    }
    return barProgressDouble;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.h,
      height: 160.h,
      child: Stack(
        children: [
          Positioned(
            child: SizedBox(
              width: 160.h,
              height: 160.h,
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
              width: 160.h,
              height: 160.h,
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
          Center(
            child: Column(
              children: [
                const Spacer(),
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
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
