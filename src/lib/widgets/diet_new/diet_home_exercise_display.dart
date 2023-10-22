import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/exercise_calories_list_item.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'exercise_list_item_box_new.dart';

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

  editExercise(BuildContext context, double width, ListExerciseItem exerciseItem, int index) {

    late TextEditingController nameController = TextEditingController(text: exerciseItem.name);
    late final nameKey = GlobalKey<FormState>();

    late TextEditingController caloriesController = TextEditingController(text: exerciseItem.calories);
    late final caloriesKey = GlobalKey<FormState>();

    double buttonSize = width/17;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Edit Exercise",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: SizedBox(
            height: (width/2.5).w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: nameKey,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (20.h),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: (width/12)/2.5, left: 5, right: 5,),
                      hintText: 'Exercise Name...',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: (18.h),
                      ),
                      errorStyle: const TextStyle(
                        height: 0,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appSecondaryColour,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isNotEmpty) {
                        return null;
                      }
                      return "";
                    },
                  ),
                ),

                Form(
                  key: caloriesKey,
                  child: TextFormField(
                    controller: caloriesController,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: (20.h),
                    ),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final text = newValue.text;
                        return text.isEmpty
                            ? newValue
                            : double.tryParse(text) == null
                            ? oldValue
                            : newValue;
                      }),
                      //NumericalRangeFormatter(min: 0, max: 100000),
                    ],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: (width/12)/2.5, left: 5, right: 5,),
                      hintText: 'Calories Burned...',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: (18.h),
                      ),
                      errorStyle: const TextStyle(
                        height: 0,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: appSecondaryColour,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isNotEmpty) {
                        return null;
                      }
                      return "";
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: Colors.red,
                      buttonText: "Delete",
                      onTap: () {

                        context.read<UserNutritionData>().deleteExerciseItemFromDiary(index, "exercise");

                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Save",
                      onTap: () {
                        if (nameKey.currentState!.validate() && caloriesKey.currentState!.validate()) {
                          context.read<UserNutritionData>().editExerciseItemInDiary(
                            ListExerciseItem(
                              name: nameController.text,
                              category: "Exercise",
                              calories: caloriesController.text,
                              extraInfoField: exerciseItem.extraInfoField,
                              hideDelete: exerciseItem.hideDelete,
                            ),
                            index,
                          );
                          Navigator.pop(context);
                        }
                      },
                    )
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
             // borderRadius: BorderRadius.only(
             //   topRight: Radius.circular(10),
             //   topLeft: Radius.circular(10),
             // ),
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

                    return ExerciseListItemBoxNew(
                      key: UniqueKey(),
                      exerciseObject: widget.exerciseList[index],
                      onTap: () => widget.exerciseList[index].hideDelete ? null : editExercise(context, widget.width, widget.exerciseList[index], index),
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
