import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';
import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/models/stats/user_data_model.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/workout_overall_stats_model.dart';
import 'package:fitness_tracker/providers/general/general_data_provider.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/stats/stats_model.dart';
import '../../providers/general/database_get.dart';
import '../../providers/stats/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late List<String> categories;
  late List<StatsMeasurement> measurements;
  late UserDataModel userData;
  late UserNutritionModel userNutrition;
  late UserNutritionFoodModel userNutritionHistory;
  late UserNutritionFoodModel userCustomFood;
  late UserNutritionFoodModel userRecipes;
  late String groceryListID;
  late List<String> groceryLists;
  late List<RoutinesModel> routines;
  late List<String> exercises;
  late bool workoutStarted;
  late Map workoutLogs;
  late WorkoutOverallStatsModel workoutOverallStats;
  late Map<String, dynamic> weekdayTrackingValues;
  late Map<String, dynamic> dailyStreak;

  Future<void> stepsCalorieCalculator() async {

    final permissionStatus = Permission.activityRecognition.request();
    if (await permissionStatus.isDenied ||
        await permissionStatus.isPermanentlyDenied) {
      return;
    }
    await Permission.activityRecognition.request().isGranted;
    await Permission.location.request().isGranted;

    HealthFactory health = HealthFactory();

    var types = [
      HealthDataType.STEPS,
    ];

    await health.requestAuthorization(types);

    var day = context
        .read<UserNutritionData>()
        .nutritionDate;


    int? steps = await health.getTotalStepsInInterval(
      DateTime(
        day.year,
        day.month,
        day.day,
        0,
        0,
        0,
      ),
      DateTime(
        day.year,
        day.month,
        day.day,
        23,
        59,
        59,
      ),
    ) ?? 0;

    if (steps > 0) {
      UserDataModel userData = context.read<UserData>().userData;

      double walkingFactor = 0.57;

      double caloriesBurnedPerMile = walkingFactor * (double.parse(userData.weight) * 2.2);

      double stride = double.parse(userData.height) * 0.415;

      double stepsPerMile = 160394.4 / stride;

      double conversionFactor = caloriesBurnedPerMile / stepsPerMile;

      double caloriesBurned = steps * conversionFactor;

      print(caloriesBurned.toString() + " Kcal");

      context.read<UserNutritionData>().addWalkingCalories(caloriesBurned, steps);
    }

  }

  void fetchData() async {

    try {dailyStreak = await GetDailyStreak();} catch (exception) {print(exception);}

    try {

      print("DIFFERENCE IN HOURS");
      print(DateTime.now().difference(dailyStreak["lastDate"]).inHours);

      if (DateTime.now().difference(dailyStreak["lastDate"]).inHours > 23
          && DateTime.now().difference(dailyStreak["lastDate"]).inHours < 50) {

        try {context.read<GeneralDataProvider>().updateDailyStreak(dailyStreak);} catch (exception) {print(exception);}

      } else if (DateTime.now().difference(dailyStreak["lastDate"]).inHours >= 0
          && DateTime.now().difference(dailyStreak["lastDate"]).inHours <= 23) {

        try {context.read<GeneralDataProvider>().setDailyStreak(dailyStreak);} catch (exception) {print(exception);}
      } else {
        try {context.read<GeneralDataProvider>().setDailyStreak(<String, dynamic>{
          "lastDate": DateTime.now(),
          "dailyStreak": 0,
        });} catch (exception) {print(exception);}
      }

    } catch (exception) {

      try {context.read<GeneralDataProvider>().setDailyStreak(<String, dynamic>{
      "lastDate": DateTime.now(),
      "dailyStreak": 0,
      });} catch (exception) {print(exception);}

      debugPrint(exception.toString());
    }

    try {measurements = await GetUserMeasurements();} catch (exception) {print(exception);}
    try {userData = await GetUserDataTrainingPlan();} catch (exception) {print(exception);}
    try {userData = await GetUserBioData();} catch (exception) {print(exception);}
    print("Fetching nutrition");
    try {userNutrition = await GetUserNutritionData(context.read<UserNutritionData>().nutritionDate.toString());} catch (exception) {print(exception);}

    try {userNutritionHistory = await GetUserNutritionHistory();} catch (exception) {print(exception);}
    try {userCustomFood = await GetUserCustomFood();} catch (exception) {print(exception);}
    try {userRecipes = await GetUserCustomRecipes();} catch (exception) {print("recipe");print(exception);}

    try {groceryListID = await GetUserGroceryListID();} catch (exception) {print("recipe");print(exception);}
    try {groceryLists = await GetUserGroceryLists();} catch (exception) {print("recipe");print(exception);}

    try {routines = await GetRoutinesData();} catch (exception) {print("routines");print(exception);}
    try {exercises = await GetExerciseData();} catch (exception) {print("exercises");print(exception);}

    try {workoutStarted = await GetWorkoutStarted();} catch (exception) {print("started");print(exception);}
    try {workoutLogs = await GetPastWorkoutData(null);} catch (exception) {print("logs");print(exception);}
    try {workoutOverallStats = await GetWorkoutOverallStats();} catch (exception) {print("workout-stats");print(exception);}
    try {weekdayTrackingValues = await GetWeekdayExerciseTracking();} catch (exception) {print("weekday-tracking");print(exception);}

    try {context.read<UserData>().setUserBioData(userData);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCalories(userData.calories);} catch (exception) {print(exception);}

    try {context.read<GroceryProvider>().setGroceryListID(groceryListID);} catch (exception) {print(exception);}
    try {context.read<GroceryProvider>().setGroceryLists(groceryLists);} catch (exception) {print(exception);}
    try {context.read<GroceryProvider>().setGroceryList();} catch (exception) {print(exception);}

    try {context.read<UserStatsMeasurements>().initialiseStatsMeasurements(measurements);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCurrentFoodDiary(userNutrition);} catch (exception) {print(exception);}

    try {context.read<UserNutritionData>().setFoodHistory(userNutritionHistory);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCustomFood(userCustomFood);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCustomRecipes(userRecipes);} catch (exception) {print(exception);}

    try {context.read<WorkoutProvider>().loadRoutineData(routines);} catch (exception) {print(exception);}
    try {context.read<WorkoutProvider>().loadExerciseNamesData(exercises);} catch (exception) {print(exception);}

    try {context.read<WorkoutProvider>().loadWorkoutStarted(workoutStarted);} catch (exception) {print(exception);}
    try {context.read<WorkoutProvider>().loadWorkoutLogs(workoutLogs);} catch (exception) {print(exception);}
    try {context.read<WorkoutProvider>().loadOverallStats(workoutOverallStats);} catch (exception) {print(exception);}
    try {context.read<WorkoutProvider>().loadWeekdayExerciseTracking(weekdayTrackingValues);} catch (exception) {print(exception);}


    try {await stepsCalorieCalculator();} catch (exception) {print(exception);}

    context.read<PageChange>().setDataLoadingStatus(false);
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: appPrimaryColour,
      body: Stack(
              children: [

                SizedBox.expand(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Center(
                        child: AvatarGlow(
                          glowRadiusFactor: 0.2,
                          glowCount: 2,
                          glowColor: appSecondaryColour,
                          child: Image.asset(
                            'assets/logo/applogonobg.png',
                            height: 80.0.h,
                          ),
                        ),
                      ),
                    ),
                ),
              ],
            )
    );
  }
}
