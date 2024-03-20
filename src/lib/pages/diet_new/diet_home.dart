import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/pages/groceries/groceries_home.dart';
import 'package:fitness_tracker/widgets/general/screen_width_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health/health.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/diet/user_nutrition_model.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/database_get.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/diet_new/diet_home_daily_nutrition_display.dart';
import '../../widgets/diet_new/diet_home_exercise_display.dart';
import '../../widgets/diet_new/diet_home_food_display.dart';
import '../../widgets/diet_new/diet_water_box.dart';

class DietHomePage extends StatefulWidget {
  const DietHomePage({Key? key}) : super(key: key);

  @override
  State<DietHomePage> createState() => _DietHomePageState();
}

class _DietHomePageState extends State<DietHomePage> {

  void loadNewData() async {
    FirebaseAnalytics.instance.logEvent(name: 'changed_nutrition_date_swipe');
    UserNutritionModel userNutritionData;
    String date = context.read<UserNutritionData>().nutritionDate.toString();

    if (
    context.read<UserNutritionData>().userDailyNutritionCache.any((element) => element.date.toString() == date)
    ) {

      print("Found");

      print(date);
      print(context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)].date);

      userNutritionData = context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)
      ];

    } else {

      bool result = await InternetConnection().hasInternetAccess;
      GetOptions options = const GetOptions(source: Source.serverAndCache);

      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("No Internet Connection \nAttempting to load"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.6695,
              right: 20,
              left: 20,
            ),
            dismissDirection: DismissDirection.none,
            duration: const Duration(milliseconds: 700),
          ),
        );
        options = const GetOptions(source: Source.cache);
      }

      print("Not Found");

      userNutritionData = await GetUserNutritionData(
        date,
        options: options,
      );

      context.read<UserNutritionData>()
          .addToNutritionDataCache(userNutritionData);

    }

    context.read<UserNutritionData>().setCurrentFoodDiary(
        userNutritionData
    );
  }

  @override
  Widget build(BuildContext context) {

    double _margin = 15;
    double _smallContainerMin = 95;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails direction) {
        if (direction.primaryVelocity! > 0) {
          FirebaseAnalytics.instance.logEvent(name: 'changed_nutrition_date_swipe_left');
          context
              .read<UserNutritionData>()
              .updateNutritionDateArrows(true);
          loadNewData();
        } else {
          FirebaseAnalytics.instance.logEvent(name: 'changed_nutrition_date_swipe_right');
          context
              .read<UserNutritionData>()
              .updateNutritionDateArrows(false);
          loadNewData();
        }
      },
      child: Scaffold(
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

                ScreenWidthButton(
                  label: "Groceries List",
                  onTap: () => context.read<PageChange>().changePageCache(GroceriesHome()),
                ),

                SizedBox(
                  height: 40.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

