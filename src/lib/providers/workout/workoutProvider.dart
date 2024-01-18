import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:flutter/cupertino.dart';
import '../../models/workout/exercise_model.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../models/workout/routines_model.dart';
import '../general/database_get.dart';
import '../general/database_write.dart';

class WorkoutProvider with ChangeNotifier {

  late List<RoutinesModel> _routinesList = [

    RoutinesModel(
      routineID: "1",
      routineName: "Pull Day",
      routineDate: "05/01/2024",
      exercises: [
        ExerciseListModel(
            exerciseName: "Barbell Sumo Deadlift",
            exerciseDate: "05/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Seated Machine Row",
            exerciseDate: "01/11/2023"
        ),
        ExerciseListModel(
            exerciseName: "One Arm Lat Pulldown",
            exerciseDate: "05/12/2023"
        ),
        ExerciseListModel(
            exerciseName: "Rear Delt Flys",
            exerciseDate: "02/01/2024"
        ),
      ],
    ),

    RoutinesModel(
      routineID: "1",
      routineName: "Test Routine 1",
      routineDate: "05/01/2024",
      exercises: [
        ExerciseListModel(
          exerciseName: "Test Exercise 1",
          exerciseDate: "05/01/2024"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 2",
            exerciseDate: "01/11/2023"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 3",
            exerciseDate: "05/12/2023"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 4",
            exerciseDate: "02/01/2024"
        ),
        ExerciseListModel(
          exerciseName: "Test Exercise 5",
            exerciseDate: "05/01/2024"
        ),
      ],
    ),

    RoutinesModel(
      routineID: "2",
      routineName: "Test Routine 2",
      routineDate: "05/01/2024",
      exercises: [
        ExerciseListModel(
            exerciseName: "Test Exercise 5",
            exerciseDate: "05/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 6",
            exerciseDate: "01/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 7",
            exerciseDate: "02/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 8",
            exerciseDate: "03/01/2024"
        ),
        ExerciseListModel(
            exerciseName: "Test Exercise 9",
            exerciseDate: "04/01/2024"
        ),
      ],
    )

  ];

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