
class WorkoutLogExerciseDataModel {

  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'reps': reps,
      'weight': weight,
      'timestamp': timestamp,
    };
  }
  WorkoutLogExerciseDataModel({
    required this.measurementName,
    required this.reps,
    required this.weight,
    required this.timestamp,
  });

  String measurementName;
  double reps;
  double weight;
  String timestamp;
}