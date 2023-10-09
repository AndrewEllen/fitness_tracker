import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/exercise_calories_list_item.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../pages/diet/diet_barcode_scanner.dart';
import '../../pages/diet/diet_food_display_page.dart';
import '../diet/diet_category_add_bar.dart';
import '../diet/exercise_list_item_box.dart';
import '../diet/food_list_item_box.dart';
import '../general/app_container_header.dart';
import '../general/app_default_button.dart';
import 'diet_home_bottom_button.dart';
import 'diet_home_exercise_bottom_button.dart';

class DietHomeExerciseDisplay extends StatefulWidget {
  const DietHomeExerciseDisplay({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.exerciseList, required this.caloriesTotal
  }) : super(key: key);
  final double bigContainerMin, height, margin, width, caloriesTotal;
  final String title;
  final List<ListExerciseItem> exerciseList;

  @override
  State<DietHomeExerciseDisplay> createState() => _DietHomeExerciseDisplayState();
}

class _DietHomeExerciseDisplayState extends State<DietHomeExerciseDisplay> {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
            //height: 240.h,
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: boldTextStyle.copyWith(
                              color: appSecondaryColour,
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(right: 8.0.h),
                            child: Text(
                              "${widget.caloriesTotal.toStringAsFixed(0)} Kcal",
                              style: boldTextStyle.copyWith(
                                color: appSenaryColour,
                                fontSize: 18.h,
                              ),
                            ),
                          ),
                          Text(
                            "Burned",
                            style: boldTextStyle.copyWith(
                              fontSize: 12.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                context.read<UserNutritionData>().isCurrentFoodItemLoaded ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.exerciseList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {

                    return ExerciseListDisplayBox(
                      key: UniqueKey(),
                      width: widget.width,
                      exerciseList: widget.exerciseList[index],
                      icon: MdiIcons.trashCan,
                      iconColour: Colors.red,
                      onTapIcon: () {
                        context.read<UserNutritionData>().deleteExerciseItemFromDiary(index, widget.title);
                      },
                    );
                  },
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
          DietHomeExerciseBottomButton(
            category: widget.title,
          ),
        ],
      ),
    );
  }
}
