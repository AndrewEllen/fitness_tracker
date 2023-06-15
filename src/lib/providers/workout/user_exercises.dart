import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';

class UserExercisesList with ChangeNotifier {
  late List<Exercises> _exerciseList = [];

  List<Exercises> get exerciseList => _exerciseList;

  void inititateExerciseList(List<Exercises> newExercises) {
    _exerciseList = newExercises;
    notifyListeners();
  }
  void updateExercise(String newCategory, String newName, int index) {
    _exerciseList[index].exerciseCategory = newCategory;
    _exerciseList[index].exerciseName = newName;
    notifyListeners();
  }
  void addExercise(String newCategory, String newName) {
    _exerciseList.add(Exercises(
        exerciseName: newName,
        exerciseCategory: newCategory,
      ),
    );
    notifyListeners();
  }
  void deleteExercise(int index) {
    _exerciseList.removeAt(index);
    notifyListeners();
  }
}