import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import '../../helpers/diet/analyse_barcode.dart';
import '../../helpers/diet/extract_image_byte_data.dart';
import '../../helpers/diet/nutrition_tracker.dart';
import '../../models/diet/food_item.dart';
import 'package:provider/provider.dart';

import '../../widgets/diet/diet_exercise_box.dart';
import '../../widgets/diet/diet_home_macro_nutrition_display.dart';
import '../../widgets/diet/diet_category_box.dart';
import 'diet_food_display_page.dart';

class DietHomePageOld extends StatefulWidget {
  const DietHomePageOld({Key? key}) : super(key: key);

  @override
  State<DietHomePageOld> createState() => _DietHomePageOldState();
}

class _DietHomePageOldState extends State<DietHomePageOld> {

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().isCurrentFoodItemLoaded;

    double _margin = 15;
    double _bigContainerMin = 230;
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
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [

                NutritionHomeStats(
                  bigContainerMin: _bigContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                ),

                SizedBox(
                  height: MediaQuery.of(context).devicePixelRatio < 2.75 ? (MediaQuery.of(context).size.aspectRatio > 0.6 ? _height * 0.61 : _height * 0.51) : _height * 0.5,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(),
                    children: [
                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Breakfast",
                        foodList: context.watch<UserNutritionData>().foodListItemsBreakfast,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Lunch",
                        foodList: context.watch<UserNutritionData>().foodListItemsLunch,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Dinner",
                        foodList: context.watch<UserNutritionData>().foodListItemsDinner,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Snacks",
                        foodList: context.watch<UserNutritionData>().foodListItemsSnacks,
                      ),
                      DietExerciseBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Exercise",
                        exerciseList: context.watch<UserNutritionData>().foodListItemsExercise,
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
