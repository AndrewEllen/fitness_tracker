
import 'package:fitness_tracker/models/workout/routines_model.dart';

class TrainingPlanWeekShare {

  Map<String, dynamic> toMap() {
    return {
      'weekNumber': weekNumber,
      'monday': mondayRoutine.toMap(),
      'tuesday': tuesdayRoutine.toMap(),
      'wednesday': wednesdayRoutine.toMap(),
      'thursday': thursdayRoutine.toMap(),
      'friday': fridayRoutine.toMap(),
      'saturday': saturdayRoutine.toMap(),
      'sunday': sundayRoutine.toMap(),
      'exerciseMuscleMap': exerciseMuscleMap,
    };
  }
  TrainingPlanWeekShare({
    required this.weekNumber,
    required this.mondayRoutine,
    required this.tuesdayRoutine,
    required this.wednesdayRoutine,
    required this.thursdayRoutine,
    required this.fridayRoutine,
    required this.saturdayRoutine,
    required this.sundayRoutine,
    required this.exerciseMuscleMap
  });

  int weekNumber;
  RoutinesModel mondayRoutine;
  RoutinesModel tuesdayRoutine;
  RoutinesModel wednesdayRoutine;
  RoutinesModel thursdayRoutine;
  RoutinesModel fridayRoutine;
  RoutinesModel saturdayRoutine;
  RoutinesModel sundayRoutine;
  Map<String,dynamic> exerciseMuscleMap;
}