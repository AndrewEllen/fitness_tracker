
class DistanceTimeStatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'timeInSeconds': timeInSeconds,
    };
  }
  DistanceTimeStatsMeasurement({
    required this.measurementName,
    required this.timeInSeconds,
  });

  String measurementName;
  int timeInSeconds;
}