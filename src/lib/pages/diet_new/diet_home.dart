import 'package:fitness_tracker/pages/groceries/groceries_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/diet_new/diet_home_daily_nutrition_display.dart';
import '../../widgets/diet_new/diet_home_exercise_display.dart';
import '../../widgets/diet_new/diet_home_food_display.dart';
import '../../widgets/diet_new/diet_water_box.dart';

class DietHomePage extends StatelessWidget {
  DietHomePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    double _margin = 15;
    double _smallContainerMin = 95;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
          child: SingleChildScrollView(
          //physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Center(
                    child: DailyNutritionDisplay(),
                  ),
                ),
                DietHomeFoodDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Breakfast",
                  foodList: context.watch<UserNutritionData>().foodListItemsBreakfast,
                  caloriesTotal: context.read<UserNutritionData>().breakfastCalories,
                ),

                DietHomeFoodDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Lunch",
                  foodList: context.watch<UserNutritionData>().foodListItemsLunch,
                  caloriesTotal: context.read<UserNutritionData>().lunchCalories,
                ),

                DietHomeFoodDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Dinner",
                  foodList: context.watch<UserNutritionData>().foodListItemsDinner,
                  caloriesTotal: context.read<UserNutritionData>().dinnerCalories,
                ),

                DietHomeFoodDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Snacks",
                  foodList: context.watch<UserNutritionData>().foodListItemsSnacks,
                  caloriesTotal: context.read<UserNutritionData>().snacksCalories,
                ),

                DietHomeExerciseDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Exercise",
                  exerciseList: context.watch<UserNutritionData>().foodListItemsExercise,
                  caloriesTotal: context.read<UserNutritionData>().exerciseCalories,
                ),

                DietWaterDisplay(
                  bigContainerMin: _smallContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                  title: "Water",

                ),

                ElevatedButton(
                  onPressed: () => context.read<PageChange>().changePageCache(const GroceriesHome()),
                  child: const Text(
                    "Groceries",
                  ),
                ),

                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        ),
    );
  }
}
