import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:core';

ExerciseCategoryListFiller(List<String> categoryNames, List<Exercises> categoryExercises) {
  List<Exercises> categoryExercisesClone = [...categoryExercises];
  List<List<String>> listOfExercisesByCategory = [];
  for (int i = 0; i < categoryNames.length; i++) {
    listOfExercisesByCategory.add([]);
    for (int x = 0; x < categoryExercises.length; x++) {
      if (categoryExercises[x].exerciseCategory == categoryNames[i]) {
        listOfExercisesByCategory[i].add(categoryExercises[x].exerciseName);
        categoryExercisesClone[x] = Exercises(exerciseName: "added", exerciseCategory: categoryExercises[x].exerciseCategory);
      }
    }
  }
  listOfExercisesByCategory.add([]);
  for (int i = 0; i < categoryExercises.length; i++) {
    if (categoryExercisesClone[i].exerciseName != "added") {
      listOfExercisesByCategory[listOfExercisesByCategory.length - 1].add(categoryExercises[i].exerciseName);
    }
  }
  return listOfExercisesByCategory;
}

CheckPanelTitles(List<String> panelTitles, List<String> panelContentOtherCategory) {
  //print(panelContentOtherCategory);
  if (panelContentOtherCategory.isNotEmpty) {
    panelTitles.add("Other");
    return panelTitles;
  }
  return panelTitles;
}

FillBooleanListExercises(int numberOfLists, List<List<String>> numberOfValues) {
  List<List<bool>> listOfMultipleBooleans = List.filled(numberOfLists, []);
  for (int i = 0; i < numberOfLists; i++) {
    List<bool> listOfBooleans = List.filled(numberOfValues[i].length, false);
    listOfMultipleBooleans[i] = listOfBooleans;
  }
  return listOfMultipleBooleans;
}

class ExerciseList with ChangeNotifier {
  late List<String> _categories = [];
  late List<Exercises> _exercises = [];
  late List<List<String>> _panelContent = ExerciseCategoryListFiller(_categories, _exercises);
  late List<String> _panelTitles = CheckPanelTitles(_categories, _panelContent.last);
  late List<List<bool>> _panelContentSelected = FillBooleanListExercises(_panelTitles.length, _panelContent);

  List<String> get panelTitles => _panelTitles;
  List<List<String>> get panelContent => _panelContent;
  List<List<bool>> get panelContentSelected => _panelContentSelected;
  List<Exercises> get exercises => _exercises;
  List<String> get categories => _categories;

  void setCategoriesInititial(List<String> newCategories) {
    _categories = newCategories;
  }
  void setExerciseInititial(List<Exercises> newExercises) {
    _exercises = newExercises;
  }
  void updatePanelTitle(List<String> newPanelTitlesContent) {
    _panelTitles = newPanelTitlesContent;
    notifyListeners();
  }
  void updatePanelContent(List<List<String>> newPanelContent) {
    _panelContent = newPanelContent;
    notifyListeners();
  }
  void updatePanelContentSelected(List<List<bool>> newPanelContentSelected) {
    _panelContentSelected = newPanelContentSelected;
    notifyListeners();
  }
  void resetValueUserSelectedExercises() {
    _panelContentSelected = FillBooleanListExercises(_panelTitles.length, _panelContent);
    notifyListeners();
  }
  void editRoutineAndSetupBooleanList(List<String> exercisesInRoutine) {
    //todo fix crash on edit. Bool not updating properly
    _panelContentSelected = FillBooleanListExercises(_panelTitles.length, _panelContent);
    int count = 0;
    for (int i = 0; i < _panelContent.length; i++) {
      for (int x = 0; x < exercisesInRoutine.length; x++) {
        int indexIfFound = _panelContent[i].indexWhere((element) => element == exercisesInRoutine[x]);
        if (indexIfFound > -1) {
          count++;
          _panelContentSelected[i][indexIfFound] = true;
        }
      }
      if (count == exercisesInRoutine.length) {
        break;
      }
    }
  }
}