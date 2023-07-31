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

class FoodRecipeNew extends StatefulWidget {
  const FoodRecipeNew({Key? key, required this.category})
      : super(key: key);
  final String category;

  @override
  State<FoodRecipeNew> createState() => _FoodRecipeNewState();
}

class _FoodRecipeNewState extends State<FoodRecipeNew> {
  late bool _loading = true;

  late TextEditingController barcodeController = TextEditingController();
  late TextEditingController foodNameController = TextEditingController();
  late TextEditingController quantityController = TextEditingController();
  late TextEditingController servingSizeController = TextEditingController();
  late TextEditingController servingsController = TextEditingController();

  late final barcodeKey = GlobalKey<FormState>();
  late final foodNameKey = GlobalKey<FormState>();
  late final quanityKey = GlobalKey<FormState>();
  late final servingSizekey = GlobalKey<FormState>();
  late final servingskey = GlobalKey<FormState>();


  late final UserRecipesModel currentRecipe;


  @override
  void initState() {

    currentRecipe = context.read<UserNutritionData>().currentRecipe;

    barcodeController.text = barcodeController.text = const Uuid().v4();

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
              height: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.73 : _height * 0.43,
              child: Column(
                children: [
                  FoodNutritionListFormField(
                    controller: foodNameController,
                    formKey: foodNameKey,
                    width: _width,
                    formName: "Name",
                    numbersOnly: false,
                    centerForm: true,
                  ),
                  FoodNutritionListFormField(
                    controller: servingsController,
                    formKey: servingskey,
                    width: _width,
                    formName: "Servings",
                    numbersOnly: true,
                    centerForm: true,
                  ),
                  FoodNutritionListFormField(
                    controller: servingSizeController,
                    formKey: servingSizekey,
                    width: _width,
                    formName: "Serving Size",
                    numbersOnly: true,
                    centerForm: true,
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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.18 : _height * 0.18),
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
                              onTap: () => context.read<PageChange>().changePageCache(const FoodRecipeSearchPage()),
                              buttonText: "Add Ingredients",
                            ),
                          ),
                        )
                      ],
                    )
                  ) : SizedBox(
                    ///Overflowing parent constraints. Adding constraints here for now.
                    height: MediaQuery.of(context).devicePixelRatio < 3 ? _height * 0.54 : _height * 0.43,
                    child: ListView.builder(
                      itemCount: context.watch<UserNutritionData>().currentRecipe.recipeFoodList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return FoodListDisplayBox(
                          key: UniqueKey(),
                          width: MediaQuery.of(context).size.width,
                          foodObject: currentRecipe.recipeFoodList[index],
                          icon: Icons.delete,
                          iconColour: Colors.red,
                          onTapIcon: () => context.read<UserNutritionData>().removeFoodItemFromRecipe(index),
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
                  onTap: () => context.read<PageChange>().changePageCache(const FoodRecipeSearchPage()),
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
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}