import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/nutrition_tracker.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:fitness_tracker/models/routines_model.dart';
import 'package:fitness_tracker/models/training_plan_model.dart';
import 'package:fitness_tracker/models/user_custom_foods.dart';
import 'package:fitness_tracker/models/user_nutrition_model.dart';
import 'package:fitness_tracker/providers/user_nutrition_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/food_data_list_item.dart';
import '../models/food_item.dart';
import '../models/stats_model.dart';
import '../models/user_nutrition_history_model.dart';

GetPreDefinedCategories() async {

  final snapshot = await FirebaseFirestore.instance
      .collection('predefined-data')
      .doc('predefined-categories')
      .get();
  final List<String> data = List<String>.from(snapshot.get("categories"));
  return data;
}

GetPreDefinedExercises() async {

  final snapshot = await FirebaseFirestore.instance
      .collection('predefined-data')
      .doc('predefined-exercises')
      .get();

  final _data = snapshot.get("exercises");
  final List<Exercises> data = List<Exercises>.generate(_data.length, (int index) {
    return Exercises(
        exerciseName: _data[index]["exerciseName"],
        exerciseCategory: _data[index]["exerciseCategory"],
    );
  });
  return data;
}

GetPreDefinedRoutines() async {

  final snapshot = await FirebaseFirestore.instance
      .collection('predefined-data')
      .doc('predefined-routines')
      .get();

  final _data = snapshot.get("routines");
  final List<WorkoutRoutine> data = List<WorkoutRoutine>.generate(_data.length, (int index) {
    final List<String> exercises = List<String>.generate(_data[index]["exercises"].length, (int indexExercises) {
      return _data[index]["exercises"][indexExercises];
    });
    return WorkoutRoutine(
      routineID: _data[index]["routineID"],
      routineName: _data[index]["routineName"],
      exercises: exercises,
    );
  });
  return data;
}

GetPreDefinedTrainingPlans() async {

  final snapshot = await FirebaseFirestore.instance
      .collection('predefined-data')
      .doc('predefined-training-plans')
      .get();

  final _data = snapshot.get("training-plans");
  final List<TrainingPlan> data = List<TrainingPlan>.generate(_data.length, (int index) {
    final List<String> routineIDs = List<String>.generate(_data[index]["routineIDs"].length, (int indexRoutines) {
      return _data[index]["routineIDs"][indexRoutines];
    });
    return TrainingPlan(
      trainingPlanID: _data[index]["trainingPlanID"],
      routineIDs: routineIDs,
      trainingPlanName: _data[index]["trainingPlanName"],
    );
  });
  return data;
}

GetUserCategories() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final snapshot = await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("categories")
      .get();
  final List<String> data = List<String>.from(snapshot.get("categories"));
  return data;

  } catch (exception) {
    print(exception);
  }
}

GetUserRoutines() async {

  try {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final snapshot = await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("routines")
      .get();

  final _data = snapshot.get("routines");
  final List<WorkoutRoutine> data = List<WorkoutRoutine>.generate(_data.length, (int index) {
    final List<String> exercises = List<String>.generate(_data[index]["exercises"].length, (int indexExercises) {
      return _data[index]["exercises"][indexExercises];
    });
    return WorkoutRoutine(
      routineID: _data[index]["routineID"],
      routineName: _data[index]["routineName"],
      exercises: exercises,
    );
  });
  return data;

  } catch (exception) {
    print(exception);
  }
}

GetUserTrainingPlans() async {

  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("workout-data")
        .doc("training-plans")
        .get();

    final _data = snapshot.get("training-plans");
    final List<TrainingPlan> data = List<TrainingPlan>.generate(_data.length, (int index) {
      final List<String> routineIDs = List<String>.generate(_data[index]["routineIDs"].length, (int indexRoutines) {
        return _data[index]["routineIDs"][indexRoutines];
      });
      return TrainingPlan(
        trainingPlanID: _data[index]["trainingPlanID"],
        routineIDs: routineIDs,
        trainingPlanName: _data[index]["trainingPlanName"],
      );
    });
    return data;

  } catch (exception) {
    print(exception);
  }
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

GetUserExercises() async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('user-data')
        .doc("${firebaseAuth.currentUser?.uid.toString()}")
        .collection("workout-data")
        .doc("exercises")
        .get();

    final _data = snapshot.get("exercises");
    final List<Exercises> data = List<Exercises>.generate(_data.length, (int index) {
      return Exercises(
        exerciseName: _data[index]["exerciseName"],
        exerciseCategory: _data[index]["exerciseCategory"],
      );
    });
    return data;

  } catch (exception) {
    print(exception);
  }
}

//[LO3.7.3.5]
//Gets the food data from my firebase database

GetFoodDataFromFirebase(String barcode) async {
  try {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    final snapshot = await FirebaseFirestore.instance
        .collection('food-data')
        .doc("${barcode}")
        .get();

    final _data = snapshot.get("food-data");

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
    );

  } catch (exception) {
    print(exception);
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

    print("returning nutrition");


    Future<List<ListFoodItem>> ToListFoodItem (_data) async {
      try {

        final List<ListFoodItem> generateFoodList = List<ListFoodItem>.generate(_data.length, (int index) {

          return ListFoodItem(
            category: _data[index]["category"] ?? "",
            barcode: _data[index]["barcode"] ?? "",
            foodServingSize: _data[index]["foodServingSize"] ?? "",
            foodServings: _data[index]["foodServings"] ?? "",
            foodItemData: FoodDefaultData(),
          );
        });

        List<ListFoodItem> foodList = generateFoodList;

        for (int i = 0; i < foodList.length; i++) {

          foodList[i].foodItemData = await CheckFoodBarcode( foodList[i].barcode);

        }

        return generateFoodList;

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

    return UserNutritionHistoryModel(
      barcodes: List<String>.from(_data["barcodes"] as List),
      foodListItemNames: List<String>.from(_data["foodListItemNames"] as List),
      foodServings: List<String>.from(_data["foodServings"] as List),
      foodServingSize: List<String>.from(_data["foodServingSize"] as List),
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

    return UserNutritionCustomFoodModel(
      barcodes: List<String>.from(_data["barcodes"] as List),
      foodListItemNames: List<String>.from(_data["foodListItemNames"] as List),
      foodServings: List<String>.from(_data["foodServings"] as List),
      foodServingSize: List<String>.from(_data["foodServingSize"] as List),
    );

  } catch (exception) {
    print(exception);
  }
}
