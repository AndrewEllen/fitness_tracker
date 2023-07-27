import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';


FillBooleanListRoutines(List<WorkoutRoutine> numberOfValues) {
  int numberOfLists = 7;
  List<List<bool>> listOfMultipleBooleans = List.filled(numberOfLists, []);
  for (int i = 0; i < numberOfLists; i++) {
    List<bool> listOfBooleans = List.filled(numberOfValues.length, false);
    listOfMultipleBooleans[i] = listOfBooleans;
  }
  //print(listOfMultipleBooleans);
  return listOfMultipleBooleans;
}

class RoutinesList with ChangeNotifier {
  late List<WorkoutRoutine> _workoutRoutines = [];
  late List<String> _newRoutineExerciseList = [];
  late List<List<bool>> _panelContentSelected = FillBooleanListRoutines(_workoutRoutines);

  List<WorkoutRoutine> get workoutRoutines => _workoutRoutines;
  List<String> get newRoutineExerciseList => _newRoutineExerciseList;
  List<List<bool>> get panelContentSelected => _panelContentSelected;

  void updateRoutine(List<WorkoutRoutine> newWorkoutRoutine) {
    //Change to update list of routines
    _workoutRoutines = newWorkoutRoutine;
    notifyListeners();
  }
  void setRoutineInititial(List<WorkoutRoutine> newRoutines) {
    _workoutRoutines = newRoutines;
  }
  void resetValueUserSelectedRoutines() {
    _panelContentSelected = FillBooleanListRoutines(_workoutRoutines);
    notifyListeners();
  }
  void addNewRoutine(WorkoutRoutine newWorkoutRoutine) {
    _workoutRoutines.add(newWorkoutRoutine);
    notifyListeners();
  }
  void editExistingRoutine(WorkoutRoutine newWorkoutRoutine, String routineID) {
    for (int i = 0; i < _workoutRoutines.length; i++) {
      if (_workoutRoutines[i].routineID == routineID) {
        _workoutRoutines[i] = newWorkoutRoutine;
        break;
      }
    }

    notifyListeners();
  }
  void updateNewRoutineExerciseList(List<String> newExercisesList) {
    _newRoutineExerciseList = newExercisesList;
    notifyListeners();
  }
}