import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';

import '../../models/diet/food_item.dart';

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
    for (var exerciseModel in exercisesList) {
      Map exercise = exerciseModel.toMap();
      exercises.add(exercise);
    }
    return exercises;
  }

  List<Map> exercises = ConvertToMap(exercisesList: exercisesList);

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
    for (var workoutRoutine in workoutRoutinesList) {
      Map routine = workoutRoutine.toMap();
      routines.add(routine);
    }
    return routines;
  }

  List<Map> routines = ConvertToMap(workoutRoutinesList: workoutRoutinesList);

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
    for (var trainingPlan in trainingPlansList) {
      Map plan = trainingPlan.toMap();
      trainingPlans.add(plan);
    }
    return trainingPlans;
  }

  List<Map> trainingPlans = ConvertToMap(trainingPlansList: trainingPlansList);

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

  Map measurementsMapped = ConvertToMap(measurements: measurements);

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

  if (foodItem.foodName.isNotEmpty && foodItem.barcode.isNotEmpty) {
    Map ConvertToMap({required FoodItem foodItemData}) {
      Map foodItemMap = foodItemData.toMap();
      return foodItemMap;
    }

    Map mappedFoodItem = ConvertToMap(foodItemData: foodItem);

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    print(firebaseAuth.currentUser?.uid);

    await FirebaseFirestore.instance
        .collection('food-data')
        .doc(foodItem.barcode)
        .set({
            "food-data": mappedFoodItem,
            "foodNameSearch" : foodItem.foodName.triGram(),
        });

  }
}



void UpdateUserNutritionalData(UserNutritionModel userNutrition) async {

  Map ConvertToMap({required UserNutritionModel nutrition}) {
    Map nutritionMap = nutrition.toMap();
    return nutritionMap;
  }

  Map nutritionMapped = ConvertToMap(nutrition: userNutrition);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-data")
      .doc(userNutrition.date)
      .set({"nutrition-data": nutritionMapped});

}

void UpdateUserNutritionHistoryData(UserNutritionFoodModel userNutritionHistory) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-history-data")
      .doc("history")
      .set({"history": userNutritionHistory.toMap()});
}

void UpdateUserCustomFoodData(UserNutritionFoodModel userNutritionCustomFood) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-custom-food-data")
      .doc("food")
      .set({"food": userNutritionCustomFood.toMap()});
}

void UpdateUserCustomRecipeData(UserNutritionFoodModel userNutritionCustomFood) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("nutrition-recipes-food-data")
      .doc("food")
      .set({"food": userNutritionCustomFood.toMap()});
}

void UpdateRecipeFoodData(UserRecipesModel foodItem) async {

  print("adding to db");
  print(foodItem.barcode);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('recipe-data')
      .doc(foodItem.barcode)
      .set({
    "food-data": foodItem.toMap(),
    "foodNameSearch" : foodItem.foodData.foodName.triGram(),
  });
}

void writeUserCalories(String calories) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("calories")
      .doc("calories")
      .set({"calories": calories});

}