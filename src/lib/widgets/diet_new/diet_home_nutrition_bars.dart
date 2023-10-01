import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/diet/user_nutrition_data.dart';
import 'diet_home_nutrition_bar_short.dart';

class DietHomeNutritionBars extends StatelessWidget {
  const DietHomeNutritionBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: Column(
        children: [
          Spacer(),
          HomeNutritionBarShort(
            label: "Proteins",
            goal: context.watch<UserNutritionData>().proteinGoal,
            progress: context.watch<UserNutritionData>().protein,
          ),
          Spacer(),
          HomeNutritionBarShort(
            indicatorColour: appSenaryColour,
            indicatorBackgroundColour: appSenaryColourDark,
            label: "Fats",
            goal: context.watch<UserNutritionData>().fatGoal,
            progress: context.watch<UserNutritionData>().fat,
          ),
          Spacer(),
          HomeNutritionBarShort(
            label: "Carbs",
            goal: context.watch<UserNutritionData>().carbohydratesGoal,
            progress: context.watch<UserNutritionData>().carbohydrates,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
