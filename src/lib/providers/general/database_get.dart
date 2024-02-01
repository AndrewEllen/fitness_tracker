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

GetUserMeasurements() async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("stats-measurements")
        .get();

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

    print(data);
    print(data[0].measurementName);

    return data;

  } catch (exception) {
    print(exception);
  }
}

//[LO3.7.3.5]
//Gets the food data from my firebase database

GetFoodDataFromFirebase(String barcode) async {

  print("firebase get");

  try {


    final snapshot = await FirebaseFirestore.instance
        .collection('food-data')
        .doc(barcode)
        .get();

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

BatchGetFoodDataFromFirebase(List<String> barcodes, {bool recipe = false}) async {

  List<FoodItem> foodItems = [];
  print(barcodes);

  if (recipe) {

    print("IS IN RECIPE");

    try {

      final snapshot = await FirebaseFirestore.instance
          .collection('recipe-data')
          .where(FieldPath.documentId, whereIn: barcodes)
          .get();

      foodItems = [
        for (QueryDocumentSnapshot document in snapshot.docs)
          ConvertToFoodItem(document.get("food-data")["foodData"], firebase: true)
            ..firebaseItem = true,
      ];

      print(foodItems[0].foodName);

    } catch (exception) {
      print(exception);

      for (var barcode in barcodes) {
        foodItems.add(await GetFoodDataFromFirebase(barcode));
      }

    }
    return foodItems;

  } else {

    try {

      final snapshot = await FirebaseFirestore.instance
          .collection('food-data')
          .where(FieldPath.documentId, whereIn: barcodes)
          .get();

      foodItems = [
        for (QueryDocumentSnapshot document in snapshot.docs)
          ConvertToFoodItem(document.get("food-data"), firebase: true)
            ..firebaseItem = true,
      ];

    } catch (exception) {
      print(exception);

      for (var barcode in barcodes) {
        foodItems.add(await GetFoodDataFromFirebase(barcode));
      }

    }
    return foodItems;
  }
}

GetUserNutritionData(String date) async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("nutrition-data")
        .doc(date)
        .get();

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
            [for (final food in foodList) if (food.recipe) food.barcode]
        );

        final foodListMap = {for (final food in foodItemList) food.barcode : food};
        for (final food in foodList) {
          ///TODO Implement null check
          food.foodItemData = foodListMap[food.barcode]!;
        }

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

    return UserNutritionModel(
        date: _data["date"] ?? "",
        foodListItemsBreakfast: await ToListFoodItem(_data["foodListItemsBreakfast"]),
        foodListItemsLunch: await ToListFoodItem(_data["foodListItemsLunch"]),
        foodListItemsDinner: await ToListFoodItem(_data["foodListItemsDinner"]),
        foodListItemsSnacks: await ToListFoodItem(_data["foodListItemsSnacks"]),
        foodListItemsExercise: await ToListExerciseItem(_data["foodListItemsExercise"]),
        water: await _data["water"] ?? 0,
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

GetUserNutritionHistory() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("nutrition-history-data")
        .doc("history")
        .get();

    final _data = snapshot.get("history");

    return UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"] as List),
      foodListItemNames: List<String>.from(_data["foodListItemNames"] as List),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"] as List)),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"] as List)),
      recipe: List<bool>.from(_data["recipe"] as List),
    );

  } catch (exception) {
    print(exception);
  }
}

GetUserCustomFood() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("nutrition-custom-food-data")
        .doc("food")
        .get();

    final _data = snapshot.get("food");

    return UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"] as List),
      foodListItemNames: List<String>.from(_data["foodListItemNames"] as List),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"] as List)),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"] as List)),
      recipe: List<bool>.generate(_data["barcodes"].length, (index) => false),
    );

  } catch (exception) {
    print(exception);
  }
}

GetUserCustomRecipes() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("nutrition-recipes-food-data")
        .doc("food")
        .get();

    final _data = snapshot.get("food");

    return UserNutritionFoodModel(
      barcodes: List<String>.from(_data["barcodes"] as List),
      foodListItemNames: List<String>.from(_data["foodListItemNames"] as List),
      foodServings: checkIfValidNumberList(List<String>.from(_data["foodServings"] as List)),
      foodServingSize: checkIfValidNumberList(List<String>.from(_data["foodServingSize"] as List)),
      recipe: List<bool>.generate(_data["barcodes"].length, (index) => true),
    );

  } catch (exception) {
    print(exception);
  }
}

GetFoodDataFromFirebaseRecipe(String barcode) async {

  print("firebase get");

  try {

    final snapshot = await FirebaseFirestore.instance
        .collection('recipe-data')
        .doc(barcode)
        .get();

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
        food.foodItemData = foodListMap[food.barcode]!;
      }

      return foodList;

  } catch (exception) {
    print("Recipe fetch failed");
    print(exception);

  }

}

GetUserBioData() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("bioData")
        .doc("bioData")
        .get();

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
    print(exception);
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

GetUserGroceryLists() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection('grocery-data')
        .doc("grocery-lists")
        .get();

    return snapshot["groceryLists"];

  } catch (exception) {
    print(exception);
  }
}

GetUserGroceryListID() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection('grocery-data')
        .doc("selected-grocery-list")
        .get();

    return snapshot["groceryListID"];

  } catch (exception) {
    print(exception);
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

GetExerciseLogData(String exerciseName) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('workout-data')
        .doc(exerciseName)
        .collection("exercise-tracking-data")
        .orderBy("timeStamp", descending: true)
        .limit(7)
        .where("timeStamp", isLessThanOrEqualTo: DateTime.now().toUtc())
        .get();

    final repsAndWeightSnapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('workout-data')
        .doc(exerciseName)
        .get();

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
        category: repsAndWeightSnapshot.data()?["category"],
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

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('workout-data')
        .doc(exerciseName)
        .collection("exercise-tracking-data")
        .orderBy("timeStamp", descending: true)
        .limit(7)
        .where("timeStamp", isLessThanOrEqualTo: DateTime(previousDay.year, previousDay.month, previousDay.day-1).toUtc())
        .get();

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

GetRoutinesData() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic data = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('routine-data')
      .get();

  List<ExerciseListModel> buildExerciseListObjects(data) {

    if (data.isEmpty) {
      return [];
    }

    List<ExerciseListModel> exercises =  [
      for (Map exercise in data)
        ExerciseListModel(
          exerciseName: exercise["exerciseName"],
          exerciseDate: exercise["exerciseDate"],
        )
    ];

    return exercises;

  }

  List<RoutinesModel> routines = [
    for (QueryDocumentSnapshot document in data.docs)
      RoutinesModel(
          routineID: document["routineID"],
          routineDate: document["routineDate"],
          routineName: document["routineName"],
          exercises: buildExerciseListObjects(document["exercises"]),
      )
  ];

  return routines;

}


GetExerciseData() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic data = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('exercise-data')
      .doc('exercise-names')
      .get();

  return List<String>.from(data['data'] as List);

}

GetCategoriesData() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic data = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('exercise-data')
      .doc('category-names')
      .get();

  return List<String>.from(data['data'] as List);

}

GetWorkoutStarted() async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    dynamic snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('current-workout-data')
        .where("started", isEqualTo: true)
        .get();

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
          intensityNumber: exercise["intensityNumber"] ?? 5,
          type: exercise.toString().contains('type') ? returnType(exercise["type"]) : 0,
          reps: exercise["reps"],
          weight: exercise["weight"],
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

GetPastWorkoutData(dynamic? document) async {
try {

  int returnType(int? type) {

    if (type != null) {
      return type;
    }
    return 0;
  }

  //DateTime previousDay = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy").parse(date)).toString());

  exercisesToModel(data) {

    print(data[0]["measurementName"]);

    return [
      for (Map exercise in data)
        WorkoutLogExerciseDataModel(
          measurementName: exercise["measurementName"],
          routineName: exercise["routineName"],
          intensityNumber: exercise["intensityNumber"] ?? 5,
          type: exercise.toString().contains('type') ? returnType(exercise["type"]) : 0,
          reps: exercise["reps"],
          weight: exercise["weight"],
          timestamp: exercise["timestamp"],
        ),
    ];

  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic snapshot;

  if (document != null) {

    print("More data");

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('workout-log-data')
        .orderBy("time-stamp", descending: true)
        .limit(7)
        .startAfterDocument(document)
        .get();
    
  } else {

    print("Less data");

    snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('workout-log-data')
        .orderBy("time-stamp", descending: true)
        .limit(7)
        .where("time-stamp", isLessThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).toUtc())
        .get();
    
  }

  dynamic parseDateTime(Timestamp? timeStamp) {

    print("timestamp");

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
    print("error");

  }

}

GetWorkoutOverallStats() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic snapshot = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-overall-stats')
      .doc("stats")
      .get();

  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }

  return WorkoutOverallStatsModel(
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
  );

}

GetWeekdayExerciseTracking() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic snapshot = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('current-workout-data')
      .doc("week-days-worked")
      .get();

  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }

  Map<String, dynamic> snapshotMap = Map<String, dynamic>.from(snapshot.data());
  snapshotMap["lastDate"] = parseDateTime(snapshotMap["lastDate"]);

  return snapshotMap;

}

GetDailyStreak() async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  dynamic snapshot = await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('user-data')
      .doc("daily-streak")
      .get();

  dynamic parseDateTime(Timestamp? timeStamp) {

    if (timeStamp != null) {
      return timeStamp.toDate();
    }
    return null;

  }

  Map<String, dynamic> snapshotMap = Map<String, dynamic>.from(snapshot.data());
  snapshotMap["lastDate"] = parseDateTime(snapshotMap["lastDate"]);

  return snapshotMap;

}