

import 'exercise_list_model.dart';

class RoutinesModel {

  Map<String, dynamic> toMap() {
    return {
      'routineID' : routineID,
      'routineDate': routineDate,
      'routineName': routineName,
      'exercises': exercises.asMap(),
      'exerciseSetsAndRepsPlan': exerciseSetsAndRepsPlan,
    };
  }

  RoutinesModel({
    required this.routineID,
    required this.routineDate,
    required this.routineName,
    required this.exercises,
    this.exerciseSetsAndRepsPlan,
  });

  String routineID;
  String routineDate;
  String routineName;
  List<ExerciseListModel> exercises;
  Map<String, dynamic>? exerciseSetsAndRepsPlan;
}