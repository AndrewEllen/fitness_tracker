import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/models/exercise_model.dart';
import 'package:fitness_tracker/models/routines_model.dart';
import 'package:fitness_tracker/models/stats_model.dart';
import 'package:fitness_tracker/models/training_plan_model.dart';
import 'package:fitness_tracker/models/user_custom_foods.dart';
import 'package:fitness_tracker/models/user_nutrition_model.dart';

import '../models/food_data_list_item.dart';
import '../models/food_item.dart';
import '../models/user_nutrition_history_model.dart';

void UpdateUserDocumentCategories(List<String> categories) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("categories")
      .set({"categories": categories});
}

void UpdateUserDocumentExercises(List<Exercises> exercisesList) async {

  List<Map> ConvertToMap({required List<Exercises> exercisesList}) {
    List<Map> exercises = [];
    exercisesList.forEach((Exercises exerciseModel) {
      Map exercise = exerciseModel.toMap();
      exercises.add(exercise);
    });
    return exercises;
  }

  List<Map> exercises = await ConvertToMap(exercisesList: exercisesList);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("exercises")
      .set({"exercises": exercises });

}

void UpdateUserDocumentRoutines(List<WorkoutRoutine> workoutRoutinesList) async {

  List<Map> ConvertToMap({required List<WorkoutRoutine> workoutRoutinesList}) {
    List<Map> routines = [];
    workoutRoutinesList.forEach((WorkoutRoutine workoutRoutine) {
      Map routine = workoutRoutine.toMap();
      routines.add(routine);
    });
    return routines;
  }

  List<Map> routines = await ConvertToMap(workoutRoutinesList: workoutRoutinesList);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("routines")
      .set({"routines": routines });
}

void UpdateUserDocumentTrainingPlans(List<TrainingPlan> trainingPlansList) async {

  List<Map> ConvertToMap({required List<TrainingPlan> trainingPlansList}) {
    List<Map> trainingPlans = [];
    trainingPlansList.forEach((TrainingPlan trainingPlan) {
      Map plan = trainingPlan.toMap();
      trainingPlans.add(plan);
    });
    return trainingPlans;
  }

  List<Map> trainingPlans = await ConvertToMap(trainingPlansList: trainingPlansList);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-data")
      .doc("training-plans")
      .set({"training-plans": trainingPlans });

}

void UpdateUserDocumentUserData(String selectedTrainingPlanID) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("user-data")
      .doc("training-plan")
      .set({"training-data": {
        "selected-training-plan": selectedTrainingPlanID,
        },
      });
}

void DeleteUserDocumentMeasurements(String documentName) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("stats-measurements")
      .doc(documentName)
      .delete();

}

void UpdateUserDocumentMeasurements(StatsMeasurement measurements) async {

  Map ConvertToMap({required StatsMeasurement measurements}) {
    Map measurementsMap = measurements.toMap();
    return measurementsMap;
  }

  Map measurementsMapped = await ConvertToMap(measurements: measurements);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("stats-measurements")
      .doc(measurements.measurementID)
      .set({"measurements-data": measurementsMapped});

}

//[LO3.7.3.5]
//writes food data to my database
void UpdateFoodItemData(FoodItem foodItem) async {

  Map ConvertToMap({required FoodItem foodItemData}) {
    Map foodItemMap = foodItemData.toMap();
    return foodItemMap;
  }

  Map mappedFoodItem = await ConvertToMap(foodItemData: foodItem);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  print(firebaseAuth.currentUser?.uid);

  await FirebaseFirestore.instance
      .collection('food-data')
      .doc("${foodItem.barcode}")
      .set({"food-data": mappedFoodItem });

}



void UpdateUserNutritionalData(UserNutritionModel userNutrition) async {

  Map ConvertToMap({required UserNutritionModel nutrition}) {
    Map nutritionMap = nutrition.toMap();
    return nutritionMap;
  }

  Map nutritionMapped = await ConvertToMap(nutrition: userNutrition);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-data")
      .doc(userNutrition.date)
      .set({"nutrition-data": nutritionMapped});

}

void UpdateUserNutritionHistoryData(UserNutritionHistoryModel userNutritionHistory) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-history-data")
      .doc("history")
      .set({"history": userNutritionHistory.toMap()});
}

void UpdateUserCustomFoodData(UserNutritionCustomFoodModel userNutritionCustomFood) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-custom-food-data")
      .doc("food")
      .set({"food": userNutritionCustomFood.toMap()});
}