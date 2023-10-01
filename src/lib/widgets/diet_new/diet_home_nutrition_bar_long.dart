import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class HomeNutritionBarLong extends StatelessWidget {
  const HomeNutritionBarLong({Key? key,
    required this.label,
    required this.progress,
    required this.goal,
    this.indicatorColour = appSecondaryColour,
    this.indicatorBackgroundColour = appSecondaryColourDark,
    this.units = "mg",
    this.excludeColourChange = true,
  }) : super(key: key);
  final Color indicatorColour, indicatorBackgroundColour;
  final String label, units;
  final double progress, goal;
  final bool excludeColourChange;

  double barProgress(double progress, double goal) {
    double barProgressDouble;
    try {
      if (goal > 0) {
        barProgressDouble = progress / goal;

        if (!excludeColourChange && barProgressDouble > 2) {
          return barProgressDouble = 2;
        } else if (excludeColourChange && barProgressDouble > 1) {
          return barProgressDouble = 1;
        }
        return barProgressDouble;
      } else if (progress > 0) {
        return barProgressDouble = 1;
      }
      return barProgressDouble = 0;
    } catch (error) {
      return barProgressDouble = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            width: 390.w,
            child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      label,
                      style: boldTextStyle.copyWith(
                          fontSize: 13.w
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${progress.toStringAsFixed(0)}g of ${goal.toStringAsFixed(0)}g",
                      style: boldTextStyle.copyWith(
                          fontSize: 13.w
                      ),
                    ),
                  ),
                ]
            ),
          ),
          Stack(
            children: [
              !excludeColourChange ? SizedBox(
                width: 390.w,
                height: 10.w,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: goal == 0 ? barProgress(progress, goal) : barProgress(progress, goal)-1),
                  duration: const Duration(milliseconds: 750),
                  builder: (context, value, _) => ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: value,
                      valueColor: const AlwaysStoppedAnimation<Color>(streakColourOrange),
                      backgroundColor: indicatorColour,
                    ),
                  ),
                ),
              ) : const SizedBox.shrink(),
              SizedBox(
                width: 390.w,
                height: 10.w,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: barProgress(progress, goal)),
                  duration: const Duration(milliseconds: 750),
                  builder: (context, value, _) => value <= 1 ? ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: value,
                      valueColor: AlwaysStoppedAnimation<Color>(goal == 0 ? streakColourOrange : indicatorColour),
                      backgroundColor: indicatorBackgroundColour,
                    ),
                  ) : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
