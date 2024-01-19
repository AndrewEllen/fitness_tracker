import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/routines_model.dart';
import '../general/database_get.dart';
import '../general/database_write.dart';

class WorkoutProvider with ChangeNotifier {

  late List<RoutinesModel> _routinesList = [];

  List<RoutinesModel> get routinesList => _routinesList;


  late final List<ExerciseModel> _exerciseList = [];

  List<ExerciseModel> get exerciseList => _exerciseList;


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

    deleteRoutineData(_routinesList[index].routineName);
    _routinesList.removeAt(index);

    notifyListeners();
  }

  void loadRoutineData(List<RoutinesModel> routines) {

    _routinesList = routines;

    notifyListeners();
  }

  void addNewLog(ExerciseModel newLog, Map newLogMap) {

    _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == newLog.exerciseName)] = newLog;

    saveExerciseLogs(
        _exerciseList[_exerciseList.indexWhere((element) => element.exerciseName == newLog.exerciseName)],
        newLogMap
    );

    notifyListeners();

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