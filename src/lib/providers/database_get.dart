import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:fitness_tracker/models/routines_model.dart';
import 'package:fitness_tracker/models/training_plan_model.dart';
import 'package:fitness_tracker/models/user_nutrition_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/food_data_list_item.dart';
import '../models/food_item.dart';
import '../models/stats_model.dart';

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


    List<ListFoodItem> ToListFoodItem (_data) {
      print("mapping");

      try {

        final List<ListFoodItem> foodList = List<ListFoodItem>.generate(_data.length, (int index) {
          return ListFoodItem(
            category: _data[index]["category"] ?? "",
            barcode: _data[index]["barcode"] ?? "",
            foodName: _data[index]["foodName"] ?? "",
            foodServingSize: _data[index]["foodServingSize"] ?? "",
            foodServings: _data[index]["foodServings"] ?? "",
            foodCalories: _data[index]["foodCalories"] ?? "",
            kiloJoules: _data[index]["kiloJoules"] ?? "",
            proteins: _data[index]["proteins"] ?? "",
            carbs: _data[index]["carbs"] ?? "",
            fiber: _data[index]["fiber"] ?? "",
            sugars: _data[index]["sugars"] ?? "",
            fat: _data[index]["fat"] ?? "",
            saturatedFat: _data[index]["saturatedFat"] ?? "",
            polyUnsaturatedFat: _data[index]["polyUnsaturatedFat"] ?? "",
            monoUnsaturatedFat: _data[index]["monoUnsaturatedFat"] ?? "",
            transFat: _data[index]["transFat"] ?? "",
            cholesterol: _data[index]["cholesterol"] ?? "",
            calcium: _data[index]["calcium"] ?? "",
            iron: _data[index]["iron"] ?? "",
            sodium: _data[index]["sodium"] ?? "",
            zinc: _data[index]["zinc"] ?? "",
            magnesium: _data[index]["magnesium"] ?? "",
            potassium: _data[index]["potassium"] ?? "",
            vitaminA: _data[index]["vitaminA"] ?? "",
            vitaminB1: _data[index]["vitaminB1"] ?? "",
            vitaminB2: _data[index]["vitaminB2"] ?? "",
            vitaminB3: _data[index]["vitaminB3"] ?? "",
            vitaminB6: _data[index]["vitaminB6"] ?? "",
            vitaminB9: _data[index]["vitaminB9"] ?? "",
            vitaminB12: _data[index]["vitaminB12"] ?? "",
            vitaminC: _data[index]["vitaminC"] ?? "",
            vitaminD: _data[index]["vitaminD"] ?? "",
            vitaminE: _data[index]["vitaminE"] ?? "",
            vitaminK: _data[index]["vitaminK"] ?? "",
            omega3: _data[index]["omega3"] ?? "",
            omega6: _data[index]["omega6"] ?? "",
            alcohol: _data[index]["alcohol"] ?? "",
            biotin: _data[index]["biotin"] ?? "",
            butyricAcid: _data[index]["butyricAcid"] ?? "",
            caffeine: _data[index]["caffeine"] ?? "",
            capricAcid: _data[index]["capricAcid"] ?? "",
            caproicAcid: _data[index]["caproicAcid"] ?? "",
            caprylicAcid: _data[index]["caprylicAcid"] ?? "",
            chloride: _data[index]["chloride"] ?? "",
            chromium: _data[index]["chromium"] ?? "",
            copper: _data[index]["copper"] ?? "",
            docosahexaenoicAcid: _data[index]["docosahexaenoicAcid"] ?? "",
            eicosapentaenoicAcid: _data[index]["eicosapentaenoicAcid"] ?? "",
            erucicAcid: _data[index]["erucicAcid"] ?? "",
            fluoride: _data[index]["fluoride"] ?? "",
            iodine: _data[index]["iodine"] ?? "",
            manganese: _data[index]["manganese"] ?? "",
            molybdenum: _data[index]["molybdenum"] ?? "",
            myristicAcid: _data[index]["myristicAcid"] ?? "",
            oleicAcid: _data[index]["oleicAcid"] ?? "",
            palmiticAcid: _data[index]["palmiticAcid"] ?? "",
            pantothenicAcid: _data[index]["pantothenicAcid"] ?? "",
            selenium: _data[index]["selenium"] ?? "",
            stearicAcid: _data[index]["stearicAcid"] ?? "",
          );
        });

        return foodList;

      } catch (exception) {
        print(exception);

        return [];
      }
    }

    return UserNutritionModel(
        date: _data["date"] ?? "",
        foodListItemsBreakfast: ToListFoodItem(_data["foodListItemsBreakfast"]),
        foodListItemsLunch: ToListFoodItem(_data["foodListItemsLunch"]),
        foodListItemsDinner: ToListFoodItem(_data["foodListItemsDinner"]),
        foodListItemsSnacks: ToListFoodItem(_data["foodListItemsSnacks"]),
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