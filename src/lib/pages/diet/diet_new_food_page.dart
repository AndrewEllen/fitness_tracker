import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/database_write.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/diet/diet_list_header_box.dart';
import '../../widgets/diet/food_nutrition_list_formfield.dart';
import '../diet_new/diet_nutrition_table_extraction.dart';
import 'diet_food_display_page.dart';

class FoodNewNutritionEdit extends StatefulWidget {
  const FoodNewNutritionEdit({Key? key, required this.category, this.fromBarcode = false, this.recipe = false, this.saveAsCustom = true}) : super(key: key);
  final String category;
  final bool fromBarcode, recipe, saveAsCustom;

  @override
  State<FoodNewNutritionEdit> createState() => _FoodNewNutritionEditState();
}

class _FoodNewNutritionEditState extends State<FoodNewNutritionEdit> {
  late bool _loading = true;

  late FoodItem currentFoodItem = context.read<UserNutritionData>().currentFoodItem;

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

    if (widget.fromBarcode) {
      barcodeController.text = currentFoodItem.barcode;
    } else {
      barcodeController.text = const Uuid().v4();
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

    servingsController.text = double.tryParse(servingsController.text) == null ? "0" : servingsController.text;
    servingSizeController.text = double.tryParse(servingSizeController.text) == null ? "0" : servingSizeController.text;

    //print(context.read<UserNutritionData>().foodListItemsBreakfast.last.foodItemData.foodName);

    print("Barcode on new food edit screen");
    print(barcodeController.text);

    if (foodNameController.text.isNotEmpty && caloriesController.text.isNotEmpty && servingSizeController.text.isNotEmpty
    && servingsController.text.isNotEmpty) {

      if (widget.saveAsCustom) {
        context.read<UserNutritionData>().updateCustomFoodList(
          barcodeController.text,
          foodNameController.text,
          servingsController.text,
          servingSizeController.text,
        );
      }

      context.read<UserNutritionData>().updateCurrentFoodItemServings(servingsController.text);
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSizeController.text);

      context.read<UserNutritionData>().updateCurrentFoodItem(
        barcodeController.text,
        foodNameController.text,
        quantityController.text,
        servingSizeController.text,
        servingsController.text,
        caloriesController.text,
        kiloJoulesController.text,
        proteinsController.text,
        carbsController.text,
        fiberController.text,
        sugarsController.text,
        fatController.text,
        saturatedFatController.text,
        polyUnsaturatedFatController.text,
        monoUnsaturatedFatController.text,
        transFatController.text,
        cholesterolController.text,
        calciumController.text,
        ironController.text,
        sodiumController.text,
        zincController.text,
        magnesiumController.text,
        potassiumController.text,
        vitaminAController.text,
        vitaminB1Controller.text,
        vitaminB2Controller.text,
        vitaminB3Controller.text,
        vitaminB6Controller.text,
        vitaminB9Controller.text,
        vitaminB12Controller.text,
        vitaminCController.text,
        vitaminDController.text,
        vitaminEController.text,
        vitaminKController.text,
        omega3Controller.text,
        omega6Controller.text,
        alcoholController.text,
        biotinController.text,
        butyricAcidController.text,
        caffeineController.text,
        capricAcidController.text,
        caproicAcidController.text,
        caprylicAcidController.text,
        chlorideController.text,
        chromiumController.text,
        copperController.text,
        docosahexaenoicAcidController.text,
        eicosapentaenoicAcidController.text,
        erucicAcidController.text,
        fluorideController.text,
        iodineController.text,
        manganeseController.text,
        molybdenumController.text,
        myristicAcidController.text,
        oleicAcidController.text,
        palmiticAcidController.text,
        pantothenicAcidController.text,
        seleniumController.text,
        stearicAcidController.text,
      );

      UpdateFoodItemData(context.read<UserNutritionData>().currentFoodItem);

      context.read<PageChange>().changePageRemovePreviousCache(FoodDisplayPage(category: widget.category, recipe: widget.recipe,));
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
      servingsController.text = double.tryParse(servingsController.text) == null ? "0" : servingsController.text;
      servingSizeController.text = double.tryParse(servingSizeController.text) == null ? "0" : servingSizeController.text;
      return ((double.parse(valuePerOneHundred) / 100) *
          (double.parse(servingSize) * double.parse(servings)))
          .toStringAsFixed(decimalPlaces);
    } catch (error) {
      return "-";
    }
  }

  void setValueOfControllersToScanned(FoodItem scannedItem) {

    servingSizeController.text = scannedItem.servingSize.isNotEmpty ? scannedItem.servingSize : currentFoodItem.servingSize;
    caloriesController.text = scannedItem.calories.isNotEmpty ? scannedItem.calories : currentFoodItem.calories;
    kiloJoulesController.text = scannedItem.kiloJoules.isNotEmpty ? scannedItem.kiloJoules : currentFoodItem.kiloJoules;
    proteinsController.text = scannedItem.proteins.isNotEmpty ? scannedItem.proteins : currentFoodItem.proteins;
    carbsController.text = scannedItem.carbs.isNotEmpty ? scannedItem.carbs : currentFoodItem.carbs;
    fiberController.text = scannedItem.fiber.isNotEmpty ? scannedItem.fiber : currentFoodItem.fiber;
    sugarsController.text = scannedItem.sugars.isNotEmpty ? scannedItem.sugars : currentFoodItem.sugars;
    fatController.text = scannedItem.fat.isNotEmpty ? scannedItem.fat : currentFoodItem.fat;
    saturatedFatController.text = scannedItem.saturatedFat.isNotEmpty ? scannedItem.saturatedFat : currentFoodItem.saturatedFat;
    polyUnsaturatedFatController.text = scannedItem.polyUnsaturatedFat.isNotEmpty ? scannedItem.polyUnsaturatedFat : currentFoodItem.polyUnsaturatedFat;
    monoUnsaturatedFatController.text = scannedItem.monoUnsaturatedFat.isNotEmpty ? scannedItem.monoUnsaturatedFat : currentFoodItem.monoUnsaturatedFat;
    transFatController.text = scannedItem.transFat.isNotEmpty ? scannedItem.transFat : currentFoodItem.transFat;
    cholesterolController.text = scannedItem.cholesterol.isNotEmpty ? scannedItem.cholesterol : currentFoodItem.cholesterol;
    calciumController.text = scannedItem.calcium.isNotEmpty ? scannedItem.calcium : currentFoodItem.calcium;
    ironController.text = scannedItem.iron.isNotEmpty ? scannedItem.iron : currentFoodItem.iron;
    sodiumController.text = scannedItem.sodium.isNotEmpty ? scannedItem.sodium : currentFoodItem.sodium;
    zincController.text = scannedItem.zinc.isNotEmpty ? scannedItem.zinc : currentFoodItem.zinc;
    magnesiumController.text = scannedItem.magnesium.isNotEmpty ? scannedItem.magnesium : currentFoodItem.magnesium;
    potassiumController.text = scannedItem.potassium.isNotEmpty ? scannedItem.potassium : currentFoodItem.potassium;
    vitaminAController.text = scannedItem.vitaminA.isNotEmpty ? scannedItem.vitaminA : currentFoodItem.vitaminA;
    vitaminB1Controller.text = scannedItem.vitaminB1.isNotEmpty ? scannedItem.vitaminB1 : currentFoodItem.vitaminB1;
    vitaminB2Controller.text = scannedItem.vitaminB2.isNotEmpty ? scannedItem.vitaminB2 : currentFoodItem.vitaminB2;
    vitaminB3Controller.text = scannedItem.vitaminB3.isNotEmpty ? scannedItem.vitaminB3 : currentFoodItem.vitaminB3;
    vitaminB6Controller.text = scannedItem.vitaminB6.isNotEmpty ? scannedItem.vitaminB6 : currentFoodItem.vitaminB6;
    vitaminB9Controller.text = scannedItem.vitaminB9.isNotEmpty ? scannedItem.vitaminB9 : currentFoodItem.vitaminB9;
    vitaminB12Controller.text = scannedItem.vitaminB12.isNotEmpty ? scannedItem.vitaminB12 : currentFoodItem.vitaminB12;
    vitaminCController.text = scannedItem.vitaminC.isNotEmpty ? scannedItem.vitaminC : currentFoodItem.vitaminC;
    vitaminDController.text = scannedItem.vitaminD.isNotEmpty ? scannedItem.vitaminD : currentFoodItem.vitaminD;
    vitaminEController.text = scannedItem.vitaminE.isNotEmpty ? scannedItem.vitaminE : currentFoodItem.vitaminE;
    vitaminKController.text = scannedItem.vitaminK.isNotEmpty ? scannedItem.vitaminK : currentFoodItem.vitaminK;
    omega3Controller.text = scannedItem.omega3.isNotEmpty ? scannedItem.omega3 : currentFoodItem.omega3;
    omega6Controller.text = scannedItem.omega6.isNotEmpty ? scannedItem.omega6 : currentFoodItem.omega6;
    alcoholController.text = scannedItem.alcohol.isNotEmpty ? scannedItem.alcohol : currentFoodItem.alcohol;
    biotinController.text = scannedItem.biotin.isNotEmpty ? scannedItem.biotin : currentFoodItem.biotin;
    butyricAcidController.text = scannedItem.butyricAcid.isNotEmpty ? scannedItem.butyricAcid : currentFoodItem.butyricAcid;
    caffeineController.text = scannedItem.caffeine.isNotEmpty ? scannedItem.caffeine : currentFoodItem.caffeine;
    capricAcidController.text = scannedItem.capricAcid.isNotEmpty ? scannedItem.capricAcid : currentFoodItem.capricAcid;
    caproicAcidController.text = scannedItem.caproicAcid.isNotEmpty ? scannedItem.caproicAcid : currentFoodItem.caproicAcid;
    caprylicAcidController.text = scannedItem.caprylicAcid.isNotEmpty ? scannedItem.caprylicAcid : currentFoodItem.caprylicAcid;
    chlorideController.text = scannedItem.chloride.isNotEmpty ? scannedItem.chloride : currentFoodItem.chloride;
    chromiumController.text = scannedItem.chromium.isNotEmpty ? scannedItem.chromium : currentFoodItem.chromium;
    copperController.text = scannedItem.copper.isNotEmpty ? scannedItem.copper : currentFoodItem.copper;
    docosahexaenoicAcidController.text = scannedItem.docosahexaenoicAcid.isNotEmpty ? scannedItem.docosahexaenoicAcid : currentFoodItem.docosahexaenoicAcid;
    eicosapentaenoicAcidController.text = scannedItem.eicosapentaenoicAcid.isNotEmpty ? scannedItem.eicosapentaenoicAcid : currentFoodItem.eicosapentaenoicAcid;
    erucicAcidController.text = scannedItem.erucicAcid.isNotEmpty ? scannedItem.erucicAcid : currentFoodItem.erucicAcid;
    fluorideController.text = scannedItem.fluoride.isNotEmpty ? scannedItem.fluoride : currentFoodItem.fluoride;
    iodineController.text = scannedItem.iodine.isNotEmpty ? scannedItem.iodine : currentFoodItem.iodine;
    manganeseController.text = scannedItem.manganese.isNotEmpty ? scannedItem.manganese : currentFoodItem.manganese;
    molybdenumController.text = scannedItem.molybdenum.isNotEmpty ? scannedItem.molybdenum : currentFoodItem.molybdenum;
    myristicAcidController.text = scannedItem.myristicAcid.isNotEmpty ? scannedItem.myristicAcid : currentFoodItem.myristicAcid;
    oleicAcidController.text = scannedItem.oleicAcid.isNotEmpty ? scannedItem.oleicAcid : currentFoodItem.oleicAcid;
    palmiticAcidController.text = scannedItem.palmiticAcid.isNotEmpty ? scannedItem.palmiticAcid : currentFoodItem.palmiticAcid;
    pantothenicAcidController.text = scannedItem.pantothenicAcid.isNotEmpty ? scannedItem.pantothenicAcid : currentFoodItem.pantothenicAcid;
    seleniumController.text = scannedItem.selenium.isNotEmpty ? scannedItem.selenium : currentFoodItem.selenium;
    stearicAcidController.text = scannedItem.stearicAcid.isNotEmpty ? scannedItem.stearicAcid : currentFoodItem.stearicAcid;

    context.read<UserNutritionData>().changeItemScannedBool(false);
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().itemScanned;
    FoodItem scannedItem = context.read<UserNutritionData>().scannedFoodItem;

    if (context.read<UserNutritionData>().itemScanned) {
      setValueOfControllersToScanned(scannedItem);
    } else {
      SetControllerValues();
    }

    double _margin = 15;
    double _smallContainerMin = 95;
    double _width = 393.w;
    double _height = 851.h;

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
              height: _height * 0.8,
              child: ListView(
                children: [
                  FoodNutritionListFormField(
                    controller: foodNameController,
                    formKey: foodNameKey,
                    width: _width,
                    formName: "Name",
                    numbersOnly: false,
                    centerForm: true,
                    noUnits: true,
                  ),
                  FoodNutritionListFormField(
                    controller: servingsController,
                    formKey: servingskey,
                    width: _width,
                    formName: "Servings",
                    numbersOnly: true,
                    centerForm: true,
                    noUnits: true,
                  ),
                  FoodNutritionListFormField(
                    controller: servingSizeController,
                    formKey: servingSizekey,
                    width: _width,
                    formName: "Serving Size",
                    numbersOnly: true,
                    centerForm: true,
                    units: "g"
                  ),
                  SizedBox(
                    width: _width / 2,
                    height: 40.h,
                    child: DietListHeaderBox(
                      width: _width,
                      title: "Barcode: " + barcodeController.text,
                      largeTitle: true,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: _width / 2,
                    height: 40.h,
                    child: DietListHeaderBox(
                      width: _width,
                      title: "Values per 100g",
                      largeTitle: true,
                      color: Colors.white,
                    ),
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title: "Calories and Macro Nutrients",
                  ),
                  FoodNutritionListFormField(
                    controller: caloriesController,
                    formKey: caloriesKey,
                    width: _width,
                    formName: "Calories",
                    units: "Kcal",
                  ),
                  FoodNutritionListFormField(
                    controller: proteinsController,
                    formKey: proteinsKey,
                    width: _width,
                    formName: "Protein",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: carbsController,
                    formKey: carbsKey,
                    width: _width,
                    formName: "Carbohydrates",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: fatController,
                    formKey: fatKey,
                    width: _width,
                    formName: "Fat",
                    units: "g",
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title: "Carbohydrates and Fats (g)",
                  ),
                  FoodNutritionListFormField(
                    controller: fiberController,
                    formKey: fiberKey,
                    width: _width,
                    formName: "Fiber",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: sugarsController,
                    formKey: sugarsKey,
                    width: _width,
                    formName: "Sugars",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: saturatedFatController,
                    formKey: saturatedFatKey,
                    width: _width,
                    formName: "Saturated Fat",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: polyUnsaturatedFatController,
                    formKey: polyUnsaturatedFatKey,
                    width: _width,
                    formName: "Polyunsaturated Fat",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: monoUnsaturatedFatController,
                    formKey: monoUnsaturatedFatKey,
                    width: _width,
                    formName: "Monounsaturated Fat",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: transFatController,
                    formKey: transFatKey,
                    width: _width,
                    formName: "Trans Fat",
                    units: "g",
                  ),
                  FoodNutritionListFormField(
                    controller: cholesterolController,
                    formKey: cholesterolKey,
                    width: _width,
                    formName: "Cholesterol",
                    units: "mg",
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title: "Caffeine and Alcohol",
                  ),
                  FoodNutritionListFormField(
                    controller: caffeineController,
                    formKey: caffeineKey,
                    width: _width,
                    formName: "Caffeine",
                  ),
                  FoodNutritionListFormField(
                    controller: alcoholController,
                    formKey: alcoholKey,
                    width: _width,
                    formName: "Alcohol",
                    units: "g",
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title: "Minerals",
                  ),
                  FoodNutritionListFormField(
                      controller: sodiumController,
                      formKey: sodiumKey,
                      width: _width,
                      formName: "Salt",
                      units: "g"
                  ),
                  FoodNutritionListFormField(
                    controller: magnesiumController,
                    formKey: magnesiumKey,
                    width: _width,
                    formName: "Magnesium",
                  ),
                  FoodNutritionListFormField(
                    controller: potassiumController,
                    formKey: potassiumKey,
                    width: _width,
                    formName: "Potassium",
                  ),
                  FoodNutritionListFormField(
                    controller: ironController,
                    formKey: ironKey,
                    width: _width,
                    formName: "Iron",
                  ),
                  FoodNutritionListFormField(
                    controller: zincController,
                    formKey: zincKey,
                    width: _width,
                    formName: "Zinc",
                  ),
                  FoodNutritionListFormField(
                    controller: calciumController,
                    formKey: calciumKey,
                    width: _width,
                    formName: "Calcium",
                  ),
                  FoodNutritionListFormField(
                    controller: seleniumController,
                    formKey: seleniumKey,
                    width: _width,
                    formName: "Selenium",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: chlorideController,
                    formKey: chlorideKey,
                    width: _width,
                    formName: "Chloride",
                  ),
                  FoodNutritionListFormField(
                    controller: chromiumController,
                    formKey: chromiumKey,
                    width: _width,
                    formName: "Chromium",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: copperController,
                    formKey: copperKey,
                    width: _width,
                    formName: "Copper",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: fluorideController,
                    formKey: fluorideKey,
                    width: _width,
                    formName: "Fluoride",
                  ),
                  FoodNutritionListFormField(
                    controller: iodineController,
                    formKey: iodineKey,
                    width: _width,
                    formName: "Iodine",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: manganeseController,
                    formKey: manganeseKey,
                    width: _width,
                    formName: "Manganese",
                  ),
                  FoodNutritionListFormField(
                    controller: molybdenumController,
                    formKey: molybdenumKey,
                    width: _width,
                    formName: "Molybdenum",
                    units: "μg",
                  ),
                  DietListHeaderBox(
                    width: _width,
                    title: "Vitamins and Amino Acids",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminAController,
                    formKey: vitaminAKey,
                    width: _width,
                    formName: "Vitamin A",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB1Controller,
                    formKey: vitaminB1Key,
                    width: _width,
                    formName: "Vitamin B1",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB2Controller,
                    formKey: vitaminB2Key,
                    width: _width,
                    formName: "Vitamin B2",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB3Controller,
                    formKey: vitaminB3Key,
                    width: _width,
                    formName: "Niacin",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB6Controller,
                    formKey: vitaminB6Key,
                    width: _width,
                    formName: "Vitamin B6",
                  ),
                  FoodNutritionListFormField(
                    controller: biotinController,
                    formKey: biotinKey,
                    width: _width,
                    formName: "Biotin",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB9Controller,
                    formKey: vitaminB9Key,
                    width: _width,
                    formName: "Folic Acid (B9)",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminB12Controller,
                    formKey: vitaminB12Key,
                    width: _width,
                    formName: "Vitamin B12",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminCController,
                    formKey: vitaminCKey,
                    width: _width,
                    formName: "Vitamin C",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminDController,
                    formKey: vitaminDKey,
                    width: _width,
                    formName: "Vitamin D",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminEController,
                    formKey: vitaminEKey,
                    width: _width,
                    formName: "Vitamin E",
                  ),
                  FoodNutritionListFormField(
                    controller: vitaminKController,
                    formKey: vitaminKKey,
                    width: _width,
                    formName: "Vitamin K",
                    units: "μg",
                  ),
                  FoodNutritionListFormField(
                    controller: omega3Controller,
                    formKey: omega3Key,
                    width: _width,
                    formName: "Omega3",
                  ),
                  FoodNutritionListFormField(
                    controller: omega6Controller,
                    formKey: omega6Key,
                    width: _width,
                    formName: "Omega6",
                  ),
                  FoodNutritionListFormField(
                    controller: butyricAcidController,
                    formKey: butyricAcidKey,
                    width: _width,
                    formName: "Butyric Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: capricAcidController,
                    formKey: capricAcidKey,
                    width: _width,
                    formName: "Capric Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: caproicAcidController,
                    formKey: caproicAcidKey,
                    width: _width,
                    formName: "Caproic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: caprylicAcidController,
                    formKey: caprylicAcidKey,
                    width: _width,
                    formName: "Caprylic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: docosahexaenoicAcidController,
                    formKey: docosahexaenoicAcidKey,
                    width: _width,
                    formName: "Docosahexaenoic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: eicosapentaenoicAcidController,
                    formKey: eicosapentaenoicAcidKey,
                    width: _width,
                    formName: "Eicosapentaenoic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: erucicAcidController,
                    formKey: erucicAcidKey,
                    width: _width,
                    formName: "Erucic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: myristicAcidController,
                    formKey: myristicAcidKey,
                    width: _width,
                    formName: "Myristic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: oleicAcidController,
                    formKey: oleicAcidKey,
                    width: _width,
                    formName: "Oleic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: palmiticAcidController,
                    formKey: palmiticAcidKey,
                    width: _width,
                    formName: "Palmitic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: pantothenicAcidController,
                    formKey: pantothenicAcidKey,
                    width: _width,
                    formName: "Pantothenic Acid",
                  ),
                  FoodNutritionListFormField(
                    controller: stearicAcidController,
                    formKey: stearicAcidKey,
                    width: _width,
                    formName: "Stearic Acid",
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(

                children: [

                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: ElevatedButton(
                        onPressed: () => SaveFoodItem(),
                        child: const Text(
                          "Save Food Data",
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: ElevatedButton(
                        onPressed: () => context.read<PageChange>().changePageCache(const NutritionTableExtraction()),
                        child: const Icon(
                          MdiIcons.cubeScan,
                        ),
                      ),
                    ),
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
