
class WorkoutLogExerciseDataModel {

  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'routineName': routineName,
      'type': type,
      'reps': reps,
      'weight': weight,
      'timestamp': timestamp,
    };
  }
  WorkoutLogExerciseDataModel({
    required this.measurementName,
    required this.routineName,
    required this.type,
    required this.reps,
    required this.weight,
    required this.timestamp,
  });

  String measurementName;
  String routineName;
  int? type;
  double reps;
  double weight;
  String timestamp;
}