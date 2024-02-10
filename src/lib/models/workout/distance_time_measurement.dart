
class DistanceTimeStatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'timeInSeconds': timeInSeconds,
      'distance': distance,
    };
  }
  DistanceTimeStatsMeasurement({
    required this.measurementName,
    required this.timeInSeconds,
    required this.distance,
  });

  String measurementName;
  int timeInSeconds;
  double distance;
}