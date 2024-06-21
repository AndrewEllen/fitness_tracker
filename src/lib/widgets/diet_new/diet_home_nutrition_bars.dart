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
          const Spacer(),
          HomeNutritionBarShort(
            indicatorColour: Colors.redAccent,
            indicatorBackgroundColour: const Color.fromRGBO(90, 21, 20, 1.0),
            label: "Proteins",
            goal: context.watch<UserNutritionData>().proteinGoal,
            progress: context.watch<UserNutritionData>().protein,
          ),
          const Spacer(),
          HomeNutritionBarShort(
            indicatorColour: Colors.purple,
            indicatorBackgroundColour: appSenaryColourDark,
            label: "Fats",
            goal: context.watch<UserNutritionData>().fatGoal,
            progress: context.watch<UserNutritionData>().fat,
          ),
          const Spacer(),
          HomeNutritionBarShort(
            indicatorColour: Colors.blueAccent,
            indicatorBackgroundColour: const Color.fromRGBO(17, 32, 102, 1.0),
            label: "Carbs",
            goal: context.watch<UserNutritionData>().carbohydratesGoal,
            progress: context.watch<UserNutritionData>().carbohydrates,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
