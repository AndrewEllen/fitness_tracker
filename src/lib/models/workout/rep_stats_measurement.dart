
class RepsStatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'reps': reps,
    };
  }
  RepsStatsMeasurement({
    required this.measurementName,
    required this.reps,
  });

  String measurementName;
  double reps;
}