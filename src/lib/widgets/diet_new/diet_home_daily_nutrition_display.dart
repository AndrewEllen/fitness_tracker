import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/diet/user_nutrition_data.dart';
import 'diet_home_bottom_button.dart';
import 'diet_home_calories_circle.dart';
import 'diet_home_date_picker.dart';
import 'diet_home_extra_nutrition_bars.dart';
import 'diet_home_nutrition_bars.dart';

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
          height: 240.h,
          child: Column(
            children: [
              DietDatePicker(),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(
                  top: 2.0.h,
                  bottom: 10.0.h,
                  left: 4.0.w,
                  right: 4.0.w,
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 2.0.w),
                      child: Center(
                        child: CalorieCircle(
                          calories: context.watch<UserNutritionData>().calories,
                          caloriesGoal: context.watch<UserNutritionData>().caloriesGoal,
                        ),
                      ),
                    ),
                    Spacer(),
                    DietHomeNutritionBars(),
                    Spacer(),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        const DietHomeExtraNutritionBars(),
      ],
    );
  }
}
