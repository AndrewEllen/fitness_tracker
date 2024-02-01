
class WorkoutLogExerciseDataModel {

  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'routineName': routineName,
      'intensityNumber': intensityNumber,
      'type': type,
      'reps': reps,
      'weight': weight,
      'timestamp': timestamp,
    };
  }
  WorkoutLogExerciseDataModel({
    required this.measurementName,
    required this.routineName,
    required this.intensityNumber,
    required this.type,
    required this.reps,
    required this.weight,
    required this.timestamp,
  });

  String measurementName;
  String routineName;
  double? intensityNumber;
  int? type;
  double reps;
  double weight;
  String timestamp;
}