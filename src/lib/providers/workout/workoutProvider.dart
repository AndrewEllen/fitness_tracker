
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_week_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:fitness_tracker/models/workout/workout_overall_stats_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/stats/stats_model.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/routines_model.dart';
import '../../models/workout/training_plan_model.dart';
import '../../models/workout/workout_log_model.dart';
import '../diet/user_nutrition_data.dart';
import '../general/database_get.dart';
import '../general/database_write.dart';


class WorkoutProvider with ChangeNotifier {

  dynamic _lastWorkoutLogDocument;

  dynamic get lastWorkoutLogDocument => _lastWorkoutLogDocument;

  late Map<String, dynamic> _dailyStreak = {
    "lastDate": DateTime.now(),
    "dailyStreak": 0,
  };

  dynamic get dailyStreak => _dailyStreak;

  late Map<String, dynamic> _weekDayExerciseTracker = {
    "lastDate": DateTime.now(),
    "Monday": false,
    "Tuesday": false,
    "Wednesday": false,
    "Thursday": false,
    "Friday": false,
    "Saturday": false,
    "Sunday": false,
  };

  dynamic get weekDayExerciseTracker => _weekDayExerciseTracker;

  Map<String, String> _exerciseMaxRepAndWeight = {};

  Map<String, String> get exerciseMaxRepAndWeight => _exerciseMaxRepAndWeight;


  late WorkoutOverallStatsModel _workoutOverallStatsModel = WorkoutOverallStatsModel(
      totalVolume: 0,
      totalReps: 0,
      totalSets: 0,
      totalWorkouts: 0,
      totalAverageDuration: 0,
      totalVolumeThisYear: 0,
      totalVolumeThisMonth: 0,
      totalRepsThisYear: 0,
      totalRepsThisMonth: 0,
      totalSetsThisYear: 0,
      totalSetsThisMonth: 0,
      totalWorkoutsThisYear: 0,
      totalWorkoutsThisMonth: 0,
      averageDurationThisYear: 0,
      averageDurationThisMonth: 0,
      lastLog: DateTime.now(),
  );

  WorkoutOverallStatsModel get workoutOverallStatsModel => _workoutOverallStatsModel;


  late WorkoutLogModel _currentSelectedLog = WorkoutLogModel(
      startOfWorkout: startOfWorkout,
      exercises: [],
      routineNames: [],
  );

  WorkoutLogModel get currentSelectedLog => _currentSelectedLog;

  late List<WorkoutLogModel> _workoutLogs = [];

  List<WorkoutLogModel> get workoutLogs => _workoutLogs;

  late List<RoutinesModel> _routinesList = [];

  List<RoutinesModel> get routinesList => _routinesList;

  late List<String> _exerciseNamesList = [];

  List<String> get exerciseNamesList => _exerciseNamesList;

  late List<String> _categoriesNamesList = [];

  List<String> get categoriesNamesList => _categoriesNamesList;

  late final List<ExerciseModel> _exerciseList = [];

  List<ExerciseModel> get exerciseList => _exerciseList;

  late bool _workoutStarted = false;
  late DateTime _startOfWorkout = DateTime.now();
  late DateTime _endOfWorkout = DateTime.now();

  bool get workoutStarted => _workoutStarted;
  DateTime get startOfWorkout => _startOfWorkout;
  DateTime get endOfWorkout => _endOfWorkout;

  late WorkoutLogModel _currentWorkout = WorkoutLogModel(
      startOfWorkout: startOfWorkout,
      exercises: [],
      routineNames: [],
  );

  WorkoutLogModel get currentWorkout => _currentWorkout;

  bool checkForExerciseName(String exerciseNameToCheck) {

    if (_exerciseNamesList.any((value) => value.toLowerCase() == exerciseNameToCheck.toLowerCase())) {
      return true;
    }
    return false;

  }

  bool checkForExerciseCategory(String? categoryNameToCheck) {

    if (categoryNameToCheck != null) {
      if (_categoriesNamesList.any((value) => value.toLowerCase() == categoryNameToCheck.toLowerCase())) {
        return true;
      }
    }
    return false;

  }

  bool checkForExerciseData(String exerciseNameToCheck) {

    if (_exerciseList.any((value) => value.exerciseName == exerciseNameToCheck)) {
      return true;
    } else {

      _exerciseList.add(

        ExerciseModel(
            exerciseName: exerciseNameToCheck,
            exerciseTrackingData: RepsWeightStatsMeasurement(
                measurementName: exerciseNameToCheck,
                dailyLogs: []
            ),
          exerciseMaxRepsAndWeight: {},
        ),

      );

      return true;
    }

  }

  bool checkForRoutineData(String routineNameToCheck) {

    if (_routinesList.any((value) => value.routineName == routineNameToCheck)) {
      return true;
    }
    return false;

  }

  void RemoveWorkoutCache(String exerciseName) {

    print(_exerciseList);

    _exerciseList.removeAt(
        _exerciseList.indexWhere((element) => element.exerciseName == exerciseName)
    );

    print(_exerciseList);

    notifyListeners();
  }

  void AddNewWorkout(ExerciseModel newExercise) {

    _exerciseList.add(newExercise);

    createNewExercise(newExercise);

    _exerciseNamesList.add(newExercise.exerciseName);

    updateExerciseData(_exerciseNamesList);

    if (!checkForExerciseCategory(newExercise.category) && newExercise.category != null) {
      _categoriesNamesList.add(newExercise.category!);
      updateCategoriesData(_categoriesNamesList);
    }

    notifyListeners();
  }

  void UpdateLastWorkoutLogDocument(dynamic document) {

    _lastWorkoutLogDocument = document;

  }

  void selectLog(int index) {
    _currentSelectedLog = _workoutLogs[index];
    notifyListeners();
  }

  void loadWorkoutLogs(Map workoutLogs) {

    print("logs");
    print(workoutLogs["workoutLogs"]);

    _workoutLogs.addAll(workoutLogs["workoutLogs"]);
    _lastWorkoutLogDocument = workoutLogs["lastDoc"];

    print("fin");

    notifyListeners();
  }

  void loadMoreWorkoutLogs() async {

    Map workoutLogs = await GetPastWorkoutData(_lastWorkoutLogDocument);

    _workoutLogs.addAll(workoutLogs["workoutLogs"]);
    _lastWorkoutLogDocument = workoutLogs["lastDoc"];

    notifyListeners();

  }

  void loadWorkoutStarted(bool workoutStartedValue) async {

    _workoutStarted = workoutStartedValue;

    if (_workoutStarted) {

      _currentWorkout = await GetCurrentWorkoutData();

    }

    notifyListeners();
  }

  void startWorkout() {

    _startOfWorkout = DateTime.now();
    _workoutStarted = true;

    _currentWorkout = WorkoutLogModel(
      startOfWorkout: startOfWorkout,
      exercises: [],
      routineNames: [],
    );

    writeWorkoutStarted(_workoutStarted, _currentWorkout);

    notifyListeners();

  }

  void loadOverallStats(WorkoutOverallStatsModel stats) {

    _workoutOverallStatsModel = stats;

    DateTime currentDate = DateTime.now();

    if (
    _workoutOverallStatsModel.lastLog.month < currentDate.month
        && _workoutOverallStatsModel.lastLog.year == currentDate.year
    ) {

      _workoutOverallStatsModel.totalWorkoutsThisMonth = 0;
      _workoutOverallStatsModel.totalVolumeThisMonth = 0;
      _workoutOverallStatsModel.totalRepsThisMonth = 0;
      _workoutOverallStatsModel.totalSetsThisMonth = 0;
      _workoutOverallStatsModel.averageDurationThisMonth = 0;

    } else if (_workoutOverallStatsModel.lastLog.year < currentDate.year) {

      _workoutOverallStatsModel.totalWorkoutsThisYear = 0;
      _workoutOverallStatsModel.totalVolumeThisYear = 0;
      _workoutOverallStatsModel.totalRepsThisYear = 0;
      _workoutOverallStatsModel.totalSetsThisYear = 0;
      _workoutOverallStatsModel.averageDurationThisYear = 0;

      _workoutOverallStatsModel.totalWorkoutsThisMonth = 0;
      _workoutOverallStatsModel.totalVolumeThisMonth = 0;
      _workoutOverallStatsModel.totalRepsThisMonth = 0;
      _workoutOverallStatsModel.totalSetsThisMonth = 0;
      _workoutOverallStatsModel.averageDurationThisMonth = 0;

    }

    notifyListeners();
  }

  void calculateOverallStats() {

    DateTime currentDate = DateTime.now();

    double volume = 0;
    double reps = 0;
    double sets = 0;
    int workoutDuration = _currentWorkout.endOfWorkoutInSeconds!;

    for (WorkoutLogExerciseDataModel exerciseData in _currentWorkout.exercises) {
      if (exerciseData.type == 0) {
        volume += exerciseData.weight * exerciseData.reps;
      }
    }
    for (WorkoutLogExerciseDataModel exerciseData in _currentWorkout.exercises) {
      if (exerciseData.type == 0) {
        reps += exerciseData.reps;
      }
    }
    for (WorkoutLogExerciseDataModel exerciseData in _currentWorkout.exercises) {
      sets += 1;
    }

    _workoutOverallStatsModel.totalAverageDuration = (
        ((_workoutOverallStatsModel.totalAverageDuration * _workoutOverallStatsModel.totalWorkouts) + workoutDuration)
            / (_workoutOverallStatsModel.totalWorkouts+1)
    ).round();

    _workoutOverallStatsModel.averageDurationThisMonth = (
        ((_workoutOverallStatsModel.averageDurationThisMonth * _workoutOverallStatsModel.totalWorkoutsThisMonth) + workoutDuration)
            / (_workoutOverallStatsModel.totalWorkoutsThisMonth+1)
    ).round();

    _workoutOverallStatsModel.averageDurationThisYear = (
        ((_workoutOverallStatsModel.averageDurationThisYear * _workoutOverallStatsModel.totalWorkoutsThisYear) + workoutDuration)
            / (_workoutOverallStatsModel.totalWorkoutsThisYear+1)
    ).round();

    _workoutOverallStatsModel.totalVolume += volume;
    _workoutOverallStatsModel.totalVolumeThisMonth += volume;
    _workoutOverallStatsModel.totalVolumeThisYear += volume;

    _workoutOverallStatsModel.totalReps += reps.round();
    _workoutOverallStatsModel.totalRepsThisMonth += reps.round();
    _workoutOverallStatsModel.totalRepsThisYear += reps.round();

    _workoutOverallStatsModel.totalSets += sets.round();
    _workoutOverallStatsModel.totalSetsThisMonth += sets.round();
    _workoutOverallStatsModel.totalSetsThisYear += sets.round();

    _workoutOverallStatsModel.totalWorkouts += 1;
    _workoutOverallStatsModel.totalWorkoutsThisMonth += 1;
    _workoutOverallStatsModel.totalWorkoutsThisYear += 1;

    _workoutOverallStatsModel.lastLog = currentDate;

    saveOverallStats(_workoutOverallStatsModel);

    notifyListeners();
  }

  void loadWeekdayExerciseTracking(Map<String, dynamic> weekdayTrackingValues) {

    ///https://stackoverflow.com/questions/49393231/how-to-get-day-of-year-week-of-year-from-a-datetime-dart-object

    int numOfWeeks(int year) {
      DateTime dec28 = DateTime(year, 12, 28);
      int dayOfDec28 = int.parse(DateFormat("D").format(dec28));
      return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
    }

    int weekNumber(DateTime date) {
      int dayOfYear = int.parse(DateFormat("D").format(date));
      int woy =  ((dayOfYear - date.weekday + 10) / 7).floor();
      if (woy < 1) {
        woy = numOfWeeks(date.year - 1);
      } else if (woy > numOfWeeks(date.year)) {
        woy = 1;
      }
      return woy;
    }

    print(weekdayTrackingValues["lastDate"]);
    print(weekNumber(weekdayTrackingValues["lastDate"]));

    if ((weekNumber(weekdayTrackingValues["lastDate"]) < weekNumber(DateTime.now()))
        || (weekNumber(weekdayTrackingValues["lastDate"]) != 52
          && DateTime.now().year > weekdayTrackingValues["lastDate"].year)) {

      weekdayTrackingValues = {
        "lastDate": weekdayTrackingValues["lastDate"],
        "Monday": false,
        "Tuesday": false,
        "Wednesday": false,
        "Thursday": false,
        "Friday": false,
        "Saturday": false,
        "Sunday": false,
      };

    }

    _weekDayExerciseTracker = weekdayTrackingValues;

    notifyListeners();

  }

  List<StatsMeasurement> _routineVolumeStats = [];

  List<StatsMeasurement> get routineVolumeStats => _routineVolumeStats;

  Future<void> addVolumeDataToList(String routineName, GetOptions options) async {

    StatsMeasurement volumeData = await GetRoutineVolumeData(routineName);

    _routineVolumeStats.add(volumeData);

    notifyListeners();
  }

  void calculateRoutineStats() {

    List<String> routineNames = {
      for(WorkoutLogExerciseDataModel exercise in _currentWorkout.exercises)
        exercise.routineName!
    }.toList();

    ///During testing this doesnt work but is the proper implementation
    //for (String routineName in _currentWorkout.routineNames) {
    for (String routineName in routineNames) {

      double volume = 0;

      for (WorkoutLogExerciseDataModel exerciseData in _currentWorkout.exercises) {
        if (exerciseData.type == 0 && exerciseData.routineName == routineName) {
          volume += exerciseData.weight * exerciseData.reps;
        }
      }

      if (_routineVolumeStats.any((element) => element.measurementID == routineName)) {

        int index = _routineVolumeStats.indexWhere((element) => element.measurementID == routineName);

        _routineVolumeStats[index].measurementValues.add(volume);
        _routineVolumeStats[index].measurementDates.add(_currentWorkout.startOfWorkout.toString());

      } else {

        _routineVolumeStats.add(
            StatsMeasurement(
                measurementID: routineName,
                measurementName: routineName + " Volume",
                measurementValues: [volume],
                measurementDates: [_currentWorkout.startOfWorkout.toString()],
            ),
        );

      }

      SaveRoutineVolumeData(_routineVolumeStats[_routineVolumeStats.indexWhere((element) => element.measurementID == routineName)]);

      print(routineName);
      print(volume);
    }


  }

  void endWorkout(DateTime endOfWorkout, int endOfWorkoutInSeconds) {

    _workoutStarted = false;
    _currentWorkout.endOfWorkout = endOfWorkout;
    _currentWorkout.endOfWorkoutInSeconds = endOfWorkoutInSeconds;

    if (_currentWorkout.exercises.isNotEmpty) {

      FirebaseAnalytics.instance.logEvent(name: 'workout_saved');

      _weekDayExerciseTracker[DateFormat('EEEE').format(startOfWorkout)] = true;
      _weekDayExerciseTracker["lastDate"] = startOfWorkout;
      saveDayTracking(_weekDayExerciseTracker);

      _currentWorkout.routineNames = {
        for(WorkoutLogExerciseDataModel exercise in _currentWorkout.exercises)
          exercise.routineName
      }.toList();

      calculateRoutineStats();
      calculateOverallStats();

      ///todo add calorie calculations for cardio

      finalizeWorkout(_currentWorkout);
      _workoutLogs.insert(0, _currentWorkout);
    }

    writeWorkoutStarted(_workoutStarted, null);

    _currentWorkout = WorkoutLogModel(
      startOfWorkout: DateTime.now(),
      exercises: [],
      routineNames: [],
    );

    notifyListeners();

  }

  void createNewRoutine(String routineName) {

    RoutinesModel newRoutine = RoutinesModel(
      routineID: const Uuid().v4().toString(),
      routineDate: '',
      routineName: routineName,
      exercises: <ExerciseListModel>[],
    );

    createRoutine(newRoutine);

    _routinesList.add(newRoutine);

    notifyListeners();
  }

  void deleteRoutine(int index) {

    print(index);

    deleteRoutineData(_routinesList[index].routineName);
    _routinesList.removeAt(index);

    notifyListeners();
  }

  void loadRoutineData(List<RoutinesModel> routines) {

    _routinesList = routines;

    notifyListeners();
  }

  void updateExerciseDate(RoutinesModel routine, int routineID, int exerciseID) {

    DateTime currentDateTime = DateTime.now();
    String DateTimeFormatted = DateFormat("dd/MM/yyyy").format(currentDateTime);

    _routinesList[routineID].routineDate = DateTimeFormatted;
    _routinesList[routineID].exercises[exerciseID].exerciseDate = DateTimeFormatted;

    updateRoutineData(_routinesList[routineID]);

    notifyListeners();
  }

  void updateWorkoutExerciseLogs(ExerciseModel newLog, RoutinesModel routine) {

    _currentWorkout.exercises.add(
      WorkoutLogExerciseDataModel(
        measurementName: newLog.exerciseName,
        type: newLog.type ?? 0,
        intensityNumber: newLog.exerciseTrackingData.dailyLogs[0]["intensityValues"][0],
        reps: newLog.exerciseTrackingData.dailyLogs[0]["repValues"][0],
        weight: newLog.exerciseTrackingData.dailyLogs[0]["weightValues"][0],
        timestamp: newLog.exerciseTrackingData.dailyLogs[0]["measurementTimeStamp"][0],
        routineName: routine.routineName,
      ),
    );

    updateCurrentWorkout(_currentWorkout);

    notifyListeners();
  }

  void addNewLog(ExerciseModel newLog, Map newLogMap, RoutinesModel routine) {

    if (!_workoutStarted) {
      startWorkout();
    }

    _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == newLog.exerciseName)] = newLog;

    saveExerciseLogs(
        _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == newLog.exerciseName)],
        newLogMap
    );

    int routineID = _routinesList.indexOf(routine);

    int exerciseID = _routinesList[routineID].exercises.indexWhere((element) => element.exerciseName == newLog.exerciseName);

    updateExerciseDate(routine, routineID, exerciseID);

    notifyListeners();

    try {
      if (_workoutStarted) {
        updateWorkoutExerciseLogs(newLog, routine);
      }
    } catch (error) {
      debugPrint(error.toString());
    }

  }


  void setMaxWeightAtRep(Map<String, String> exerciseMaxRepAndWeight) {

    _exerciseMaxRepAndWeight = SplayTreeMap<String,String>.from(exerciseMaxRepAndWeight, (a, b) => double.parse(a).compareTo(double.parse(b)));


    notifyListeners();
  }

  void updateMaxWeightAtRep(String reps, String weight, String exerciseName) {

    if (_exerciseMaxRepAndWeight.containsKey(weight)) {

      if (double.parse(reps) > double.parse(_exerciseMaxRepAndWeight[weight]!)) {

        _exerciseMaxRepAndWeight[weight] = reps;

      }

    } else {

      _exerciseMaxRepAndWeight[weight] = reps;

    }

    _exerciseMaxRepAndWeight = SplayTreeMap<String,String>.from(exerciseMaxRepAndWeight, (a, b) => double.parse(a).compareTo(double.parse(b)));

    saveExerciseMaxRepsAtWeight(exerciseName, _exerciseMaxRepAndWeight);
    _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseMaxRepsAndWeight = _exerciseMaxRepAndWeight;

    notifyListeners();

  }

  void deleteLog(String exerciseName, int index, int index2) {

    ExerciseModel selectedExerciseData = _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)];

    try {
      if (_workoutStarted) {

        _currentWorkout.exercises.removeAt(_currentWorkout.exercises.lastIndexWhere((element) =>
        element.measurementName == exerciseName
            && element.reps == selectedExerciseData.exerciseTrackingData.dailyLogs[index]["repValues"][index2]
            && element.weight == selectedExerciseData.exerciseTrackingData.dailyLogs[index]["weightValues"][index2]
            && element.timestamp == selectedExerciseData.exerciseTrackingData.dailyLogs[index]["measurementTimeStamp"][index2]
        ));

        updateCurrentWorkout(_currentWorkout);

      }
    } catch (error) {
      debugPrint(error.toString());
    }

    selectedExerciseData.exerciseTrackingData.dailyLogs[index]["measurementTimeStamp"].removeAt(index2);

    selectedExerciseData.exerciseTrackingData.dailyLogs[index]["weightValues"].removeAt(index2);

    selectedExerciseData.exerciseTrackingData.dailyLogs[index]["repValues"].removeAt(index2);

    if (selectedExerciseData.exerciseTrackingData.dailyLogs[index]["repValues"].isEmpty) {

      deleteLogData(
        selectedExerciseData,
        index,
      );

      selectedExerciseData.exerciseTrackingData.dailyLogs.removeAt(index);

    } else {
      updateLogData(
          selectedExerciseData,
          index,
      );
    }

    notifyListeners();
  }

  void addExerciseToRoutine(RoutinesModel routine, List<ExerciseListModel> exercises) {

    int routineIndex = _routinesList.indexOf(routine);

    if (routine.exercises.isNotEmpty) {
      for (final newExercise in exercises) {
        if (!_routinesList[routineIndex].exercises.any((routineExercises)
        => routineExercises.exerciseName == newExercise.exerciseName)) _routinesList[routineIndex].exercises.add(newExercise);
      }
    } else {
      _routinesList[routineIndex].exercises = exercises;
    }



    updateRoutineData(routine);

    notifyListeners();

  }

  void addNewExercise(String exerciseName) {

    _exerciseNamesList.add(exerciseName);

    updateExerciseData(_exerciseNamesList);

    notifyListeners();

  }

  void DeleteExercise(String exerciseName) {

    _exerciseNamesList.removeWhere((element) => element == exerciseName);

    updateExerciseData(_exerciseNamesList);
    deleteExercise(exerciseName);

    notifyListeners();

  }

  void deleteExerciseFromRoutine(int indexOfExercise, RoutinesModel routine) {

    int routineIndex = _routinesList.indexOf(routine);

    _routinesList[routineIndex].exercises.removeAt(indexOfExercise);

    updateRoutineData(routine);

    notifyListeners();

  }

  void loadExerciseNamesData(List<String> exerciseNames) {

    _exerciseNamesList = exerciseNames;

    notifyListeners();
  }

  void loadCategoriesNamesData(List<String> categories) {

    _categoriesNamesList = categories;

    notifyListeners();
  }

  fetchExerciseData(String exerciseName, GetOptions options) async {

    if (_exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseTrackingData.dailyLogs.isEmpty) {
      ExerciseModel data = await GetExerciseLogData(exerciseName, options: options);
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseTrackingData.dailyLogs = data.exerciseTrackingData.dailyLogs;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseMaxRepsAndWeight = data.exerciseMaxRepsAndWeight;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].type = data.type;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseTrackingType = data.exerciseTrackingType;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].category = data.category;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].primaryMuscle = data.primaryMuscle;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].secondaryMuscle = data.secondaryMuscle;
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].tertiaryMuscle = data.tertiaryMuscle;

    }
    setMaxWeightAtRep(_exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseMaxRepsAndWeight);

    notifyListeners();

  }


  void fetchMoreExerciseData(ExerciseModel exercise) async {
    try {
      ExerciseModel data = await GetMoreExerciseLogData(
          exercise.exerciseName,
          _exerciseList[_exerciseList.indexWhere((element) =>
          element.exerciseName == exercise.exerciseName)].exerciseTrackingData
              .dailyLogs.last["measurementDate"]
      );


      if (_exerciseList.any((value) =>
      value.exerciseName == exercise.exerciseName)) {
        _exerciseList[_exerciseList.indexWhere((element) =>
        element.exerciseName == exercise.exerciseName)].exerciseTrackingData
            .dailyLogs += data.exerciseTrackingData.dailyLogs;
      }

      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }



  late List<TrainingPlan> _trainingPlanList = [];

  late Map<int, String> _trainingPlanListOrder;

  List<TrainingPlan> get trainingPlanList => _trainingPlanList;

  Map get trainingPlanListOrder => _trainingPlanListOrder;


  bool checkForTrainingPlanData(String trainingPlanNameToCheck) {

    if (_trainingPlanList.any((value) => value.trainingPlanName == trainingPlanNameToCheck)) {
      return true;
    }
    return false;

  }


  void initialiseTrainingPlanListOrder(Map<int, String> trainingPlanListOrder) {

    _trainingPlanListOrder = trainingPlanListOrder;

  }


  Future<void> initialiseTrainingPlans(List<TrainingPlan> trainingPlanList) async {

    _trainingPlanList = trainingPlanList;

    try {

      await Future.wait<void>([
        GetTrainingPlanOrder(options: const GetOptions(source: Source.serverAndCache)).then((result) => _trainingPlanListOrder = result),
      ]);

    } catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrint(stacktrace.toString());
    }

    if (_trainingPlanListOrder.isNotEmpty) {
      debugPrint("Ordering Training Plans");

      List<TrainingPlan> newListToOrder = [];

      for (String value in _trainingPlanListOrder.values) {
        newListToOrder.add(_trainingPlanList[_trainingPlanList.indexWhere((item) => item.trainingPlanName == value)]);
      }
      _trainingPlanList = newListToOrder;


    }

  }


  void updateTrainingPlanListOrder(List<TrainingPlan> trainingPlans) {

    _trainingPlanListOrder = {

      for (int index = 0; index < trainingPlans.length; index++) index: trainingPlans[index].trainingPlanName

    };

    UpdateTrainingPlanOrder(_trainingPlanListOrder);

    debugPrint(_trainingPlanListOrder.toString());

    notifyListeners();

  }


  void addNewTrainingPlan(String trainingPlanName) {

    _trainingPlanList.add(

      TrainingPlan(
          trainingPlanName: trainingPlanName,
          trainingPlanWeeks: [
            TrainingPlanWeek(
                weekNumber: 1,
                mondayRoutineID: "",
                tuesdayRoutineID: "",
                wednesdayRoutineID: "",
                thursdayRoutineID: "",
                fridayRoutineID: "",
                saturdayRoutineID: "",
                sundayRoutineID: "",
            )
          ],
      )

    );

    CreateNewTrainingPlan(_trainingPlanList.last);

    updateTrainingPlanListOrder(_trainingPlanList);

  }


  void addRoutineToTrainingPlanDay(String routineID, int dayOfTheWeek, int trainingPlanWeek, int trainingPlanIndex) {

    debugPrint("Adding Routine To Training Plan");

    switch(dayOfTheWeek) {

      case 0:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].mondayRoutineID = routineID;
      case 1:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].tuesdayRoutineID = routineID;
      case 2:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].wednesdayRoutineID = routineID;
      case 3:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].thursdayRoutineID = routineID;
      case 4:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].fridayRoutineID = routineID;
      case 5:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].saturdayRoutineID = routineID;
      case 6:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].sundayRoutineID = routineID;

    }

    UpdateTrainingPlan(
      _trainingPlanList[trainingPlanIndex]
    );

    notifyListeners();

  }

  void removeRoutineFromTrainingPlanDay(int dayOfTheWeek, int trainingPlanWeek, int trainingPlanIndex) {

    debugPrint("Adding Routine To Training Plan");

    switch(dayOfTheWeek) {

      case 0:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].mondayRoutineID = "";
      case 1:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].tuesdayRoutineID = "";
      case 2:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].wednesdayRoutineID = "";
      case 3:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].thursdayRoutineID = "";
      case 4:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].fridayRoutineID = "";
      case 5:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].saturdayRoutineID = "";
      case 6:
        _trainingPlanList[trainingPlanIndex].trainingPlanWeeks[trainingPlanWeek].sundayRoutineID = "";

    }

    UpdateTrainingPlan(
        _trainingPlanList[trainingPlanIndex]
    );

    notifyListeners();

  }

  void deleteTrainingPlan(TrainingPlan trainingPlan) {

    debugPrint("Deleting Training Plan");

    _trainingPlanList.remove(trainingPlan);

    updateTrainingPlanListOrder(_trainingPlanList);

    DeleteTrainingPlan(
      trainingPlan,
    );

    notifyListeners();

  }


}