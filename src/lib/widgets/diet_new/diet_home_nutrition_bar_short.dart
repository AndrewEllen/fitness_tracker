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
  final String label, progress, goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  label,
                  style: boldTextStyle.copyWith(
                      fontSize: 13.h
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  " " + progress + "g of " + goal + "g",
                  style: boldTextStyle.copyWith(
                    fontSize: 12.h
                  ),
                ),
              ),
            ]
          ),
        ),
        SizedBox(
          width: 120.h,
          height: 10.h,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 0.5),
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
