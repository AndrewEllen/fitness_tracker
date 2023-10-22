import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../diet/diet_list_header_box.dart';
import '../diet/nutrition_progress_bar.dart';
import 'diet_home_nutrition_bar_long.dart';

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
                  //bottomRight: Radius.circular(10),
                  //bottomLeft: Radius.circular(10),
                ),
                onTap: onTap,
                child: Ink(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      //bottomRight: Radius.circular(10),
                      //bottomLeft: Radius.circular(10),
                    ),
                    color: appSenaryColour,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        basicAppShadow
                      ],
                    ),
                    width: double.maxFinite.w,
                    height: 30.h,
                    child: Center(
                        child: Text(
                          value > 0 ? "Hide" : "See More",
                          style: boldTextStyle.copyWith(
                            fontSize: 17.w,
                          ),
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
        HomeNutritionBarLong(
          label: "Fiber",
          progress: context.watch<UserNutritionData>().fiber,
          goal: context.watch<UserNutritionData>().fiberGoal,

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
        HomeNutritionBarLong(
          label: "Sugars",
          progress: context.watch<UserNutritionData>().sugar,
          goal: context.watch<UserNutritionData>().sugarGoal,

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
        HomeNutritionBarLong(
          label: "Saturated Fat",
          progress: context.watch<UserNutritionData>().saturatedFat,
          goal: context.watch<UserNutritionData>().saturatedFatGoal,

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
        HomeNutritionBarLong(
          label: "Polyunsaturated Fat",
          progress:
          context.watch<UserNutritionData>().polyUnsaturatedFat,
          goal: context.watch<UserNutritionData>().polyUnsaturatedFatGoal,

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
        HomeNutritionBarLong(
          label: "Monounsaturated Fat",
          progress:
          context.watch<UserNutritionData>().monoUnsaturatedFat,
          goal: context.watch<UserNutritionData>().monoUnsaturatedFatGoal,

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
        HomeNutritionBarLong(
          label: "Trans Fat",
          progress: context.watch<UserNutritionData>().transFat,
          goal: context.watch<UserNutritionData>().transFatGoal,

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
        HomeNutritionBarLong(
          label: "Cholesterol",
          progress: context.watch<UserNutritionData>().cholesterol,
          goal: context.watch<UserNutritionData>().cholesterolGoal,

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
        HomeNutritionBarLong(
          label: "Caffeine",
          progress: context.watch<UserNutritionData>().caffeine,
          goal: context.watch<UserNutritionData>().caffeineGoal,
          units: "mg",

          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Alcohol",
          progress: context.watch<UserNutritionData>().alcohol,
          goal: context.watch<UserNutritionData>().alcoholGoal,

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
        HomeNutritionBarLong(
          label: "Salt",
          progress: context.watch<UserNutritionData>().sodium,
          goal: context.watch<UserNutritionData>().sodiumGoal,

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
        HomeNutritionBarLong(
          label: "Magnesium",
          progress: context.watch<UserNutritionData>().magnesium,
          goal: context.watch<UserNutritionData>().magnesiumGoal,

          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Potassium",
          progress: context.watch<UserNutritionData>().potassium,
          goal: context.watch<UserNutritionData>().potassiumGoal,

          excludeColourChange: false,
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Iron",
          progress: context.watch<UserNutritionData>().iron,
          goal: context.watch<UserNutritionData>().ironGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Zinc",
          progress: context.watch<UserNutritionData>().zinc,
          goal: context.watch<UserNutritionData>().zincGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Calcium",
          progress: context.watch<UserNutritionData>().calcium,
          goal: context.watch<UserNutritionData>().calciumGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Selenium",
          progress: context.watch<UserNutritionData>().selenium,
          goal: context.watch<UserNutritionData>().seleniumGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Chloride",
          progress: context.watch<UserNutritionData>().chloride,
          goal: context.watch<UserNutritionData>().chlorideGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Chromium",
          progress: context.watch<UserNutritionData>().chromium,
          goal: context.watch<UserNutritionData>().chromiumGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Copper",
          progress: context.watch<UserNutritionData>().copper,
          goal: context.watch<UserNutritionData>().copperGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Fluoride",
          progress: context.watch<UserNutritionData>().fluoride,
          goal: context.watch<UserNutritionData>().fluorideGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Iodine",
          progress: context.watch<UserNutritionData>().iodine,
          goal: context.watch<UserNutritionData>().iodineGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Manganese",
          progress: context.watch<UserNutritionData>().manganese,
          goal: context.watch<UserNutritionData>().manganeseGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Molybdenum",
          progress: context.watch<UserNutritionData>().molybdenum,
          goal: context.watch<UserNutritionData>().molybdenumGoal,

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
        HomeNutritionBarLong(
          label: "Vitamin A",
          progress: context.watch<UserNutritionData>().vitaminA,
          goal: context.watch<UserNutritionData>().vitaminAGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin B1",
          progress: context.watch<UserNutritionData>().vitaminB1,
          goal: context.watch<UserNutritionData>().vitaminB1Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin B2",
          progress: context.watch<UserNutritionData>().vitaminB2,
          goal: context.watch<UserNutritionData>().vitaminB2Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Niacin",
          progress: context.watch<UserNutritionData>().vitaminB3,
          goal: context.watch<UserNutritionData>().vitaminB3Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin B6",
          progress: context.watch<UserNutritionData>().vitaminB6,
          goal: context.watch<UserNutritionData>().vitaminB6Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Biotin",
          progress: context.watch<UserNutritionData>().biotin,
          goal: context.watch<UserNutritionData>().biotinGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Folic Acid (B9)",
          progress: context.watch<UserNutritionData>().vitaminB9,
          goal: context.watch<UserNutritionData>().vitaminB9Goal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin B12",
          progress: context.watch<UserNutritionData>().vitaminB12,
          goal: context.watch<UserNutritionData>().vitaminB12Goal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin C",
          progress: context.watch<UserNutritionData>().vitaminC,
          goal: context.watch<UserNutritionData>().vitaminCGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin D",
          progress: context.watch<UserNutritionData>().vitaminD,
          goal: context.watch<UserNutritionData>().vitaminDGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin E",
          progress: context.watch<UserNutritionData>().vitaminE,
          goal: context.watch<UserNutritionData>().vitaminEGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Vitamin K",
          progress: context.watch<UserNutritionData>().vitaminK,
          goal: context.watch<UserNutritionData>().vitaminKGoal,

          units: "μg",
        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Omega-3",
          progress: context.watch<UserNutritionData>().omega3,
          goal: context.watch<UserNutritionData>().omega3Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Omega-6",
          progress: context.watch<UserNutritionData>().omega6,
          goal: context.watch<UserNutritionData>().omega6Goal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Butyric Acid",
          progress: context.watch<UserNutritionData>().butyricAcid,
          goal: context.watch<UserNutritionData>().butyricAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Capric Acid",
          progress: context.watch<UserNutritionData>().capricAcid,
          goal: context.watch<UserNutritionData>().capricAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Caproic Acid",
          progress: context.watch<UserNutritionData>().caproicAcid,
          goal: context.watch<UserNutritionData>().caproicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Caprylic Acid",
          progress: context.watch<UserNutritionData>().caprylicAcid,
          goal: context.watch<UserNutritionData>().caprylicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Docosahexaenoic Acid",
          progress:
          context.watch<UserNutritionData>().docosahexaenoicAcid,
          goal: context.watch<UserNutritionData>().docosahexaenoicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Eicosapentaenoic Acid",
          progress:
          context.watch<UserNutritionData>().eicosapentaenoicAcid,
          goal: context.watch<UserNutritionData>().eicosapentaenoicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Erucic Acid",
          progress: context.watch<UserNutritionData>().erucicAcid,
          goal: context.watch<UserNutritionData>().erucicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Myristic Acid",
          progress: context.watch<UserNutritionData>().myristicAcid,
          goal: context.watch<UserNutritionData>().myristicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Oleic Acid",
          progress: context.watch<UserNutritionData>().oleicAcid,
          goal: context.watch<UserNutritionData>().oleicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Palmitic Acid",
          progress: context.watch<UserNutritionData>().palmiticAcid,
          goal: context.watch<UserNutritionData>().palmiticAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Pantothenic Acid",
          progress: context.watch<UserNutritionData>().pantothenicAcid,
          goal: context.watch<UserNutritionData>().pantothenicAcidGoal,

        ),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: appPrimaryColour),
            ),
          ),
        ),
        HomeNutritionBarLong(
          label: "Stearic Acid",
          progress: context.watch<UserNutritionData>().stearicAcid,
          goal: context.watch<UserNutritionData>().stearicAcidGoal,

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