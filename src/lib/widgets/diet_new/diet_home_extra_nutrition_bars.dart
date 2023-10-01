import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../diet/diet_list_header_box.dart';
import '../diet/nutrition_progress_bar.dart';

class DietHomeExtraNutritionBars extends StatefulWidget {
  const DietHomeExtraNutritionBars({Key? key}) : super(key: key);

  @override
  State<DietHomeExtraNutritionBars> createState() => _DietHomeExtraNutritionBarsState();
}

class _DietHomeExtraNutritionBarsState extends State<DietHomeExtraNutritionBars> {
  double expandContainer = 0;

  void onTap() {
    updateContainerSize();
    print(expandContainer);
  }

  void updateContainerSize() {
    setState(() {
      if (expandContainer > 0) {
        expandContainer = 0;
      } else {
        expandContainer = 460;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.h, end: expandContainer.h),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, _) {
          return Column(
            children: [
              Container(
                width: double.maxFinite,
                height: value,
                color: appTertiaryColour,
                child: ClipRRect(
                    child: SingleChildScrollView(child: ExtraNutritionBars(width: 390.w,)),
                ),
              ),
              InkWell(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                onTap: onTap,
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
                          value > 0 ? "Hide" : "See More",
                          style: boldTextStyle,
                        )
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}

class ExtraNutritionBars extends StatelessWidget {
  const ExtraNutritionBars({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DietListHeaderBox(
          width: width,
          title: "Carbohydrates and Fats",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Fiber",
          currentProgress: context.watch<UserNutritionData>().fiber,
          goal: context.watch<UserNutritionData>().fiberGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Sugars",
          currentProgress: context.watch<UserNutritionData>().sugar,
          goal: context.watch<UserNutritionData>().sugarGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Saturated Fat",
          currentProgress: context.watch<UserNutritionData>().saturatedFat,
          goal: context.watch<UserNutritionData>().saturatedFatGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
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
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
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
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Trans Fat",
          currentProgress: context.watch<UserNutritionData>().transFat,
          goal: context.watch<UserNutritionData>().transFatGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Cholesterol",
          currentProgress: context.watch<UserNutritionData>().cholesterol,
          goal: context.watch<UserNutritionData>().cholesterolGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: width,
          title: "Caffeine and Alcohol",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caffeine",
          currentProgress: context.watch<UserNutritionData>().caffeine,
          goal: context.watch<UserNutritionData>().caffeineGoal,
          width: width,
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Alcohol",
          currentProgress: context.watch<UserNutritionData>().alcohol,
          goal: context.watch<UserNutritionData>().alcoholGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: width,
          title: "Minerals",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Salt",
          currentProgress: context.watch<UserNutritionData>().sodium,
          goal: context.watch<UserNutritionData>().sodiumGoal,
          width: width,
          units: "g",
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Magnesium",
          currentProgress: context.watch<UserNutritionData>().magnesium,
          goal: context.watch<UserNutritionData>().magnesiumGoal,
          width: width,
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Potassium",
          currentProgress: context.watch<UserNutritionData>().potassium,
          goal: context.watch<UserNutritionData>().potassiumGoal,
          width: width,
          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Iron",
          currentProgress: context.watch<UserNutritionData>().iron,
          goal: context.watch<UserNutritionData>().ironGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Zinc",
          currentProgress: context.watch<UserNutritionData>().zinc,
          goal: context.watch<UserNutritionData>().zincGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Calcium",
          currentProgress: context.watch<UserNutritionData>().calcium,
          goal: context.watch<UserNutritionData>().calciumGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Selenium",
          currentProgress: context.watch<UserNutritionData>().selenium,
          goal: context.watch<UserNutritionData>().seleniumGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Chloride",
          currentProgress: context.watch<UserNutritionData>().chloride,
          goal: context.watch<UserNutritionData>().chlorideGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Chromium",
          currentProgress: context.watch<UserNutritionData>().chromium,
          goal: context.watch<UserNutritionData>().chromiumGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Copper",
          currentProgress: context.watch<UserNutritionData>().copper,
          goal: context.watch<UserNutritionData>().copperGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Fluoride",
          currentProgress: context.watch<UserNutritionData>().fluoride,
          goal: context.watch<UserNutritionData>().fluorideGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Iodine",
          currentProgress: context.watch<UserNutritionData>().iodine,
          goal: context.watch<UserNutritionData>().iodineGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Manganese",
          currentProgress: context.watch<UserNutritionData>().manganese,
          goal: context.watch<UserNutritionData>().manganeseGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Molybdenum",
          currentProgress: context.watch<UserNutritionData>().molybdenum,
          goal: context.watch<UserNutritionData>().molybdenumGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        DietListHeaderBox(
          width: width,
          title: "Vitamins and Amino Acids",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin A",
          currentProgress: context.watch<UserNutritionData>().vitaminA,
          goal: context.watch<UserNutritionData>().vitaminAGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B1",
          currentProgress: context.watch<UserNutritionData>().vitaminB1,
          goal: context.watch<UserNutritionData>().vitaminB1Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B2",
          currentProgress: context.watch<UserNutritionData>().vitaminB2,
          goal: context.watch<UserNutritionData>().vitaminB2Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Niacin",
          currentProgress: context.watch<UserNutritionData>().vitaminB3,
          goal: context.watch<UserNutritionData>().vitaminB3Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B6",
          currentProgress: context.watch<UserNutritionData>().vitaminB6,
          goal: context.watch<UserNutritionData>().vitaminB6Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Biotin",
          currentProgress: context.watch<UserNutritionData>().biotin,
          goal: context.watch<UserNutritionData>().biotinGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Folic Acid (B9)",
          currentProgress: context.watch<UserNutritionData>().vitaminB9,
          goal: context.watch<UserNutritionData>().vitaminB9Goal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin B12",
          currentProgress: context.watch<UserNutritionData>().vitaminB12,
          goal: context.watch<UserNutritionData>().vitaminB12Goal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin C",
          currentProgress: context.watch<UserNutritionData>().vitaminC,
          goal: context.watch<UserNutritionData>().vitaminCGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin D",
          currentProgress: context.watch<UserNutritionData>().vitaminD,
          goal: context.watch<UserNutritionData>().vitaminDGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin E",
          currentProgress: context.watch<UserNutritionData>().vitaminE,
          goal: context.watch<UserNutritionData>().vitaminEGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Vitamin K",
          currentProgress: context.watch<UserNutritionData>().vitaminK,
          goal: context.watch<UserNutritionData>().vitaminKGoal,
          width: width,
          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Omega-3",
          currentProgress: context.watch<UserNutritionData>().omega3,
          goal: context.watch<UserNutritionData>().omega3Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Omega-6",
          currentProgress: context.watch<UserNutritionData>().omega6,
          goal: context.watch<UserNutritionData>().omega6Goal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Butyric Acid",
          currentProgress: context.watch<UserNutritionData>().butyricAcid,
          goal: context.watch<UserNutritionData>().butyricAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Capric Acid",
          currentProgress: context.watch<UserNutritionData>().capricAcid,
          goal: context.watch<UserNutritionData>().capricAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caproic Acid",
          currentProgress: context.watch<UserNutritionData>().caproicAcid,
          goal: context.watch<UserNutritionData>().caproicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Caprylic Acid",
          currentProgress: context.watch<UserNutritionData>().caprylicAcid,
          goal: context.watch<UserNutritionData>().caprylicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
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
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
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
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Erucic Acid",
          currentProgress: context.watch<UserNutritionData>().erucicAcid,
          goal: context.watch<UserNutritionData>().erucicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Myristic Acid",
          currentProgress: context.watch<UserNutritionData>().myristicAcid,
          goal: context.watch<UserNutritionData>().myristicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Oleic Acid",
          currentProgress: context.watch<UserNutritionData>().oleicAcid,
          goal: context.watch<UserNutritionData>().oleicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Palmitic Acid",
          currentProgress: context.watch<UserNutritionData>().palmiticAcid,
          goal: context.watch<UserNutritionData>().palmiticAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Pantothenic Acid",
          currentProgress: context.watch<UserNutritionData>().pantothenicAcid,
          goal: context.watch<UserNutritionData>().pantothenicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        NutritionProgressBar(
          title: "Stearic Acid",
          currentProgress: context.watch<UserNutritionData>().stearicAcid,
          goal: context.watch<UserNutritionData>().stearicAcidGoal,
          width: width,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
      ],
    );
  }
}