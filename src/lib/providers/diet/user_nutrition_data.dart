import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../models/diet/food_item.dart';
import '../../models/diet/user__foods_model.dart';
import '../../models/diet/user_nutrition_model.dart';
import '../general/database_write.dart';

//[LO3.7.3.5]
//Processes the data for the food items retrieved
//This is where data is saved between pages so that nothing is lost when switching page in the app
//It also removes the problem with using futures because all the data in here is already resolved so the app is able to use it from the provider rather than relying on a future builder.

String FormatDate(DateTime dateToFormat) {

  if (dateToFormat == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
    return "Today";
  } else if (dateToFormat == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1)) {
    return "Yesterday";
  } else if (dateToFormat == DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1)) {
    return "Tomorrow";
  }

  return DateFormat('dd/MM/yyyy').format(dateToFormat);
}

String ServingSizeCalculator(String valuePerOneHundred, String servingSize, String servings, int decimalPlaces) {

  try {
    return ((double.parse(valuePerOneHundred) / 100) * (double.parse(servingSize) * double.parse(servings))).toStringAsFixed(decimalPlaces);
  } catch (error) {
    return "-";
  }

}

FoodItem FoodDefaultData() {
  return FoodItem(
    barcode: "",
    foodName: "",
    quantity: "",
    servingSize: "",
    servings: "",
    calories: "",
    kiloJoules: "",
    proteins: "",
    carbs: "",
    fiber: "",
    sugars: "",
    fat: "",
    saturatedFat: "",
    polyUnsaturatedFat: "",
    monoUnsaturatedFat: "",
    transFat: "",
    cholesterol: "",
    calcium: "",
    iron: "",
    sodium: "",
    zinc: "",
    magnesium: "",
    potassium: "",
    vitaminA: "",
    vitaminB1: "",
    vitaminB2: "",
    vitaminB3: "",
    vitaminB6: "",
    vitaminB9: "",
    vitaminB12: "",
    vitaminC: "",
    vitaminD: "",
    vitaminE: "",
    vitaminK: "",
    omega3: "",
    omega6: "",
    alcohol: "",
    biotin: "",
    butyricAcid: "",
    caffeine: "",
    capricAcid: "",
    caproicAcid: "",
    caprylicAcid: "",
    chloride: "",
    chromium: "",
    copper: "",
    docosahexaenoicAcid: "",
    eicosapentaenoicAcid: "",
    erucicAcid: "",
    fluoride: "",
    iodine: "",
    manganese: "",
    molybdenum: "",
    myristicAcid: "",
    oleicAcid: "",
    palmiticAcid: "",
    pantothenicAcid: "",
    selenium: "",
    stearicAcid: "",
  );
}

class UserNutritionData with ChangeNotifier {

  //late List<ListFoodItem> _foodListItemsBreakfast = [];
  //late List<ListFoodItem> _foodListItemsLunch = [];
  //late List<ListFoodItem> _foodListItemsDinner = [];
  //late List<ListFoodItem> _foodListItemsSnacks = [];

  late UserNutritionModel _userDailyNutrition = UserNutritionModel(
    date: DateTime(DateTime
        .now()
        .year, DateTime
        .now()
        .month, DateTime
        .now()
        .day).toString(),
    foodListItemsBreakfast: [],
    foodListItemsLunch: [],
    foodListItemsDinner: [],
    foodListItemsSnacks: [],
  );

  late final List<UserRecipesModel> _userRecipesList = [];

  List<UserRecipesModel> get userRecipesList => _userRecipesList;

  late UserRecipesModel _currentRecipe = UserRecipesModel(
    barcode: "",
    recipeFoodList: [],
    foodData: FoodItem(
    barcode: "",
    foodName: "",
    quantity: "",
    servingSize: "",
    servings: "",
    calories: "",
    kiloJoules: "",
    proteins: "",
    carbs: "",
    fiber: "",
    sugars: "",
    fat: "",
    saturatedFat: "",
    polyUnsaturatedFat: "",
    monoUnsaturatedFat: "",
    transFat: "",
    cholesterol: "",
    calcium: "",
    iron: "",
    sodium: "",
    zinc: "",
    magnesium: "",
    potassium: "",
    vitaminA: "",
    vitaminB1: "",
    vitaminB2: "",
    vitaminB3: "",
    vitaminB6: "",
    vitaminB9: "",
    vitaminB12: "",
    vitaminC: "",
    vitaminD: "",
    vitaminE: "",
    vitaminK: "",
    omega3: "",
    omega6: "",
    alcohol: "",
    biotin: "",
    butyricAcid: "",
    caffeine: "",
    capricAcid: "",
    caproicAcid: "",
    caprylicAcid: "",
    chloride: "",
    chromium: "",
    copper: "",
    docosahexaenoicAcid: "",
    eicosapentaenoicAcid: "",
    erucicAcid: "",
    fluoride: "",
    iodine: "",
    manganese: "",
    molybdenum: "",
    myristicAcid: "",
    oleicAcid: "",
    palmiticAcid: "",
    pantothenicAcid: "",
    selenium: "",
    stearicAcid: "",
  ),
  );

  UserRecipesModel get currentRecipe => _currentRecipe;

  late FoodItem _currentFoodItem = FoodItem(
    barcode: "",
    foodName: "",
    quantity: "",
    servingSize: "",
    servings: "",
    calories: "",
    kiloJoules: "",
    proteins: "",
    carbs: "",
    fiber: "",
    sugars: "",
    fat: "",
    saturatedFat: "",
    polyUnsaturatedFat: "",
    monoUnsaturatedFat: "",
    transFat: "",
    cholesterol: "",
    calcium: "",
    iron: "",
    sodium: "",
    zinc: "",
    magnesium: "",
    potassium: "",
    vitaminA: "",
    vitaminB1: "",
    vitaminB2: "",
    vitaminB3: "",
    vitaminB6: "",
    vitaminB9: "",
    vitaminB12: "",
    vitaminC: "",
    vitaminD: "",
    vitaminE: "",
    vitaminK: "",
    omega3: "",
    omega6: "",
    alcohol: "",
    biotin: "",
    butyricAcid: "",
    caffeine: "",
    capricAcid: "",
    caproicAcid: "",
    caprylicAcid: "",
    chloride: "",
    chromium: "",
    copper: "",
    docosahexaenoicAcid: "",
    eicosapentaenoicAcid: "",
    erucicAcid: "",
    fluoride: "",
    iodine: "",
    manganese: "",
    molybdenum: "",
    myristicAcid: "",
    oleicAcid: "",
    palmiticAcid: "",
    pantothenicAcid: "",
    selenium: "",
    stearicAcid: "",
  );
  late ListFoodItem _currentFoodListItem = ListFoodItem(
    barcode: "",
    category: "",
    foodServingSize: "100",
    foodServings: "1",
    foodItemData: FoodDefaultData(),
    recipe: false
  );
  late bool _isCurrentFoodItemLoaded = false;
  late DateTime _nutritionDate = DateTime(DateTime
      .now()
      .year, DateTime
      .now()
      .month, DateTime
      .now()
      .day);


  late double _calories = 0;
  late double _protein = 0;
  late double _fat = 0;
  late double _carbohydrates = 0;
  late double _fiber = 0;
  late double _sugar = 0;
  late double _saturatedFat = 0.0;
  late double _polyUnsaturatedFat = 0.0;
  late double _monoUnsaturatedFat = 0.0;
  late double _transFat = 0.0;
  late double _cholesterol = 0.0;
  late double _calcium = 0.0;
  late double _iron = 0.0;
  late double _sodium = 0.0;
  late double _zinc = 0.0;
  late double _magnesium = 0.0;
  late double _potassium = 0.0;
  late double _vitaminA = 0.0;
  late double _vitaminB1 = 0.0;
  late double _vitaminB2 = 0.0;
  late double _vitaminB3 = 0.0;
  late double _vitaminB6 = 0.0;
  late double _vitaminB9 = 0.0;
  late double _vitaminB12 = 0.0;
  late double _vitaminC = 0.0;
  late double _vitaminD = 0.0;
  late double _vitaminE = 0.0;
  late double _vitaminK = 0.0;
  late double _omega3 = 0.0;
  late double _omega6 = 0.0;
  late double _alcohol = 0.0;
  late double _biotin = 0.0;
  late double _butyricAcid = 0.0;
  late double _caffeine = 0.0;
  late double _capricAcid = 0.0;
  late double _caproicAcid = 0.0;
  late double _caprylicAcid = 0.0;
  late double _chloride = 0.0;
  late double _chromium = 0.0;
  late double _copper = 0.0;
  late double _docosahexaenoicAcid = 0.0;
  late double _eicosapentaenoicAcid = 0.0;
  late double _erucicAcid = 0.0;
  late double _fluoride = 0.0;
  late double _iodine = 0.0;
  late double _manganese = 0.0;
  late double _molybdenum = 0.0;
  late double _myristicAcid = 0.0;
  late double _oleicAcid = 0.0;
  late double _palmiticAcid = 0.0;
  late double _pantothenicAcid = 0.0;
  late double _selenium = 0.0;
  late double _stearicAcid = 0.0;

  late final double _caloriesGoal = 2424;
  late final double _proteinGoal = 160;
  late final double _fatGoal = 85;
  late final double _carbohydratesGoal = 286;

  //grams
  late final double _fiberGoal = 30; // Recommended fiber intake for adults (general guideline)
  late final double _sugarGoal = 50; // Maximum recommended sugar intake for adults (general guideline)
  late final double _saturatedFatGoal = 20; // Maximum recommended saturated fat intake as a percentage of total calories (general guideline)
  late final double _polyUnsaturatedFatGoal = 12; // Recommended polyunsaturated fat intake as a percentage of total calories (general guideline)
  late final double _monoUnsaturatedFatGoal = 15; // Recommended monounsaturated fat intake as a percentage of total calories (general guideline)
  late final double _transFatGoal = 0; // Maximum recommended trans fat intake (general guideline)
  late final double _cholesterolGoal = 300; // Maximum recommended cholesterol intake in milligrams (general guideline)

  //mg
  late final double _calciumGoal = 1000; // Example: Calcium goal for adults (general guideline)
  late final double _ironGoal = 8; // Example: Iron goal for adults (general guideline)
  late final double _sodiumGoal = 2300; // Example: Sodium goal for adults (general guideline)
  late final double _zincGoal = 11; // Example: Zinc goal for adults (general guideline)
  late final double _magnesiumGoal = 400; // Example: Magnesium goal for adults (general guideline)
  late final double _potassiumGoal = 3500; // Example: Potassium goal

  //mg
  late final double _vitaminAGoal = 0.800; // Example: Vitamin A goal for adults (general guideline)
  late final double _vitaminB1Goal = 1.1; // Example: Thiamine (Vitamin B1) goal for adults (general guideline)
  late final double _vitaminB2Goal = 1.3; // Example: Riboflavin (Vitamin B2) goal for adults (general guideline)
  late final double _vitaminB3Goal = 16; // Example: Niacin (Vitamin B3) goal for adults (general guideline)
  late final double _vitaminB6Goal = 1.3; // Example: Vitamin B6 goal for adults (general guideline)
  late final double _vitaminB9Goal = 0.400; // Example: Folate (Vitamin B9) goal for adults (general guideline)
  late final double _vitaminB12Goal = 2.4; // Example: Vitamin B12 goal for adults (general guideline)
  late final double _vitaminCGoal = 90; // Example: Vitamin C goal for adults (general guideline)
  late final double _vitaminDGoal = 15; // Example: Vitamin D goal for adults (general guideline)
  late final double _vitaminEGoal = 15; // Example: Vitamin E goal for adults (general guideline)
  late final double _vitaminKGoal = 75; // Example: Vitamin K goal for adults (general guideline)

  late final double _alcoholGoal = 0;
  late final double _caffeineGoal = 0;

  //mg
  late final double _omega3Goal = 1000; // mg of combined EPA and DHA per day
  late final double _omega6Goal = 12000; // approximate ratio of 4:1 (omega-6 to omega-3)
  late final double _biotinGoal = 0.30; // mcg per day
  late final double _butyricAcidGoal = 150; // no specific recommendation
  late final double _capricAcidGoal = 1000; // no specific recommendation
  late final double _caproicAcidGoal = 0; // no specific recommendation
  late final double _caprylicAcidGoal = 1000; // no specific recommendation
  late final double _chlorideGoal = 2300; // mg per day
  late final double _chromiumGoal = 0.25; // mcg per day
  late final double _copperGoal = 0.900; // mcg per day
  late final double _docosahexaenoicAcidGoal = 250; // mg per day
  late final double _eicosapentaenoicAcidGoal = 250; // mg per day
  late final double _erucicAcidGoal = 400; // no specific recommendation
  late final double _fluorideGoal = 4; // mg per day
  late final double _iodineGoal = 0.150; // mcg per day
  late final double _manganeseGoal = 1.8; // mg per day
  late final double _molybdenumGoal = 0.045; // mcg per day
  late final double _myristicAcidGoal = 0.89; // no specific recommendation
  late final double _oleicAcidGoal = 20000; // no specific recommendation
  late final double _palmiticAcidGoal = 20000; // no specific recommendation
  late final double _pantothenicAcidGoal = 5; // mg per day
  late final double _seleniumGoal = 0.055; // mcg per day
  late final double _stearicAcidGoal = 5700; // no specific recommendation


  double get calories => _calories;
  double get protein => _protein;
  double get fat => _fat;
  double get carbohydrates => _carbohydrates;
  double get fiber => _fiber;
  double get sugar => _sugar;
  double get saturatedFat => _saturatedFat;
  double get polyUnsaturatedFat => _polyUnsaturatedFat;
  double get monoUnsaturatedFat => _monoUnsaturatedFat;
  double get transFat => _transFat;
  double get cholesterol => _cholesterol;
  double get calcium => _calcium;
  double get iron => _iron;
  double get sodium => _sodium;
  double get zinc => _zinc;
  double get magnesium => _magnesium;
  double get potassium => _potassium;
  double get vitaminA => _vitaminA;
  double get vitaminB1 => _vitaminB1;
  double get vitaminB2 => _vitaminB2;
  double get vitaminB3 => _vitaminB3;
  double get vitaminB6 => _vitaminB6;
  double get vitaminB9 => _vitaminB9;
  double get vitaminB12 => _vitaminB12;
  double get vitaminC => _vitaminC;
  double get vitaminD => _vitaminD;
  double get vitaminE => _vitaminE;
  double get vitaminK => _vitaminK;
  double get omega3 => _omega3;
  double get omega6 => _omega6;
  double get alcohol => _alcohol;
  double get biotin => _biotin;
  double get butyricAcid => _butyricAcid;
  double get caffeine => _caffeine;
  double get capricAcid => _capricAcid;
  double get caproicAcid => _caproicAcid;
  double get caprylicAcid => _caprylicAcid;
  double get chloride => _chloride;
  double get chromium => _chromium;
  double get copper => _copper;
  double get docosahexaenoicAcid => _docosahexaenoicAcid;
  double get eicosapentaenoicAcid => _eicosapentaenoicAcid;
  double get erucicAcid => _erucicAcid;
  double get fluoride => _fluoride;
  double get iodine => _iodine;
  double get manganese => _manganese;
  double get molybdenum => _molybdenum;
  double get myristicAcid => _myristicAcid;
  double get oleicAcid => _oleicAcid;
  double get palmiticAcid => _palmiticAcid;
  double get pantothenicAcid => _pantothenicAcid;
  double get selenium => _selenium;
  double get stearicAcid => _stearicAcid;


  double get caloriesGoal => _caloriesGoal;
  double get proteinGoal => _proteinGoal;
  double get fatGoal => _fatGoal;
  double get carbohydratesGoal => _carbohydratesGoal;
  double get fiberGoal => _fiberGoal;
  double get sugarGoal => _sugarGoal;
  double get saturatedFatGoal => _saturatedFatGoal;
  double get polyUnsaturatedFatGoal => _polyUnsaturatedFatGoal;
  double get monoUnsaturatedFatGoal => _monoUnsaturatedFatGoal;
  double get transFatGoal => _transFatGoal;
  double get cholesterolGoal => _cholesterolGoal;
  double get calciumGoal => _calciumGoal;
  double get ironGoal => _ironGoal;
  double get sodiumGoal => _sodiumGoal;
  double get zincGoal => _zincGoal;
  double get magnesiumGoal => _magnesiumGoal;
  double get potassiumGoal => _potassiumGoal;
  double get vitaminAGoal => _vitaminAGoal;
  double get vitaminB1Goal => _vitaminB1Goal;
  double get vitaminB2Goal => _vitaminB2Goal;
  double get vitaminB3Goal => _vitaminB3Goal;
  double get vitaminB6Goal => _vitaminB6Goal;
  double get vitaminB9Goal => _vitaminB9Goal;
  double get vitaminB12Goal => _vitaminB12Goal;
  double get vitaminCGoal => _vitaminCGoal;
  double get vitaminDGoal => _vitaminDGoal;
  double get vitaminEGoal => _vitaminEGoal;
  double get vitaminKGoal => _vitaminKGoal;
  double get omega3Goal => _omega3Goal;
  double get omega6Goal => _omega6Goal;
  double get alcoholGoal => _alcoholGoal;
  double get biotinGoal => _biotinGoal;
  double get butyricAcidGoal => _butyricAcidGoal;
  double get caffeineGoal => _caffeineGoal;
  double get capricAcidGoal => _capricAcidGoal;
  double get caproicAcidGoal => _caproicAcidGoal;
  double get caprylicAcidGoal => _caprylicAcidGoal;
  double get chlorideGoal => _chlorideGoal;
  double get chromiumGoal => _chromiumGoal;
  double get copperGoal => _copperGoal;
  double get docosahexaenoicAcidGoal => _docosahexaenoicAcidGoal;
  double get eicosapentaenoicAcidGoal => _eicosapentaenoicAcidGoal;
  double get erucicAcidGoal => _erucicAcidGoal;
  double get fluorideGoal => _fluorideGoal;
  double get iodineGoal => _iodineGoal;
  double get manganeseGoal => _manganeseGoal;
  double get molybdenumGoal => _molybdenumGoal;
  double get myristicAcidGoal => _myristicAcidGoal;
  double get oleicAcidGoal => _oleicAcidGoal;
  double get palmiticAcidGoal => _palmiticAcidGoal;
  double get pantothenicAcidGoal => _pantothenicAcidGoal;
  double get seleniumGoal => _seleniumGoal;
  double get stearicAcidGoal => _stearicAcidGoal;


  List<ListFoodItem> get foodListItemsBreakfast =>
      _userDailyNutrition.foodListItemsBreakfast;

  List<ListFoodItem> get foodListItemsLunch =>
      _userDailyNutrition.foodListItemsLunch;

  List<ListFoodItem> get foodListItemsDinner =>
      _userDailyNutrition.foodListItemsDinner;

  List<ListFoodItem> get foodListItemsSnacks =>
      _userDailyNutrition.foodListItemsSnacks;

  UserNutritionModel get userDailyNutrition => _userDailyNutrition;

  FoodItem get currentFoodItem => _currentFoodItem;

  ListFoodItem get currentFoodListItem => _currentFoodListItem;

  bool get isCurrentFoodItemLoaded => _isCurrentFoodItemLoaded;

  DateTime get nutritionDate => _nutritionDate;

  String get formattedNutritionDate => FormatDate(_nutritionDate);


  late UserNutritionFoodModel _userNutritionHistory = UserNutritionFoodModel(
      barcodes: [], foodListItemNames: [], foodServings: [], foodServingSize: [], recipe: []);

  UserNutritionFoodModel get userNutritionHistory => _userNutritionHistory;

  late UserNutritionFoodModel _userNutritionCustomFood = UserNutritionFoodModel(
      barcodes: [], foodListItemNames: [], foodServings: [], foodServingSize: [], recipe: []);

  UserNutritionFoodModel get userNutritionCustomFood => _userNutritionCustomFood;

  void setCustomFood(UserNutritionFoodModel userCustomFood) {
    _userNutritionCustomFood = userCustomFood;

  }

  void resetCurrentFood() {
    _currentFoodItem = FoodDefaultData();
  }

  void updateCustomFoodList(String barcode, String foodName, String servings, String servingSize) {

    _userNutritionCustomFood.barcodes.add(barcode);
    _userNutritionCustomFood.foodListItemNames.add(foodName);
    _userNutritionCustomFood.foodServings.add(servings);
    _userNutritionCustomFood.foodServingSize.add(servingSize);

    print(_userNutritionCustomFood.barcodes.length);

    UpdateUserCustomFoodData(userNutritionCustomFood);

    notifyListeners();

  }

  void setFoodHistory(UserNutritionFoodModel userHistory) {
    _userNutritionHistory = userHistory;

  }

  void updateFoodHistory(String barcode, String foodName, String servings, String servingSize, bool recipe) {

    if (!_userNutritionHistory.barcodes.contains(barcode)) {
      _userNutritionHistory.barcodes.insert(0, barcode);
      _userNutritionHistory.foodListItemNames.insert(0, foodName);
      _userNutritionHistory.foodServings.insert(0, servings);
      _userNutritionHistory.foodServingSize.insert(0, servingSize);
      _userNutritionHistory.recipe.insert(0, recipe);

      if (_userNutritionHistory.barcodes.length > 50) {
        _userNutritionHistory.barcodes.removeLast();
        _userNutritionHistory.foodListItemNames.removeLast();
        _userNutritionHistory.foodServings.removeLast();
        _userNutritionHistory.foodServingSize.removeLast();
        _userNutritionHistory.recipe.removeLast();
      }

      UpdateUserNutritionHistoryData(userNutritionHistory);

      notifyListeners();

    } else if (_userNutritionHistory.barcodes.contains(barcode)) {

      int index = _userNutritionHistory.barcodes.indexOf(barcode);

      _userNutritionHistory.barcodes.removeAt(index);
      _userNutritionHistory.foodListItemNames.removeAt(index);
      _userNutritionHistory.foodServings.removeAt(index);
      _userNutritionHistory.foodServingSize.removeAt(index);
      _userNutritionHistory.recipe.removeAt(index);

      _userNutritionHistory.barcodes.insert(0, barcode);
      _userNutritionHistory.foodListItemNames.insert(0, foodName);
      _userNutritionHistory.foodServings.insert(0, servings);
      _userNutritionHistory.foodServingSize.insert(0, servingSize);
      _userNutritionHistory.recipe.insert(0, recipe);

      UpdateUserNutritionHistoryData(userNutritionHistory);

      notifyListeners();

    }

  }

  String convertToUsableData(dynamic valueToConvert, {bool convertToNumber = true}) {

    if (valueToConvert != null) {
      valueToConvert = valueToConvert.toString();
      if (convertToNumber) {

        valueToConvert = valueToConvert.replaceAll(RegExp(r'[^0-9]'),' ');
        List valueToConvertList = valueToConvert.split(" ");
        valueToConvert = valueToConvertList[0];

        try {
          double.parse(valueToConvert);
        } catch (error) {
          valueToConvert = "0";
        }

      }
    } else {
      valueToConvert = "";
    }

    return valueToConvert;
  }

  void calculateMacros() {

    _calories = 0;
    _protein = 0;
    _fat = 0;
    _carbohydrates = 0;
    _fiber = 0;
    _sugar = 0;
    _saturatedFat = 0.0;
    _polyUnsaturatedFat = 0.0;
    _monoUnsaturatedFat = 0.0;
    _transFat = 0.0;
    _cholesterol = 0.0;
    _calcium = 0.0;
    _iron = 0.0;
    _sodium = 0.0;
    _zinc = 0.0;
    _magnesium = 0.0;
    _potassium = 0.0;
    _vitaminA = 0.0;
    _vitaminB1 = 0.0;
    _vitaminB2 = 0.0;
    _vitaminB3 = 0.0;
    _vitaminB6 = 0.0;
    _vitaminB9 = 0.0;
    _vitaminB12 = 0.0;
    _vitaminC = 0.0;
    _vitaminD = 0.0;
    _vitaminE = 0.0;
    _vitaminK = 0.0;
    _omega3 = 0.0;
    _omega6 = 0.0;
    _alcohol = 0.0;
    _biotin = 0.0;
    _butyricAcid = 0.0;
    _caffeine = 0.0;
    _capricAcid = 0.0;
    _caproicAcid = 0.0;
    _caprylicAcid = 0.0;
    _chloride = 0.0;
    _chromium = 0.0;
    _copper = 0.0;
    _docosahexaenoicAcid = 0.0;
    _eicosapentaenoicAcid = 0.0;
    _erucicAcid = 0.0;
    _fluoride = 0.0;
    _iodine = 0.0;
    _manganese = 0.0;
    _molybdenum = 0.0;
    _myristicAcid = 0.0;
    _oleicAcid = 0.0;
    _palmiticAcid = 0.0;
    _pantothenicAcid = 0.0;
    _selenium = 0.0;
    _stearicAcid = 0.0;

    void calculateTotal(List<ListFoodItem> listOfFood) {
      for (var foodItem in listOfFood) {
        try {
          _calories += (double.parse(foodItem.foodItemData.calories)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _calories += 0;
        }
        try {
          _protein += (double.parse(foodItem.foodItemData.proteins)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _protein += 0;
        }
        try {
          _fat += (double.parse(foodItem.foodItemData.fat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _fat += 0;
        }
        try {
          _carbohydrates += (double.parse(foodItem.foodItemData.carbs)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _carbohydrates += 0;
        }
        try {
          _fiber += (double.parse(foodItem.foodItemData.fiber)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _fiber += 0;
        }
        try {
          _sugar += (double.parse(foodItem.foodItemData.sugars)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _sugar += 0;
        }
        try {
          _saturatedFat += (double.parse(foodItem.foodItemData.saturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _saturatedFat += 0;
        }
        try {
          _polyUnsaturatedFat += (double.parse(foodItem.foodItemData.polyUnsaturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _polyUnsaturatedFat += 0;
        }
        try {
          _monoUnsaturatedFat += (double.parse(foodItem.foodItemData.monoUnsaturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _monoUnsaturatedFat += 0;
        }
        try {
          _transFat += (double.parse(foodItem.foodItemData.transFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _transFat += 0;
        }
        try {
          _cholesterol += (double.parse(foodItem.foodItemData.cholesterol)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _cholesterol += 0;
        }
        try {
          _calcium += (double.parse(foodItem.foodItemData.calcium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _calcium += 0;
        }
        try {
          _iron += (double.parse(foodItem.foodItemData.iron)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _iron += 0;
        }
        try {
          _sodium += (double.parse(foodItem.foodItemData.sodium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _sodium += 0;
        }
        try {
          _zinc += (double.parse(foodItem.foodItemData.zinc)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _zinc += 0;
        }
        try {
          _magnesium += (double.parse(foodItem.foodItemData.magnesium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _magnesium += 0;
        }
        try {
          _potassium += (double.parse(foodItem.foodItemData.potassium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _potassium += 0;
        }
        try {
          _vitaminA += (double.parse(foodItem.foodItemData.vitaminA)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminA += 0;
        }
        try {
          _vitaminB1 += (double.parse(foodItem.foodItemData.vitaminB1)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB1 += 0;
        }
        try {
          _vitaminB2 += (double.parse(foodItem.foodItemData.vitaminB2)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB2 += 0;
        }
        try {
          _vitaminB3 += (double.parse(foodItem.foodItemData.vitaminB3)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB3 += 0;
        }
        try {
          _vitaminB6 += (double.parse(foodItem.foodItemData.vitaminB6)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB6 += 0;
        }
        try {
          _vitaminB9 += (double.parse(foodItem.foodItemData.vitaminB9)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB9 += 0;
        }
        try {
          _vitaminB12 += (double.parse(foodItem.foodItemData.vitaminB12)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminB12 += 0;
        }
        try {
          _vitaminC += (double.parse(foodItem.foodItemData.vitaminC)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminC += 0;
        }
        try {
          _vitaminD += (double.parse(foodItem.foodItemData.vitaminD)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminD += 0;
        }
        try {
          _vitaminE += (double.parse(foodItem.foodItemData.vitaminE)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminE += 0;
        }
        try {
          _vitaminK += (double.parse(foodItem.foodItemData.vitaminK)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _vitaminK += 0;
        }
        try {
          _omega3 += (double.parse(foodItem.foodItemData.omega3)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _omega3 += 0;
        }
        try {
          _omega6 += (double.parse(foodItem.foodItemData.omega6)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _omega6 += 0;
        }
        try {
          _alcohol += (double.parse(foodItem.foodItemData.alcohol)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _alcohol += 0;
        }
        try {
          _biotin += (double.parse(foodItem.foodItemData.biotin)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _biotin += 0;
        }
        try {
          _butyricAcid += (double.parse(foodItem.foodItemData.butyricAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _butyricAcid += 0;
        }
        try {
          _caffeine += (double.parse(foodItem.foodItemData.caffeine)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _caffeine += 0;
        }
        try {
          _capricAcid += (double.parse(foodItem.foodItemData.capricAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _capricAcid += 0;
        }
        try {
          _caproicAcid += (double.parse(foodItem.foodItemData.caproicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _caproicAcid += 0;
        }
        try {
          _caprylicAcid += (double.parse(foodItem.foodItemData.caprylicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _caprylicAcid += 0;
        }
        try {
          _chloride += (double.parse(foodItem.foodItemData.chloride)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _chloride += 0;
        }
        try {
          _chromium += (double.parse(foodItem.foodItemData.chromium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _chromium += 0;
        }
        try {
          _copper += (double.parse(foodItem.foodItemData.copper)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _copper += 0;
        }
        try {
          _docosahexaenoicAcid += (double.parse(foodItem.foodItemData.docosahexaenoicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _docosahexaenoicAcid += 0;
        }
        try {
          _eicosapentaenoicAcid += (double.parse(foodItem.foodItemData.eicosapentaenoicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _eicosapentaenoicAcid += 0;
        }
        try {
          _erucicAcid += (double.parse(foodItem.foodItemData.erucicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _erucicAcid += 0;
        }
        try {
          _fluoride += (double.parse(foodItem.foodItemData.fluoride)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _fluoride += 0;
        }
        try {
          _iodine += (double.parse(foodItem.foodItemData.iodine)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _iodine += 0;
        }
        try {
          _manganese += (double.parse(foodItem.foodItemData.manganese)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _manganese += 0;
        }
        try {
          _molybdenum += (double.parse(foodItem.foodItemData.molybdenum)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _molybdenum += 0;
        }
        try {
          _myristicAcid += (double.parse(foodItem.foodItemData.myristicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _myristicAcid += 0;
        }
        try {
          _oleicAcid += (double.parse(foodItem.foodItemData.oleicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _oleicAcid += 0;
        }
        try {
          _palmiticAcid += (double.parse(foodItem.foodItemData.palmiticAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _palmiticAcid += 0;
        }
        try {
          _pantothenicAcid += (double.parse(foodItem.foodItemData.pantothenicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _pantothenicAcid += 0;
        }
        try {
          _selenium += (double.parse(foodItem.foodItemData.selenium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _selenium += 0;
        }
        try {
          _stearicAcid += (double.parse(foodItem.foodItemData.stearicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _stearicAcid += 0;
        }
      }
    }

    calculateTotal(_userDailyNutrition.foodListItemsBreakfast);
    calculateTotal(_userDailyNutrition.foodListItemsLunch);
    calculateTotal(_userDailyNutrition.foodListItemsDinner);
    calculateTotal(_userDailyNutrition.foodListItemsSnacks);

    notifyListeners();

  }

  void setCurrentFoodDiary(UserNutritionModel diary) {
    _isCurrentFoodItemLoaded = false;

    _userDailyNutrition = diary;

    print("LOADED ITEMS");
    _isCurrentFoodItemLoaded = true;

    calculateMacros();

    notifyListeners();

  }

  void deleteFoodFromDiary(int index, String category) {
    if (category.toLowerCase() == "breakfast") {
      _userDailyNutrition.foodListItemsBreakfast.removeAt(index);
    } else if (category.toLowerCase() == "lunch") {
      _userDailyNutrition.foodListItemsLunch.removeAt(index);
    } else if (category.toLowerCase() == "dinner") {
      _userDailyNutrition.foodListItemsDinner.removeAt(index);
    } else if (category.toLowerCase() == "snacks") {
      _userDailyNutrition.foodListItemsSnacks.removeAt(index);
    }

    UpdateUserNutritionalData(_userDailyNutrition);

    calculateMacros();

    notifyListeners();
  }

  void editFoodItemInDiary(FoodItem item, String category, String servings,
      String servingSize, index, recipe) {

    print("EDITING DATA");

    _userDailyNutrition.date = _nutritionDate.toString();

    if (category.toLowerCase() == "breakfast") {
      _userDailyNutrition.foodListItemsBreakfast[index] = (ListFoodItem(
        barcode: item.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: item,
        recipe: recipe,
      ));

      //_userDailyNutrition.foodListItemsDinner += _foodListItemsDinner;
    } else if (category.toLowerCase() == "lunch") {
      _userDailyNutrition.foodListItemsLunch[index] = (ListFoodItem(
        barcode: item.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: item,
        recipe: recipe,
      ));

      //_userDailyNutrition.foodListItemsSnacks += _foodListItemsSnacks;
    } else if (category.toLowerCase() == "dinner") {
      _userDailyNutrition.foodListItemsDinner[index] = (ListFoodItem(
        barcode: item.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: item,
        recipe: recipe,
      ));

      //_userDailyNutrition.foodListItemsSnacks += _foodListItemsSnacks;
    } else if (category.toLowerCase() == "snacks") {
      _userDailyNutrition.foodListItemsSnacks[index] = (ListFoodItem(
        barcode: item.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: item,
        recipe: recipe,
      ));

      //_userDailyNutrition.foodListItemsSnacks += _foodListItemsSnacks;
    }

    UpdateUserNutritionalData(_userDailyNutrition);

    calculateMacros();

    notifyListeners();
  }

  void editFoodItemInRecipe(FoodItem item, String category, String servings,
      String servingSize, index, recipe) {


    _currentRecipe.recipeFoodList[index] = (ListFoodItem(
      barcode: item.barcode,
      category: category,
      foodServings: servings,
      foodServingSize: servingSize,
      foodItemData: item,
      recipe: recipe,
    ));

    calculateRecipeMacros();

    notifyListeners();
  }

  void removeFoodItemFromRecipe(int index) {
    _currentRecipe.recipeFoodList.removeAt(index);

    calculateRecipeMacros();

    notifyListeners();
  }

  void updateRecipeServings(String servings) {

    try {
      _currentRecipe.foodData.servings = servings;
      _currentRecipe.foodData.servingSize = (double.parse(_currentRecipe.foodData.quantity) / double.parse(servings)).toStringAsFixed(1);

      calculateRecipeMacros();
    } catch (error) {
      _currentRecipe.foodData.servings = "";
      _currentRecipe.foodData.servingSize = "";

      calculateRecipeMacros();
      notifyListeners();
    }

  }

  void resetCurrentRecipe() {
    _currentRecipe = UserRecipesModel(
      barcode: "",
      recipeFoodList: [],
      foodData: FoodItem(
        barcode: "",
        foodName: "",
        quantity: "",
        servingSize: "",
        servings: "",
        calories: "",
        kiloJoules: "",
        proteins: "",
        carbs: "",
        fiber: "",
        sugars: "",
        fat: "",
        saturatedFat: "",
        polyUnsaturatedFat: "",
        monoUnsaturatedFat: "",
        transFat: "",
        cholesterol: "",
        calcium: "",
        iron: "",
        sodium: "",
        zinc: "",
        magnesium: "",
        potassium: "",
        vitaminA: "",
        vitaminB1: "",
        vitaminB2: "",
        vitaminB3: "",
        vitaminB6: "",
        vitaminB9: "",
        vitaminB12: "",
        vitaminC: "",
        vitaminD: "",
        vitaminE: "",
        vitaminK: "",
        omega3: "",
        omega6: "",
        alcohol: "",
        biotin: "",
        butyricAcid: "",
        caffeine: "",
        capricAcid: "",
        caproicAcid: "",
        caprylicAcid: "",
        chloride: "",
        chromium: "",
        copper: "",
        docosahexaenoicAcid: "",
        eicosapentaenoicAcid: "",
        erucicAcid: "",
        fluoride: "",
        iodine: "",
        manganese: "",
        molybdenum: "",
        myristicAcid: "",
        oleicAcid: "",
        palmiticAcid: "",
        pantothenicAcid: "",
        selenium: "",
        stearicAcid: "",
      ),
    );

    notifyListeners();
  }

  void setCurrentRecipe(UserRecipesModel recipeItem) {
    _currentRecipe = recipeItem;

  }

  void setCurrentRecipeFood(List<ListFoodItem> recipeFoodList) {
    _currentRecipe.recipeFoodList = recipeFoodList;

  }

  void addFoodItemToRecipe(FoodItem newItem, String category, String servings,
      String servingSize, recipe) {
      _currentRecipe.recipeFoodList.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: newItem,
        recipe: recipe,
      ));

      calculateRecipeMacros();

      updateRecipeServings(_currentRecipe.foodData.servings);

      notifyListeners();
  }

  late UserNutritionFoodModel _userNutritionCustomRecipes = UserNutritionFoodModel(
      barcodes: [], foodListItemNames: [], foodServings: [], foodServingSize: [], recipe: []);

  UserNutritionFoodModel get userNutritionCustomRecipes => _userNutritionCustomRecipes;

  void updateRecipeFoodList(String barcode, String foodName, String servings, String servingSize) {

    _userNutritionCustomRecipes.barcodes.add(barcode);
    _userNutritionCustomRecipes.foodListItemNames.add(foodName);
    _userNutritionCustomRecipes.foodServings.add(servings);
    _userNutritionCustomRecipes.foodServingSize.add(servingSize);

    print(_userNutritionCustomRecipes.barcodes.length);

    UpdateUserCustomRecipeData(userNutritionCustomRecipes);

    notifyListeners();

  }

  void createRecipe(String foodName, String barcode) {
    _currentRecipe.foodData.foodName = foodName;
    _currentRecipe.foodData.barcode = barcode;
    _currentRecipe.barcode = barcode;

    UpdateRecipeFoodData(currentRecipe);

    if (!_userNutritionCustomRecipes.barcodes.contains(barcode)) {
      updateRecipeFoodList(barcode, foodName, _currentRecipe.foodData.servings, _currentRecipe.foodData.servingSize);
    }

  }

  void setCustomRecipes(UserNutritionFoodModel userRecipes) {
    _userNutritionCustomRecipes = userRecipes;

  }

  void updateRecipename(String foodName) {
    _currentRecipe.foodData.foodName = foodName;
  }

  late double _recipeweight = 0;
  late double _recipecalories = 0;
  late double _recipeprotein = 0;
  late double _recipefat = 0;
  late double _recipecarbohydrates = 0;
  late double _recipefiber = 0;
  late double _recipesugar = 0;
  late double _recipesaturatedFat = 0.0;
  late double _recipepolyUnsaturatedFat = 0.0;
  late double _recipemonoUnsaturatedFat = 0.0;
  late double _recipetransFat = 0.0;
  late double _recipecholesterol = 0.0;
  late double _recipecalcium = 0.0;
  late double _recipeiron = 0.0;
  late double _recipesodium = 0.0;
  late double _recipezinc = 0.0;
  late double _recipemagnesium = 0.0;
  late double _recipepotassium = 0.0;
  late double _recipevitaminA = 0.0;
  late double _recipevitaminB1 = 0.0;
  late double _recipevitaminB2 = 0.0;
  late double _recipevitaminB3 = 0.0;
  late double _recipevitaminB6 = 0.0;
  late double _recipevitaminB9 = 0.0;
  late double _recipevitaminB12 = 0.0;
  late double _recipevitaminC = 0.0;
  late double _recipevitaminD = 0.0;
  late double _recipevitaminE = 0.0;
  late double _recipevitaminK = 0.0;
  late double _recipeomega3 = 0.0;
  late double _recipeomega6 = 0.0;
  late double _recipealcohol = 0.0;
  late double _recipebiotin = 0.0;
  late double _recipebutyricAcid = 0.0;
  late double _recipecaffeine = 0.0;
  late double _recipecapricAcid = 0.0;
  late double _recipecaproicAcid = 0.0;
  late double _recipecaprylicAcid = 0.0;
  late double _recipechloride = 0.0;
  late double _recipechromium = 0.0;
  late double _recipecopper = 0.0;
  late double _recipedocosahexaenoicAcid = 0.0;
  late double _recipeeicosapentaenoicAcid = 0.0;
  late double _recipeerucicAcid = 0.0;
  late double _recipefluoride = 0.0;
  late double _recipeiodine = 0.0;
  late double _recipemanganese = 0.0;
  late double _recipemolybdenum = 0.0;
  late double _recipemyristicAcid = 0.0;
  late double _recipeoleicAcid = 0.0;
  late double _recipepalmiticAcid = 0.0;
  late double _recipepantothenicAcid = 0.0;
  late double _recipeselenium = 0.0;
  late double _recipestearicAcid = 0.0;

  double get recipeweight => _recipeweight;
  double get recipecalories => _recipecalories;
  double get recipeprotein => _recipeprotein;
  double get recipefat => _recipefat;
  double get recipecarbohydrates => _recipecarbohydrates;
  double get recipefiber => _recipefiber;
  double get recipesugar => _recipesugar;
  double get recipesaturatedFat => _recipesaturatedFat;
  double get recipepolyUnsaturatedFat => _recipepolyUnsaturatedFat;
  double get recipemonoUnsaturatedFat => _recipemonoUnsaturatedFat;
  double get recipetransFat => _recipetransFat;
  double get recipecholesterol => _recipecholesterol;
  double get recipecalcium => _recipecalcium;
  double get recipeiron => _recipeiron;
  double get recipesodium => _recipesodium;
  double get recipezinc => _recipezinc;
  double get recipemagnesium => _recipemagnesium;
  double get recipepotassium => _recipepotassium;
  double get recipevitaminA => _recipevitaminA;
  double get recipevitaminB1 => _recipevitaminB1;
  double get recipevitaminB2 => _recipevitaminB2;
  double get recipevitaminB3 => _recipevitaminB3;
  double get recipevitaminB6 => _recipevitaminB6;
  double get recipevitaminB9 => _recipevitaminB9;
  double get recipevitaminB12 => _recipevitaminB12;
  double get recipevitaminC => _recipevitaminC;
  double get recipevitaminD => _recipevitaminD;
  double get recipevitaminE => _recipevitaminE;
  double get recipevitaminK => _recipevitaminK;
  double get recipeomega3 => _recipeomega3;
  double get recipeomega6 => _recipeomega6;
  double get recipealcohol => _recipealcohol;
  double get recipebiotin => _recipebiotin;
  double get recipebutyricAcid => _recipebutyricAcid;
  double get recipecaffeine => _recipecaffeine;
  double get recipecapricAcid => _recipecapricAcid;
  double get recipecaproicAcid => _recipecaproicAcid;
  double get recipecaprylicAcid => _recipecaprylicAcid;
  double get recipechloride => _recipechloride;
  double get recipechromium => _recipechromium;
  double get recipecopper => _recipecopper;
  double get recipedocosahexaenoicAcid => _recipedocosahexaenoicAcid;
  double get recipeeicosapentaenoicAcid => _recipeeicosapentaenoicAcid;
  double get recipeerucicAcid => _recipeerucicAcid;
  double get recipefluoride => _recipefluoride;
  double get recipeiodine => _recipeiodine;
  double get recipemanganese => _recipemanganese;
  double get recipemolybdenum => _recipemolybdenum;
  double get recipemyristicAcid => _recipemyristicAcid;
  double get recipeoleicAcid => _recipeoleicAcid;
  double get recipepalmiticAcid => _recipepalmiticAcid;
  double get recipepantothenicAcid => _recipepantothenicAcid;
  double get recipeselenium => _recipeselenium;
  double get recipestearicAcid => _recipestearicAcid;

  void calculateRecipeMacros() {

    _recipeweight = 0;
    _recipecalories = 0;
    _recipeprotein = 0;
    _recipefat = 0;
    _recipecarbohydrates = 0;
    _recipefiber = 0;
    _recipesugar = 0;
    _recipesaturatedFat = 0.0;
    _recipepolyUnsaturatedFat = 0.0;
    _recipemonoUnsaturatedFat = 0.0;
    _recipetransFat = 0.0;
    _recipecholesterol = 0.0;
    _recipecalcium = 0.0;
    _recipeiron = 0.0;
    _recipesodium = 0.0;
    _recipezinc = 0.0;
    _recipemagnesium = 0.0;
    _recipepotassium = 0.0;
    _recipevitaminA = 0.0;
    _recipevitaminB1 = 0.0;
    _recipevitaminB2 = 0.0;
    _recipevitaminB3 = 0.0;
    _recipevitaminB6 = 0.0;
    _recipevitaminB9 = 0.0;
    _recipevitaminB12 = 0.0;
    _recipevitaminC = 0.0;
    _recipevitaminD = 0.0;
    _recipevitaminE = 0.0;
    _recipevitaminK = 0.0;
    _recipeomega3 = 0.0;
    _recipeomega6 = 0.0;
    _recipealcohol = 0.0;
    _recipebiotin = 0.0;
    _recipebutyricAcid = 0.0;
    _recipecaffeine = 0.0;
    _recipecapricAcid = 0.0;
    _recipecaproicAcid = 0.0;
    _recipecaprylicAcid = 0.0;
    _recipechloride = 0.0;
    _recipechromium = 0.0;
    _recipecopper = 0.0;
    _recipedocosahexaenoicAcid = 0.0;
    _recipeeicosapentaenoicAcid = 0.0;
    _recipeerucicAcid = 0.0;
    _recipefluoride = 0.0;
    _recipeiodine = 0.0;
    _recipemanganese = 0.0;
    _recipemolybdenum = 0.0;
    _recipemyristicAcid = 0.0;
    _recipeoleicAcid = 0.0;
    _recipepalmiticAcid = 0.0;
    _recipepantothenicAcid = 0.0;
    _recipeselenium = 0.0;
    _recipestearicAcid = 0.0;

    void calculateTotal(List<ListFoodItem> listOfFood) {
      for (var foodItem in listOfFood) {
        try {
          print("serving size " + foodItem.foodItemData.servingSize);
          print("servings " + foodItem.foodServings);
          _recipeweight += (double.parse(foodItem.foodServingSize)) * (double.parse(foodItem.foodServings));
        } catch (exception) {
          _recipeweight += 0;
        }
        try {
          _recipecalories += (double.parse(foodItem.foodItemData.calories)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecalories += 0;
        }
        try {
          _recipeprotein += (double.parse(foodItem.foodItemData.proteins)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeprotein += 0;
        }
        try {
          _recipefat += (double.parse(foodItem.foodItemData.fat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipefat += 0;
        }
        try {
          _recipecarbohydrates += (double.parse(foodItem.foodItemData.carbs)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecarbohydrates += 0;
        }
        try {
          _recipefiber += (double.parse(foodItem.foodItemData.fiber)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipefiber += 0;
        }
        try {
          _recipesugar += (double.parse(foodItem.foodItemData.sugars)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipesugar += 0;
        }
        try {
          _recipesaturatedFat += (double.parse(foodItem.foodItemData.saturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipesaturatedFat += 0;
        }
        try {
          _recipepolyUnsaturatedFat += (double.parse(foodItem.foodItemData.polyUnsaturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipepolyUnsaturatedFat += 0;
        }
        try {
          _recipemonoUnsaturatedFat += (double.parse(foodItem.foodItemData.monoUnsaturatedFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipemonoUnsaturatedFat += 0;
        }
        try {
          _recipetransFat += (double.parse(foodItem.foodItemData.transFat)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipetransFat += 0;
        }
        try {
          _recipecholesterol += (double.parse(foodItem.foodItemData.cholesterol)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecholesterol += 0;
        }
        try {
          _recipecalcium += (double.parse(foodItem.foodItemData.calcium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecalcium += 0;
        }
        try {
          _recipeiron += (double.parse(foodItem.foodItemData.iron)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeiron += 0;
        }
        try {
          _recipesodium += (double.parse(foodItem.foodItemData.sodium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipesodium += 0;
        }
        try {
          _recipezinc += (double.parse(foodItem.foodItemData.zinc)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipezinc += 0;
        }
        try {
          _recipemagnesium += (double.parse(foodItem.foodItemData.magnesium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipemagnesium += 0;
        }
        try {
          _recipepotassium += (double.parse(foodItem.foodItemData.potassium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipepotassium += 0;
        }
        try {
          _recipevitaminA += (double.parse(foodItem.foodItemData.vitaminA)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminA += 0;
        }
        try {
          _recipevitaminB1 += (double.parse(foodItem.foodItemData.vitaminB1)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB1 += 0;
        }
        try {
          _recipevitaminB2 += (double.parse(foodItem.foodItemData.vitaminB2)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB2 += 0;
        }
        try {
          _recipevitaminB3 += (double.parse(foodItem.foodItemData.vitaminB3)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB3 += 0;
        }
        try {
          _recipevitaminB6 += (double.parse(foodItem.foodItemData.vitaminB6)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB6 += 0;
        }
        try {
          _recipevitaminB9 += (double.parse(foodItem.foodItemData.vitaminB9)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB9 += 0;
        }
        try {
          _recipevitaminB12 += (double.parse(foodItem.foodItemData.vitaminB12)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminB12 += 0;
        }
        try {
          _recipevitaminC += (double.parse(foodItem.foodItemData.vitaminC)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminC += 0;
        }
        try {
          _recipevitaminD += (double.parse(foodItem.foodItemData.vitaminD)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminD += 0;
        }
        try {
          _recipevitaminE += (double.parse(foodItem.foodItemData.vitaminE)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminE += 0;
        }
        try {
          _recipevitaminK += (double.parse(foodItem.foodItemData.vitaminK)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipevitaminK += 0;
        }
        try {
          _recipeomega3 += (double.parse(foodItem.foodItemData.omega3)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeomega3 += 0;
        }
        try {
          _recipeomega6 += (double.parse(foodItem.foodItemData.omega6)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeomega6 += 0;
        }
        try {
          _recipealcohol += (double.parse(foodItem.foodItemData.alcohol)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipealcohol += 0;
        }
        try {
          _recipebiotin += (double.parse(foodItem.foodItemData.biotin)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipebiotin += 0;
        }
        try {
          _recipebutyricAcid += (double.parse(foodItem.foodItemData.butyricAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipebutyricAcid += 0;
        }
        try {
          _recipecaffeine += (double.parse(foodItem.foodItemData.caffeine)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecaffeine += 0;
        }
        try {
          _recipecapricAcid += (double.parse(foodItem.foodItemData.capricAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecapricAcid += 0;
        }
        try {
          _recipecaproicAcid += (double.parse(foodItem.foodItemData.caproicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecaproicAcid += 0;
        }
        try {
          _recipecaprylicAcid += (double.parse(foodItem.foodItemData.caprylicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecaprylicAcid += 0;
        }
        try {
          _recipechloride += (double.parse(foodItem.foodItemData.chloride)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipechloride += 0;
        }
        try {
          _recipechromium += (double.parse(foodItem.foodItemData.chromium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipechromium += 0;
        }
        try {
          _recipecopper += (double.parse(foodItem.foodItemData.copper)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipecopper += 0;
        }
        try {
          _recipedocosahexaenoicAcid += (double.parse(foodItem.foodItemData.docosahexaenoicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipedocosahexaenoicAcid += 0;
        }
        try {
          _recipeeicosapentaenoicAcid += (double.parse(foodItem.foodItemData.eicosapentaenoicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeeicosapentaenoicAcid += 0;
        }
        try {
          _recipeerucicAcid += (double.parse(foodItem.foodItemData.erucicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeerucicAcid += 0;
        }
        try {
          _recipefluoride += (double.parse(foodItem.foodItemData.fluoride)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipefluoride += 0;
        }
        try {
          _recipeiodine += (double.parse(foodItem.foodItemData.iodine)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeiodine += 0;
        }
        try {
          _recipemanganese += (double.parse(foodItem.foodItemData.manganese)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipemanganese += 0;
        }
        try {
          _recipemolybdenum += (double.parse(foodItem.foodItemData.molybdenum)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipemolybdenum += 0;
        }
        try {
          _recipemyristicAcid += (double.parse(foodItem.foodItemData.myristicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipemyristicAcid += 0;
        }
        try {
          _recipeoleicAcid += (double.parse(foodItem.foodItemData.oleicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeoleicAcid += 0;
        }
        try {
          _recipepalmiticAcid += (double.parse(foodItem.foodItemData.palmiticAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipepalmiticAcid += 0;
        }
        try {
          _recipepantothenicAcid += (double.parse(foodItem.foodItemData.pantothenicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipepantothenicAcid += 0;
        }
        try {
          _recipeselenium += (double.parse(foodItem.foodItemData.selenium)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipeselenium += 0;
        }
        try {
          _recipestearicAcid += (double.parse(foodItem.foodItemData.stearicAcid)/100) * (double.parse(foodItem.foodServings) * double.parse(foodItem.foodServingSize));
        } catch (exception) {
          _recipestearicAcid += 0;
        }
      }
    }

    calculateTotal(_currentRecipe.recipeFoodList);

    _currentRecipe.foodData = FoodItem(
        barcode: _currentRecipe.barcode,
        foodName: _currentRecipe.foodData.foodName,
        quantity: recipeweight.toString(),
        servingSize: _currentRecipe.foodData.servingSize,
        servings: _currentRecipe.foodData.servings,
        calories: ((recipecalories/recipeweight)*100).toStringAsFixed(1),
        kiloJoules: "",
        proteins: ((recipeprotein/recipeweight)*100).toStringAsFixed(1),
        carbs: ((recipecarbohydrates/recipeweight)*100).toStringAsFixed(1),
        fiber: ((recipefiber/recipeweight)*100).toStringAsFixed(1),
        sugars: ((recipesugar/recipeweight)*100).toStringAsFixed(1),
        fat: ((recipefat/recipeweight)*100).toStringAsFixed(1),
        saturatedFat: ((recipesaturatedFat/recipeweight)*100).toStringAsFixed(1),
        polyUnsaturatedFat: ((recipepolyUnsaturatedFat/recipeweight)*100).toStringAsFixed(1),
        monoUnsaturatedFat: ((recipemonoUnsaturatedFat/recipeweight)*100).toStringAsFixed(1),
        transFat: ((recipetransFat/recipeweight)*100).toStringAsFixed(1),
        cholesterol: ((recipecholesterol/recipeweight)*100).toStringAsFixed(1),
        calcium: ((recipecalcium/recipeweight)*100).toStringAsFixed(1),
        iron: ((recipeiron/recipeweight)*100).toStringAsFixed(1),
        sodium: ((recipesodium/recipeweight)*100).toStringAsFixed(1),
        zinc: ((recipezinc/recipeweight)*100).toStringAsFixed(1),
        magnesium: ((recipemagnesium/recipeweight)*100).toStringAsFixed(1),
        potassium: ((recipepotassium/recipeweight)*100).toStringAsFixed(1),
        vitaminA: ((recipevitaminA/recipeweight)*100).toStringAsFixed(1),
        vitaminB1: ((recipevitaminB1/recipeweight)*100).toStringAsFixed(1),
        vitaminB2: ((recipevitaminB2/recipeweight)*100).toStringAsFixed(1),
        vitaminB3: ((recipevitaminB3/recipeweight)*100).toStringAsFixed(1),
        vitaminB6: ((recipevitaminB6/recipeweight)*100).toStringAsFixed(1),
        vitaminB9: ((recipevitaminB9/recipeweight)*100).toStringAsFixed(1),
        vitaminB12: ((recipevitaminB12/recipeweight)*100).toStringAsFixed(1),
        vitaminC: ((recipevitaminC/recipeweight)*100).toStringAsFixed(1),
        vitaminD: ((recipevitaminD/recipeweight)*100).toStringAsFixed(1),
        vitaminE: ((recipevitaminE/recipeweight)*100).toStringAsFixed(1),
        vitaminK: ((recipevitaminK/recipeweight)*100).toStringAsFixed(1),
        omega3: ((recipeomega3/recipeweight)*100).toStringAsFixed(1),
        omega6: ((recipeomega6/recipeweight)*100).toStringAsFixed(1),
        alcohol: ((recipealcohol/recipeweight)*100).toStringAsFixed(1),
        biotin: ((recipebiotin/recipeweight)*100).toStringAsFixed(1),
        butyricAcid: ((recipebutyricAcid/recipeweight)*100).toStringAsFixed(1),
        caffeine: ((recipecaffeine/recipeweight)*100).toStringAsFixed(1),
        capricAcid: ((recipecapricAcid/recipeweight)*100).toStringAsFixed(1),
        caproicAcid: ((recipecaproicAcid/recipeweight)*100).toStringAsFixed(1),
        caprylicAcid: ((recipecaprylicAcid/recipeweight)*100).toStringAsFixed(1),
        chloride: ((recipechloride/recipeweight)*100).toStringAsFixed(1),
        chromium: ((recipechromium/recipeweight)*100).toStringAsFixed(1),
        copper: ((recipecopper/recipeweight)*100).toStringAsFixed(1),
        docosahexaenoicAcid: ((recipedocosahexaenoicAcid/recipeweight)*100).toStringAsFixed(1),
        eicosapentaenoicAcid: ((recipeeicosapentaenoicAcid/recipeweight)*100).toStringAsFixed(1),
        erucicAcid: ((recipeerucicAcid/recipeweight)*100).toStringAsFixed(1),
        fluoride: ((recipefluoride/recipeweight)*100).toStringAsFixed(1),
        iodine: ((recipeiodine/recipeweight)*100).toStringAsFixed(1),
        manganese: ((recipemanganese/recipeweight)*100).toStringAsFixed(1),
        molybdenum: ((recipemolybdenum/recipeweight)*100).toStringAsFixed(1),
        myristicAcid: ((recipemyristicAcid/recipeweight)*100).toStringAsFixed(1),
        oleicAcid: ((recipeoleicAcid/recipeweight)*100).toStringAsFixed(1),
        palmiticAcid: ((recipepalmiticAcid/recipeweight)*100).toStringAsFixed(1),
        pantothenicAcid: ((recipepantothenicAcid/recipeweight)*100).toStringAsFixed(1),
        selenium: ((recipeselenium/recipeweight)*100).toStringAsFixed(1),
        stearicAcid: ((recipestearicAcid/recipeweight)*100).toStringAsFixed(1),
        recipe: true,
    );

    notifyListeners();

  }

  void addFoodItemToDiary(FoodItem newItem, String category, String servings,
      String servingSize, recipe) {

    print("ADDING DATA");

    _isCurrentFoodItemLoaded = false;

    _userDailyNutrition.date = _nutritionDate.toString();

    if (category.toLowerCase() == "breakfast") {

      _userDailyNutrition.foodListItemsBreakfast.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: newItem,
        recipe: recipe,
      ));

    } else if (category.toLowerCase() == "lunch") {
      _userDailyNutrition.foodListItemsLunch.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: newItem,
        recipe: recipe,
      ));

    } else if (category.toLowerCase() == "dinner") {
      _userDailyNutrition.foodListItemsDinner.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: newItem,
        recipe: recipe,
      ));

    } else if (category.toLowerCase() == "snacks") {
      _userDailyNutrition.foodListItemsSnacks.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodServings: servings,
        foodServingSize: servingSize,
        foodItemData: newItem,
        recipe: recipe,
      ));

    }

    UpdateUserNutritionalData(_userDailyNutrition);

    calculateMacros();

    _currentFoodItem = FoodDefaultData();

    _isCurrentFoodItemLoaded = true;

    notifyListeners();
  }

  void updateCurrentFoodListItem(ListFoodItem newItem) {
    _currentFoodListItem = newItem;
  }

  void updateCurrentFoodItemServings(String servings) {
    _currentFoodListItem.foodServings = servings;

    notifyListeners();
  }

  void updateCurrentFoodItemServingSize(String servingSize) {
    _currentFoodListItem.foodServingSize = servingSize;

    notifyListeners();
  }

  void updateCurrentFoodItem(String barcode,
      String foodName,
      String quantity,
      String servingSize,
      String servings,
      String calories,
      String kiloJoules,
      String proteins,
      String carbs,
      String fiber,
      String sugars,
      String fat,
      String saturatedFat,
      String polyUnsaturatedFat,
      String monoUnsaturatedFat,
      String transFat,
      String cholesterol,
      String calcium,
      String iron,
      String sodium,
      String zinc,
      String magnesium,
      String potassium,
      String vitaminA,
      String vitaminB1,
      String vitaminB2,
      String vitaminB3,
      String vitaminB6,
      String vitaminB9,
      String vitaminB12,
      String vitaminC,
      String vitaminD,
      String vitaminE,
      String vitaminK,
      String omega3,
      String omega6,
      String alcohol,
      String biotin,
      String butyricAcid,
      String caffeine,
      String capricAcid,
      String caproicAcid,
      String caprylicAcid,
      String chloride,
      String chromium,
      String copper,
      String docosahexaenoicAcid,
      String eicosapentaenoicAcid,
      String erucicAcid,
      String fluoride,
      String iodine,
      String manganese,
      String molybdenum,
      String myristicAcid,
      String oleicAcid,
      String palmiticAcid,
      String pantothenicAcid,
      String selenium,
      String stearicAcid,) {
    _currentFoodItem.barcode = barcode;
    _currentFoodItem.foodName = foodName;
    //_currentFoodItem.quantity = quantity;
    _currentFoodItem.servingSize = servingSize;
    //_currentFoodItem.servings = servings;
    _currentFoodItem.calories = calories;
    _currentFoodItem.kiloJoules = kiloJoules;
    _currentFoodItem.proteins = proteins;
    _currentFoodItem.carbs = carbs;
    _currentFoodItem.fiber = fiber;
    _currentFoodItem.sugars = sugars;
    _currentFoodItem.fat = fat;
    _currentFoodItem.saturatedFat = saturatedFat;
    _currentFoodItem.polyUnsaturatedFat = polyUnsaturatedFat;
    _currentFoodItem.monoUnsaturatedFat = monoUnsaturatedFat;
    _currentFoodItem.transFat = transFat;
    _currentFoodItem.cholesterol = cholesterol;
    _currentFoodItem.calcium = calcium;
    _currentFoodItem.iron = iron;
    _currentFoodItem.sodium = sodium;
    _currentFoodItem.zinc = zinc;
    _currentFoodItem.magnesium = magnesium;
    _currentFoodItem.potassium = potassium;
    _currentFoodItem.vitaminA = vitaminA;
    _currentFoodItem.vitaminB1 = vitaminB1;
    _currentFoodItem.vitaminB2 = vitaminB2;
    _currentFoodItem.vitaminB3 = vitaminB3;
    _currentFoodItem.vitaminB6 = vitaminB6;
    _currentFoodItem.vitaminB9 = vitaminB9;
    _currentFoodItem.vitaminB12 = vitaminB12;
    _currentFoodItem.vitaminC = vitaminC;
    _currentFoodItem.vitaminD = vitaminD;
    _currentFoodItem.vitaminE = vitaminE;
    _currentFoodItem.vitaminK = vitaminK;
    _currentFoodItem.omega3 = omega3;
    _currentFoodItem.omega6 = omega6;
    _currentFoodItem.alcohol = alcohol;
    _currentFoodItem.biotin = biotin;
    _currentFoodItem.butyricAcid = butyricAcid;
    _currentFoodItem.caffeine = caffeine;
    _currentFoodItem.capricAcid = capricAcid;
    _currentFoodItem.caproicAcid = caproicAcid;
    _currentFoodItem.caprylicAcid = caprylicAcid;
    _currentFoodItem.chloride = chloride;
    _currentFoodItem.chromium = chromium;
    _currentFoodItem.copper = copper;
    _currentFoodItem.docosahexaenoicAcid = docosahexaenoicAcid;
    _currentFoodItem.eicosapentaenoicAcid = eicosapentaenoicAcid;
    _currentFoodItem.erucicAcid = erucicAcid;
    _currentFoodItem.fluoride = fluoride;
    _currentFoodItem.iodine = iodine;
    _currentFoodItem.manganese = manganese;
    _currentFoodItem.molybdenum = molybdenum;
    _currentFoodItem.myristicAcid = myristicAcid;
    _currentFoodItem.oleicAcid = oleicAcid;
    _currentFoodItem.palmiticAcid = palmiticAcid;
    _currentFoodItem.pantothenicAcid = pantothenicAcid;
    _currentFoodItem.selenium = selenium;
    _currentFoodItem.stearicAcid = stearicAcid;

    notifyListeners();
  }

  void setCurrentFoodItem(FoodItem newFoodItem) {
    _currentFoodItem = newFoodItem;
    _currentFoodListItem = ListFoodItem(
      barcode: _currentFoodItem.barcode,
      category: "",
      foodServings: convertToUsableData(_currentFoodItem.servings),
      foodServingSize: convertToUsableData(_currentFoodItem.servingSize),
      foodItemData: newFoodItem,
      recipe: newFoodItem.recipe,
    );
  }

  void updateNutritionDate(DateTime date) {


    _nutritionDate = date;

    notifyListeners();
  }

  void updateNutritionDateArrows(bool _leftArrow) {


    if (_leftArrow) {
      _nutritionDate = _nutritionDate.subtract(const Duration(days: 1));
    } else {
      _nutritionDate = _nutritionDate.add(const Duration(days: 1));
    }

    notifyListeners();
  }
}