import 'package:fitness_tracker/models/diet/food_data_list_item.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/diet/food_item.dart';
import '../../models/diet/user_recipes_model.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/diet/food_list_item_box.dart';
import '../../widgets/diet/food_nutrition_list_text.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/diet/diet_list_header_box.dart';
import '../../widgets/diet/food_nutrition_list_formfield.dart';
import 'diet_food_display_page.dart';
import 'diet_recipe_food_search.dart';

class FoodRecipeCreator extends StatefulWidget {
  const FoodRecipeCreator({Key? key, required this.category})
      : super(key: key);
  final String category;

  @override
  State<FoodRecipeCreator> createState() => _FoodRecipeCreatorState();
}

class _FoodRecipeCreatorState extends State<FoodRecipeCreator> {
  late bool _loading = true;

  late TextEditingController barcodeController = TextEditingController();
  late TextEditingController foodNameController = TextEditingController();
  late TextEditingController servingsController = TextEditingController();

  late final barcodeKey = GlobalKey<FormState>();
  late final foodNameKey = GlobalKey<FormState>();
  late final servingsKey = GlobalKey<FormState>();


  late final UserRecipesModel currentRecipe;

  void AddToRecipe() {

    if (currentRecipe.foodData.servings.isNotEmpty && currentRecipe.recipeFoodList.isNotEmpty && foodNameController.text.isNotEmpty) {

      print(widget.category);

      context.read<UserNutritionData>().createRecipe(
        foodNameController.text,
        barcodeController.text,
      );

      context.read<UserNutritionData>().setCurrentFoodItem(currentRecipe.foodData);
      context.read<UserNutritionData>().updateCurrentFoodItemServings("1");
      context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipeEdit: true,));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Missing Recipe Name, Servings or Ingredients",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
    }

  }


  editEntry(BuildContext context, int index, String value, double width) {

    double buttonSize = width/17;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Edit Selection",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: RichText(
            text: TextSpan(text: 'Editing: ',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(text: value,
                  style: const TextStyle(
                    color: appSecondaryColour,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
                        context.read<UserNutritionData>().removeFoodItemFromRecipe(index);
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
                      buttonText: "Edit",
                      onTap: () {
                        context.read<UserNutritionData>().setCurrentFoodItem(currentRecipe.recipeFoodList[index].foodItemData);
                        context.read<UserNutritionData>().updateCurrentFoodItemServings(currentRecipe.recipeFoodList[index].foodServings);
                        context.read<UserNutritionData>().updateCurrentFoodItemServingSize(currentRecipe.recipeFoodList[index].foodServingSize);

                        context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, editDiary: true, index: index, recipe: true,));

                        Navigator.pop(context);
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
  void initState() {

    currentRecipe = context.read<UserNutritionData>().currentRecipe;

    if (currentRecipe.barcode.isEmpty) {
      barcodeController.text = barcodeController.text = const Uuid().v4();
    } else {
      barcodeController.text = currentRecipe.barcode;
    }

    foodNameController.text = currentRecipe.foodData.foodName;
    servingsController.text = currentRecipe.foodData.servings;

    _loading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double _margin = 15;
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
        child: _loading
            ? const Text("Place holder")
            : ListView(
          children: [
            ScreenWidthContainer(
              minHeight: 100,
              maxHeight: 820,
              height: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.73 : _height * 0.68,
              child: Column(
                children: [
                  FoodNutritionListFormField(
                    controller: foodNameController,
                    formKey: foodNameKey,
                    width: _width,
                    formName: "Name",
                    numbersOnly: false,
                    centerForm: true,
                    name: true,
                    noUnits: true,
                  ),
                  FoodNutritionListFormField(
                    controller: servingsController,
                    formKey: servingsKey,
                    width: _width,
                    formName: "Servings",
                    servings: true,
                    recipe: true,
                    numbersOnly: true,
                    centerForm: true,
                    noUnits: true,
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title:
                    (currentRecipe.recipeFoodList.isNotEmpty & currentRecipe.foodData.servings.isNotEmpty & (currentRecipe.foodData.servings != "0")) ?
                    (((double.parse(currentRecipe.foodData.calories)/100)*double.parse(currentRecipe.foodData.quantity))/ double.parse(servingsController.text)).toStringAsFixed(0)
                        + "Kcal/${currentRecipe.foodData.quantity}g"
                        : (currentRecipe.foodData.servings.isNotEmpty) ? "No Ingredients" : "Number of Servings Empty",
                    largeTitle: true,
                    color: Colors.white,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: appPrimaryColour,
                          width: 5,
                        )
                      )
                    ),
                  ),
                  currentRecipe.recipeFoodList.isEmpty ? Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.18 : _height * 0.07),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.no_food,
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "No Ingredients Added",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Text(
                            "Add an ingredient to get started.",
                            style: TextStyle(
                              color: appQuarternaryColour,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            height: 25,
                            child: AppButton(
                              onTap: () => context.read<PageChange>().changePageCache(FoodRecipeSearchPage(category: widget.category,)),
                              buttonText: "Add Ingredients",
                            ),
                          ),
                        )
                      ],
                    )
                  ) : SizedBox(
                    ///Overflowing parent constraints. Adding constraints here for now.
                    height: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.55 : _height * 0.43,
                    child: ListView.builder(
                      itemCount: context.watch<UserNutritionData>().currentRecipe.recipeFoodList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return FoodListDisplayBox(
                          key: UniqueKey(),
                          width: _width,
                          foodObject: context.read<UserNutritionData>().currentRecipe.recipeFoodList[index],
                          icon: MdiIcons.squareEditOutline,
                          iconColour: Colors.white,
                          onTapIcon: () => editEntry(
                            this.context,
                            index,
                            context.read<UserNutritionData>().currentRecipe.recipeFoodList[index].foodItemData.foodName,
                            _width,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            ScreenWidthContainer(
              minHeight: _smallContainerMin * 0.2,
              maxHeight: _smallContainerMin * 1.5,
              height: (_height / 100) * 6,
              margin: _margin / 1.5,
              child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 1,
                child: AppButton(
                  buttonText: "Add Ingredient",
                  onTap: () {
                    currentRecipe.foodData.foodName = foodNameController.text;
                    context.read<PageChange>().changePageCache(FoodRecipeSearchPage(category: widget.category,));
                  }
                ),
              ),
            ),
            ScreenWidthContainer(
              minHeight: _smallContainerMin * 0.2,
              maxHeight: _smallContainerMin * 1.5,
              height: (_height / 100) * 6,
              margin: _margin / 1.5,
              child: FractionallySizedBox(
                heightFactor: 1,
                widthFactor: 1,
                child: AppButton(
                  buttonText: "Next",
                  onTap: AddToRecipe,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}