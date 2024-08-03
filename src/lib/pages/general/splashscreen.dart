import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/stats/stats_model.dart';
import '../../models/workout/training_plan_model.dart';
import '../../providers/general/database_get.dart';
import '../../providers/stats/user_data.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double loadingValue = 0;

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
  late List<String> exerciseCategories;
  late bool workoutStarted;
  late Map workoutLogs;
  late WorkoutOverallStatsModel workoutOverallStats;
  late Map<String, dynamic> weekdayTrackingValues;
  late Map<String, dynamic> dailyStreak;
  late List<TrainingPlan> trainingPlans;

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

  final double loadingValueAdjustment = 0.021;
  void IncrementLoadingBar({bool completeBar = false}) {

    if (completeBar == true) {
      setState(() {
        loadingValue = 1;
      });
    }

    loadingValue += loadingValueAdjustment;

    if (loadingValue > 1) {
      loadingValue = 1;
    }

    setState(() {
      loadingValue;
    });

  }

  void fetchData() async {

    bool result = await InternetConnection().hasInternetAccess;
    GetOptions options = const GetOptions(source: Source.serverAndCache);

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No Internet Connection"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.6695,
            right: 20,
            left: 20,
          ),
          dismissDirection: DismissDirection.none,
          duration: const Duration(milliseconds: 700),
        ),
      );
      options = const GetOptions(source: Source.cache);
    }

    await Future.wait<void>([
      GetDailyStreak(options: options).then((result) {
        dailyStreak = result;
        IncrementLoadingBar();
      }),
      GetUserMeasurements(options: options).then((result) {
        measurements = result;
        IncrementLoadingBar();
      }),
      GetUserBioData(options: options).then((result) {
        userData = result;
        IncrementLoadingBar();
      }),
      GetUserNutritionData(context.read<UserNutritionData>().nutritionDate.toString(), options: options).then((result) {
        userNutrition = result;
        IncrementLoadingBar();
      }),
    GetUserNutritionHistory(options: options).then((result) {
      userNutritionHistory = result;
      IncrementLoadingBar();
    }),
    ///User Custom Food is stored in one document. Will cause issues down the line.
    GetUserCustomFood(options: options).then((result) {
      userCustomFood = result;
      IncrementLoadingBar();
    }),
    ///User Custom Recipes is stored in one document. Will cause issues down the line.
    GetUserCustomRecipes(options: options).then((result) {
      userRecipes = result;
      IncrementLoadingBar();
    }),
    GetUserGroceryListID(options: options).then((result) {
      groceryListID = result;
      IncrementLoadingBar();
    }),
    GetUserGroceryLists(options: options).then((result) {
      groceryLists = result;
      IncrementLoadingBar();
    }),
    GetRoutinesData(options: options).then((result) {
      routines = result;
      IncrementLoadingBar();
    }),
    GetExerciseData(options: options).then((result) {
      exercises = result;
      IncrementLoadingBar();
    }),
    GetCategoriesData(options: options).then((result) {
      exerciseCategories = result;
      IncrementLoadingBar();
    }),
    GetWorkoutStarted(options: options).then((result) {
      workoutStarted = result;
      IncrementLoadingBar();
    }),
    GetPastWorkoutData(null, options: options).then((result) {
      workoutLogs = result;
      IncrementLoadingBar();
    }),
    GetWorkoutOverallStats(options: options).then((result) {
      workoutOverallStats = result;
      IncrementLoadingBar();
    }),
    GetWeekdayExerciseTracking(options: options).then((result) {
      weekdayTrackingValues = result;
      IncrementLoadingBar();
    }),
    GetTrainingPlans(options: options).then((result) {
      trainingPlans = result;
      IncrementLoadingBar();
    }),
    ]);

    try {

    DateTime now = DateTime.now();
    DateTime then = dailyStreak["lastDate"];

    if (DateTime(now.year, now.month, now.day) == DateTime(then.year, then.month, then.day)) {

    debugPrint("today");

    try {context.read<GeneralDataProvider>().setDailyStreak(dailyStreak);} catch (exception) {print(exception);}

    } else if (DateTime(now.year, now.month, now.day) == DateTime(then.year, then.month, then.day+1)) {

    debugPrint("new day");
    try {context.read<GeneralDataProvider>().updateDailyStreak(dailyStreak);} catch (exception) {print(exception);}

    } else if (
    (
    DateTime(now.year, now.month, now.day, now.hour)
        .difference(
    DateTime(then.year, then.month, then.day, then.hour+24)
    )
    ).inHours <= 13
    ) {

    debugPrint("new day (within 13 hours)");
    try {context.read<GeneralDataProvider>().updateDailyStreak(dailyStreak);} catch (exception) {print(exception);}

    } else {

    debugPrint("Streak lost");
    try {context.read<GeneralDataProvider>().setDailyStreak(<String, dynamic>{
    "lastDate": DateTime.now(),
    "dailyStreak": 0,
    });} catch (exception) {print(exception);}

    }
    } catch (exception) {print(exception);}

    try {
      context.read<UserData>().setUserBioData(userData);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setCalories(userData.calories);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setUserWeight(double.parse(userData.weight));
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setUserAge(double.parse(userData.age));
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setUserGender(double.parse(userData.biologicalSex));
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setUserActivity(double.parse(userData.activityLevel));
      IncrementLoadingBar();
    } catch (exception) {print(exception);}


    try {
      context.read<GroceryProvider>().setGroceryListID(groceryListID);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<GroceryProvider>().setGroceryLists(groceryLists);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<GroceryProvider>().setGroceryList();
      IncrementLoadingBar();
    } catch (exception) {print(exception);}


    try {
      context.read<UserStatsMeasurements>().initialiseStatsMeasurements(measurements);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setCurrentFoodDiary(userNutrition);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().addToNutritionDataCache(userNutrition);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}


    try {
      context.read<UserNutritionData>().setFoodHistory(userNutritionHistory);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setCustomFood(userCustomFood);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<UserNutritionData>().setCustomRecipes(userRecipes);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().initialiseTrainingPlans(trainingPlans);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadRoutineData(routines);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadExerciseNamesData(exercises);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadCategoriesNamesData(exerciseCategories);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadWorkoutStarted(workoutStarted);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadWorkoutLogs(workoutLogs);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadOverallStats(workoutOverallStats);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}

    try {
      context.read<WorkoutProvider>().loadWeekdayExerciseTracking(weekdayTrackingValues);
      IncrementLoadingBar();
    } catch (exception) {print(exception);}



    try {await stepsCalorieCalculator();} catch (exception) {print(exception);}
    IncrementLoadingBar();

    IncrementLoadingBar(completeBar: true);
    context.read<PageChange>().setDataLoadingStatus(false);
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 325.h,
                        left: 75.w,
                        right: 75.w,
                    ),
                    child: LinearProgressIndicator(
                      value: loadingValue,
                      color: appSecondaryColour,
                      backgroundColor: appTertiaryColour,
                    ),
                  ),
                ),

                const Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text(
                      "Version Beta 1.48",
                      style: boldTextStyle,
                    ),
                  ),
                ),

              ],
            )
    );
  }
}
