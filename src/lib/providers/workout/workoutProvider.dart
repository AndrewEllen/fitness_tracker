
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/routines_model.dart';
import '../../models/workout/workout_log_model.dart';
import '../general/database_get.dart';
import '../general/database_write.dart';


class WorkoutProvider with ChangeNotifier {

  dynamic _lastWorkoutLogDocument;

  dynamic get lastWorkoutLogDocument => _lastWorkoutLogDocument;

  late WorkoutLogModel _currentSelectedLog;

  WorkoutLogModel get currentSelectedLog => _currentSelectedLog;

  late List<WorkoutLogModel> _workoutLogs = [];

  List<WorkoutLogModel> get workoutLogs => _workoutLogs;

  late List<RoutinesModel> _routinesList = [];

  List<RoutinesModel> get routinesList => _routinesList;

  late List<String> _exerciseNamesList = [];

  List<String> get exerciseNamesList => _exerciseNamesList;

  late final List<ExerciseModel> _exerciseList = [];

  List<ExerciseModel> get exerciseList => _exerciseList;

  late bool _workoutStarted = false;
  late DateTime _startOfWorkout;
  late DateTime _endOfWorkout;

  bool get workoutStarted => _workoutStarted;
  DateTime get startOfWorkout => _startOfWorkout;
  DateTime get endOfWorkout => _endOfWorkout;

  late WorkoutLogModel _currentWorkout;

  WorkoutLogModel get currentWorkout => _currentWorkout;

  bool checkForExerciseName(String exerciseNameToCheck) {

    if (_exerciseNamesList.any((value) => value == exerciseNameToCheck)) {
      return true;
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

  void UpdateLastWorkoutLogDocument(dynamic document) {

    _lastWorkoutLogDocument = document;

  }

  void selectLog(int index) {
    _currentSelectedLog = _workoutLogs[index];
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

  void endWorkout(DateTime endOfWorkout) {

    _workoutStarted = false;
    _currentWorkout.endOfWorkout = endOfWorkout;

    if (_currentWorkout.exercises.isNotEmpty) {
      finalizeWorkout(_currentWorkout);
      _workoutLogs.add(_currentWorkout);
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


    _currentWorkout.routineNames.add(routine.routineName);
    _currentWorkout.routineNames = _currentWorkout.routineNames.toSet().toList();


    _currentWorkout.exercises.add(
      WorkoutLogExerciseDataModel(
        measurementName: newLog.exerciseName,
        reps: newLog.exerciseTrackingData.dailyLogs[0]["repValues"][0],
        weight: newLog.exerciseTrackingData.dailyLogs[0]["weightValues"][0],
        timestamp: newLog.exerciseTrackingData.dailyLogs[0]["measurementTimeStamp"][0],
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


  void deleteLog(String exerciseName, int index, int index2) {

    ExerciseModel selectedExerciseData = _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)];

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
        if (!_routinesList[routineIndex].exercises.any((routineExercises) => routineExercises.exerciseName == newExercise.exerciseName)) _routinesList[routineIndex].exercises.add(newExercise);
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


  void fetchExerciseData(String exerciseName) async {

    if (_exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseTrackingData.dailyLogs.isEmpty) {

      ExerciseModel data = await GetExerciseLogData(exerciseName);
      _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == exerciseName)].exerciseTrackingData.dailyLogs = data.exerciseTrackingData.dailyLogs;

    }

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

}