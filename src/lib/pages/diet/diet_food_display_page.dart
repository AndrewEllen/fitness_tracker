import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/database_get.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/diet/diet_list_header_box.dart';
import '../../widgets/diet/food_nutrition_list_formfield.dart';
import '../../widgets/general/incremental_counter.dart';
import '../diet_new/diet_home.dart';
import 'diet_recipe_creator.dart';
import 'food_nutrition_list_edit.dart';
import '../../widgets/diet/food_nutrition_list_text.dart';

class FoodDisplayPage extends StatefulWidget {
  const FoodDisplayPage({Key? key, required this.category, this.editDiary = false, this.index = 0, this.recipe = false, this.recipeEdit = false}) : super(key: key);
  final String category;
  final bool editDiary, recipe, recipeEdit;
  final int index;

  @override
  State<FoodDisplayPage> createState() => _FoodDisplayPageState();
}

class _FoodDisplayPageState extends State<FoodDisplayPage> {

  late FoodItem currentFoodItem;
  late ListFoodItem currentFoodListItem;
  late TextEditingController servingSizeController = TextEditingController();
  late TextEditingController servingsController = TextEditingController();

  late final servingSizekey = GlobalKey<FormState>();
  late final servingskey = GlobalKey<FormState>();

  void loadFoodItemsInRecipe() async {

    UserRecipesModel recipe = await GetFoodDataFromFirebaseRecipe(currentFoodItem.barcode);
    context.read<UserNutritionData>().setCurrentRecipe(recipe);
    context.read<UserNutritionData>().setCurrentRecipeFood(await GetRecipeFoodList(recipe.recipeFoodList));

    context.read<PageChange>().changePageCache(FoodRecipeCreator(category: widget.category, editDiary: widget.editDiary,));
  }

  @override
  void initState() {

    InitializeControllers();
    super.initState();
  }

  @override
  void dispose() {
    servingsController.dispose();
    servingSizeController.dispose();
    super.dispose();
  }

  void InitializeControllers() {

    currentFoodItem = context.read<UserNutritionData>().currentFoodItem;

    currentFoodListItem = context.read<UserNutritionData>().currentFoodListItem;


    servingSizeController.text = currentFoodListItem.foodServingSize;

    servingsController.text = currentFoodListItem.foodServings;

  }

  void AddToRecipe() {

    if (widget.editDiary && currentFoodItem.foodName.isNotEmpty &&
        currentFoodItem.calories != "-" && currentFoodItem.calories.isNotEmpty &&
        (servingsController.text != "-" && servingsController.text.isNotEmpty) &&
        (servingSizeController.text != "-" && servingSizeController.text.isNotEmpty)
    ) {

      print("editing");

      context.read<UserNutritionData>().editFoodItemInRecipe(
        currentFoodItem,
        widget.category,
        servingsController.text,
        servingSizeController.text,
        widget.index,
        currentFoodItem.recipe,
      );

      context.read<PageChange>().changePageCache(FoodRecipeCreator(category: widget.category, editDiary: widget.editDiary,));

    } else if (currentFoodItem.foodName.isNotEmpty &&
        currentFoodItem.calories != "-" && currentFoodItem.calories.isNotEmpty &&
        (servingsController.text != "-" && servingsController.text.isNotEmpty) &&
        (servingSizeController.text != "-" && servingSizeController.text.isNotEmpty)
    ) {

      context.read<UserNutritionData>().addFoodItemToRecipe(
        currentFoodItem,
        widget.category,
        servingsController.text,
        servingSizeController.text,
        currentFoodItem.recipe,
      );

      context.read<PageChange>().changePageCache(FoodRecipeCreator(category: widget.category, editDiary: widget.editDiary,));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Missing Food Name, Servings or Calories",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        action: SnackBarAction(
          label: "Edit",
          onPressed: () => context.read<PageChange>().changePageCache(FoodNutritionListEdit(category: widget.category)),
        ),
      ));
    }

  }

  void AddToDiary() {

    servingsController.text = double.tryParse(servingsController.text) == null ? "0" : servingsController.text;
    servingSizeController.text = double.tryParse(servingSizeController.text) == null ? "0" : servingSizeController.text;

      if (widget.editDiary && currentFoodItem.foodName.isNotEmpty &&
          currentFoodItem.calories != "-" && currentFoodItem.calories.isNotEmpty &&
          (servingsController.text != "-" && servingsController.text.isNotEmpty) &&
          (servingSizeController.text != "-" && servingSizeController.text.isNotEmpty)
      ) {

        print("editing");

        context.read<UserNutritionData>().editFoodItemInDiary(
          currentFoodItem,
          widget.category,
          servingsController.text,
          servingSizeController.text,
          widget.index,
          currentFoodItem.recipe,
        );

        context.read<UserNutritionData>().updateFoodHistory(
          currentFoodItem.barcode,
          currentFoodItem.foodName,
          servingsController.text,
          servingSizeController.text,
          currentFoodItem.recipe,
        );

        context.read<UserNutritionData>().resetCurrentRecipe();
        context.read<PageChange>().changePageClearCache(DietHomePage());

      } else if (currentFoodItem.foodName.isNotEmpty &&
        currentFoodItem.calories != "-" && currentFoodItem.calories.isNotEmpty &&
        (servingsController.text != "-" && servingsController.text.isNotEmpty) &&
        (servingSizeController.text != "-" && servingSizeController.text.isNotEmpty)
        ) {

      context.read<UserNutritionData>().addFoodItemToDiary(
        currentFoodItem,
        widget.category,
        servingsController.text,
        servingSizeController.text,
        currentFoodItem.recipe,
      );

      context.read<UserNutritionData>().updateFoodHistory(
        currentFoodItem.barcode,
        currentFoodItem.foodName,
        servingsController.text,
        servingSizeController.text,
        currentFoodItem.recipe,
      );

      context.read<UserNutritionData>().resetCurrentRecipe();
      context.read<PageChange>().changePageClearCache(DietHomePage());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Missing Food Name, Servings or Calories",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        action: SnackBarAction(
          label: "Edit",
          onPressed: () => context.read<PageChange>().changePageCache(FoodNutritionListEdit(category: widget.category)),
        ),
      ));
    }
  }

  void SaveServings() {

    servingsController.text = double.tryParse(servingsController.text) == null ? "0" : servingsController.text;
    servingSizeController.text = double.tryParse(servingSizeController.text) == null ? "0" : servingSizeController.text;

    print(servingsController.text);
    print(servingSizeController.text);

    if (currentFoodItem.recipe) {
      context.read<UserNutritionData>().updateRecipeServings(servingsController.text);
    }
    context.read<UserNutritionData>().updateCurrentFoodItemServings(servingsController.text);
    context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSizeController.text);
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().currentFoodItem;

    InitializeControllers();

    double _margin = 15;
    double _bigContainerMin = 230.h;
    double _smallContainerMin = 95.h;
    double _height = 851.h;
    double _width = 393.w;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
          child: ListView(
          children: [
          ScreenWidthContainer(
            minHeight: _bigContainerMin,
            maxHeight: _bigContainerMin*4,
            height: _height * 0.38,
            margin: 0,
            child: ListView(
              children: [
                DietListHeaderBox(
                  width: _width,
                  title: currentFoodItem.foodName,
                  largeTitle: true,
                  color: Colors.white,
                ),

                IncrementalCounter(
                  inputController: servingsController,
                  suffix: '',
                  label: 'No. Of Servings*',
                  smallButtons: true,
                  function: () => SaveServings(),
                  bigIncrementAmount: 1,
                  smallIncrementAmount: 0.5,
                ),
                IncrementalCounter(
                  inputController: servingSizeController,
                  suffix: '',
                  label: 'Weight of Serving*',
                  smallButtons: true,
                  function: () => SaveServings(),
                  bigIncrementAmount: 10,
                  smallIncrementAmount: 1,
                ),

                Padding(
                  padding: EdgeInsets.all(_height/120),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: appSecondaryColour,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: currentFoodItem.barcode));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Copied Code To Clipboard!"),
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
                      },
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              "Tap to Copy Code:",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              currentFoodItem.barcode,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(_height/120),
                  child: ScreenWidthContainer(
                    minHeight: _smallContainerMin * 0.2,
                    maxHeight: _smallContainerMin * 1.5,
                    height: (_height / 100) * 4.8,
                    customMargin: true,
                    left: 6,
                    right: 6,
                    child: FractionallySizedBox(
                      heightFactor: 1,
                      widthFactor: 1,
                      child: AppButton(
                        buttonText: widget.recipe ? "Add to Recipe" : "Add to Diary",
                        onTap: widget.recipe ? AddToRecipe : AddToDiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ScreenWidthContainer(
            minHeight: _bigContainerMin/2,
            maxHeight: _bigContainerMin*4,
            height: _height * 0.53,
            margin: _margin,
            child: ListView(
              children: [
                SizedBox(
                  width: _width/2,
                  height: 40.h,
                  child: Stack(
                    children: [
                      DietListHeaderBox(
                        width: _width,
                        title: "Values per 100g ${servingSizeController.text.isEmpty || servingsController.text.isEmpty ? "" : "/ " + (double.parse(servingSizeController.text) * double.parse(servingsController.text)).toStringAsFixed(1) + "g"}",
                        largeTitle: true,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Material(
                            type: MaterialType.transparency,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: IconButton(
                              icon: const Icon(
                                  Icons.edit
                              ),
                              onPressed: () => widget.recipeEdit ? loadFoodItemsInRecipe() : context.read<PageChange>().changePageCache(FoodNutritionListEdit(category: widget.category)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                DietListHeaderBox(
                  width: _width,
                  title: "Calories and Macro Nutrients",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: caloriesController,
                  value: currentFoodItem.calories,
                  width: _width,
                  title: "Calories",
                  units: "Kcal",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: proteinsController,
                  value: currentFoodItem.proteins,
                  width: _width,
                  title: "Protein",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: carbsController,
                  value: currentFoodItem.carbs,
                  width: _width,
                  title: "Carbohydrates",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: fatController,
                  value: currentFoodItem.fat,
                  width: _width,
                  title: "Fat",
                  units: "g",
                ),

                DietListHeaderBox(
                  width: _width,
                  title: "Carbohydrates and Fats",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: fiberController,
                  value: currentFoodItem.fiber,
                  width: _width,
                  title: "Fiber",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: sugarsController,
                  value: currentFoodItem.sugars,
                  width: _width,
                  title: "Sugars",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: saturatedFatController,
                  value: currentFoodItem.saturatedFat,
                  width: _width,
                  title: "Saturated Fat",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: polyUnsaturatedFatController,
                  value: currentFoodItem.polyUnsaturatedFat,
                  width: _width,
                  title: "Polyunsaturated Fat",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: monoUnsaturatedFatController,
                  value: currentFoodItem.monoUnsaturatedFat,
                  width: _width,
                  title: "Monounsaturated Fat",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: transFatController,
                  value: currentFoodItem.transFat,
                  width: _width,
                  title: "Trans Fat",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: cholesterolController,
                  value: currentFoodItem.cholesterol,
                  width: _width,
                  title: "Cholesterol",
                  units: "mg",
                ),

                DietListHeaderBox(
                  width: _width,
                  title: "Caffeine and Alcohol",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: caffeineController,
                  value: currentFoodItem.caffeine,
                  width: _width,
                  title: "Caffeine",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: alcoholController,
                  value: currentFoodItem.alcohol,
                  width: _width,
                  title: "Alcohol",
                  units: "g",
                ),

                DietListHeaderBox(
                  width: _width,
                  title: "Minerals",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: sodiumController,
                  value: currentFoodItem.sodium,
                  width: _width,
                  title: "Salt",
                  units: "g",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: magnesiumController,
                  value: currentFoodItem.magnesium,
                  width: _width,
                  title: "Magnesium",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: potassiumController,
                  value: currentFoodItem.potassium,
                  width: _width,
                  title: "Potassium",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: ironController,
                  value: currentFoodItem.iron,
                  width: _width,
                  title: "Iron",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: zincController,
                  value: currentFoodItem.zinc,
                  width: _width,
                  title: "Zinc",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: calciumController,
                  value: currentFoodItem.calcium,
                  width: _width,
                  title: "Calcium",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: seleniumController,
                  value: currentFoodItem.selenium,
                  width: _width,
                  title: "Selenium",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: chlorideController,
                  value: currentFoodItem.chloride,
                  width: _width,
                  title: "Chloride",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: chromiumController,
                  value: currentFoodItem.chromium,
                  width: _width,
                  title: "Chromium",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: copperController,
                  value: currentFoodItem.copper,
                  width: _width,
                  title: "Copper",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: fluorideController,
                  value: currentFoodItem.fluoride,
                  width: _width,
                  title: "Fluoride",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: iodineController,
                  value: currentFoodItem.iodine,
                  width: _width,
                  title: "Iodine",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: manganeseController,
                  value: currentFoodItem.manganese,
                  width: _width,
                  title: "Manganese",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: molybdenumController,
                  value: currentFoodItem.molybdenum,
                  width: _width,
                  title: "Molybdenum",
                  units: "μg",
                ),

                DietListHeaderBox(
                  width: _width,
                  title: "Vitamins and Amino Acids",
                ),

                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminAController,
                  value: currentFoodItem.vitaminA,
                  width: _width,
                  title: "Vitamin A",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB1Controller,
                  value: currentFoodItem.vitaminB1,
                  width: _width,
                  title: "Vitamin B1",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB2Controller,
                  value: currentFoodItem.vitaminB2,
                  width: _width,
                  title: "Vitamin B2",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB3Controller,
                  value: currentFoodItem.vitaminB3,
                  width: _width,
                  title: "Niacin",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB6Controller,
                  value: currentFoodItem.vitaminB6,
                  width: _width,
                  title: "Vitamin B6",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: biotinController,
                  value: currentFoodItem.biotin,
                  width: _width,
                  title: "Biotin",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB9Controller,
                  value: currentFoodItem.vitaminB9,
                  width: _width,
                  title: "Vitamin B9",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminB12Controller,
                  value: currentFoodItem.vitaminB12,
                  width: _width,
                  title: "Vitamin B12",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminCController,
                  value: currentFoodItem.vitaminC,
                  width: _width,
                  title: "Vitamin C",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminDController,
                  value: currentFoodItem.vitaminD,
                  width: _width,
                  title: "Vitamin D",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminEController,
                  value: currentFoodItem.vitaminE,
                  width: _width,
                  title: "Vitamin E",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: vitaminKController,
                  value: currentFoodItem.vitaminK,
                  width: _width,
                  title: "Vitamin K",
                  units: "μg",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: omega3Controller,
                  value: currentFoodItem.omega3,
                  width: _width,
                  title: "Omega3",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: omega6Controller,
                  value: currentFoodItem.omega6,
                  width: _width,
                  title: "Omega6",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: butyricAcidController,
                  value: currentFoodItem.butyricAcid,
                  width: _width,
                  title: "Butyric Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: capricAcidController,
                  value: currentFoodItem.capricAcid,
                  width: _width,
                  title: "Capric Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: caproicAcidController,
                  value: currentFoodItem.caproicAcid,
                  width: _width,
                  title: "Caproic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: caprylicAcidController,
                  value: currentFoodItem.caprylicAcid,
                  width: _width,
                  title: "Caprylic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: docosahexaenoicAcidController,
                  value: currentFoodItem.docosahexaenoicAcid,
                  width: _width,
                  title: "Docosahexaenoic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: eicosapentaenoicAcidController,
                  value: currentFoodItem.eicosapentaenoicAcid,
                  width: _width,
                  title: "Eicosapentaenoic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: erucicAcidController,
                  value: currentFoodItem.erucicAcid,
                  width: _width,
                  title: "Erucic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: myristicAcidController,
                  value: currentFoodItem.myristicAcid,
                  width: _width,
                  title: "Myristic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: oleicAcidController,
                  value: currentFoodItem.oleicAcid,
                  width: _width,
                  title: "Oleic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: palmiticAcidController,
                  value: currentFoodItem.palmiticAcid,
                  width: _width,
                  title: "Palmitic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: pantothenicAcidController,
                  value: currentFoodItem.pantothenicAcid,
                  width: _width,
                  title: "Pantothenic Acid",
                ),
                FoodNutritionListText(
                  servingSize: servingSizeController.text,
                  servings: servingsController.text,
                  //controller: stearicAcidController,
                  value: currentFoodItem.stearicAcid,
                  width: _width,
                  title: "Stearic Acid",
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
