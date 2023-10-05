import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class HomeNutritionBarShort extends StatelessWidget {
  const HomeNutritionBarShort({Key? key,
    required this.label,
    required this.progress,
    required this.goal,
    this.indicatorColour = appSecondaryColour,
    this.indicatorBackgroundColour = appSecondaryColourDark}) : super(key: key);
  final Color indicatorColour, indicatorBackgroundColour;
  final String label;
  final double progress, goal;

  double barProgress(double progress, double goal) {
    double barProgressDouble;
    try {
      barProgressDouble = progress / goal;
      if (barProgressDouble > 1) {
        barProgressDouble = 1;
      }
    } catch (error) {
      barProgressDouble = 0;
    }
    return barProgressDouble;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 160.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: boldTextStyle.copyWith(
                      fontSize: 14.w
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${progress.toStringAsFixed(0)}g of ${goal.toStringAsFixed(0)}g",
                  style: boldTextStyle.copyWith(
                    fontSize: 14.w
                  ),
                ),
              ),
            ]
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              basicAppShadow,
            ],
          ),
          width: 160.w,
          height: 10.w,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: barProgress(progress, goal)),
            duration: const Duration(milliseconds: 750),
            builder: (context, value, _) => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: value,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColour),
                backgroundColor: indicatorBackgroundColour,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
