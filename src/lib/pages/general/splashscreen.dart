import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';
import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/models/stats/user_data_model.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

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

    try {await stepsCalorieCalculator();} catch (exception) {print(exception);}

    setState(() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage(),
        ),
      );
    });
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
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: (_height/100)*20),
              child: const Text(
                "FIT",
                style: TextStyle(
                  color: appSecondaryColour,
                  fontSize: 60,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: appSecondaryColour,
            ),
          ),
        ],
      ),
    );
  }
}
