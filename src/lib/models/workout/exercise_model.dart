import 'package:fitness_tracker/models/workout/reps_weight_stats_model.dart';

class ExerciseModel {

  Map<String, dynamic> toMap() {
    return {
      'exerciseName': exerciseName,
      'exerciseTrackingData': exerciseTrackingData.toMap(),
      'category': category,
      'primaryMuscle': primaryMuscle,
      'secondaryMuscle': secondaryMuscle,
      'tertiaryMuscle': tertiaryMuscle,
      'type': type,
      'exerciseTrackingType': exerciseTrackingType,
    };
  }

  ExerciseModel({
    required this.exerciseName,
    required this.exerciseTrackingData,
    required this.exerciseMaxRepsAndWeight,
    this.category,
    this.primaryMuscle,
    this.secondaryMuscle,
    this.tertiaryMuscle,
    this.type = 0,
    this.exerciseTrackingType,
  });

  String exerciseName;
  RepsWeightStatsMeasurement exerciseTrackingData;
  Map<String, String> exerciseMaxRepsAndWeight;
  String? category;
  String? primaryMuscle;
  String? secondaryMuscle;
  String? tertiaryMuscle;
  int? type;
  int? exerciseTrackingType;
}