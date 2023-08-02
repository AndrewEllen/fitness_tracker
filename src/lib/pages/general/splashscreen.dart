import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_nutrition_model.dart';
import 'package:fitness_tracker/providers/workout/user_exercises.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/workout/exercise_model.dart';
import '../../models/workout/routines_model.dart';
import '../../models/stats/stats_model.dart';
import '../../models/workout/training_plan_model.dart';
import '../../providers/general/database_get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late List<String> categories;
  late List<Exercises> exercises;
  late List<WorkoutRoutine> routines;
  late List<TrainingPlan> trainingPlans;
  late List<StatsMeasurement> measurements;
  late Map userData;
  late UserNutritionModel userNutrition;
  late UserNutritionFoodModel userNutritionHistory;
  late UserNutritionFoodModel userCustomFood;
  late UserNutritionFoodModel userRecipes;

  void fetchData() async {
    categories = await GetPreDefinedCategories();
    exercises = await GetPreDefinedExercises();
    routines = await GetPreDefinedRoutines();
    trainingPlans = await GetPreDefinedTrainingPlans();

    try {exercises = await GetUserExercises();} catch (exception) {print(exception);}
    try {categories = await GetUserCategories();} catch (exception) {print(exception);}
    try {routines = await GetUserRoutines();} catch (exception) {print(exception);}
    try {trainingPlans = await GetUserTrainingPlans();} catch (exception) {print(exception);}
    try {measurements = await GetUserMeasurements();} catch (exception) {print(exception);}
    try {userData = await GetUserDataTrainingPlan();} catch (exception) {print(exception);}
    print("Fetching nutrition");
    try {userNutrition = await GetUserNutritionData(context.read<UserNutritionData>().nutritionDate.toString());} catch (exception) {print(exception);}

    try {userNutritionHistory = await GetUserNutritionHistory();} catch (exception) {print(exception);}
    try {userCustomFood = await GetUserCustomFood();} catch (exception) {print(exception);}
    try {userRecipes = await GetUserCustomRecipes();} catch (exception) {print("recipe");print(exception);}

    try {context.read<UserExercisesList>().inititateExerciseList(exercises);} catch (exception) {print(exception);}
    try {context.read<ExerciseList>().setCategoriesInititial(categories);} catch (exception) {print(exception);}
    try {context.read<ExerciseList>().setExerciseInititial(exercises);} catch (exception) {print(exception);}
    try {context.read<RoutinesList>().setRoutineInititial(routines);} catch (exception) {print(exception);}
    try {context.read<TrainingPlanProvider>().setTrainingPlanInititial(trainingPlans);} catch (exception) {print(exception);}
    try {context.read<UserStatsMeasurements>().initialiseStatsMeasurements(measurements);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCurrentFoodDiary(userNutrition);} catch (exception) {print(exception);}

    try {context.read<UserNutritionData>().setFoodHistory(userNutritionHistory);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCustomFood(userCustomFood);} catch (exception) {print(exception);}
    try {context.read<UserNutritionData>().setCustomRecipes(userRecipes);} catch (exception) {print(exception);}

    try {
      context.read<TrainingPlanProvider>().selectTrainingPlan(userData["selected-training-plan"]);
    } catch (exception) {print(exception);}

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
