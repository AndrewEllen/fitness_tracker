import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'diet_home_bottom_button.dart';

class DailyNutritionDisplay extends StatelessWidget {
  const DailyNutritionDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            color: appTertiaryColour,
          ),
          width: double.maxFinite.w,
          height: 213.h,
        ),
        const DietHomeBottomButton(),
      ],
    );
  }
}
