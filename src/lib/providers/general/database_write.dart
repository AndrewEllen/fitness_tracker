import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:fitness_tracker/models/stats/user_data_model.dart';
import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/diet/food_item.dart';
import '../../models/groceries/grocery_item.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/workout_log_model.dart';


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

void writeUserBiometric(UserDataModel userData) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("bioData")
      .doc("bioData")
      .set({"bioData": userData.toMap()});

}

void writeGrocery(GroceryItem groceryItem, String groceryListID) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('grocery-lists')
      .doc(groceryListID)
      .collection('grocery-data')
      .doc(groceryItem.uuid)
      .set({"groceryData": groceryItem.toMap()});

}

void writeGroceryLists(List<String> groceryLists) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection('grocery-data')
      .doc("grocery-lists")
      .set({"groceryLists": groceryLists});

}

void writeGroceryListID(String groceryListID) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection('grocery-data')
      .doc("selected-grocery-list")
      .set({"groceryListID": groceryListID});

}

void deleteGrocery(GroceryItem groceryItem, String groceryListID) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('grocery-lists')
      .doc(groceryListID)
      .collection('grocery-data')
      .doc(groceryItem.uuid)
      .delete();

}

void createExercise(ExerciseModel exercise) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .set({
          "exerciseName": exercise.exerciseName,
      });

}

void saveExerciseLogs(ExerciseModel exercise, Map log) async {

  print(log);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  var logToSave = exercise.exerciseTrackingData.dailyLogs.where((element) => element["measurementDate"] == log["measurementDate"]);

  print(logToSave);

  print(log["measurementDate"].runtimeType);

  //DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(log["measurementDate"]));

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .collection("exercise-tracking-data")
      .doc(DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(log["measurementDate"])).toString())
      .set({
        "timeStamp": DateFormat("dd/MM/yyyy").parse(log["measurementDate"]).toUtc(),
        "data": logToSave,
      });

}

void updateLogData(ExerciseModel exercise, int index) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .collection("exercise-tracking-data")
      .doc(DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"])).toString())
      .update({
    "data": [
      {
      "measurementDate": exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"],
      "measurementTimeStamp": exercise.exerciseTrackingData.dailyLogs[index]["measurementTimeStamp"],
      "repValues": exercise.exerciseTrackingData.dailyLogs[index]["repValues"],
      "weightValues": exercise.exerciseTrackingData.dailyLogs[index]["weightValues"]
      }
    ],
  });

}

void deleteLogData(ExerciseModel exercise, int index) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .collection("exercise-tracking-data")
      .doc(DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"])).toString())
      .delete();

}

void createRoutine(RoutinesModel routine) async {

  mapData(data) {

    return [
      for (ExerciseListModel exerciseListData in data)
        {
          "exerciseName": exerciseListData.exerciseName,
          "exerciseDate": exerciseListData.exerciseDate,
        }
      ];

  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('routine-data')
      .doc(routine.routineName)
      .set({
          "routineName": routine.routineName,
          "routineDate": routine.routineDate,
          "routineID": routine.routineID,
          "exercises": mapData(routine.exercises),
      });

}

void updateRoutineData(RoutinesModel routine) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  mapData(data) {

    return [
      for (ExerciseListModel exerciseListData in data)
        {
          "exerciseName": exerciseListData.exerciseName,
          "exerciseDate": exerciseListData.exerciseDate,
        }
    ];

  }

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('routine-data')
      .doc(routine.routineName)
      .update({
    "routineName": routine.routineName,
    "routineDate": routine.routineDate,
    "routineID": routine.routineID,
    "exercises": mapData(routine.exercises),
  });

}

void deleteRoutineData(String routineName) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('routine-data')
      .doc(routineName)
      .delete();

}

void updateExerciseData(List<String> exerciseNames) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('exercise-data')
      .doc("exercise-names")
      .update({
        "data": exerciseNames,
      });

}

void writeWorkoutStarted(bool workoutStarted, WorkoutLogModel? workout) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('current-workout-data')
      .doc("started")
      .set({
        "started": workoutStarted,
      });

  if (workout != null) {
    await FirebaseFirestore.instance
        .collection('user-data')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('current-workout-data')
        .doc("workout")
        .set(workout.toMap());
  }

}

void updateCurrentWorkout(WorkoutLogModel workoutLog) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('current-workout-data')
      .doc("workout")
      .update(workoutLog.toMap());

}

void finalizeWorkout(WorkoutLogModel workoutLog) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-log-data')
      .doc(const Uuid().v4().toString())
      .set({
          "data": workoutLog.toMap(),
          "time-stamp": DateTime.now().toUtc(),
      });

}

