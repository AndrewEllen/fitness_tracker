import 'package:fitness_tracker/models/workout/reps_weight_stats_model.dart';

class ExerciseModel {

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseTrackingData': exerciseTrackingData.toMap(),
      'category': category,
      'exerciseTrackingType': exerciseTrackingType,
    };
  }

  ExerciseModel({
    required this.exerciseName,
    required this.exerciseTrackingData,
    this.category,
    this.exerciseTrackingType = 0,
  });

  String exerciseName;
  RepsWeightStatsMeasurement exerciseTrackingData;
  String? category;
  int? exerciseTrackingType;
}