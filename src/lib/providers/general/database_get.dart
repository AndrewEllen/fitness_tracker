
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/diet/nutrition_tracker.dart';
import 'package:fitness_tracker/models/diet/exercise_calories_list_item.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/models/stats/user_data_model.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_week_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:fitness_tracker/models/workout/workout_log_model.dart';
import 'package:fitness_tracker/models/workout/workout_overall_stats_model.dart';
import 'package:fitness_tracker/providers/diet/user_nutrition_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

import '../../models/diet/food_data_list_item.dart';
import '../../models/diet/food_item.dart';
import '../../models/stats/stats_model.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';


String checkIfValidNumber(String value) {

  return double.tryParse(value) == null ? "1" : value;

}

List<String> checkIfValidNumberList(List<String> valueList) {

  return [
    for (String item in valueList)
      double.tryParse(item) == null ? "1" : item
  ];

}


GetUserDataTrainingPlan() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("user-data")
        .doc("training-plan")
        .get();
    final Map data = snapshot.get("user-data");
    return data;

  } catch (exception) {
    print(exception);
  }
}

GetUserMeasurements({options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("stats-measurements")
            .get(const GetOptions(source: Source.cache));

        if (snapshot.docs.isEmpty) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Measurements.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("stats-measurements")
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("stats-measurements")
          .get(options);

    }

    final _data = snapshot.docs.map((doc) => doc.data()).toList();

    final List<StatsMeasurement> data = List<StatsMeasurement>.generate(_data.length, (int index) {
      final List<double> values = List<double>.generate(_data[index]["measurements-data"]["measurementData"].length, (int indexData) {
        return _data[index]["measurements-data"]["measurementData"][indexData];
      });
      final List<String> dates = List<String>.generate(_data[index]["measurements-data"]["measurementData"].length, (int indexData) {
        return _data[index]["measurements-data"]["measurementDate"][indexData];
      });

      return StatsMeasurement(
        measurementID: _data[index]["measurements-data"]['measurementID'],
        measurementName: _data[index]["measurements-data"]["measurementName"],
        measurementValues: values,
        measurementDates: dates,
      );
    });

    return data;

  } catch (exception) {
    print(exception);

    return [];

  }
}

//[LO3.7.3.5]
//Gets the food data from my firebase database

GetFoodDataFromFirebase(String barcode, {options = const GetOptions(source: Source.serverAndCache)}) async {

  print("firebase get");

  try {


    final snapshot = await FirebaseFirestore.instance
        .collection('food-data')
        .doc(barcode)
        .get(options);

    final _data = snapshot.get("food-data");

    print(_data["foodName"]);

    return FoodItem(
      barcode: _data["barcode"] ?? "",
      foodName: _data["foodName"] ?? "",
      quantity: _data["quantity"] ?? "",
      servingSize: _data["servingSize"] ?? "",
      servings: _data["servings"] ?? "",
      calories: _data["calories"] ?? "",
      kiloJoules: _data["kiloJoules"] ?? "",
      proteins: _data["proteins"] ?? "",
      carbs: _data["carbs"] ?? "",
      fiber: _data["fiber"] ?? "",
      sugars: _data["sugars"] ?? "",
      fat: _data["fat"] ?? "",
      saturatedFat: _data["saturatedFat"] ?? "",
      polyUnsaturatedFat: _data["polyUnsaturatedFat"] ?? "",
      monoUnsaturatedFat: _data["monoUnsaturatedFat"] ?? "",
      transFat: _data["transFat"] ?? "",
      cholesterol: _data["cholesterol"] ?? "",
      calcium: _data["calcium"] ?? "",
      iron: _data["iron"] ?? "",
      sodium: _data["sodium"] ?? "",
      zinc: _data["zinc"] ?? "",
      magnesium: _data["magnesium"] ?? "",
      potassium: _data["potassium"] ?? "",
      vitaminA: _data["vitaminA"] ?? "",
      vitaminB1: _data["vitaminB1"] ?? "",
      vitaminB2: _data["vitaminB2"] ?? "",
      vitaminB3: _data["vitaminB3"] ?? "",
      vitaminB6: _data["vitaminB6"] ?? "",
      vitaminB9: _data["vitaminB9"] ?? "",
      vitaminB12: _data["vitaminB12"] ?? "",
      vitaminC: _data["vitaminC"] ?? "",
      vitaminD: _data["vitaminD"] ?? "",
      vitaminE: _data["vitaminE"] ?? "",
      vitaminK: _data["vitaminK"] ?? "",
      omega3: _data["omega3"] ?? "",
      omega6: _data["omega6"] ?? "",
      alcohol: _data["alcohol"] ?? "",
      biotin: _data["biotin"] ?? "",
      butyricAcid: _data["butyricAcid"] ?? "",
      caffeine: _data["caffeine"] ?? "",
      capricAcid: _data["capricAcid"] ?? "",
      caproicAcid: _data["caproicAcid"] ?? "",
      caprylicAcid: _data["caprylicAcid"] ?? "",
      chloride: _data["chloride"] ?? "",
      chromium: _data["chromium"] ?? "",
      copper: _data["copper"] ?? "",
      docosahexaenoicAcid: _data["docosahexaenoicAcid"] ?? "",
      eicosapentaenoicAcid: _data["eicosapentaenoicAcid"] ?? "",
      erucicAcid: _data["erucicAcid"] ?? "",
      fluoride: _data["fluoride"] ?? "",
      iodine: _data["iodine"] ?? "",
      manganese: _data["manganese"] ?? "",
      molybdenum: _data["molybdenum"] ?? "",
      myristicAcid: _data["myristicAcid"] ?? "",
      oleicAcid: _data["oleicAcid"] ?? "",
      palmiticAcid: _data["palmiticAcid"] ?? "",
      pantothenicAcid: _data["pantothenicAcid"] ?? "",
      selenium: _data["selenium"] ?? "",
      stearicAcid: _data["stearicAcid"] ?? "",
      firebaseItem: true,
    );

  } catch (exception) {
    print(exception);
  }
}

BatchGetFoodDataFromFirebase(List<String> barcodes, {bool recipe = false, options = const GetOptions(source: Source.serverAndCache)}) async {

  List<FoodItem> foodItems = [];
  print(barcodes);

  if (recipe) {

    print("IS IN RECIPE");

    QuerySnapshot<Map<String, dynamic>> snapshot;

    try {



      if (options == const GetOptions(source: Source.serverAndCache)) {
        debugPrint("Checking Local Cache First");

        try {

          snapshot = await FirebaseFirestore.instance
              .collection('recipe-data')
              .where(FieldPath.documentId, whereIn: barcodes)
              .get(const GetOptions(source: Source.cache));


          if (snapshot.docs.isEmpty || snapshot.docs.length != barcodes.length) {
            debugPrint("Throwing");
            throw Exception("Snapshot Docs are empty or incorrect. Throwing local check");
          }

          debugPrint("Data Found In Local Firebase Cache");

        } catch (error) {
          debugPrint(error.toString());
          debugPrint("No data found in cache or an exception has occurred");
          debugPrint("Checking Server");

          snapshot = await FirebaseFirestore.instance
              .collection('recipe-data')
              .where(FieldPath.documentId, whereIn: barcodes)
              .get(const GetOptions(source: Source.serverAndCache));

        }

      } else {

        snapshot = await FirebaseFirestore.instance
            .collection('recipe-data')
            .where(FieldPath.documentId, whereIn: barcodes)
            .get(options);

      }

      foodItems = [
        for (QueryDocumentSnapshot document in snapshot.docs)
          ConvertToFoodItem(document.get("food-data")["foodData"], firebase: true)
            ..firebaseItem = true,
      ];

      for (FoodItem item in foodItems) {
        debugPrint(item.foodName);
        debugPrint(item.calories + " Calories");
        debugPrint(item.sodium + " Salt");
      }

    } catch (exception) {
      print(exception);

      for (var barcode in barcodes) {
        foodItems.add(await GetFoodDataFromFirebase(barcode, options: options));
      }

    }

    debugPrint(foodItems.toString());
    for (FoodItem item in foodItems) {
      debugPrint(item.foodName);
      debugPrint(item.calories + " Calories");
      debugPrint(item.sodium + " Salt");
    }

    return foodItems;

  } else {

    QuerySnapshot<Map<String, dynamic>> snapshot;

    try {

      if (options == const GetOptions(source: Source.serverAndCache)) {
        debugPrint("Checking Local Cache First");

        try {

          snapshot = await FirebaseFirestore.instance
              .collection('food-data')
              .where(FieldPath.documentId, whereIn: barcodes)
              .get(const GetOptions(source: Source.cache));

          if (snapshot.docs.isEmpty || snapshot.docs.length != barcodes.length) {
            debugPrint("Throwing");
            throw Exception("Snapshot Docs are empty or incorrect. Throwing local check");
          }

          debugPrint("Data Found In Local Firebase Cache");

        } catch (error) {
          debugPrint(error.toString());
          debugPrint("No data found in cache or an exception has occurred");
          debugPrint("Checking Server");

          snapshot = await FirebaseFirestore.instance
              .collection('food-data')
              .where(FieldPath.documentId, whereIn: barcodes)
              .get(const GetOptions(source: Source.serverAndCache));

        }

      } else {

        snapshot = await FirebaseFirestore.instance
            .collection('food-data')
            .where(FieldPath.documentId, whereIn: barcodes)
            .get(options);

      }

      foodItems = [
        for (QueryDocumentSnapshot document in snapshot.docs)
          ConvertToFoodItem(document.get("food-data"), firebase: true)
            ..firebaseItem = true,
      ];

      debugPrint(foodItems.toString());
      for (FoodItem item in foodItems) {
        debugPrint(item.foodName);
        debugPrint(item.calories + " Calories");
        debugPrint(item.sodium + " Salt");
      }

    } catch (exception) {
      print(exception);

      for (var barcode in barcodes) {
        foodItems.add(await GetFoodDataFromFirebase(barcode, options: options));
      }

    }
    return foodItems;
  }
}

GetUserNutritionData(String date, {options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      debugPrint("Checking Local Cache First");

      try {

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-data")
            .doc(date)
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          debugPrint("Throwing");
          throw Exception("Snapshot Docs are empty or incorrect. Throwing local check");
        }

        debugPrint("Data Found In Local Firebase Cache");

      } catch (error) {
        debugPrint("No data found in cache or an exception has occurred");
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-data")
            .doc(date)
            .get(const GetOptions(source: Source.serverAndCache));

      }

    } else {
      debugPrint("Checking Cache or Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("nutrition-data")
          .doc(date)
          .get(options);

    }

    final Map _data = snapshot.get("nutrition-data");

    Future<List<ListFoodItem>> ToListFoodItem (_data) async {
      try {

        final List<ListFoodItem> generateFoodList = List<ListFoodItem>.generate(_data.length, (int index) {

          return ListFoodItem(
            category: _data[index]["category"] ?? "",
            barcode: _data[index]["barcode"] ?? "",
            foodServingSize: checkIfValidNumber(_data[index]["foodServingSize"]) ?? "",
            foodServings: checkIfValidNumber(_data[index]["foodServings"]) ?? "",
            foodItemData: FoodDefaultData(),
            recipe: _data[index]["recipe"] as bool,
          );
        });

        List<ListFoodItem> foodList = generateFoodList;

        List<FoodItem> foodItemList = await CheckFoodBarcodeList(
            [for (final food in foodList) if (!food.recipe) food.barcode],
            [for (final food in foodList) if (food.recipe) food.barcode],
            options: options
        );

        debugPrint("Food Item List Fetched");

        final foodListMap = {for (final food in foodItemList) food.barcode : food};

        debugPrint("Generated Food List Map");

        for (final food in foodList) {
          debugPrint("Food Item List Loop Beginning");

          debugPrint(foodListMap[0].toString());

          try {
            food.foodItemData = foodListMap[food.barcode]!;
          } catch (error, stacktrace) {

            debugPrint(error.toString());
            debugPrint(stacktrace.toString());

            debugPrint("Error on loading food item with barcode " + food.barcode);
            debugPrint("Category " + food.category);
            debugPrint("Recipe Status ${food.recipe.toString()}");
            debugPrint("Food Name ${food.foodItemData.foodName}");
          }

          debugPrint("Food Item List Loop End");
        }

        debugPrint("Returning Food Item List");

        return foodList;

      } catch (exception) {
        print(exception);

        return [];
      }
    }

    Future<List<ListExerciseItem>> ToListExerciseItem (_data) async {
      try {

        final List<ListExerciseItem> generateExerciseList = List<ListExerciseItem>.generate(_data.length, (int index) {

          return ListExerciseItem(
            category: _data[index]["category"] ?? "",
            name: _data[index]["name"] ?? "",
            calories: _data[index]["calories"] ?? "",
            extraInfoField: _data[index]["extraInfoField"] ?? "",
            hideDelete: _data[index]["hideDelete"] ?? false,
          );
        });

        return generateExerciseList;

      } catch (exception) {
        print(exception);

        return [];
      }
    }

    List<ListFoodItem> breakfastList = [];
    List<ListFoodItem> lunchList = [];
    List<ListFoodItem> dinnerList = [];
    List<ListFoodItem> snacksList = [];
    List<ListExerciseItem> exerciseList = [];

    await Future.wait<void>([
      ToListFoodItem(_data["foodListItemsBreakfast"]).then((result) => breakfastList = result),
      ToListFoodItem(_data["foodListItemsLunch"]).then((result) => lunchList = result),
      ToListFoodItem(_data["foodListItemsDinner"]).then((result) => dinnerList = result),
      ToListFoodItem(_data["foodListItemsSnacks"]).then((result) => snacksList = result),
      ToListExerciseItem(_data["foodListItemsExercise"]).then((result) => exerciseList = result),
    ]);

    return UserNutritionModel(
        date: _data["date"] ?? "",
        foodListItemsBreakfast: breakfastList,
        foodListItemsLunch: lunchList,
        foodListItemsDinner: dinnerList,
        foodListItemsSnacks: snacksList,
        foodListItemsExercise: exerciseList,
        water: _data["water"],
    );

  } catch (exception) {
    print("nutrition failed");
    print(exception);

    return UserNutritionModel(
      date: date,
      foodListItemsBreakfast: [],
      foodListItemsLunch: [],
      foodListItemsDinner: [],
      foodListItemsSnacks: [],
      foodListItemsExercise: [],
      water: 0,
    );
  }

}

GetUserNutritionHistory({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot snapshot;


    if (options == const GetOptions(source: Source.serverAndCache)) {
      debugPrint("Checking Local Cache First");

      try {

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-history-data")
            .doc("history")
            .get(const GetOptions(source: Source.cache));


        if (!snapshot.exists) {
          debugPrint("Throwing");
          throw Exception("Snapshot Docs are empty or incorrect. Throwing local check");
        }

        debugPrint("Data Found In Local Firebase Cache");

      } catch (error) {
        debugPrint("No data found in cache or an exception has occurred");
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-history-data")
            .doc("history")
            .get(const GetOptions(source: Source.serverAndCache));

      }

    } else {
      debugPrint("Checking Cache or Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("nutrition-history-data")
          .doc("history")
          .get(options);

    }

    final _data = snapshot.get("history");

    UserNutritionFoodModel historyModel = UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"]),
      foodListItemNames: List<String>.from(_data["foodListItemNames"]),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"])),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"])),
      recipe: List<bool>.from(_data["recipe"]),
    );

    return historyModel;

  } catch (exception) {
    print(exception);

    return UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );

  }
}

GetUserCustomFood({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {


      try {

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-custom-food-data")
            .doc("food")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Doc Is Empty. Throwing Custom Food.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-custom-food-data")
            .doc("food")
            .get(const GetOptions(source: Source.serverAndCache));

      }

    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("nutrition-custom-food-data")
          .doc("food")
          .get(options);

    }

    final _data = snapshot.get("food");

    return UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"]),
      foodListItemNames: List<String>.from(_data["foodListItemNames"]),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"])),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"])),
      recipe: List<bool>.generate(_data["barcodes"].length, (index) => false),
    );

  } catch (exception) {
    debugPrint(exception.toString());
    return UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );
  }
}

GetUserCustomRecipes({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {


      try {

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-recipes-food-data")
            .doc("food")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Doc Is Empty. Throwing Custom Recipes.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("nutrition-recipes-food-data")
            .doc("food")
            .get(const GetOptions(source: Source.serverAndCache));

      }

    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("nutrition-recipes-food-data")
          .doc("food")
          .get(options);

    }

    final _data = snapshot.get("food");

    return UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"]),
      foodListItemNames: List<String>.from(_data["foodListItemNames"]),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"])),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"])),
      recipe: List<bool>.generate(_data["barcodes"].length, (index) => true),
    );

  } catch (exception) {
    debugPrint(exception.toString());
    return UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );
  }
}

GetFoodDataFromFirebaseRecipe(String barcode, {options = const GetOptions(source: Source.serverAndCache)}) async {

  print("firebase get");

  try {

    final snapshot = await FirebaseFirestore.instance
        .collection('recipe-data')
        .doc(barcode)
        .get(options);

    final _data = snapshot.get("food-data");

    final List<ListFoodItem> generateFoodList = List<ListFoodItem>.generate(_data["recipeFoodList"].length, (int index) {

      return ListFoodItem(
        category: _data["recipeFoodList"][index]["category"] ?? "",
        barcode: _data["recipeFoodList"][index]["barcode"] ?? "",
        foodServingSize: _data["recipeFoodList"][index]["foodServingSize"] ?? "",
        foodServings: _data["recipeFoodList"][index]["foodServings"] ?? "",
        foodItemData: FoodDefaultData(),
        recipe: _data["recipeFoodList"][index]["recipe"] as bool,
      );
    });

    List<ListFoodItem> foodList = generateFoodList;

    return UserRecipesModel(
      barcode: _data["barcode"] ?? "",
      recipeFoodList: foodList,
      foodData: FoodItem(
        barcode: _data["foodData"]["barcode"] ?? "",
        foodName: _data["foodData"]["foodName"] ?? "",
        quantity: _data["foodData"]["quantity"] ?? "",
        servingSize: _data["foodData"]["servingSize"] ?? "",
        servings: _data["foodData"]["servings"] ?? "",
        calories: _data["foodData"]["calories"] ?? "",
        kiloJoules: _data["foodData"]["kiloJoules"] ?? "",
        proteins: _data["foodData"]["proteins"] ?? "",
        carbs: _data["foodData"]["carbs"] ?? "",
        fiber: _data["foodData"]["fiber"] ?? "",
        sugars: _data["foodData"]["sugars"] ?? "",
        fat: _data["foodData"]["fat"] ?? "",
        saturatedFat: _data["foodData"]["saturatedFat"] ?? "",
        polyUnsaturatedFat: _data["foodData"]["polyUnsaturatedFat"] ?? "",
        monoUnsaturatedFat: _data["foodData"]["monoUnsaturatedFat"] ?? "",
        transFat: _data["foodData"]["transFat"] ?? "",
        cholesterol: _data["foodData"]["cholesterol"] ?? "",
        calcium: _data["foodData"]["calcium"] ?? "",
        iron: _data["foodData"]["iron"] ?? "",
        sodium: _data["foodData"]["sodium"] ?? "",
        zinc: _data["foodData"]["zinc"] ?? "",
        magnesium: _data["foodData"]["magnesium"] ?? "",
        potassium: _data["foodData"]["potassium"] ?? "",
        vitaminA: _data["foodData"]["vitaminA"] ?? "",
        vitaminB1: _data["foodData"]["vitaminB1"] ?? "",
        vitaminB2: _data["foodData"]["vitaminB2"] ?? "",
        vitaminB3: _data["foodData"]["vitaminB3"] ?? "",
        vitaminB6: _data["foodData"]["vitaminB6"] ?? "",
        vitaminB9: _data["foodData"]["vitaminB9"] ?? "",
        vitaminB12: _data["foodData"]["vitaminB12"] ?? "",
        vitaminC: _data["foodData"]["vitaminC"] ?? "",
        vitaminD: _data["foodData"]["vitaminD"] ?? "",
        vitaminE: _data["foodData"]["vitaminE"] ?? "",
        vitaminK: _data["foodData"]["vitaminK"] ?? "",
        omega3: _data["foodData"]["omega3"] ?? "",
        omega6: _data["foodData"]["omega6"] ?? "",
        alcohol: _data["foodData"]["alcohol"] ?? "",
        biotin: _data["foodData"]["biotin"] ?? "",
        butyricAcid: _data["foodData"]["butyricAcid"] ?? "",
        caffeine: _data["foodData"]["caffeine"] ?? "",
        capricAcid: _data["foodData"]["capricAcid"] ?? "",
        caproicAcid: _data["foodData"]["caproicAcid"] ?? "",
        caprylicAcid: _data["foodData"]["caprylicAcid"] ?? "",
        chloride: _data["foodData"]["chloride"] ?? "",
        chromium: _data["foodData"]["chromium"] ?? "",
        copper: _data["foodData"]["copper"] ?? "",
        docosahexaenoicAcid: _data["foodData"]["docosahexaenoicAcid"] ?? "",
        eicosapentaenoicAcid: _data["foodData"]["eicosapentaenoicAcid"] ?? "",
        erucicAcid: _data["foodData"]["erucicAcid"] ?? "",
        fluoride: _data["foodData"]["fluoride"] ?? "",
        iodine: _data["foodData"]["iodine"] ?? "",
        manganese: _data["foodData"]["manganese"] ?? "",
        molybdenum: _data["foodData"]["molybdenum"] ?? "",
        myristicAcid: _data["foodData"]["myristicAcid"] ?? "",
        oleicAcid: _data["foodData"]["oleicAcid"] ?? "",
        palmiticAcid: _data["foodData"]["palmiticAcid"] ?? "",
        pantothenicAcid: _data["foodData"]["pantothenicAcid"] ?? "",
        selenium: _data["foodData"]["selenium"] ?? "",
        stearicAcid: _data["foodData"]["stearicAcid"] ?? "",
        recipe: _data["foodData"]["recipe"] as bool,
        firebaseItem: true,
      ),
    );

  } catch (exception) {
    print(exception);
  }
}

GetRecipeFoodList(List<ListFoodItem> foodList) async {

  List<List<String>> splitList(List<String> list, int chunkSize) {
    List<List<String>> result = [];

    for (int i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      result.add(list.sublist(i, end));
    }

    return result;
  }

  List<String> recipeBarcodeList = List.generate(foodList.length, (index) => foodList[index].barcode);

  List<List<String>> recipeBarcodeListofLists = splitList(recipeBarcodeList, 10);

  List<FoodItem> foodItemDataComplete = [];

  try{

    for (List<String> barcodes in recipeBarcodeListofLists) {
      final snapshot = await FirebaseFirestore.instance
          .collection('food-data')
          .where(FieldPath.documentId, whereIn: barcodes)
          .get();

      List<FoodItem> foodItemData = [
        for (QueryDocumentSnapshot document in snapshot.docs)
          ConvertToFoodItem(document.get("food-data"), firebase: true)
            ..firebaseItem = true,
      ];

      foodItemDataComplete.addAll(foodItemData);
    }

      final foodListMap = {for (final food in foodItemDataComplete) food.barcode : food};
      for (final food in foodList) {

        ///TODO Implement null check

        try {
          food.foodItemData = foodListMap[food.barcode]!;
        } catch (error, stacktrace) {

          debugPrint(error.toString());
          debugPrint(stacktrace.toString());

          debugPrint("Error on loading food item with barcode " + food.barcode);
          debugPrint("Category " + food.category);
          debugPrint("Recipe Status ${food.recipe.toString()}");
          debugPrint("Food Name ${food.foodItemData.foodName}");
        }

      }

      return foodList;

  } catch (exception) {
    print("Recipe fetch failed");
    print(exception);

  }

}

GetUserBioData({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {


      try {

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("bioData")
            .doc("bioData")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Doc Is Empty. Throwing BioData.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection("bioData")
            .doc("bioData")
            .get(const GetOptions(source: Source.serverAndCache));

      }

    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection("bioData")
          .doc("bioData")
          .get(options);

    }

    return UserDataModel(
        height: snapshot["bioData"]["height"],
        weight: snapshot["bioData"]["weight"],
        age: snapshot["bioData"]["age"],
        activityLevel: snapshot["bioData"]["activityLevel"],
        weightGoal: snapshot["bioData"]["weightGoal"],
        biologicalSex: snapshot["bioData"]["biologicalSex"],
        calories: snapshot["bioData"]["calories"],
    );

  } catch (exception) {
    debugPrint(exception.toString());

    return UserDataModel(
      height: "1",
      weight: "1",
      age: "1",
      activityLevel: "0",
      weightGoal: "0",
      biologicalSex: "0",
      calories: "10",
    );

  }
}

GetUserCalories() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("calories")
        .doc("calories")
        .get();

    return snapshot["calories"];

  } catch (exception) {
    print(exception);
  }
}

GetUserGroceryLists({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection('grocery-data')
            .doc("grocery-lists")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Groceries Lists.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection('grocery-data')
            .doc("grocery-lists")
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection('grocery-data')
          .doc("grocery-lists")
          .get(options);

    }

    return List<String>.from(snapshot["groceryLists"]);

  } catch (exception) {
    print(exception);
    return <String>[];
  }
}

GetUserGroceryListID({options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection('grocery-data')
            .doc("selected-grocery-list")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Groceries List ID.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc("${firebaseAuth.currentUser?.uid.toString()}")
            .collection('grocery-data')
            .doc("selected-grocery-list")
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc("${firebaseAuth.currentUser?.uid.toString()}")
          .collection('grocery-data')
          .doc("selected-grocery-list")
          .get(options);

    }

    return snapshot["groceryListID"];

  } catch (exception) {
    debugPrint(exception.toString());
    return Uuid().v4.toString();
  }
}

GetUserGroceries(String groceryListID) async {
  try {

    print("Getting Groceries");

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = FirebaseFirestore.instance
        .collection('grocery-lists')
        .doc(groceryListID)
        .collection('grocery-data')
        .where(FieldPath.documentId)
        .snapshots()
        .listen((event) {

          List<GroceryItem> groceryItems = [
          for (QueryDocumentSnapshot document in event.docs)
            GroceryItem(
              uuid: document.get("groceryData")["uuid"],
              barcode: document.get("groceryData")["barcode"],
              foodName: document.get("groceryData")["foodName"],
              cupboard: document.get("groceryData")["cupboard"],
              fridge: document.get("groceryData")["fridge"],
              freezer: document.get("groceryData")["freezer"],
              needed: document.get("groceryData")["needed"],
            ),
          ];
        });

  } catch (exception) {
    print(exception);
  }
}

GetExerciseLogData(String exerciseName, {options = const GetOptions(source: Source.serverAndCache)}) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-data')
            .doc(exerciseName)
            .collection("exercise-tracking-data")
            .orderBy("timeStamp", descending: true)
            .limit(7)
            .where("timeStamp", isLessThanOrEqualTo: DateTime.now().toUtc())
            .get(const GetOptions(source: Source.cache));

        if (snapshot.docs.isEmpty) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Past Workout Data.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-data')
            .doc(exerciseName)
            .collection("exercise-tracking-data")
            .orderBy("timeStamp", descending: true)
            .limit(7)
            .where("timeStamp", isLessThanOrEqualTo: DateTime.now().toUtc())
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-data')
          .doc(exerciseName)
          .collection("exercise-tracking-data")
          .orderBy("timeStamp", descending: true)
          .limit(7)
          .where("timeStamp", isLessThanOrEqualTo: DateTime.now().toUtc())
          .get(options);

    }

    DocumentSnapshot <Map<String, dynamic>> repsAndWeightSnapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        repsAndWeightSnapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-data')
            .doc(exerciseName)
            .get(const GetOptions(source: Source.cache));

        if (!repsAndWeightSnapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Past Workout Data.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        repsAndWeightSnapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-data')
            .doc(exerciseName)
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      repsAndWeightSnapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-data')
          .doc(exerciseName)
          .get(options);

    }

    Map mapData(data) {

      return {
        "measurementDate": data["data"][0]["measurementDate"],
        "measurementTimeStamp": data["data"][0]["measurementTimeStamp"],
        "repValues": data["data"][0]["repValues"],
        "weightValues": data["data"][0]["weightValues"],
        "intensityValues": data["data"][0]["intensityValues"]
      };

    }

    ExerciseModel data = ExerciseModel(
        exerciseName: exerciseName,
        exerciseTrackingData: RepsWeightStatsMeasurement(
          measurementName: exerciseName,
          dailyLogs: [
            for (QueryDocumentSnapshot document in snapshot.docs)
              mapData(document.data())
          ],
        ),
        category: repsAndWeightSnapshot.data()?["category"],
        primaryMuscle: repsAndWeightSnapshot.data()?["primary-muscle"],
        secondaryMuscle: repsAndWeightSnapshot.data()?["secondary-muscle"],
        tertiaryMuscle: repsAndWeightSnapshot.data()?["tertiary-muscle"],
        type: repsAndWeightSnapshot.data()?["type"] ?? 0,
        exerciseTrackingType: repsAndWeightSnapshot.data()?["exerciseTrackingType"],
        exerciseMaxRepsAndWeight: repsAndWeightSnapshot.data()?["data"] == null ? {}
            : repsAndWeightSnapshot.data()!["data"].map<String, String>((key, value) => MapEntry<String, String>(key.toString(), value.toString()))
    );

    return data;

  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

GetMoreExerciseLogData(String exerciseName, String date) async {
  try {

    DateTime previousDay = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(date)).toString());


    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot;

    try {
      debugPrint("Checking Cache First");
      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-data')
          .doc(exerciseName)
          .collection("exercise-tracking-data")
          .orderBy("timeStamp", descending: true)
          .limit(7)
          .where("timeStamp", isLessThanOrEqualTo: DateTime(previousDay.year, previousDay.month, previousDay.day-1).toUtc())
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) {
        throw Exception("Snapshot Docs are empty or incorrect. Throwing Past Exercise Data.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-data')
          .doc(exerciseName)
          .collection("exercise-tracking-data")
          .orderBy("timeStamp", descending: true)
          .limit(7)
          .where("timeStamp", isLessThanOrEqualTo: DateTime(previousDay.year, previousDay.month, previousDay.day-1).toUtc())
          .get(const GetOptions(source: Source.serverAndCache));

    }

    Map mapData(data) {

      return {
        "measurementDate": data["data"][0]["measurementDate"],
        "measurementTimeStamp": data["data"][0]["measurementTimeStamp"],
        "repValues": data["data"][0]["repValues"],
        "weightValues": data["data"][0]["weightValues"]
      };

    }

    ExerciseModel data = ExerciseModel(
        exerciseName: exerciseName,
        exerciseTrackingData: RepsWeightStatsMeasurement(
          measurementName: exerciseName,
          dailyLogs: [
            for (QueryDocumentSnapshot document in snapshot.docs)
              mapData(document.data())
          ],
        ),
      exerciseMaxRepsAndWeight: {},
    );

    return data;

  } catch (exception) {
    print(exception);
  }
}

GetRoutinesData({options = const GetOptions(source: Source.serverAndCache)}) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  QuerySnapshot<Map<String, dynamic>> snapshot;

  if (options == const GetOptions(source: Source.serverAndCache)) {
    try {
      debugPrint("Checking Cache First For User Measurements");
      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('routine-data')
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) {
        throw Exception("Snapshot Docs are empty or incorrect. Throwing Routines.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('routine-data')
          .get(const GetOptions(source: Source.serverAndCache));

    }
  } else {

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('routine-data')
        .get(options);

  }

  List<ExerciseListModel> buildExerciseListObjects(data) {

    if (data.isEmpty) {
      return [];
    }

    List<ExerciseListModel> exercises =  [
      for (Map exercise in data)
        ExerciseListModel(
          exerciseName: exercise["exerciseName"],
          exerciseDate: exercise["exerciseDate"],
          exerciseTrackingType: exercise["exerciseTrackingType"],
          mainOrAccessory: exercise["mainOrAccessory"],
        )
    ];

    return exercises;

  }

  List<RoutinesModel> routines = [
    for (QueryDocumentSnapshot document in snapshot.docs)
      RoutinesModel(
          routineID: document["routineID"],
          routineDate: document["routineDate"],
          routineName: document["routineName"],
          exercises: buildExerciseListObjects(document["exercises"]),
          exerciseSetsAndRepsPlan: (document.data() as Map<String,dynamic>).containsKey('setsAndRepsPlan') ? document["setsAndRepsPlan"] : {},
      )
  ];

  return routines;

}


GetExerciseData({options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('exercise-data')
            .doc('exercise-names')
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Exercise Data.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('exercise-data')
            .doc('exercise-names')
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('exercise-data')
          .doc('exercise-names')
          .get(options);

    }

    bool _exists;
    try {
      ///Not 100% sure why I'm doing this. Seems to be just a method to check if the field "data" is there else return blank.
      ///Most likely because attempting to check the field "data" if it is not there throws an error in the containing try catch block
      var test = snapshot["data"];
      _exists = true;

    } catch (e) {

      _exists = false;

    }

    List<String> exerciseData = _exists ? List<String>.from(snapshot['data']) : [];

    return exerciseData;

  } catch (e, stackTrace) {
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    return [];

  }



}

GetCategoriesData({options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('exercise-data')
            .doc('category-names')
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Categories.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('exercise-data')
            .doc('category-names')
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('exercise-data')
          .doc('category-names')
          .get(options);

    }

    bool _exists;
    try {
      var test = snapshot["data"];
      _exists = true;

    } catch (e) {

      _exists = false;

    }

    List<String> exerciseData = _exists ? List<String>.from(snapshot['data']) : [];

    return exerciseData;

  } catch (e, stackTrace) {

    debugPrint("Error Located");
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    return [];

  }



}

GetWorkoutStarted({options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    QuerySnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('current-workout-data')
            .where("started", isEqualTo: true)
            .get(const GetOptions(source: Source.cache));

        if (snapshot.docs.isEmpty) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Check On Workout Now.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('current-workout-data')
            .where("started", isEqualTo: true)
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('current-workout-data')
          .where("started", isEqualTo: true)
          .get(options);

    }

    dynamic data = [
      for (QueryDocumentSnapshot document in snapshot.docs)
        document.data()
    ];

    return data[0]["started"];


  } catch (error) {

    debugPrint(error.toString());

    return false;

  }


}

GetCurrentWorkoutData() async {

  int returnType(int? type) {

    if (type != null) {
      return type;
    }
    return 0;
  }

  exercisesToModel(data) {

    return [
      for (Map exercise in data)
        WorkoutLogExerciseDataModel(
          measurementName: exercise["measurementName"],
          routineName: exercise["routineName"],
          intensityNumber: exercise["intensityNumber"] != null ? exercise["intensityNumber"].toDouble() : 5.0,
          type: exercise.toString().contains('type') ? returnType(exercise["type"]) : 0,
          reps: exercise["reps"].toDouble(),
          weight: exercise["weight"].toDouble(),
          timestamp: exercise["timestamp"],
        ),
      ];
    
  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic data = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('current-workout-data')
      .doc("workout")
      .get();
  
  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

    
  }


  return WorkoutLogModel(
    startOfWorkout: parseDateTime(data["startOfWorkout"]),
    endOfWorkout: parseDateTime(data["endOfWorkout"]),
    exercises: exercisesToModel(data["exercises"]),
    routineNames: List<String>.from(data["routineNames"]),
  );

}

GetPastWorkoutData(dynamic? document, {options = const GetOptions(source: Source.serverAndCache)}) async {
try {

  int returnType(int? type) {

    if (type != null) {
      return type;
    }
    return 0;
  }

  //DateTime previousDay = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(date)).toString());

  exercisesToModel(data) {

    debugPrint(data[0]["measurementName"]);

    return [
      for (Map exercise in data)
        WorkoutLogExerciseDataModel(
          measurementName: exercise["measurementName"],
          routineName: exercise["routineName"],
          intensityNumber: exercise["intensityNumber"] != null ? exercise["intensityNumber"].toDouble() : 5.0,
          type: exercise.toString().contains('type') ? returnType(exercise["type"]) : 0,
          reps: exercise["reps"].toDouble(),
          weight: exercise["weight"].toDouble(),
          timestamp: exercise["timestamp"],
        ),
    ];

  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  QuerySnapshot<Map<String, dynamic>> snapshot;

  if (document != null) {

    debugPrint("More data");

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-log-data')
            .orderBy("time-stamp", descending: true)
            .limit(7)
            .startAfterDocument(document)
            .get(const GetOptions(source: Source.cache));

        if (snapshot.docs.isEmpty) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Past Workout Data.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-log-data')
            .orderBy("time-stamp", descending: true)
            .limit(7)
            .startAfterDocument(document)
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-log-data')
          .orderBy("time-stamp", descending: true)
          .limit(7)
          .startAfterDocument(document)
          .get(options);

    }

  } else {

    debugPrint("Less data");

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-log-data')
            .orderBy("time-stamp", descending: true)
            .limit(7)
            .where("time-stamp", isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).toUtc())
            .get(const GetOptions(source: Source.cache));

        if (snapshot.docs.isEmpty) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Past Workout Data.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-log-data')
            .orderBy("time-stamp", descending: true)
            .limit(7)
            .where("time-stamp", isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).toUtc())
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-log-data')
          .orderBy("time-stamp", descending: true)
          .limit(7)
          .where("time-stamp", isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).toUtc())
          .get(options);

    }

  }

  dynamic parseDateTime(Timestamp? timeStamp) {

    debugPrint("timestamp");

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }

  return {
    "workoutLogs": <WorkoutLogModel>[

    for (dynamic document in snapshot.docs)
      WorkoutLogModel(
        startOfWorkout: parseDateTime(document.data()["data"]["startOfWorkout"]),
        endOfWorkout: parseDateTime(document.data()["data"]["endOfWorkout"]),
        exercises: exercisesToModel(document.data()["data"]["exercises"]),
        routineNames: List<String>.from(document.data()["data"]["routineNames"]),
      )
  ],
    "lastDoc": snapshot.docs.isEmpty ? document : snapshot.docs.last,
  };


  } catch (error, stacktrace) {

    debugPrint(error.toString());
    debugPrint(stacktrace.toString());
    debugPrint("error");

  }

}

GetWorkoutOverallStats({options = const GetOptions(source: Source.serverAndCache)}) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    DocumentSnapshot<Map<String, dynamic>> snapshot;

    if (options == const GetOptions(source: Source.serverAndCache)) {
      try {
        debugPrint("Checking Cache First For User Measurements");
        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-overall-stats')
            .doc("stats")
            .get(const GetOptions(source: Source.cache));

        if (!snapshot.exists) {
          throw Exception("Snapshot Docs are empty or incorrect. Throwing Workout Stats.");
        }

      } catch (error, stacktrace) {
        debugPrint(error.toString());
        debugPrint(stacktrace.toString());
        debugPrint("Checking Server");

        snapshot = await FirebaseFirestore.instance
            .collection('user-data')
            .doc(firebaseAuth.currentUser!.uid)
            .collection('workout-overall-stats')
            .doc("stats")
            .get(const GetOptions(source: Source.serverAndCache));

      }
    } else {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-overall-stats')
          .doc("stats")
          .get(options);

    }

    dynamic parseDateTime(Timestamp? timeStamp) {

      if (timeStamp != null) {
        return timeStamp.toDate();
      }
      return null;

    }

    bool _exists;
    try {
      var test = snapshot["totalVolume"];
      _exists = true;

    } catch (e) {

      _exists = false;

    }

    return _exists ? WorkoutOverallStatsModel(
      totalVolume: snapshot["totalVolume"],
      totalReps: snapshot["totalReps"],
      totalSets: snapshot["totalSets"],
      totalWorkouts: snapshot["totalWorkouts"],
      totalAverageDuration: snapshot["totalAverageDuration"],
      totalVolumeThisYear: snapshot["totalVolumeThisYear"],
      totalVolumeThisMonth: snapshot["totalVolumeThisMonth"],
      totalRepsThisYear: snapshot["totalRepsThisYear"],
      totalRepsThisMonth: snapshot["totalRepsThisMonth"],
      totalSetsThisYear: snapshot["totalSetsThisYear"],
      totalSetsThisMonth: snapshot["totalSetsThisMonth"],
      totalWorkoutsThisYear: snapshot["totalWorkoutsThisYear"],
      totalWorkoutsThisMonth: snapshot["totalWorkoutsThisMonth"],
      averageDurationThisYear: snapshot["averageDurationThisYear"],
      averageDurationThisMonth: snapshot["averageDurationThisMonth"],
      lastLog: parseDateTime(snapshot["lastLog"]),
    ) :
    WorkoutOverallStatsModel(
      totalVolume: 0,
      totalReps: 0,
      totalSets: 0,
      totalWorkouts: 0,
      totalAverageDuration: 0,
      totalVolumeThisYear: 0,
      totalVolumeThisMonth: 0,
      totalRepsThisYear: 0,
      totalRepsThisMonth: 0,
      totalSetsThisYear: 0,
      totalSetsThisMonth: 0,
      totalWorkoutsThisYear: 0,
      totalWorkoutsThisMonth: 0,
      averageDurationThisYear: 0,
      averageDurationThisMonth: 0,
      lastLog: DateTime.now(),
    );

  } catch (e, stackTrace) {

    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    return WorkoutOverallStatsModel(
      totalVolume: 0,
      totalReps: 0,
      totalSets: 0,
      totalWorkouts: 0,
      totalAverageDuration: 0,
      totalVolumeThisYear: 0,
      totalVolumeThisMonth: 0,
      totalRepsThisYear: 0,
      totalRepsThisMonth: 0,
      totalSetsThisYear: 0,
      totalSetsThisMonth: 0,
      totalWorkoutsThisYear: 0,
      totalWorkoutsThisMonth: 0,
      averageDurationThisYear: 0,
      averageDurationThisMonth: 0,
      lastLog: DateTime.now(),
    );

  }


}

GetWeekdayExerciseTracking({options = const GetOptions(source: Source.serverAndCache)}) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  ///When this isn't set to dynamic throws an error. Not sure why yet.
  dynamic snapshot;

  if (options == const GetOptions(source: Source.serverAndCache)) {
    try {
      debugPrint("Checking Cache First For User Measurements");
      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('current-workout-data')
          .doc("week-days-worked")
          .get(const GetOptions(source: Source.cache));

      if (!snapshot.exists) {
        throw Exception("Snapshot Docs are empty or incorrect. Throwing Workout Weekday Tracking.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('current-workout-data')
          .doc("week-days-worked")
          .get(const GetOptions(source: Source.serverAndCache));

    }
  } else {

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('current-workout-data')
        .doc("week-days-worked")
        .get(options);

  }


  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }

  Map<String, dynamic> snapshotMap;

  try {

    snapshotMap = snapshot.data() != null ? Map<String, dynamic>.from(snapshot.data()) : {

      "Monday": false,
      "Tuesday": false,
      "Wednesday": false,
      "Thursday": false,
      "Friday": false,
      "Saturday": false,
      "Sunday": false,
      "lastDate": DateTime.now(),

    };
    snapshotMap["lastDate"] = snapshot.data() != null ? parseDateTime(snapshotMap["lastDate"]) : DateTime.now();

  } catch (e, stackTrace) {
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    snapshotMap = {

      "Monday": false,
      "Tuesday": false,
      "Wednesday": false,
      "Thursday": false,
      "Friday": false,
      "Saturday": false,
      "Sunday": false,
      "lastDate": DateTime.now(),

    };

  }

  return snapshotMap;

}

GetDailyStreak({options = const GetOptions(source: Source.serverAndCache)}) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  ///When this is not dynamic it has an error. Not sure why.
  dynamic snapshot;

  if (options == const GetOptions(source: Source.serverAndCache)) {


    try {

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('user-data')
          .doc("daily-streak")
          .get(const GetOptions(source: Source.cache));

      if (!snapshot.exists) {
        throw Exception("Snapshot Doc Is Empty. Throwing Streak.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('user-data')
          .doc("daily-streak")
          .get(const GetOptions(source: Source.serverAndCache));

    }

  } else {

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('user-data')
        .doc("daily-streak")
        .get(options);

  }


  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }
  Map<String, dynamic> snapshotMap;
  try {

    snapshotMap = snapshot.data() != null ? Map<String, dynamic>.from(snapshot.data()) : {

      "dailyStreak": 0,
      "lastDate": DateTime.now(),

    };

    snapshotMap["lastDate"] = snapshot.data() != null ? parseDateTime(snapshotMap["lastDate"]) : DateTime.now();

  } catch (e, stackTrace) {
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    snapshotMap = {

      "dailyStreak": 0,
      "lastDate": DateTime.now(),

    };

  }

  return snapshotMap;

}

GetRoutineVolumeData(String routineName, {options = const GetOptions(source: Source.serverAndCache)}) async {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      dynamic snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('workout-routine-stats')
          .doc(routineName)
          .get(options);

      return StatsMeasurement(
        measurementID: snapshot["measurements-data"]['measurementID'],
        measurementName: snapshot["measurements-data"]["measurementName"],
        measurementValues: List<double>.from(snapshot["measurements-data"]["measurementData"].map((e) => e.toDouble()).toList()),
        measurementDates: List<String>.from(snapshot["measurements-data"]["measurementDate"]),
      );
}


GetTrainingPlanOrder({options = const GetOptions(source: Source.serverAndCache)}) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  DocumentSnapshot snapshot;

  if (options == const GetOptions(source: Source.serverAndCache)) {
    try {
      debugPrint("Checking Cache First For Training Plan Order");
      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('training-plan-data')
          .doc("trainingPlanOrder")
          .get(const GetOptions(source: Source.cache));

      if (!snapshot.exists) {
        throw Exception("Snapshot Docs are empty or incorrect. Throwing Training Plan Order.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('training-plan-data')
          .doc("trainingPlanOrder")
          .get(const GetOptions(source: Source.serverAndCache));

    }
  } else {

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('training-plan-data')
        .doc("trainingPlanOrder")
        .get(options);

  }

  return snapshot["data"].map<int, String>(
      (key, value) => MapEntry<int, String>(int.parse(key), value.toString())
  );

}


GetTrainingPlans({options = const GetOptions(source: Source.serverAndCache)}) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  QuerySnapshot<Map<String, dynamic>> snapshot;

  if (options == const GetOptions(source: Source.serverAndCache)) {
    try {
      debugPrint("Checking Cache First For Training Plans");
      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('training-plans')
          .get(const GetOptions(source: Source.cache));

      if (snapshot.docs.isEmpty) {
        throw Exception("Snapshot Docs are empty or incorrect. Throwing Training Plans.");
      }

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
      debugPrint("Checking Server");

      snapshot = await FirebaseFirestore.instance
          .collection('user-data')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('training-plans')
          .get(const GetOptions(source: Source.serverAndCache));

    }
  } else {

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('training-plans')
        .get(options);

  }

  List<TrainingPlanWeek> buildTrainingPlanWeekObjects(data) {

    if (data.isEmpty) {
      return [];
    }

    List<TrainingPlanWeek> trainingPlanWeeks =  [
      for (Map trainingWeek in data)
        TrainingPlanWeek(
            weekNumber: trainingWeek["weekNumber"],
            mondayRoutineID: trainingWeek["monday"],
            tuesdayRoutineID: trainingWeek["tuesday"],
            wednesdayRoutineID: trainingWeek["wednesday"],
            thursdayRoutineID: trainingWeek["thursday"],
            fridayRoutineID: trainingWeek["friday"],
            saturdayRoutineID: trainingWeek["saturday"],
            sundayRoutineID: trainingWeek["sunday"],
        )
    ];

    return trainingPlanWeeks;

  }

  List<TrainingPlan> trainingPlans = [
    for (QueryDocumentSnapshot document in snapshot.docs)
      TrainingPlan(
        trainingPlanName: document["trainingPlanName"],
        trainingPlanWeeks: buildTrainingPlanWeekObjects(document["trainingPlanWeek"]),
        trainingPlanID: (document.data() as Map<String,dynamic>).containsKey('trainingPlanID') ? document["trainingPlanID"] : null,
      )
  ];

  return trainingPlans;

}


GetTrainingPlanByCode(String trainingPlanCode, {options = const GetOptions(source: Source.server)}) async {


  List<ExerciseListModel> generateExerciseList(data) {

    List<ExerciseListModel> exercises =  [
      for (Map exercise in data)
        ExerciseListModel(
          exerciseName: exercise["exerciseName"],
          exerciseDate: exercise["exerciseDate"],
          ///For some reason tracking type and accessory are swapped around
          exerciseTrackingType: exercise["mainOrAccessory"],
          mainOrAccessory: exercise["mainOrAccessory"],
        )
    ];

    for (final exercise in exercises) {
      debugPrint(exercise.mainOrAccessory.toString());
      debugPrint(exercise.exerciseTrackingType.toString());
    }

    return exercises;

  }


  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('training-plans')
      .doc(trainingPlanCode)
      .get(options);

  final snapshotData = snapshot["data"];

  final List<String> routinesListIDs = [
    snapshotData["trainingPlanWeek"][0]["monday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["tuesday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["wednesday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["thursday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["friday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["saturday"]["routineID"],
    snapshotData["trainingPlanWeek"][0]["sunday"]["routineID"],
  ];

  for (int i = 0; i < routinesListIDs.length; i++) {
    if (routinesListIDs[i] != "-1") {
      routinesListIDs[i] = const Uuid().v4().toString();
    }
  }

  final List<RoutinesModel> routinesList = [
    RoutinesModel(
      routineID: routinesListIDs[0],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["monday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["monday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["monday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["monday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[1],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["tuesday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["tuesday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["tuesday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["tuesday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[2],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["wednesday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["wednesday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["wednesday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["wednesday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[3],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["thursday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["thursday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["thursday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["thursday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[4],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["friday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["friday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["friday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["friday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[5],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["saturday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["saturday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["saturday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["saturday"]["exerciseSetsAndRepsPlan"] : {},
    ),
    RoutinesModel(
      routineID: routinesListIDs[6],
      routineDate: "",
      routineName: snapshotData["trainingPlanWeek"][0]["sunday"]["routineName"],
      exercises: generateExerciseList(snapshotData["trainingPlanWeek"][0]["sunday"]["exercises"]),
      exerciseSetsAndRepsPlan: (snapshotData["trainingPlanWeek"][0]["sunday"] as Map<String,dynamic>).containsKey('exerciseSetsAndRepsPlan') ? snapshotData["trainingPlanWeek"][0]["sunday"]["exerciseSetsAndRepsPlan"] : {},
    ),

  ];

  for (final RoutinesModel routine in routinesList) {

    debugPrint(routine.exerciseSetsAndRepsPlan.toString());

  }

  final TrainingPlan trainingPlan = TrainingPlan(
    trainingPlanName: snapshotData["trainingPlanName"],
    trainingPlanWeeks: [
      TrainingPlanWeek(
          weekNumber: 1,
          mondayRoutineID: routinesListIDs[0],
          tuesdayRoutineID: routinesListIDs[1],
          wednesdayRoutineID: routinesListIDs[2],
          thursdayRoutineID: routinesListIDs[3],
          fridayRoutineID: routinesListIDs[4],
          saturdayRoutineID: routinesListIDs[5],
          sundayRoutineID: routinesListIDs[6],
      ),
    ],
    trainingPlanID: trainingPlanCode,
  );


  return [trainingPlan, routinesList];

}