import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';

import 'diet_home_nutrition_bar_short.dart';

class DietHomeNutritionBars extends StatelessWidget {
  const DietHomeNutritionBars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Spacer(),
        HomeNutritionBarShort(
          label: "Proteins",
          goal: "140",
          progress: "70",
        ),
        Spacer(),
        HomeNutritionBarShort(
          indicatorColour: appSenaryColour,
          indicatorBackgroundColour: appSenaryColourDark,
          label: "Fats",
          goal: "45",
          progress: "27",
        ),
        Spacer(),
        HomeNutritionBarShort(
          label: "Carbs",
          goal: "300",
          progress: "180",
        ),
        Spacer(),
      ],
    );
  }
}
