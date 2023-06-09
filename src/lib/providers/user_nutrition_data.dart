import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/user_nutrition_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import '../models/food_data_list_item.dart';
import '../models/food_item.dart';
import '../models/user_nutrition_model.dart';
import 'database_get.dart';
import 'database_write.dart';

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


  late FoodItem _currentFoodItem;
  late ListFoodItem _currentFoodListItem = ListFoodItem(barcode: "", category: "", foodName: "N/A", foodServings: "1", foodServingSize: "100", foodCalories: "", kiloJoules: "", proteins: "", carbs: "", fiber: "", sugars: "", fat: "", saturatedFat: "", polyUnsaturatedFat: "", monoUnsaturatedFat: "", transFat: "", cholesterol: "", calcium: "", iron: "", sodium: "", zinc: "", magnesium: "", potassium: "", vitaminA: "", vitaminB1: "", vitaminB2: "", vitaminB3: "", vitaminB6: "", vitaminB9: "", vitaminB12: "", vitaminC: "", vitaminD: "", vitaminE: "", vitaminK: "", omega3: "", omega6: "", alcohol: "", biotin: "", butyricAcid: "", caffeine: "", capricAcid: "", caproicAcid: "", caprylicAcid: "", chloride: "", chromium: "", copper: "", docosahexaenoicAcid: "", eicosapentaenoicAcid: "", erucicAcid: "", fluoride: "", iodine: "", manganese: "", molybdenum: "", myristicAcid: "", oleicAcid: "", palmiticAcid: "", pantothenicAcid: "", selenium: "", stearicAcid: "");
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

  late double _caloriesGoal = 2424;
  late double _proteinGoal = 160;
  late double _fatGoal = 85;
  late double _carbohydratesGoal = 286;

  //grams
  late double _fiberGoal = 30; // Recommended fiber intake for adults (general guideline)
  late double _sugarGoal = 50; // Maximum recommended sugar intake for adults (general guideline)
  late double _saturatedFatGoal = 20; // Maximum recommended saturated fat intake as a percentage of total calories (general guideline)
  late double _polyUnsaturatedFatGoal = 12; // Recommended polyunsaturated fat intake as a percentage of total calories (general guideline)
  late double _monoUnsaturatedFatGoal = 15; // Recommended monounsaturated fat intake as a percentage of total calories (general guideline)
  late double _transFatGoal = 0; // Maximum recommended trans fat intake (general guideline)
  late double _cholesterolGoal = 300; // Maximum recommended cholesterol intake in milligrams (general guideline)

  //mg
  late double _calciumGoal = 1000; // Example: Calcium goal for adults (general guideline)
  late double _ironGoal = 8; // Example: Iron goal for adults (general guideline)
  late double _sodiumGoal = 2300; // Example: Sodium goal for adults (general guideline)
  late double _zincGoal = 11; // Example: Zinc goal for adults (general guideline)
  late double _magnesiumGoal = 400; // Example: Magnesium goal for adults (general guideline)
  late double _potassiumGoal = 3500; // Example: Potassium goal

  //mg
  late double _vitaminAGoal = 0.800; // Example: Vitamin A goal for adults (general guideline)
  late double _vitaminB1Goal = 1.1; // Example: Thiamine (Vitamin B1) goal for adults (general guideline)
  late double _vitaminB2Goal = 1.3; // Example: Riboflavin (Vitamin B2) goal for adults (general guideline)
  late double _vitaminB3Goal = 16; // Example: Niacin (Vitamin B3) goal for adults (general guideline)
  late double _vitaminB6Goal = 1.3; // Example: Vitamin B6 goal for adults (general guideline)
  late double _vitaminB9Goal = 0.400; // Example: Folate (Vitamin B9) goal for adults (general guideline)
  late double _vitaminB12Goal = 2.4; // Example: Vitamin B12 goal for adults (general guideline)
  late double _vitaminCGoal = 90; // Example: Vitamin C goal for adults (general guideline)
  late double _vitaminDGoal = 15; // Example: Vitamin D goal for adults (general guideline)
  late double _vitaminEGoal = 15; // Example: Vitamin E goal for adults (general guideline)
  late double _vitaminKGoal = 75; // Example: Vitamin K goal for adults (general guideline)

  late double _alcoholGoal = 0;
  late double _caffeineGoal = 0;

  //mg
  late double _omega3Goal = 1000; // mg of combined EPA and DHA per day
  late double _omega6Goal = 12000; // approximate ratio of 4:1 (omega-6 to omega-3)
  late double _biotinGoal = 0.30; // mcg per day
  late double _butyricAcidGoal = 150; // no specific recommendation
  late double _capricAcidGoal = 1000; // no specific recommendation
  late double _caproicAcidGoal = 0; // no specific recommendation
  late double _caprylicAcidGoal = 1000; // no specific recommendation
  late double _chlorideGoal = 2300; // mg per day
  late double _chromiumGoal = 0.25; // mcg per day
  late double _copperGoal = 0.900; // mcg per day
  late double _docosahexaenoicAcidGoal = 250; // mg per day
  late double _eicosapentaenoicAcidGoal = 250; // mg per day
  late double _erucicAcidGoal = 400; // no specific recommendation
  late double _fluorideGoal = 4; // mg per day
  late double _iodineGoal = 0.150; // mcg per day
  late double _manganeseGoal = 1.8; // mg per day
  late double _molybdenumGoal = 0.045; // mcg per day
  late double _myristicAcidGoal = 0.89; // no specific recommendation
  late double _oleicAcidGoal = 20000; // no specific recommendation
  late double _palmiticAcidGoal = 20000; // no specific recommendation
  late double _pantothenicAcidGoal = 5; // mg per day
  late double _seleniumGoal = 0.055; // mcg per day
  late double _stearicAcidGoal = 5700; // no specific recommendation


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


  late UserNutritionHistoryModel _userNutritionHistory = UserNutritionHistoryModel(
      barcodes: [], foodListItemNames: [], foodServings: [], foodServingSize: []);

  UserNutritionHistoryModel get userNutritionHistory => _userNutritionHistory;

  void setFoodHistory(UserNutritionHistoryModel userHistory) {
    _userNutritionHistory = userHistory;

  }

  void updateFoodHistory(String barcode, String foodName, String servings, String servingSize) {

    if (!_userNutritionHistory.barcodes.contains(barcode)) {
      _userNutritionHistory.barcodes.add(barcode);
      _userNutritionHistory.foodListItemNames.add(foodName);
      _userNutritionHistory.foodServings.add(servings);
      _userNutritionHistory.foodServingSize.add(servingSize);

      if (_userNutritionHistory.barcodes.length > 20) {
        _userNutritionHistory.barcodes.removeAt(0);
        _userNutritionHistory.foodListItemNames.removeAt(0);
        _userNutritionHistory.foodServings.removeAt(0);
        _userNutritionHistory.foodServingSize.removeAt(0);
      };

      UpdateUserNutritionHistoryData(userNutritionHistory);

      notifyListeners();

    } else if (_userNutritionHistory.barcodes.contains(barcode)) {

      int index = _userNutritionHistory.barcodes.indexOf(barcode);

      _userNutritionHistory.barcodes.removeAt(index);
      _userNutritionHistory.foodListItemNames.removeAt(index);
      _userNutritionHistory.foodServings.removeAt(index);
      _userNutritionHistory.foodServingSize.removeAt(index);

      _userNutritionHistory.barcodes.add(barcode);
      _userNutritionHistory.foodListItemNames.add(foodName);
      _userNutritionHistory.foodServings.add(servings);
      _userNutritionHistory.foodServingSize.add(servingSize);

      UpdateUserNutritionHistoryData(userNutritionHistory);

      notifyListeners();

    }

  }

  String convertToUsableData(dynamic valueToConvert) {
    if (valueToConvert != null) {
      valueToConvert = valueToConvert.toString();
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

    void calculateTotal(listOfFood) {
      listOfFood.forEach((foodItem) {
        try {
          _calories += double.parse(foodItem.foodCalories);
        } catch (exception) {
          _calories += 0;
        }
        try {
          _protein += double.parse(foodItem.proteins);
        } catch (exception) {
          _protein += 0;
        }
        try {
          _fat += double.parse(foodItem.fat);
        } catch (exception) {
          _fat += 0;
        }
        try {
          _carbohydrates += double.parse(foodItem.carbs);
        } catch (exception) {
          _carbohydrates += 0;
        }
        try {
          _fiber += double.parse(foodItem.fiber);
        } catch (exception) {
          _fiber += 0;
        }
        try {
          _sugar += double.parse(foodItem.sugars);
        } catch (exception) {
          _sugar += 0;
        }
        try {
          _saturatedFat += double.parse(foodItem.saturatedFat);
        } catch (exception) {
          _saturatedFat += 0;
        }
        try {
          _polyUnsaturatedFat += double.parse(foodItem.polyunsaturatedFat);
        } catch (exception) {
          _polyUnsaturatedFat += 0;
        }
        try {
          _monoUnsaturatedFat += double.parse(foodItem.monounsaturatedFat);
        } catch (exception) {
          _monoUnsaturatedFat += 0;
        }
        try {
          _transFat += double.parse(foodItem.transFat);
        } catch (exception) {
          _transFat += 0;
        }
        try {
          _cholesterol += double.parse(foodItem.cholesterol);
        } catch (exception) {
          _cholesterol += 0;
        }
        try {
          _calcium += double.parse(foodItem.calcium);
        } catch (exception) {
          _calcium += 0;
        }
        try {
          _iron += double.parse(foodItem.iron);
        } catch (exception) {
          _iron += 0;
        }
        try {
          _sodium += double.parse(foodItem.sodium);
        } catch (exception) {
          _sodium += 0;
        }
        try {
          _zinc += double.parse(foodItem.zinc);
        } catch (exception) {
          _zinc += 0;
        }
        try {
          _magnesium += double.parse(foodItem.magnesium);
        } catch (exception) {
          _magnesium += 0;
        }
        try {
          _potassium += double.parse(foodItem.potassium);
        } catch (exception) {
          _potassium += 0;
        }
        try {
          _vitaminA += double.parse(foodItem.vitaminA);
        } catch (exception) {
          _vitaminA += 0;
        }
        try {
          _vitaminB1 += double.parse(foodItem.vitaminB1);
        } catch (exception) {
          _vitaminB1 += 0;
        }
        try {
          _vitaminB2 += double.parse(foodItem.vitaminB2);
        } catch (exception) {
          _vitaminB2 += 0;
        }
        try {
          _vitaminB3 += double.parse(foodItem.vitaminB3);
        } catch (exception) {
          _vitaminB3 += 0;
        }
        try {
          _vitaminB6 += double.parse(foodItem.vitaminB6);
        } catch (exception) {
          _vitaminB6 += 0;
        }
        try {
          _vitaminB9 += double.parse(foodItem.vitaminB9);
        } catch (exception) {
          _vitaminB9 += 0;
        }
        try {
          _vitaminB12 += double.parse(foodItem.vitaminB12);
        } catch (exception) {
          _vitaminB12 += 0;
        }
        try {
          _vitaminC += double.parse(foodItem.vitaminC);
        } catch (exception) {
          _vitaminC += 0;
        }
        try {
          _vitaminD += double.parse(foodItem.vitaminD);
        } catch (exception) {
          _vitaminD += 0;
        }
        try {
          _vitaminE += double.parse(foodItem.vitaminE);
        } catch (exception) {
          _vitaminE += 0;
        }
        try {
          _vitaminK += double.parse(foodItem.vitaminK);
        } catch (exception) {
          _vitaminK += 0;
        }
        try {
          _omega3 += double.parse(foodItem.omega3);
        } catch (exception) {
          _omega3 += 0;
        }
        try {
          _omega6 += double.parse(foodItem.omega6);
        } catch (exception) {
          _omega6 += 0;
        }
        try {
          _alcohol += double.parse(foodItem.alcohol);
        } catch (exception) {
          _alcohol += 0;
        }
        try {
          _biotin += double.parse(foodItem.biotin);
        } catch (exception) {
          _biotin += 0;
        }
        try {
          _butyricAcid += double.parse(foodItem.butyricAcid);
        } catch (exception) {
          _butyricAcid += 0;
        }
        try {
          _caffeine += double.parse(foodItem.caffeine);
        } catch (exception) {
          _caffeine += 0;
        }
        try {
          _capricAcid += double.parse(foodItem.capricAcid);
        } catch (exception) {
          _capricAcid += 0;
        }
        try {
          _caproicAcid += double.parse(foodItem.caproicAcid);
        } catch (exception) {
          _caproicAcid += 0;
        }
        try {
          _caprylicAcid += double.parse(foodItem.caprylicAcid);
        } catch (exception) {
          _caprylicAcid += 0;
        }
        try {
          _chloride += double.parse(foodItem.chloride);
        } catch (exception) {
          _chloride += 0;
        }
        try {
          _chromium += double.parse(foodItem.chromium);
        } catch (exception) {
          _chromium += 0;
        }
        try {
          _copper += double.parse(foodItem.copper);
        } catch (exception) {
          _copper += 0;
        }
        try {
          _docosahexaenoicAcid += double.parse(foodItem.docosahexaenoicAcid);
        } catch (exception) {
          _docosahexaenoicAcid += 0;
        }
        try {
          _eicosapentaenoicAcid += double.parse(foodItem.eicosapentaenoicAcid);
        } catch (exception) {
          _eicosapentaenoicAcid += 0;
        }
        try {
          _erucicAcid += double.parse(foodItem.erucicAcid);
        } catch (exception) {
          _erucicAcid += 0;
        }
        try {
          _fluoride += double.parse(foodItem.fluoride);
        } catch (exception) {
          _fluoride += 0;
        }
        try {
          _iodine += double.parse(foodItem.iodine);
        } catch (exception) {
          _iodine += 0;
        }
        try {
          _manganese += double.parse(foodItem.manganese);
        } catch (exception) {
          _manganese += 0;
        }
        try {
          _molybdenum += double.parse(foodItem.molybdenum);
        } catch (exception) {
          _molybdenum += 0;
        }
        try {
          _myristicAcid += double.parse(foodItem.myristicAcid);
        } catch (exception) {
          _myristicAcid += 0;
        }
        try {
          _oleicAcid += double.parse(foodItem.oleicAcid);
        } catch (exception) {
          _oleicAcid += 0;
        }
        try {
          _palmiticAcid += double.parse(foodItem.palmiticAcid);
        } catch (exception) {
          _palmiticAcid += 0;
        }
        try {
          _pantothenicAcid += double.parse(foodItem.pantothenicAcid);
        } catch (exception) {
          _pantothenicAcid += 0;
        }
        try {
          _selenium += double.parse(foodItem.selenium);
        } catch (exception) {
          _selenium += 0;
        }
        try {
          _stearicAcid += double.parse(foodItem.stearicAcid);
        } catch (exception) {
          _stearicAcid += 0;
        }
      });
    }

    calculateTotal(_userDailyNutrition.foodListItemsBreakfast);
    calculateTotal(_userDailyNutrition.foodListItemsLunch);
    calculateTotal(_userDailyNutrition.foodListItemsDinner);
    calculateTotal(_userDailyNutrition.foodListItemsSnacks);

    //notifyListeners();

  }


  void setCurrentFoodDiary(UserNutritionModel diary) {
    _userDailyNutrition = diary;

    notifyListeners();

    calculateMacros();

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

    notifyListeners();
  }

  void addFoodItemToDiary(FoodItem newItem, String category, String servings,
      String servingSize) {
    _userDailyNutrition.date = _nutritionDate.toString();

    print("ADding food");

    if (category.toLowerCase() == "breakfast") {
      _userDailyNutrition.foodListItemsBreakfast.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodName: newItem.foodName,
        foodServings: servings,
        foodServingSize: servingSize,
        foodCalories: ServingSizeCalculator(
          newItem.calories, servingSize, servings, 0,),
        kiloJoules: ServingSizeCalculator(
          currentFoodItem.kiloJoules, servingSize, servings, 0,),
        proteins: ServingSizeCalculator(
          currentFoodItem.proteins, servingSize, servings, 0,),
        carbs: ServingSizeCalculator(
          currentFoodItem.carbs, servingSize, servings, 0,),
        fiber: ServingSizeCalculator(
          currentFoodItem.fiber, servingSize, servings, 0,),
        sugars: ServingSizeCalculator(
          currentFoodItem.sugars, servingSize, servings, 0,),
        fat: ServingSizeCalculator(
          currentFoodItem.fat, servingSize, servings, 0,),
        saturatedFat: ServingSizeCalculator(
          currentFoodItem.saturatedFat, servingSize, servings, 0,),
        polyUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.polyUnsaturatedFat, servingSize, servings, 0,),
        monoUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.monoUnsaturatedFat, servingSize, servings, 0,),
        transFat: ServingSizeCalculator(
          currentFoodItem.transFat, servingSize, servings, 0,),
        cholesterol: ServingSizeCalculator(
          currentFoodItem.cholesterol, servingSize, servings, 0,),
        calcium: ServingSizeCalculator(
          currentFoodItem.calcium, servingSize, servings, 0,),
        iron: ServingSizeCalculator(
          currentFoodItem.iron, servingSize, servings, 0,),
        sodium: ServingSizeCalculator(
          currentFoodItem.sodium, servingSize, servings, 0,),
        zinc: ServingSizeCalculator(
          currentFoodItem.zinc, servingSize, servings, 0,),
        magnesium: ServingSizeCalculator(
          currentFoodItem.magnesium, servingSize, servings, 0,),
        potassium: ServingSizeCalculator(
          currentFoodItem.potassium, servingSize, servings, 0,),
        vitaminA: ServingSizeCalculator(
          currentFoodItem.vitaminA, servingSize, servings, 0,),
        vitaminB1: ServingSizeCalculator(
          currentFoodItem.vitaminB1, servingSize, servings, 0,),
        vitaminB2: ServingSizeCalculator(
          currentFoodItem.vitaminB2, servingSize, servings, 0,),
        vitaminB3: ServingSizeCalculator(
          currentFoodItem.vitaminB3, servingSize, servings, 0,),
        vitaminB6: ServingSizeCalculator(
          currentFoodItem.vitaminB6, servingSize, servings, 0,),
        vitaminB9: ServingSizeCalculator(
          currentFoodItem.vitaminB9, servingSize, servings, 0,),
        vitaminB12: ServingSizeCalculator(
          currentFoodItem.vitaminB12, servingSize, servings, 0,),
        vitaminC: ServingSizeCalculator(
          currentFoodItem.vitaminC, servingSize, servings, 0,),
        vitaminD: ServingSizeCalculator(
          currentFoodItem.vitaminD, servingSize, servings, 0,),
        vitaminE: ServingSizeCalculator(
          currentFoodItem.vitaminE, servingSize, servings, 0,),
        vitaminK: ServingSizeCalculator(
          currentFoodItem.vitaminK, servingSize, servings, 0,),
        omega3: ServingSizeCalculator(
          currentFoodItem.omega3, servingSize, servings, 0,),
        omega6: ServingSizeCalculator(
          currentFoodItem.omega6, servingSize, servings, 0,),
        alcohol: ServingSizeCalculator(
          currentFoodItem.alcohol, servingSize, servings, 0,),
        biotin: ServingSizeCalculator(
          currentFoodItem.biotin, servingSize, servings, 0,),
        butyricAcid: ServingSizeCalculator(
          currentFoodItem.butyricAcid, servingSize, servings, 0,),
        caffeine: ServingSizeCalculator(
          currentFoodItem.caffeine, servingSize, servings, 0,),
        capricAcid: ServingSizeCalculator(
          currentFoodItem.capricAcid, servingSize, servings, 0,),
        caproicAcid: ServingSizeCalculator(
          currentFoodItem.caproicAcid, servingSize, servings, 0,),
        caprylicAcid: ServingSizeCalculator(
          currentFoodItem.caprylicAcid, servingSize, servings, 0,),
        chloride: ServingSizeCalculator(
          currentFoodItem.chloride, servingSize, servings, 0,),
        chromium: ServingSizeCalculator(
          currentFoodItem.chromium, servingSize, servings, 0,),
        copper: ServingSizeCalculator(
          currentFoodItem.copper, servingSize, servings, 0,),
        docosahexaenoicAcid: ServingSizeCalculator(
          currentFoodItem.docosahexaenoicAcid, servingSize, servings, 0,),
        eicosapentaenoicAcid: ServingSizeCalculator(
          currentFoodItem.eicosapentaenoicAcid, servingSize, servings, 0,),
        erucicAcid: ServingSizeCalculator(
          currentFoodItem.erucicAcid, servingSize, servings, 0,),
        fluoride: ServingSizeCalculator(
          currentFoodItem.fluoride, servingSize, servings, 0,),
        iodine: ServingSizeCalculator(
          currentFoodItem.iodine, servingSize, servings, 0,),
        manganese: ServingSizeCalculator(
          currentFoodItem.manganese, servingSize, servings, 0,),
        molybdenum: ServingSizeCalculator(
          currentFoodItem.molybdenum, servingSize, servings, 0,),
        myristicAcid: ServingSizeCalculator(
          currentFoodItem.myristicAcid, servingSize, servings, 0,),
        oleicAcid: ServingSizeCalculator(
          currentFoodItem.oleicAcid, servingSize, servings, 0,),
        palmiticAcid: ServingSizeCalculator(
          currentFoodItem.palmiticAcid, servingSize, servings, 0,),
        pantothenicAcid: ServingSizeCalculator(
          currentFoodItem.pantothenicAcid, servingSize, servings, 0,),
        selenium: ServingSizeCalculator(
          currentFoodItem.selenium, servingSize, servings, 0,),
        stearicAcid: ServingSizeCalculator(
          currentFoodItem.stearicAcid, servingSize, servings, 0,),
      ));

      //_userDailyNutrition.foodListItemsBreakfast += _foodListItemsBreakfast;
    } else if (category.toLowerCase() == "lunch") {
      _userDailyNutrition.foodListItemsLunch.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodName: newItem.foodName,
        foodServings: servings,
        foodServingSize: servingSize,
        foodCalories: ServingSizeCalculator(
          newItem.calories, servingSize, servings, 0,),
        kiloJoules: ServingSizeCalculator(
          currentFoodItem.kiloJoules, servingSize, servings, 0,),
        proteins: ServingSizeCalculator(
          currentFoodItem.proteins, servingSize, servings, 0,),
        carbs: ServingSizeCalculator(
          currentFoodItem.carbs, servingSize, servings, 0,),
        fiber: ServingSizeCalculator(
          currentFoodItem.fiber, servingSize, servings, 0,),
        sugars: ServingSizeCalculator(
          currentFoodItem.sugars, servingSize, servings, 0,),
        fat: ServingSizeCalculator(
          currentFoodItem.fat, servingSize, servings, 0,),
        saturatedFat: ServingSizeCalculator(
          currentFoodItem.saturatedFat, servingSize, servings, 0,),
        polyUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.polyUnsaturatedFat, servingSize, servings, 0,),
        monoUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.monoUnsaturatedFat, servingSize, servings, 0,),
        transFat: ServingSizeCalculator(
          currentFoodItem.transFat, servingSize, servings, 0,),
        cholesterol: ServingSizeCalculator(
          currentFoodItem.cholesterol, servingSize, servings, 0,),
        calcium: ServingSizeCalculator(
          currentFoodItem.calcium, servingSize, servings, 0,),
        iron: ServingSizeCalculator(
          currentFoodItem.iron, servingSize, servings, 0,),
        sodium: ServingSizeCalculator(
          currentFoodItem.sodium, servingSize, servings, 0,),
        zinc: ServingSizeCalculator(
          currentFoodItem.zinc, servingSize, servings, 0,),
        magnesium: ServingSizeCalculator(
          currentFoodItem.magnesium, servingSize, servings, 0,),
        potassium: ServingSizeCalculator(
          currentFoodItem.potassium, servingSize, servings, 0,),
        vitaminA: ServingSizeCalculator(
          currentFoodItem.vitaminA, servingSize, servings, 0,),
        vitaminB1: ServingSizeCalculator(
          currentFoodItem.vitaminB1, servingSize, servings, 0,),
        vitaminB2: ServingSizeCalculator(
          currentFoodItem.vitaminB2, servingSize, servings, 0,),
        vitaminB3: ServingSizeCalculator(
          currentFoodItem.vitaminB3, servingSize, servings, 0,),
        vitaminB6: ServingSizeCalculator(
          currentFoodItem.vitaminB6, servingSize, servings, 0,),
        vitaminB9: ServingSizeCalculator(
          currentFoodItem.vitaminB9, servingSize, servings, 0,),
        vitaminB12: ServingSizeCalculator(
          currentFoodItem.vitaminB12, servingSize, servings, 0,),
        vitaminC: ServingSizeCalculator(
          currentFoodItem.vitaminC, servingSize, servings, 0,),
        vitaminD: ServingSizeCalculator(
          currentFoodItem.vitaminD, servingSize, servings, 0,),
        vitaminE: ServingSizeCalculator(
          currentFoodItem.vitaminE, servingSize, servings, 0,),
        vitaminK: ServingSizeCalculator(
          currentFoodItem.vitaminK, servingSize, servings, 0,),
        omega3: ServingSizeCalculator(
          currentFoodItem.omega3, servingSize, servings, 0,),
        omega6: ServingSizeCalculator(
          currentFoodItem.omega6, servingSize, servings, 0,),
        alcohol: ServingSizeCalculator(
          currentFoodItem.alcohol, servingSize, servings, 0,),
        biotin: ServingSizeCalculator(
          currentFoodItem.biotin, servingSize, servings, 0,),
        butyricAcid: ServingSizeCalculator(
          currentFoodItem.butyricAcid, servingSize, servings, 0,),
        caffeine: ServingSizeCalculator(
          currentFoodItem.caffeine, servingSize, servings, 0,),
        capricAcid: ServingSizeCalculator(
          currentFoodItem.capricAcid, servingSize, servings, 0,),
        caproicAcid: ServingSizeCalculator(
          currentFoodItem.caproicAcid, servingSize, servings, 0,),
        caprylicAcid: ServingSizeCalculator(
          currentFoodItem.caprylicAcid, servingSize, servings, 0,),
        chloride: ServingSizeCalculator(
          currentFoodItem.chloride, servingSize, servings, 0,),
        chromium: ServingSizeCalculator(
          currentFoodItem.chromium, servingSize, servings, 0,),
        copper: ServingSizeCalculator(
          currentFoodItem.copper, servingSize, servings, 0,),
        docosahexaenoicAcid: ServingSizeCalculator(
          currentFoodItem.docosahexaenoicAcid, servingSize, servings, 0,),
        eicosapentaenoicAcid: ServingSizeCalculator(
          currentFoodItem.eicosapentaenoicAcid, servingSize, servings, 0,),
        erucicAcid: ServingSizeCalculator(
          currentFoodItem.erucicAcid, servingSize, servings, 0,),
        fluoride: ServingSizeCalculator(
          currentFoodItem.fluoride, servingSize, servings, 0,),
        iodine: ServingSizeCalculator(
          currentFoodItem.iodine, servingSize, servings, 0,),
        manganese: ServingSizeCalculator(
          currentFoodItem.manganese, servingSize, servings, 0,),
        molybdenum: ServingSizeCalculator(
          currentFoodItem.molybdenum, servingSize, servings, 0,),
        myristicAcid: ServingSizeCalculator(
          currentFoodItem.myristicAcid, servingSize, servings, 0,),
        oleicAcid: ServingSizeCalculator(
          currentFoodItem.oleicAcid, servingSize, servings, 0,),
        palmiticAcid: ServingSizeCalculator(
          currentFoodItem.palmiticAcid, servingSize, servings, 0,),
        pantothenicAcid: ServingSizeCalculator(
          currentFoodItem.pantothenicAcid, servingSize, servings, 0,),
        selenium: ServingSizeCalculator(
          currentFoodItem.selenium, servingSize, servings, 0,),
        stearicAcid: ServingSizeCalculator(
          currentFoodItem.stearicAcid, servingSize, servings, 0,),
      ));

      //_userDailyNutrition.foodListItemsLunch += _foodListItemsLunch;
    } else if (category.toLowerCase() == "dinner") {
      _userDailyNutrition.foodListItemsDinner.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodName: newItem.foodName,
        foodServings: servings,
        foodServingSize: servingSize,
        foodCalories: ServingSizeCalculator(
          newItem.calories, servingSize, servings, 0,),
        kiloJoules: ServingSizeCalculator(
          currentFoodItem.kiloJoules, servingSize, servings, 0,),
        proteins: ServingSizeCalculator(
          currentFoodItem.proteins, servingSize, servings, 0,),
        carbs: ServingSizeCalculator(
          currentFoodItem.carbs, servingSize, servings, 0,),
        fiber: ServingSizeCalculator(
          currentFoodItem.fiber, servingSize, servings, 0,),
        sugars: ServingSizeCalculator(
          currentFoodItem.sugars, servingSize, servings, 0,),
        fat: ServingSizeCalculator(
          currentFoodItem.fat, servingSize, servings, 0,),
        saturatedFat: ServingSizeCalculator(
          currentFoodItem.saturatedFat, servingSize, servings, 0,),
        polyUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.polyUnsaturatedFat, servingSize, servings, 0,),
        monoUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.monoUnsaturatedFat, servingSize, servings, 0,),
        transFat: ServingSizeCalculator(
          currentFoodItem.transFat, servingSize, servings, 0,),
        cholesterol: ServingSizeCalculator(
          currentFoodItem.cholesterol, servingSize, servings, 0,),
        calcium: ServingSizeCalculator(
          currentFoodItem.calcium, servingSize, servings, 0,),
        iron: ServingSizeCalculator(
          currentFoodItem.iron, servingSize, servings, 0,),
        sodium: ServingSizeCalculator(
          currentFoodItem.sodium, servingSize, servings, 0,),
        zinc: ServingSizeCalculator(
          currentFoodItem.zinc, servingSize, servings, 0,),
        magnesium: ServingSizeCalculator(
          currentFoodItem.magnesium, servingSize, servings, 0,),
        potassium: ServingSizeCalculator(
          currentFoodItem.potassium, servingSize, servings, 0,),
        vitaminA: ServingSizeCalculator(
          currentFoodItem.vitaminA, servingSize, servings, 0,),
        vitaminB1: ServingSizeCalculator(
          currentFoodItem.vitaminB1, servingSize, servings, 0,),
        vitaminB2: ServingSizeCalculator(
          currentFoodItem.vitaminB2, servingSize, servings, 0,),
        vitaminB3: ServingSizeCalculator(
          currentFoodItem.vitaminB3, servingSize, servings, 0,),
        vitaminB6: ServingSizeCalculator(
          currentFoodItem.vitaminB6, servingSize, servings, 0,),
        vitaminB9: ServingSizeCalculator(
          currentFoodItem.vitaminB9, servingSize, servings, 0,),
        vitaminB12: ServingSizeCalculator(
          currentFoodItem.vitaminB12, servingSize, servings, 0,),
        vitaminC: ServingSizeCalculator(
          currentFoodItem.vitaminC, servingSize, servings, 0,),
        vitaminD: ServingSizeCalculator(
          currentFoodItem.vitaminD, servingSize, servings, 0,),
        vitaminE: ServingSizeCalculator(
          currentFoodItem.vitaminE, servingSize, servings, 0,),
        vitaminK: ServingSizeCalculator(
          currentFoodItem.vitaminK, servingSize, servings, 0,),
        omega3: ServingSizeCalculator(
          currentFoodItem.omega3, servingSize, servings, 0,),
        omega6: ServingSizeCalculator(
          currentFoodItem.omega6, servingSize, servings, 0,),
        alcohol: ServingSizeCalculator(
          currentFoodItem.alcohol, servingSize, servings, 0,),
        biotin: ServingSizeCalculator(
          currentFoodItem.biotin, servingSize, servings, 0,),
        butyricAcid: ServingSizeCalculator(
          currentFoodItem.butyricAcid, servingSize, servings, 0,),
        caffeine: ServingSizeCalculator(
          currentFoodItem.caffeine, servingSize, servings, 0,),
        capricAcid: ServingSizeCalculator(
          currentFoodItem.capricAcid, servingSize, servings, 0,),
        caproicAcid: ServingSizeCalculator(
          currentFoodItem.caproicAcid, servingSize, servings, 0,),
        caprylicAcid: ServingSizeCalculator(
          currentFoodItem.caprylicAcid, servingSize, servings, 0,),
        chloride: ServingSizeCalculator(
          currentFoodItem.chloride, servingSize, servings, 0,),
        chromium: ServingSizeCalculator(
          currentFoodItem.chromium, servingSize, servings, 0,),
        copper: ServingSizeCalculator(
          currentFoodItem.copper, servingSize, servings, 0,),
        docosahexaenoicAcid: ServingSizeCalculator(
          currentFoodItem.docosahexaenoicAcid, servingSize, servings, 0,),
        eicosapentaenoicAcid: ServingSizeCalculator(
          currentFoodItem.eicosapentaenoicAcid, servingSize, servings, 0,),
        erucicAcid: ServingSizeCalculator(
          currentFoodItem.erucicAcid, servingSize, servings, 0,),
        fluoride: ServingSizeCalculator(
          currentFoodItem.fluoride, servingSize, servings, 0,),
        iodine: ServingSizeCalculator(
          currentFoodItem.iodine, servingSize, servings, 0,),
        manganese: ServingSizeCalculator(
          currentFoodItem.manganese, servingSize, servings, 0,),
        molybdenum: ServingSizeCalculator(
          currentFoodItem.molybdenum, servingSize, servings, 0,),
        myristicAcid: ServingSizeCalculator(
          currentFoodItem.myristicAcid, servingSize, servings, 0,),
        oleicAcid: ServingSizeCalculator(
          currentFoodItem.oleicAcid, servingSize, servings, 0,),
        palmiticAcid: ServingSizeCalculator(
          currentFoodItem.palmiticAcid, servingSize, servings, 0,),
        pantothenicAcid: ServingSizeCalculator(
          currentFoodItem.pantothenicAcid, servingSize, servings, 0,),
        selenium: ServingSizeCalculator(
          currentFoodItem.selenium, servingSize, servings, 0,),
        stearicAcid: ServingSizeCalculator(
          currentFoodItem.stearicAcid, servingSize, servings, 0,),
      ));

      //_userDailyNutrition.foodListItemsDinner += _foodListItemsDinner;
    } else if (category.toLowerCase() == "snacks") {
      _userDailyNutrition.foodListItemsSnacks.add(ListFoodItem(
        barcode: newItem.barcode,
        category: category,
        foodName: newItem.foodName,
        foodServings: servings,
        foodServingSize: servingSize,
        foodCalories: ServingSizeCalculator(
          newItem.calories, servingSize, servings, 0,),
        kiloJoules: ServingSizeCalculator(
          currentFoodItem.kiloJoules, servingSize, servings, 0,),
        proteins: ServingSizeCalculator(
          currentFoodItem.proteins, servingSize, servings, 0,),
        carbs: ServingSizeCalculator(
          currentFoodItem.carbs, servingSize, servings, 0,),
        fiber: ServingSizeCalculator(
          currentFoodItem.fiber, servingSize, servings, 0,),
        sugars: ServingSizeCalculator(
          currentFoodItem.sugars, servingSize, servings, 0,),
        fat: ServingSizeCalculator(
          currentFoodItem.fat, servingSize, servings, 0,),
        saturatedFat: ServingSizeCalculator(
          currentFoodItem.saturatedFat, servingSize, servings, 0,),
        polyUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.polyUnsaturatedFat, servingSize, servings, 0,),
        monoUnsaturatedFat: ServingSizeCalculator(
          currentFoodItem.monoUnsaturatedFat, servingSize, servings, 0,),
        transFat: ServingSizeCalculator(
          currentFoodItem.transFat, servingSize, servings, 0,),
        cholesterol: ServingSizeCalculator(
          currentFoodItem.cholesterol, servingSize, servings, 0,),
        calcium: ServingSizeCalculator(
          currentFoodItem.calcium, servingSize, servings, 0,),
        iron: ServingSizeCalculator(
          currentFoodItem.iron, servingSize, servings, 0,),
        sodium: ServingSizeCalculator(
          currentFoodItem.sodium, servingSize, servings, 0,),
        zinc: ServingSizeCalculator(
          currentFoodItem.zinc, servingSize, servings, 0,),
        magnesium: ServingSizeCalculator(
          currentFoodItem.magnesium, servingSize, servings, 0,),
        potassium: ServingSizeCalculator(
          currentFoodItem.potassium, servingSize, servings, 0,),
        vitaminA: ServingSizeCalculator(
          currentFoodItem.vitaminA, servingSize, servings, 0,),
        vitaminB1: ServingSizeCalculator(
          currentFoodItem.vitaminB1, servingSize, servings, 0,),
        vitaminB2: ServingSizeCalculator(
          currentFoodItem.vitaminB2, servingSize, servings, 0,),
        vitaminB3: ServingSizeCalculator(
          currentFoodItem.vitaminB3, servingSize, servings, 0,),
        vitaminB6: ServingSizeCalculator(
          currentFoodItem.vitaminB6, servingSize, servings, 0,),
        vitaminB9: ServingSizeCalculator(
          currentFoodItem.vitaminB9, servingSize, servings, 0,),
        vitaminB12: ServingSizeCalculator(
          currentFoodItem.vitaminB12, servingSize, servings, 0,),
        vitaminC: ServingSizeCalculator(
          currentFoodItem.vitaminC, servingSize, servings, 0,),
        vitaminD: ServingSizeCalculator(
          currentFoodItem.vitaminD, servingSize, servings, 0,),
        vitaminE: ServingSizeCalculator(
          currentFoodItem.vitaminE, servingSize, servings, 0,),
        vitaminK: ServingSizeCalculator(
          currentFoodItem.vitaminK, servingSize, servings, 0,),
        omega3: ServingSizeCalculator(
          currentFoodItem.omega3, servingSize, servings, 0,),
        omega6: ServingSizeCalculator(
          currentFoodItem.omega6, servingSize, servings, 0,),
        alcohol: ServingSizeCalculator(
          currentFoodItem.alcohol, servingSize, servings, 0,),
        biotin: ServingSizeCalculator(
          currentFoodItem.biotin, servingSize, servings, 0,),
        butyricAcid: ServingSizeCalculator(
          currentFoodItem.butyricAcid, servingSize, servings, 0,),
        caffeine: ServingSizeCalculator(
          currentFoodItem.caffeine, servingSize, servings, 0,),
        capricAcid: ServingSizeCalculator(
          currentFoodItem.capricAcid, servingSize, servings, 0,),
        caproicAcid: ServingSizeCalculator(
          currentFoodItem.caproicAcid, servingSize, servings, 0,),
        caprylicAcid: ServingSizeCalculator(
          currentFoodItem.caprylicAcid, servingSize, servings, 0,),
        chloride: ServingSizeCalculator(
          currentFoodItem.chloride, servingSize, servings, 0,),
        chromium: ServingSizeCalculator(
          currentFoodItem.chromium, servingSize, servings, 0,),
        copper: ServingSizeCalculator(
          currentFoodItem.copper, servingSize, servings, 0,),
        docosahexaenoicAcid: ServingSizeCalculator(
          currentFoodItem.docosahexaenoicAcid, servingSize, servings, 0,),
        eicosapentaenoicAcid: ServingSizeCalculator(
          currentFoodItem.eicosapentaenoicAcid, servingSize, servings, 0,),
        erucicAcid: ServingSizeCalculator(
          currentFoodItem.erucicAcid, servingSize, servings, 0,),
        fluoride: ServingSizeCalculator(
          currentFoodItem.fluoride, servingSize, servings, 0,),
        iodine: ServingSizeCalculator(
          currentFoodItem.iodine, servingSize, servings, 0,),
        manganese: ServingSizeCalculator(
          currentFoodItem.manganese, servingSize, servings, 0,),
        molybdenum: ServingSizeCalculator(
          currentFoodItem.molybdenum, servingSize, servings, 0,),
        myristicAcid: ServingSizeCalculator(
          currentFoodItem.myristicAcid, servingSize, servings, 0,),
        oleicAcid: ServingSizeCalculator(
          currentFoodItem.oleicAcid, servingSize, servings, 0,),
        palmiticAcid: ServingSizeCalculator(
          currentFoodItem.palmiticAcid, servingSize, servings, 0,),
        pantothenicAcid: ServingSizeCalculator(
          currentFoodItem.pantothenicAcid, servingSize, servings, 0,),
        selenium: ServingSizeCalculator(
          currentFoodItem.selenium, servingSize, servings, 0,),
        stearicAcid: ServingSizeCalculator(
          currentFoodItem.stearicAcid, servingSize, servings, 0,),
      ));

      //_userDailyNutrition.foodListItemsSnacks += _foodListItemsSnacks;
    }

    UpdateUserNutritionalData(_userDailyNutrition);

    notifyListeners();
  }

  void updateCurrentFoodListItem(ListFoodItem newItem) {
    _currentFoodListItem = newItem;
  }

  void changeCurrentFoodItemLoadingStatus(bool newBool) {
    _isCurrentFoodItemLoaded = newBool;
    notifyListeners();
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
    //_currentFoodItem.servingSize = servingSize;
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
    changeCurrentFoodItemLoadingStatus(false);
    _currentFoodItem = newFoodItem;
    _currentFoodListItem = ListFoodItem(
      barcode: currentFoodItem.barcode,
      category: "",
      foodName: currentFoodItem.foodName,
      foodServings: currentFoodItem.servings,
      foodServingSize: currentFoodItem.servingSize,
      foodCalories: currentFoodItem.calories,
      kiloJoules: currentFoodItem.kiloJoules,
      proteins: currentFoodItem.proteins,
      carbs: currentFoodItem.carbs,
      fiber: currentFoodItem.fiber,
      sugars: currentFoodItem.sugars,
      fat: currentFoodItem.fat,
      saturatedFat: currentFoodItem.saturatedFat,
      polyUnsaturatedFat: currentFoodItem.polyUnsaturatedFat,
      monoUnsaturatedFat: currentFoodItem.monoUnsaturatedFat,
      transFat: currentFoodItem.transFat,
      cholesterol: currentFoodItem.cholesterol,
      calcium: currentFoodItem.calcium,
      iron: currentFoodItem.iron,
      sodium: currentFoodItem.sodium,
      zinc: currentFoodItem.zinc,
      magnesium: currentFoodItem.magnesium,
      potassium: currentFoodItem.potassium,
      vitaminA: currentFoodItem.vitaminA,
      vitaminB1: currentFoodItem.vitaminB1,
      vitaminB2: currentFoodItem.vitaminB2,
      vitaminB3: currentFoodItem.vitaminB3,
      vitaminB6: currentFoodItem.vitaminB6,
      vitaminB9: currentFoodItem.vitaminB9,
      vitaminB12: currentFoodItem.vitaminB12,
      vitaminC: currentFoodItem.vitaminC,
      vitaminD: currentFoodItem.vitaminD,
      vitaminE: currentFoodItem.vitaminE,
      vitaminK: currentFoodItem.vitaminK,
      omega3: currentFoodItem.omega3,
      omega6: currentFoodItem.omega6,
      alcohol: currentFoodItem.alcohol,
      biotin: currentFoodItem.biotin,
      butyricAcid: currentFoodItem.butyricAcid,
      caffeine: currentFoodItem.caffeine,
      capricAcid: currentFoodItem.capricAcid,
      caproicAcid: currentFoodItem.caproicAcid,
      caprylicAcid: currentFoodItem.caprylicAcid,
      chloride: currentFoodItem.chloride,
      chromium: currentFoodItem.chromium,
      copper: currentFoodItem.copper,
      docosahexaenoicAcid: currentFoodItem.docosahexaenoicAcid,
      eicosapentaenoicAcid: currentFoodItem.eicosapentaenoicAcid,
      erucicAcid: currentFoodItem.erucicAcid,
      fluoride: currentFoodItem.fluoride,
      iodine: currentFoodItem.iodine,
      manganese: currentFoodItem.manganese,
      molybdenum: currentFoodItem.molybdenum,
      myristicAcid: currentFoodItem.myristicAcid,
      oleicAcid: currentFoodItem.oleicAcid,
      palmiticAcid: currentFoodItem.palmiticAcid,
      pantothenicAcid: currentFoodItem.pantothenicAcid,
      selenium: currentFoodItem.selenium,
      stearicAcid: currentFoodItem.stearicAcid,
    );
    changeCurrentFoodItemLoadingStatus(true);
  }

  void setCurrentFoodItemFromOpenFF(ProductResultV3 product,
      String barcodeDisplayValue) {
    changeCurrentFoodItemLoadingStatus(false);

    _currentFoodItem = FoodItem(
        barcode: barcodeDisplayValue,
        foodName: convertToUsableData(product.product?.productName),
        quantity: convertToUsableData(
            product.product?.quantity?.replaceAll(RegExp("[a-zA-Z:\s]"), "") ??
                "1"),
        servingSize: convertToUsableData(
            product.product?.servingSize?.replaceAll(
                RegExp("[a-zA-Z:\s]"), "") ?? "100"),
        servings: "1",
        calories: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.energyKCal, PerSize.oneHundredGrams)),
        kiloJoules: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.energyKJ, PerSize.oneHundredGrams)),
        proteins: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.proteins, PerSize.oneHundredGrams)),
        carbs: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.carbohydrates, PerSize.oneHundredGrams)),
        fiber: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.fiber, PerSize.oneHundredGrams)),
        sugars: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.sugars, PerSize.oneHundredGrams)),
        fat: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.fat, PerSize.oneHundredGrams)),
        saturatedFat: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.saturatedFat, PerSize.oneHundredGrams)),
        polyUnsaturatedFat: convertToUsableData(
            product.product?.nutriments?.getValue(
                Nutrient.polyunsaturatedFat, PerSize.oneHundredGrams)),
        monoUnsaturatedFat: convertToUsableData(
            product.product?.nutriments?.getValue(
                Nutrient.monounsaturatedFat, PerSize.oneHundredGrams)),
        transFat: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.transFat, PerSize.oneHundredGrams)),
        cholesterol: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.cholesterol, PerSize.oneHundredGrams)),
        calcium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.calcium, PerSize.oneHundredGrams)),
        iron: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.iron, PerSize.oneHundredGrams)),
        sodium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.sodium, PerSize.oneHundredGrams)),
        zinc: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.zinc, PerSize.oneHundredGrams)),
        magnesium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.magnesium, PerSize.oneHundredGrams)),
        potassium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.potassium, PerSize.oneHundredGrams)),
        vitaminA: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminA, PerSize.oneHundredGrams)),
        vitaminB1: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminB1, PerSize.oneHundredGrams)),
        vitaminB2: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminB2, PerSize.oneHundredGrams)),
        vitaminB3: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminPP, PerSize.oneHundredGrams)),
        vitaminB6: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminB6, PerSize.oneHundredGrams)),
        vitaminB9: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminB9, PerSize.oneHundredGrams)),
        vitaminB12: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminB12, PerSize.oneHundredGrams)),
        vitaminC: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminC, PerSize.oneHundredGrams)),
        vitaminD: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminD, PerSize.oneHundredGrams)),
        vitaminE: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminE, PerSize.oneHundredGrams)),
        vitaminK: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.vitaminK, PerSize.oneHundredGrams)),
        omega3: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.omega3, PerSize.oneHundredGrams)),
        omega6: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.omega6, PerSize.oneHundredGrams)),
        alcohol: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.alcohol, PerSize.oneHundredGrams)),
        biotin: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.biotin, PerSize.oneHundredGrams)),
        butyricAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.butyricAcid, PerSize.oneHundredGrams)),
        caffeine: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.caffeine, PerSize.oneHundredGrams)),
        capricAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.capricAcid, PerSize.oneHundredGrams)),
        caproicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.caproicAcid, PerSize.oneHundredGrams)),
        caprylicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.caprylicAcid, PerSize.oneHundredGrams)),
        chloride: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.chloride, PerSize.oneHundredGrams)),
        chromium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.chromium, PerSize.oneHundredGrams)),
        copper: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.copper, PerSize.oneHundredGrams)),
        docosahexaenoicAcid: convertToUsableData(
            product.product?.nutriments?.getValue(
                Nutrient.docosahexaenoicAcid, PerSize.oneHundredGrams)),
        eicosapentaenoicAcid: convertToUsableData(
            product.product?.nutriments?.getValue(
                Nutrient.eicosapentaenoicAcid, PerSize.oneHundredGrams)),
        erucicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.erucicAcid, PerSize.oneHundredGrams)),
        fluoride: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.fluoride, PerSize.oneHundredGrams)),
        iodine: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.iodine, PerSize.oneHundredGrams)),
        manganese: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.manganese, PerSize.oneHundredGrams)),
        molybdenum: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.molybdenum, PerSize.oneHundredGrams)),
        myristicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.myristicAcid, PerSize.oneHundredGrams)),
        oleicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.oleicAcid, PerSize.oneHundredGrams)),
        palmiticAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.palmiticAcid, PerSize.oneHundredGrams)),
        pantothenicAcid: convertToUsableData(
            product.product?.nutriments?.getValue(
                Nutrient.pantothenicAcid, PerSize.oneHundredGrams)),
        selenium: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.selenium, PerSize.oneHundredGrams)),
        stearicAcid: convertToUsableData(product.product?.nutriments?.getValue(
            Nutrient.stearicAcid, PerSize.oneHundredGrams))
    );
    changeCurrentFoodItemLoadingStatus(true);
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