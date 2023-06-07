import 'package:fitness_tracker/widgets/app_container_header.dart';
import 'package:fitness_tracker/widgets/app_default_button.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/user_nutrition_model.dart';
import '../providers/database_get.dart';
import '../providers/user_nutrition_data.dart';
import 'diet_list_header_box.dart';
import 'nutrition_progress_bar.dart';

class NutritionHomeStats extends StatefulWidget {
  NutritionHomeStats({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width
  }) : super(key: key);
  double bigContainerMin, height, margin, width;

  @override
  State<NutritionHomeStats> createState() => _NutritionHomeStatsState();
}

class _NutritionHomeStatsState extends State<NutritionHomeStats> {

  void loadNewData () async {
    context.read<UserNutritionData>().setCurrentFoodDiary(await GetUserNutritionData(context.read<UserNutritionData>().nutritionDate.toString()));
  }


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: widget.margin),
      height: (widget.height / 100) * 32,
      width: (widget.width / 100) * 97,
      decoration: homeBoxDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            child: Stack(
              children: [
                AppHeaderBox(
                  title: context.watch<UserNutritionData>().formattedNutritionDate,
                  width: widget.width,
                  largeTitle: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.width/6,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Material(
                      type: MaterialType.transparency,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left_outlined,
                        ),
                        color: Colors.white,
                          onPressed: () {
                            context.read<UserNutritionData>().updateNutritionDateArrows(true);
                            loadNewData();
                          }
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: widget.width/6,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      type: MaterialType.transparency,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_right_outlined,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          context.read<UserNutritionData>().updateNutritionDateArrows(false);
                          loadNewData();
                        }
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      type: MaterialType.transparency,
                      shape: CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        icon: const Icon(
                            Icons.calendar_today
                        ),
                        onPressed: () async {
                          DateTime? newDateUnformatted = await showDatePicker(
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  dialogBackgroundColor: appTertiaryColour,
                                  colorScheme: const ColorScheme.light(
                                    primary: appSecondaryColour,
                                    onPrimary: Colors.white,
                                    onSurface: appSecondaryColour,
                                  ),
                                  textTheme: const TextTheme(
                                    bodyLarge: TextStyle(
                                      color: Colors.white,
                                    ),
                                    headlineMedium: TextStyle(
                                      fontSize: 26,
                                    ),
                                    headlineSmall: TextStyle(
                                      fontSize: 26,
                                    ),
                                    titleSmall: TextStyle(
                                      fontSize: 20,
                                    ),
                                    bodyMedium: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      foregroundColor: Colors.white,
                                      backgroundColor: appSecondaryColour,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                            context: context,
                            initialDate: context.read<UserNutritionData>().nutritionDate,
                            firstDate: DateTime(1991),
                            lastDate: DateTime(2023, 12, 31),
                          );
                          if (newDateUnformatted != null) {
                            print(newDateUnformatted);
                            context.read<UserNutritionData>().updateNutritionDate(newDateUnformatted);
                            loadNewData();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          NutritionProgressBar(
            title: "Calories",
            currentProgress: context.watch<UserNutritionData>().calories,
            goal: context.watch<UserNutritionData>().caloriesGoal,
            width: widget.width,
          ),
          NutritionProgressBar(
            title: "Protein",
            currentProgress: context.watch<UserNutritionData>().protein,
            goal: context.watch<UserNutritionData>().proteinGoal,
            width: widget.width,
          ),
          NutritionProgressBar(
            title: "Fat",
            currentProgress: context.watch<UserNutritionData>().fat,
            goal: context.watch<UserNutritionData>().fatGoal,
            width: widget.width,
          ),
          NutritionProgressBar(
            title: "Carbohydrates",
            currentProgress: context.watch<UserNutritionData>().carbohydrates,
            goal: context.watch<UserNutritionData>().carbohydratesGoal,
            width: widget.width,
          ),

          //ExtraNutritionBars(width: widget.width,),

          Spacer(),
          Material(
            type: MaterialType.transparency,
            shape: CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}

class ExtraNutritionBars extends StatefulWidget {
  ExtraNutritionBars({Key? key,
    required this.width,
  }) : super(key: key);

  double width;

  @override
  State<ExtraNutritionBars> createState() => _ExtraNutritionBarsState();
}

class _ExtraNutritionBarsState extends State<ExtraNutritionBars> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        NutritionProgressBar(
          title: "Calories",
          currentProgress: context.watch<UserNutritionData>().calories,
          goal: context.watch<UserNutritionData>().caloriesGoal,
          width: widget.width,
        ),
        NutritionProgressBar(
          title: "Protein",
          currentProgress: context.watch<UserNutritionData>().protein,
          goal: context.watch<UserNutritionData>().proteinGoal,
          width: widget.width,
        ),
        NutritionProgressBar(
          title: "Fat",
          currentProgress: context.watch<UserNutritionData>().fat,
          goal: context.watch<UserNutritionData>().fatGoal,
          width: widget.width,
        ),
        NutritionProgressBar(
          title: "Carbohydrates",
          currentProgress: context.watch<UserNutritionData>().carbohydrates,
          goal: context.watch<UserNutritionData>().carbohydratesGoal,
          width: widget.width,
        ),
      ],
    );
  }
}

