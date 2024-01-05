class RepsWeightStatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'dailyLogs': dailyLogs,
    };
  }
  RepsWeightStatsMeasurement({
    required this.measurementName,
    required this.dailyLogs,
  });

  String measurementName;
  List<Map> dailyLogs;
}