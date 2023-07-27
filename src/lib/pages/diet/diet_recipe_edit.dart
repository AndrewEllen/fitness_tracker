import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/diet/food_nutrition_list_text.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/diet/diet_list_header_box.dart';
import '../../widgets/diet/food_nutrition_list_formfield.dart';
import 'diet_food_display_page.dart';

class FoodRecipeEdit extends StatefulWidget {
  const FoodRecipeEdit({Key? key, required this.category, this.newRecipe = false})
      : super(key: key);
  final String category;
  final bool newRecipe;

  @override
  State<FoodRecipeEdit> createState() => _FoodRecipeEditState();
}

class _FoodRecipeEditState extends State<FoodRecipeEdit> {
  late bool _loading = true;

  late FoodItem currentFoodItem = FoodItem(
    barcode: "1",
    foodName: "a",
    quantity: "1",
    servingSize: "100",
    servings: "1",
    calories: "1",
    kiloJoules: "1",
    proteins: "1",
    carbs: "1",
    fiber: "1",
    sugars: "1",
    fat: "1",
    saturatedFat: "1",
    polyUnsaturatedFat: "1",
    monoUnsaturatedFat: "1",
    transFat: "1",
    cholesterol: "1",
    calcium: "1",
    iron: "1",
    sodium: "1",
    zinc: "1",
    magnesium: "1",
    potassium: "1",
    vitaminA: "1",
    vitaminB1: "1",
    vitaminB2: "1",
    vitaminB3: "1",
    vitaminB6: "1",
    vitaminB9: "1",
    vitaminB12: "1",
    vitaminC: "1",
    vitaminD: "1",
    vitaminE: "1",
    vitaminK: "1",
    omega3: "1",
    omega6: "1",
    alcohol: "1",
    biotin: "1",
    butyricAcid: "1",
    caffeine: "1",
    capricAcid: "1",
    caproicAcid: "1",
    caprylicAcid: "1",
    chloride: "1",
    chromium: "1",
    copper: "1",
    docosahexaenoicAcid: "1",
    eicosapentaenoicAcid: "1",
    erucicAcid: "1",
    fluoride: "1",
    iodine: "1",
    manganese: "1",
    molybdenum: "1",
    myristicAcid: "1",
    oleicAcid: "1",
    palmiticAcid: "1",
    pantothenicAcid: "1",
    selenium: "1",
    stearicAcid: "1",
  );

  late TextEditingController barcodeController = TextEditingController();
  late TextEditingController foodNameController = TextEditingController();
  late TextEditingController quantityController = TextEditingController();
  late TextEditingController servingSizeController = TextEditingController();
  late TextEditingController servingsController = TextEditingController();
  late TextEditingController caloriesController = TextEditingController();
  late TextEditingController kiloJoulesController = TextEditingController();
  late TextEditingController proteinsController = TextEditingController();
  late TextEditingController carbsController = TextEditingController();
  late TextEditingController fiberController = TextEditingController();
  late TextEditingController sugarsController = TextEditingController();
  late TextEditingController fatController = TextEditingController();
  late TextEditingController saturatedFatController = TextEditingController();
  late TextEditingController polyUnsaturatedFatController =
      TextEditingController();
  late TextEditingController monoUnsaturatedFatController =
      TextEditingController();
  late TextEditingController transFatController = TextEditingController();
  late TextEditingController cholesterolController = TextEditingController();
  late TextEditingController calciumController = TextEditingController();
  late TextEditingController ironController = TextEditingController();
  late TextEditingController sodiumController = TextEditingController();
  late TextEditingController zincController = TextEditingController();
  late TextEditingController magnesiumController = TextEditingController();
  late TextEditingController potassiumController = TextEditingController();
  late TextEditingController vitaminAController = TextEditingController();
  late TextEditingController vitaminB1Controller = TextEditingController();
  late TextEditingController vitaminB2Controller = TextEditingController();
  late TextEditingController vitaminB3Controller = TextEditingController();
  late TextEditingController vitaminB6Controller = TextEditingController();
  late TextEditingController vitaminB9Controller = TextEditingController();
  late TextEditingController vitaminB12Controller = TextEditingController();
  late TextEditingController vitaminCController = TextEditingController();
  late TextEditingController vitaminDController = TextEditingController();
  late TextEditingController vitaminEController = TextEditingController();
  late TextEditingController vitaminKController = TextEditingController();
  late TextEditingController omega3Controller = TextEditingController();
  late TextEditingController omega6Controller = TextEditingController();
  late TextEditingController alcoholController = TextEditingController();
  late TextEditingController biotinController = TextEditingController();
  late TextEditingController butyricAcidController = TextEditingController();
  late TextEditingController caffeineController = TextEditingController();
  late TextEditingController capricAcidController = TextEditingController();
  late TextEditingController caproicAcidController = TextEditingController();
  late TextEditingController caprylicAcidController = TextEditingController();
  late TextEditingController chlorideController = TextEditingController();
  late TextEditingController chromiumController = TextEditingController();
  late TextEditingController copperController = TextEditingController();
  late TextEditingController docosahexaenoicAcidController =
      TextEditingController();
  late TextEditingController eicosapentaenoicAcidController =
      TextEditingController();
  late TextEditingController erucicAcidController = TextEditingController();
  late TextEditingController fluorideController = TextEditingController();
  late TextEditingController iodineController = TextEditingController();
  late TextEditingController manganeseController = TextEditingController();
  late TextEditingController molybdenumController = TextEditingController();
  late TextEditingController myristicAcidController = TextEditingController();
  late TextEditingController oleicAcidController = TextEditingController();
  late TextEditingController palmiticAcidController = TextEditingController();
  late TextEditingController pantothenicAcidController =
      TextEditingController();
  late TextEditingController seleniumController = TextEditingController();
  late TextEditingController stearicAcidController = TextEditingController();

  late final barcodeKey = GlobalKey<FormState>();
  late final foodNameKey = GlobalKey<FormState>();
  late final quanityKey = GlobalKey<FormState>();
  late final servingSizekey = GlobalKey<FormState>();
  late final servingskey = GlobalKey<FormState>();
  late final caloriesKey = GlobalKey<FormState>();
  late final kiloJoulesKey = GlobalKey<FormState>();
  late final proteinsKey = GlobalKey<FormState>();
  late final carbsKey = GlobalKey<FormState>();
  late final fiberKey = GlobalKey<FormState>();
  late final sugarsKey = GlobalKey<FormState>();
  late final fatKey = GlobalKey<FormState>();
  late final saturatedFatKey = GlobalKey<FormState>();
  late final polyUnsaturatedFatKey = GlobalKey<FormState>();
  late final monoUnsaturatedFatKey = GlobalKey<FormState>();
  late final transFatKey = GlobalKey<FormState>();
  late final cholesterolKey = GlobalKey<FormState>();
  late final calciumKey = GlobalKey<FormState>();
  late final ironKey = GlobalKey<FormState>();
  late final sodiumKey = GlobalKey<FormState>();
  late final zincKey = GlobalKey<FormState>();
  late final magnesiumKey = GlobalKey<FormState>();
  late final potassiumKey = GlobalKey<FormState>();
  late final vitaminAKey = GlobalKey<FormState>();
  late final vitaminB1Key = GlobalKey<FormState>();
  late final vitaminB2Key = GlobalKey<FormState>();
  late final vitaminB3Key = GlobalKey<FormState>();
  late final vitaminB6Key = GlobalKey<FormState>();
  late final vitaminB9Key = GlobalKey<FormState>();
  late final vitaminB12Key = GlobalKey<FormState>();
  late final vitaminCKey = GlobalKey<FormState>();
  late final vitaminDKey = GlobalKey<FormState>();
  late final vitaminEKey = GlobalKey<FormState>();
  late final vitaminKKey = GlobalKey<FormState>();
  late final omega3Key = GlobalKey<FormState>();
  late final omega6Key = GlobalKey<FormState>();
  late final alcoholKey = GlobalKey<FormState>();
  late final biotinKey = GlobalKey<FormState>();
  late final butyricAcidKey = GlobalKey<FormState>();
  late final caffeineKey = GlobalKey<FormState>();
  late final capricAcidKey = GlobalKey<FormState>();
  late final caproicAcidKey = GlobalKey<FormState>();
  late final caprylicAcidKey = GlobalKey<FormState>();
  late final chlorideKey = GlobalKey<FormState>();
  late final chromiumKey = GlobalKey<FormState>();
  late final copperKey = GlobalKey<FormState>();
  late final docosahexaenoicAcidKey = GlobalKey<FormState>();
  late final eicosapentaenoicAcidKey = GlobalKey<FormState>();
  late final erucicAcidKey = GlobalKey<FormState>();
  late final fluorideKey = GlobalKey<FormState>();
  late final iodineKey = GlobalKey<FormState>();
  late final manganeseKey = GlobalKey<FormState>();
  late final molybdenumKey = GlobalKey<FormState>();
  late final myristicAcidKey = GlobalKey<FormState>();
  late final oleicAcidKey = GlobalKey<FormState>();
  late final palmiticAcidKey = GlobalKey<FormState>();
  late final pantothenicAcidKey = GlobalKey<FormState>();
  late final seleniumKey = GlobalKey<FormState>();
  late final stearicAcidKey = GlobalKey<FormState>();

  @override
  void initState() {
    SetControllerValues();

    _loading = false;

    super.initState();
  }

  void SetControllerValues() {
    if (widget.newRecipe) {
      barcodeController.text = const Uuid().v4();
    } else {
      barcodeController.text = currentFoodItem.barcode;
    }

    foodNameController.text = currentFoodItem.foodName;
    quantityController.text = currentFoodItem.quantity;
    servingSizeController.text = currentFoodItem.servingSize;
    servingsController.text = currentFoodItem.servings;
    caloriesController.text = currentFoodItem.calories;
    kiloJoulesController.text = currentFoodItem.kiloJoules;
    proteinsController.text = currentFoodItem.proteins;
    carbsController.text = currentFoodItem.carbs;
    fiberController.text = currentFoodItem.fiber;
    sugarsController.text = currentFoodItem.sugars;
    fatController.text = currentFoodItem.fat;
    saturatedFatController.text = currentFoodItem.saturatedFat;
    polyUnsaturatedFatController.text = currentFoodItem.polyUnsaturatedFat;
    monoUnsaturatedFatController.text = currentFoodItem.monoUnsaturatedFat;
    transFatController.text = currentFoodItem.transFat;
    cholesterolController.text = currentFoodItem.cholesterol;
    calciumController.text = currentFoodItem.calcium;
    ironController.text = currentFoodItem.iron;
    sodiumController.text = currentFoodItem.sodium;
    zincController.text = currentFoodItem.zinc;
    magnesiumController.text = currentFoodItem.magnesium;
    potassiumController.text = currentFoodItem.potassium;
    vitaminAController.text = currentFoodItem.vitaminA;
    vitaminB1Controller.text = currentFoodItem.vitaminB1;
    vitaminB2Controller.text = currentFoodItem.vitaminB2;
    vitaminB3Controller.text = currentFoodItem.vitaminB3;
    vitaminB6Controller.text = currentFoodItem.vitaminB6;
    vitaminB9Controller.text = currentFoodItem.vitaminB9;
    vitaminB12Controller.text = currentFoodItem.vitaminB12;
    vitaminCController.text = currentFoodItem.vitaminC;
    vitaminDController.text = currentFoodItem.vitaminD;
    vitaminEController.text = currentFoodItem.vitaminE;
    vitaminKController.text = currentFoodItem.vitaminK;
    omega3Controller.text = currentFoodItem.omega3;
    omega6Controller.text = currentFoodItem.omega6;
    alcoholController.text = currentFoodItem.alcohol;
    biotinController.text = currentFoodItem.biotin;
    butyricAcidController.text = currentFoodItem.butyricAcid;
    caffeineController.text = currentFoodItem.caffeine;
    capricAcidController.text = currentFoodItem.capricAcid;
    caproicAcidController.text = currentFoodItem.caproicAcid;
    caprylicAcidController.text = currentFoodItem.caprylicAcid;
    chlorideController.text = currentFoodItem.chloride;
    chromiumController.text = currentFoodItem.chromium;
    copperController.text = currentFoodItem.copper;
    docosahexaenoicAcidController.text = currentFoodItem.docosahexaenoicAcid;
    eicosapentaenoicAcidController.text = currentFoodItem.eicosapentaenoicAcid;
    erucicAcidController.text = currentFoodItem.erucicAcid;
    fluorideController.text = currentFoodItem.fluoride;
    iodineController.text = currentFoodItem.iodine;
    manganeseController.text = currentFoodItem.manganese;
    molybdenumController.text = currentFoodItem.molybdenum;
    myristicAcidController.text = currentFoodItem.myristicAcid;
    oleicAcidController.text = currentFoodItem.oleicAcid;
    palmiticAcidController.text = currentFoodItem.palmiticAcid;
    pantothenicAcidController.text = currentFoodItem.pantothenicAcid;
    seleniumController.text = currentFoodItem.selenium;
    stearicAcidController.text = currentFoodItem.stearicAcid;
  }

  void SaveFoodItem() {

    if (foodNameController.text.isNotEmpty &&
        caloriesController.text.isNotEmpty &&
        servingSizeController.text.isNotEmpty &&
        servingsController.text.isNotEmpty) {

      context.read<PageChange>().changePageRemovePreviousCache(
          FoodDisplayPage(category: widget.category));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Missing Food Name, Servings or Calories",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ));
    }
  }

  String ServingSizeCalculator(String valuePerOneHundred, String servingSize,
      String servings, int decimalPlaces) {
    try {
      return ((double.parse(valuePerOneHundred) / 100) *
              (double.parse(servingSize) * double.parse(servings)))
          .toStringAsFixed(decimalPlaces);
    } catch (error) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    SetControllerValues();

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
                    minHeight: 300,
                    maxHeight: 920,
                    height: 600,
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
                        RecipeMacros(
                            width: _width,
                            height: _height/1.9,
                            currentFoodItem: currentFoodItem,
                            servingSizeController: servingSizeController,
                            servingsController: servingsController,
                            caloriesController: caloriesController,
                            kiloJoulesController: kiloJoulesController,
                            proteinsController: proteinsController,
                            carbsController: carbsController,
                            fiberController: fiberController,
                            sugarsController: sugarsController,
                            fatController: fatController,
                            saturatedFatController: saturatedFatController,
                            polyUnsaturatedFatController: polyUnsaturatedFatController,
                            monoUnsaturatedFatController: monoUnsaturatedFatController,
                            transFatController: transFatController,
                            cholesterolController: cholesterolController,
                            calciumController: calciumController,
                            ironController: ironController,
                            sodiumController: sodiumController,
                            zincController: zincController,
                            magnesiumController: magnesiumController,
                            potassiumController: potassiumController,
                            vitaminAController: vitaminAController,
                            vitaminB1Controller: vitaminB1Controller,
                            vitaminB2Controller: vitaminB2Controller,
                            vitaminB3Controller: vitaminB3Controller,
                            vitaminB6Controller: vitaminB6Controller,
                            vitaminB9Controller: vitaminB9Controller,
                            vitaminB12Controller: vitaminB12Controller,
                            vitaminCController: vitaminCController,
                            vitaminDController: vitaminDController,
                            vitaminEController: vitaminEController,
                            vitaminKController: vitaminKController,
                            omega3Controller: omega3Controller,
                            omega6Controller: omega6Controller,
                            alcoholController: alcoholController,
                            biotinController: biotinController,
                            butyricAcidController: butyricAcidController,
                            caffeineController: caffeineController,
                            capricAcidController: capricAcidController,
                            caproicAcidController: caproicAcidController,
                            caprylicAcidController: caprylicAcidController,
                            chlorideController: chlorideController,
                            chromiumController: chromiumController,
                            copperController: copperController,
                            docosahexaenoicAcidController: docosahexaenoicAcidController,
                            eicosapentaenoicAcidController: eicosapentaenoicAcidController,
                            erucicAcidController: erucicAcidController,
                            fluorideController: fluorideController,
                            iodineController: iodineController,
                            manganeseController: manganeseController,
                            molybdenumController: molybdenumController,
                            myristicAcidController: myristicAcidController,
                            oleicAcidController: oleicAcidController,
                            palmiticAcidController: palmiticAcidController,
                            pantothenicAcidController: pantothenicAcidController,
                            seleniumController: seleniumController,
                            stearicAcidController: stearicAcidController,
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
                        buttonText: "Save Food Data",
                        onTap: SaveFoodItem,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class RecipeMacros extends StatelessWidget {
  const RecipeMacros({
    Key? key,
    required this.width,
    required this.height,
    required this.currentFoodItem,
    required this.servingSizeController,
    required this.servingsController,
    required this.caloriesController,
    required this.kiloJoulesController,
    required this.proteinsController,
    required this.carbsController,
    required this.fiberController,
    required this.sugarsController,
    required this.fatController,
    required this.saturatedFatController,
    required this.polyUnsaturatedFatController,
    required this.monoUnsaturatedFatController,
    required this.transFatController,
    required this.cholesterolController,
    required this.calciumController,
    required this.ironController,
    required this.sodiumController,
    required this.zincController,
    required this.magnesiumController,
    required this.potassiumController,
    required this.vitaminAController,
    required this.vitaminB1Controller,
    required this.vitaminB2Controller,
    required this.vitaminB3Controller,
    required this.vitaminB6Controller,
    required this.vitaminB9Controller,
    required this.vitaminB12Controller,
    required this.vitaminCController,
    required this.vitaminDController,
    required this.vitaminEController,
    required this.vitaminKController,
    required this.omega3Controller,
    required this.omega6Controller,
    required this.alcoholController,
    required this.biotinController,
    required this.butyricAcidController,
    required this.caffeineController,
    required this.capricAcidController,
    required this.caproicAcidController,
    required this.caprylicAcidController,
    required this.chlorideController,
    required this.chromiumController,
    required this.copperController,
    required this.docosahexaenoicAcidController,
    required this.eicosapentaenoicAcidController,
    required this.erucicAcidController,
    required this.fluorideController,
    required this.iodineController,
    required this.manganeseController,
    required this.molybdenumController,
    required this.myristicAcidController,
    required this.oleicAcidController,
    required this.palmiticAcidController,
    required this.pantothenicAcidController,
    required this.seleniumController,
    required this.stearicAcidController,
  }) : super(key: key);

  final double width;
  final double height;
  final FoodItem currentFoodItem;
  final TextEditingController servingSizeController;
  final TextEditingController servingsController;
  final TextEditingController caloriesController;
  final TextEditingController kiloJoulesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fiberController;
  final TextEditingController sugarsController;
  final TextEditingController fatController;
  final TextEditingController saturatedFatController;
  final TextEditingController polyUnsaturatedFatController;
  final TextEditingController monoUnsaturatedFatController;
  final TextEditingController transFatController;
  final TextEditingController cholesterolController;
  final TextEditingController calciumController;
  final TextEditingController ironController;
  final TextEditingController sodiumController;
  final TextEditingController zincController;
  final TextEditingController magnesiumController;
  final TextEditingController potassiumController;
  final TextEditingController vitaminAController;
  final TextEditingController vitaminB1Controller;
  final TextEditingController vitaminB2Controller;
  final TextEditingController vitaminB3Controller;
  final TextEditingController vitaminB6Controller;
  final TextEditingController vitaminB9Controller;
  final TextEditingController vitaminB12Controller;
  final TextEditingController vitaminCController;
  final TextEditingController vitaminDController;
  final TextEditingController vitaminEController;
  final TextEditingController vitaminKController;
  final TextEditingController omega3Controller;
  final TextEditingController omega6Controller;
  final TextEditingController alcoholController;
  final TextEditingController biotinController;
  final TextEditingController butyricAcidController;
  final TextEditingController caffeineController;
  final TextEditingController capricAcidController;
  final TextEditingController caproicAcidController;
  final TextEditingController caprylicAcidController;
  final TextEditingController chlorideController;
  final TextEditingController chromiumController;
  final TextEditingController copperController;
  final TextEditingController docosahexaenoicAcidController;
  final TextEditingController eicosapentaenoicAcidController;
  final TextEditingController erucicAcidController;
  final TextEditingController fluorideController;
  final TextEditingController iodineController;
  final TextEditingController manganeseController;
  final TextEditingController molybdenumController;
  final TextEditingController myristicAcidController;
  final TextEditingController oleicAcidController;
  final TextEditingController palmiticAcidController;
  final TextEditingController pantothenicAcidController;
  final TextEditingController seleniumController;
  final TextEditingController stearicAcidController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ListView(
        children: [
          SizedBox(
            width: width / 2,
            height: 40,
            child: DietListHeaderBox(
              width: width,
              title: "Values per 100g",
              largeTitle: true,
              color: Colors.white,
            ),
          ),
          DietListHeaderBox(
            width: width,
            title: "Calories and Macro Nutrients",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: caloriesController,
            value: currentFoodItem.calories,
            width: width,
            title: "Calories",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: proteinsController,
            value: currentFoodItem.proteins,
            width: width,
            title: "Protein",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: carbsController,
            value: currentFoodItem.carbs,
            width: width,
            title: "Carbohydrates",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: fatController,
            value: currentFoodItem.fat,
            width: width,
            title: "Fat",
          ),
          DietListHeaderBox(
            width: width,
            title: "Carbohydrates and Fats",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: fiberController,
            value: currentFoodItem.fiber,
            width: width,
            title: "Fiber",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: sugarsController,
            value: currentFoodItem.sugars,
            width: width,
            title: "Sugars",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: saturatedFatController,
            value: currentFoodItem.saturatedFat,
            width: width,
            title: "Saturated Fat",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: polyUnsaturatedFatController,
            value: currentFoodItem.polyUnsaturatedFat,
            width: width,
            title: "Polyunsaturated Fat",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: monoUnsaturatedFatController,
            value: currentFoodItem.monoUnsaturatedFat,
            width: width,
            title: "Monounsaturated Fat",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: transFatController,
            value: currentFoodItem.transFat,
            width: width,
            title: "Trans Fat",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: cholesterolController,
            value: currentFoodItem.cholesterol,
            width: width,
            title: "Cholesterol",
          ),
          DietListHeaderBox(
            width: width,
            title: "Caffeine and Alcohol",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: caffeineController,
            value: currentFoodItem.caffeine,
            width: width,
            title: "Caffeine (mg)",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: alcoholController,
            value: currentFoodItem.alcohol,
            width: width,
            title: "Alcohol (g)",
          ),
          DietListHeaderBox(
            width: width,
            title: "Minerals (g)",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: sodiumController,
            value: currentFoodItem.sodium,
            width: width,
            title: "Sodium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: magnesiumController,
            value: currentFoodItem.magnesium,
            width: width,
            title: "Magnesium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: potassiumController,
            value: currentFoodItem.potassium,
            width: width,
            title: "Potassium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: ironController,
            value: currentFoodItem.iron,
            width: width,
            title: "Iron",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: zincController,
            value: currentFoodItem.zinc,
            width: width,
            title: "Zinc",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: calciumController,
            value: currentFoodItem.calcium,
            width: width,
            title: "Calcium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: seleniumController,
            value: currentFoodItem.selenium,
            width: width,
            title: "Selenium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: chlorideController,
            value: currentFoodItem.chloride,
            width: width,
            title: "Chloride",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: chromiumController,
            value: currentFoodItem.chromium,
            width: width,
            title: "Chromium",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: copperController,
            value: currentFoodItem.copper,
            width: width,
            title: "Copper",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: fluorideController,
            value: currentFoodItem.fluoride,
            width: width,
            title: "Fluoride",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: iodineController,
            value: currentFoodItem.iodine,
            width: width,
            title: "Iodine",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: manganeseController,
            value: currentFoodItem.manganese,
            width: width,
            title: "Manganese",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: molybdenumController,
            value: currentFoodItem.molybdenum,
            width: width,
            title: "Molybdenum",
          ),
          DietListHeaderBox(
            width: width,
            title: "Vitamins and Amino Acids (mg)",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminAController,
            value: currentFoodItem.vitaminA,
            width: width,
            title: "Vitamin A",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB1Controller,
            value: currentFoodItem.vitaminB1,
            width: width,
            title: "Vitamin B1",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB2Controller,
            value: currentFoodItem.vitaminB2,
            width: width,
            title: "Vitamin B2",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB3Controller,
            value: currentFoodItem.vitaminB3,
            width: width,
            title: "Niacin",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB6Controller,
            value: currentFoodItem.vitaminB6,
            width: width,
            title: "Vitamin B6",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: biotinController,
            value: currentFoodItem.biotin,
            width: width,
            title: "Biotin",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB9Controller,
            value: currentFoodItem.vitaminB9,
            width: width,
            title: "Vitamin B9",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminB12Controller,
            value: currentFoodItem.vitaminB12,
            width: width,
            title: "Vitamin B12",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminCController,
            value: currentFoodItem.vitaminC,
            width: width,
            title: "Vitamin C",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminDController,
            value: currentFoodItem.vitaminD,
            width: width,
            title: "Vitamin D",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminEController,
            value: currentFoodItem.vitaminE,
            width: width,
            title: "Vitamin E",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: vitaminKController,
            value: currentFoodItem.vitaminK,
            width: width,
            title: "Vitamin K",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: omega3Controller,
            value: currentFoodItem.omega3,
            width: width,
            title: "Omega3",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: omega6Controller,
            value: currentFoodItem.omega6,
            width: width,
            title: "Omega6",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: butyricAcidController,
            value: currentFoodItem.butyricAcid,
            width: width,
            title: "Butyric Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: capricAcidController,
            value: currentFoodItem.capricAcid,
            width: width,
            title: "Capric Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: caproicAcidController,
            value: currentFoodItem.caproicAcid,
            width: width,
            title: "Caproic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: caprylicAcidController,
            value: currentFoodItem.caprylicAcid,
            width: width,
            title: "Caprylic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: docosahexaenoicAcidController,
            value: currentFoodItem.docosahexaenoicAcid,
            width: width,
            title: "Docosahexaenoic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: eicosapentaenoicAcidController,
            value: currentFoodItem.eicosapentaenoicAcid,
            width: width,
            title: "Eicosapentaenoic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: erucicAcidController,
            value: currentFoodItem.erucicAcid,
            width: width,
            title: "Erucic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: myristicAcidController,
            value: currentFoodItem.myristicAcid,
            width: width,
            title: "Myristic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: oleicAcidController,
            value: currentFoodItem.oleicAcid,
            width: width,
            title: "Oleic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: palmiticAcidController,
            value: currentFoodItem.palmiticAcid,
            width: width,
            title: "Palmitic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: pantothenicAcidController,
            value: currentFoodItem.pantothenicAcid,
            width: width,
            title: "Pantothenic Acid",
          ),
          FoodNutritionListText(
            servingSize: servingSizeController.text,
            servings: servingsController.text,
            //controller: stearicAcidController,
            value: currentFoodItem.stearicAcid,
            width: width,
            title: "Stearic Acid",
          ),
        ],
      ),
    );
  }
}
