import 'package:fitness_tracker/models/workout/reps_weight_stats_model.dart';

class ExerciseModel {

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseTrackingData': exerciseTrackingData.toMap(),
    };
  }

  ExerciseModel({
    required this.exerciseName,
    required this.exerciseTrackingData,
  });

  String exerciseName;
  RepsWeightStatsMeasurement exerciseTrackingData;
}