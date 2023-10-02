import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/diet/exercise_calories_list_item.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/page_change_provider.dart';
import '../general/app_default_button.dart';

class DietHomeExerciseBottomButton extends StatelessWidget {
  DietHomeExerciseBottomButton({Key? key, required this.category}) : super(key: key);

  final String category;

  late TextEditingController nameController = TextEditingController();
  late final nameKey = GlobalKey<FormState>();

  late TextEditingController caloriesController = TextEditingController();
  late final caloriesKey = GlobalKey<FormState>();

  addExercise(BuildContext context, double width) {

    double buttonSize = width/17;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Add Exercise",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: SizedBox(
            height: width/2.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: nameKey,
                  child: TextFormField(
                    controller: nameController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (20),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: (width/12)/2.5, left: 5, right: 5,),
                      hintText: 'Exercise Name...',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontSize: (18),
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (20),
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
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                        fontSize: (18),
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
                      buttonText: "Add",
                      onTap: () {
                        if (nameKey.currentState!.validate() && caloriesKey.currentState!.validate()) {
                          context.read<UserNutritionData>().addExerciseItemToDiary(ListExerciseItem(
                            name: nameController.text,
                            category: "Exercise",
                            calories: caloriesController.text,
                          ));
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
    return InkWell(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      onTap: () => addExercise(context, 400.w),
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          color: appSecondaryColour,
        ),
        child: SizedBox(
          width: double.maxFinite.w,
          height: 30.h,
          child: Center(
              child: Text(
                "Add Exercise",
                style: boldTextStyle.copyWith(
                  fontSize: 16.h,
                ),
              )
          ),
        ),
      ),
    );
  }
}
