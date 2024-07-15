

import 'exercise_list_model.dart';

class RoutinesModel {


  mapExerciseData(data) {

    List<Map> exerciseListToReturn = [];

    for (ExerciseListModel exerciseListData in data) {

      exerciseListToReturn.add(
          {
            "exerciseName": exerciseListData.exerciseName,
            "exerciseDate": exerciseListData.exerciseDate,
            "exerciseTrackingType": exerciseListData.exerciseTrackingType ?? 0,
            "mainOrAccessory": exerciseListData.mainOrAccessory ?? 0,
          }
      );
    }


    return exerciseListToReturn;

  }


  Map<String, dynamic> toMap() {
    return {
      'routineID' : routineID.toString(),
      'routineDate': routineDate,
      'routineName': routineName,
      'exercises': mapExerciseData(exercises),
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