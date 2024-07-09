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
import '../../models/workout/training_plan_model.dart';
import '../../models/workout/workout_log_model.dart';
import '../../models/workout/workout_overall_stats_model.dart';


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

void updateExercise(ExerciseModel exercise) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .set({
    "category": exercise.category,
    "primary-muscle": exercise.primaryMuscle,
    "secondary-muscle": exercise.secondaryMuscle,
    "tertiary-muscle": exercise.tertiaryMuscle,
    "exerciseTrackingType": exercise.exerciseTrackingType,
  }, SetOptions(merge: true));

}

void createNewExercise(ExerciseModel exercise) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exercise.exerciseName)
      .set({
        "category": exercise.category,
        "primary-muscle": exercise.primaryMuscle,
        "secondary-muscle": exercise.secondaryMuscle,
        "tertiary-muscle": exercise.tertiaryMuscle,
        "type": exercise.type,
        "exerciseTrackingType": exercise.exerciseTrackingType,
      }, SetOptions(merge: true));

}

void deleteExercise(String exerciseName) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exerciseName)
      .delete();

}

void saveExerciseLogs(ExerciseModel exercise, Map log) async {

  print(log);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  var logToSave = exercise.exerciseTrackingData.dailyLogs.where((element) => element["measurementDate"] == log["measurementDate"]);

  print("Saving");
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
        "type": exercise.type,
      }, SetOptions(merge: true));

}

void saveExerciseMaxRepsAtWeight(String exerciseName, Map maxWeightAtReps) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-data')
      .doc(exerciseName)
      .set({"data": maxWeightAtReps}, SetOptions(merge: true));

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
      .set({
    "data": [
      {
      "measurementDate": exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"],
      "measurementTimeStamp": exercise.exerciseTrackingData.dailyLogs[index]["measurementTimeStamp"],
      "repValues": exercise.exerciseTrackingData.dailyLogs[index]["repValues"],
      "weightValues": exercise.exerciseTrackingData.dailyLogs[index]["weightValues"],
      "intensityValues": exercise.exerciseTrackingData.dailyLogs[index]["intensityValues"]
      }
    ],
  }, SetOptions(merge: true));

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
          "exerciseTrackingType": exerciseListData.exerciseTrackingType,
          "mainOrAccessory": exerciseListData.mainOrAccessory,
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

void updateRoutineOrder(RoutinesModel routine) async {

  mapData(data) {

    return [
      for (ExerciseListModel exerciseListData in data)
        {
          "exerciseName": exerciseListData.exerciseName,
          "exerciseDate": exerciseListData.exerciseDate,
          "exerciseTrackingType": exerciseListData.exerciseTrackingType,
          "mainOrAccessory": exerciseListData.mainOrAccessory,
        }
    ];

  }

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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

void updateRoutineData(RoutinesModel routine) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  mapData(data) async {

    List<Map> exerciseListToReturn = [];

    for (ExerciseListModel exerciseListData in data) {

      exerciseListToReturn.add(
          {
            "exerciseName": exerciseListData.exerciseName,
            "exerciseDate": exerciseListData.exerciseDate,
            "exerciseTrackingType": exerciseListData.exerciseTrackingType ?? 0,
            "mainOrAccessory": exerciseListData.mainOrAccessory ?? 0,
          }
      );
    }


    return exerciseListToReturn;

  }

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('routine-data')
      .doc(routine.routineName)
      .set({
    "routineName": routine.routineName,
    "routineDate": routine.routineDate,
    "routineID": routine.routineID,
    "exercises": await mapData(routine.exercises),
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
      .set({
        "data": exerciseNames,
      });

}

void updateCategoriesData(List<String> categoryNames) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('exercise-data')
      .doc("category-names")
      .set({
    "data": categoryNames,
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
      .set(workoutLog.toMap());

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

void saveOverallStats(WorkoutOverallStatsModel stats) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('workout-overall-stats')
      .doc("stats")
      .set(
        stats.toMap(),
      );

}

void saveDayTracking(Map<String, dynamic> daysWorkedOut) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('current-workout-data')
      .doc("week-days-worked")
      .set(daysWorkedOut);

}

void SaveDailyStreak(Map<String, dynamic> dailyStreak) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc(firebaseAuth.currentUser!.uid)
      .collection('user-data')
      .doc("daily-streak")
      .set(dailyStreak);

}

void SaveRoutineVolumeData(StatsMeasurement volumeData) async {

  Map ConvertToMap({required StatsMeasurement volumeData}) {
    Map volumeDataMap = volumeData.toMap();
    return volumeDataMap;
  }

  Map volumeDataMapped = ConvertToMap(volumeData: volumeData);

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("workout-routine-stats")
      .doc(volumeData.measurementID)
      .set({"measurements-data": volumeDataMapped});

}


void CreateNewTrainingPlan(TrainingPlan newTrainingPlan) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("training-plans")
      .doc(newTrainingPlan.trainingPlanName)
      .set(newTrainingPlan.toMap());
}


void UpdateTrainingPlanOrder(Map<int, String> trainingPlanOrder) async {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await FirebaseFirestore.instance
      .collection('user-data')
      .doc("${firebaseAuth.currentUser?.uid.toString()}")
      .collection("training-plan-data")
      .doc("trainingPlanOrder")
      .set({"data": trainingPlanOrder.map<String, String>(
  (key, value) => MapEntry<String, String>(key.toString(), value.toString())
  )});

}
