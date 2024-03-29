import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';

class WorkoutLogModel {

  mapDataA(data) {

    return [
      for (WorkoutLogExerciseDataModel exerciseData in data)
        exerciseData.toMap()
    ];

  }

  Map<String, dynamic> toMap() {
    return {
      'startOfWorkout': startOfWorkout,
      'endOfWorkout': endOfWorkout,
      'routineNames': routineNames,
      'exercises': mapDataA(exercises),
    };
  }
  WorkoutLogModel({
    required this.startOfWorkout,
    this.endOfWorkout,
    required this.exercises,
    required this.routineNames,
  });

  DateTime startOfWorkout;
  DateTime? endOfWorkout;
  List<WorkoutLogExerciseDataModel> exercises;
  List<String> routineNames;
}