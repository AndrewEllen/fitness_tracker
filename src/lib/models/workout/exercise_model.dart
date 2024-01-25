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
    required this.exerciseMaxRepsAndWeight,
    this.category,
    this.exerciseTrackingType = 0,
  });

  String exerciseName;
  RepsWeightStatsMeasurement exerciseTrackingData;
  Map<String, String> exerciseMaxRepsAndWeight;
  String? category;
  int? exerciseTrackingType;
}