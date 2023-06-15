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
  NutritionHomeStats(
      {Key? key,
      required this.bigContainerMin,
      required this.height,
      required this.margin,
      required this.width})
      : super(key: key);
  double bigContainerMin, height, margin, width;

  @override
  State<NutritionHomeStats> createState() => _NutritionHomeStatsState();
}

class _NutritionHomeStatsState extends State<NutritionHomeStats> {
  late bool _expanded = false;

  void loadNewData() async {
    context.read<UserNutritionData>().setCurrentFoodDiary(
        await GetUserNutritionData(
            context.read<UserNutritionData>().nutritionDate.toString()));
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().isCurrentFoodItemLoaded;

    return Container(
      margin: EdgeInsets.only(top: widget.margin),
      width: (widget.width / 100) * 97,
      decoration: homeBoxDecoration,
      child: Column(
        children: [
          Container(
            height: 40,
            child: Stack(
              children: [
                AppHeaderBox(
                  title:
                      context.read<UserNutritionData>().formattedNutritionDate,
                  width: widget.width,
                  largeTitle: true,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: widget.width / 6,
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
                            context
                                .read<UserNutritionData>()
                                .updateNutritionDateArrows(true);
                            loadNewData();
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: widget.width / 6,
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
                            context
                                .read<UserNutritionData>()
                                .updateNutritionDateArrows(false);
                            loadNewData();
                          }),
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
                        icon: const Icon(Icons.calendar_today),
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
                            initialDate:
                                context.read<UserNutritionData>().nutritionDate,
                            firstDate: DateTime(1991),
                            lastDate: DateTime(2023, 12, 31),
                          );
                          if (newDateUnformatted != null) {
                            print(newDateUnformatted);
                            context
                                .read<UserNutritionData>()
                                .updateNutritionDate(newDateUnformatted);
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
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: widget.height / 1.29,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                DietListHeaderBox(
                  width: widget.width,
                  title: "Calories and Macro Nutrients",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: appPrimaryColour),
                    ),
                  ),
                ),
                NutritionProgressBar(
                  title: "Calories",
                  currentProgress: context.watch<UserNutritionData>().calories,
                  goal: context.watch<UserNutritionData>().caloriesGoal,
                  width: widget.width,
                  units: "Kcal",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: appPrimaryColour),
                    ),
                  ),
                ),
                NutritionProgressBar(
                  title: "Protein",
                  currentProgress: context.watch<UserNutritionData>().protein,
                  goal: context.watch<UserNutritionData>().proteinGoal,
                  width: widget.width,
                  units: "g",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: appPrimaryColour),
                    ),
                  ),
                ),
                NutritionProgressBar(
                  title: "Carbohydrates",
                  currentProgress:
                      context.watch<UserNutritionData>().carbohydrates,
                  goal: context.watch<UserNutritionData>().carbohydratesGoal,
                  width: widget.width,
                  units: "g",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: appPrimaryColour),
                    ),
                  ),
                ),
                NutritionProgressBar(
                  title: "Fat",
                  currentProgress: context.watch<UserNutritionData>().fat,
                  goal: context.watch<UserNutritionData>().fatGoal,
                  width: widget.width,
                  units: "g",
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: appPrimaryColour),
                    ),
                  ),
                ),
                _expanded
                    ? ExtraNutritionBars(
                        width: widget.width,
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: IconButton(
              icon: Icon(
                _expanded
                    ? Icons.keyboard_arrow_up_outlined
                    : Icons.keyboard_arrow_down_outlined,
              ),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
                print(_expanded);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ExtraNutritionBars extends StatefulWidget {
  ExtraNutritionBars({
    Key? key,
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
        DietListHeaderBox(
          width: widget.width,
          title: "Carbohydrates and Fats",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Fiber",
          currentProgress: context.watch<UserNutritionData>().fiber,
          goal: context.watch<UserNutritionData>().fiberGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Sugars",
          currentProgress: context.watch<UserNutritionData>().sugar,
          goal: context.watch<UserNutritionData>().sugarGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Saturated Fat",
          currentProgress: context.watch<UserNutritionData>().saturatedFat,
          goal: context.watch<UserNutritionData>().saturatedFatGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Polyunsaturated Fat",
          currentProgress:
              context.watch<UserNutritionData>().polyUnsaturatedFat,
          goal: context.watch<UserNutritionData>().polyUnsaturatedFatGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Monounsaturated Fat",
          currentProgress:
              context.watch<UserNutritionData>().monoUnsaturatedFat,
          goal: context.watch<UserNutritionData>().monoUnsaturatedFatGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Trans Fat",
          currentProgress: context.watch<UserNutritionData>().transFat,
          goal: context.watch<UserNutritionData>().transFatGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Cholesterol",
          currentProgress: context.watch<UserNutritionData>().cholesterol,
          goal: context.watch<UserNutritionData>().cholesterolGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: widget.width,
          title: "Caffeine and Alcohol",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caffeine",
          currentProgress: context.watch<UserNutritionData>().caffeine,
          goal: context.watch<UserNutritionData>().caffeineGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Alcohol",
          currentProgress: context.watch<UserNutritionData>().alcohol,
          goal: context.watch<UserNutritionData>().alcoholGoal,
          width: widget.width,
          units: "g",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: widget.width,
          title: "Minerals",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Sodium",
          currentProgress: context.watch<UserNutritionData>().sodium,
          goal: context.watch<UserNutritionData>().sodiumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Magnesium",
          currentProgress: context.watch<UserNutritionData>().magnesium,
          goal: context.watch<UserNutritionData>().magnesiumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Potassium",
          currentProgress: context.watch<UserNutritionData>().potassium,
          goal: context.watch<UserNutritionData>().potassiumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Iron",
          currentProgress: context.watch<UserNutritionData>().iron,
          goal: context.watch<UserNutritionData>().ironGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Zinc",
          currentProgress: context.watch<UserNutritionData>().zinc,
          goal: context.watch<UserNutritionData>().zincGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Calcium",
          currentProgress: context.watch<UserNutritionData>().calcium,
          goal: context.watch<UserNutritionData>().calciumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Selenium",
          currentProgress: context.watch<UserNutritionData>().selenium,
          goal: context.watch<UserNutritionData>().seleniumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Chloride",
          currentProgress: context.watch<UserNutritionData>().chloride,
          goal: context.watch<UserNutritionData>().chlorideGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Chromium",
          currentProgress: context.watch<UserNutritionData>().chromium,
          goal: context.watch<UserNutritionData>().chromiumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Copper",
          currentProgress: context.watch<UserNutritionData>().copper,
          goal: context.watch<UserNutritionData>().copperGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Fluoride",
          currentProgress: context.watch<UserNutritionData>().fluoride,
          goal: context.watch<UserNutritionData>().fluorideGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Iodine",
          currentProgress: context.watch<UserNutritionData>().iodine,
          goal: context.watch<UserNutritionData>().iodineGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Manganese",
          currentProgress: context.watch<UserNutritionData>().manganese,
          goal: context.watch<UserNutritionData>().manganeseGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Molybdenum",
          currentProgress: context.watch<UserNutritionData>().molybdenum,
          goal: context.watch<UserNutritionData>().molybdenumGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: widget.width,
          title: "Vitamins and Amino Acids",
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin A",
          currentProgress: context.watch<UserNutritionData>().vitaminA,
          goal: context.watch<UserNutritionData>().vitaminAGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B1",
          currentProgress: context.watch<UserNutritionData>().vitaminB1,
          goal: context.watch<UserNutritionData>().vitaminB1Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B2",
          currentProgress: context.watch<UserNutritionData>().vitaminB2,
          goal: context.watch<UserNutritionData>().vitaminB2Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Niacin",
          currentProgress: context.watch<UserNutritionData>().vitaminB3,
          goal: context.watch<UserNutritionData>().vitaminB3Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B6",
          currentProgress: context.watch<UserNutritionData>().vitaminB6,
          goal: context.watch<UserNutritionData>().vitaminB6Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Biotin",
          currentProgress: context.watch<UserNutritionData>().biotin,
          goal: context.watch<UserNutritionData>().biotinGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B9",
          currentProgress: context.watch<UserNutritionData>().vitaminB9,
          goal: context.watch<UserNutritionData>().vitaminB9Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B12",
          currentProgress: context.watch<UserNutritionData>().vitaminB12,
          goal: context.watch<UserNutritionData>().vitaminB12Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin C",
          currentProgress: context.watch<UserNutritionData>().vitaminC,
          goal: context.watch<UserNutritionData>().vitaminCGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin D",
          currentProgress: context.watch<UserNutritionData>().vitaminD,
          goal: context.watch<UserNutritionData>().vitaminDGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin E",
          currentProgress: context.watch<UserNutritionData>().vitaminE,
          goal: context.watch<UserNutritionData>().vitaminEGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin K",
          currentProgress: context.watch<UserNutritionData>().vitaminK,
          goal: context.watch<UserNutritionData>().vitaminKGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Omega-3",
          currentProgress: context.watch<UserNutritionData>().omega3,
          goal: context.watch<UserNutritionData>().omega3Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Omega-6",
          currentProgress: context.watch<UserNutritionData>().omega6,
          goal: context.watch<UserNutritionData>().omega6Goal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Butyric Acid",
          currentProgress: context.watch<UserNutritionData>().butyricAcid,
          goal: context.watch<UserNutritionData>().butyricAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Capric Acid",
          currentProgress: context.watch<UserNutritionData>().capricAcid,
          goal: context.watch<UserNutritionData>().capricAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caproic Acid",
          currentProgress: context.watch<UserNutritionData>().caproicAcid,
          goal: context.watch<UserNutritionData>().caproicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caprylic Acid",
          currentProgress: context.watch<UserNutritionData>().caprylicAcid,
          goal: context.watch<UserNutritionData>().caprylicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Docosahexaenoic Acid",
          currentProgress:
              context.watch<UserNutritionData>().docosahexaenoicAcid,
          goal: context.watch<UserNutritionData>().docosahexaenoicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Eicosapentaenoic Acid",
          currentProgress:
              context.watch<UserNutritionData>().eicosapentaenoicAcid,
          goal: context.watch<UserNutritionData>().eicosapentaenoicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Erucic Acid",
          currentProgress: context.watch<UserNutritionData>().erucicAcid,
          goal: context.watch<UserNutritionData>().erucicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Myristic Acid",
          currentProgress: context.watch<UserNutritionData>().myristicAcid,
          goal: context.watch<UserNutritionData>().myristicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Oleic Acid",
          currentProgress: context.watch<UserNutritionData>().oleicAcid,
          goal: context.watch<UserNutritionData>().oleicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Palmitic Acid",
          currentProgress: context.watch<UserNutritionData>().palmiticAcid,
          goal: context.watch<UserNutritionData>().palmiticAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Pantothenic Acid",
          currentProgress: context.watch<UserNutritionData>().pantothenicAcid,
          goal: context.watch<UserNutritionData>().pantothenicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Stearic Acid",
          currentProgress: context.watch<UserNutritionData>().stearicAcid,
          goal: context.watch<UserNutritionData>().stearicAcidGoal,
          width: widget.width,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
      ],
    );
    // NutritionProgressBar(
  }
}
