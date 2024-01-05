class RepsWeightStatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementName': measurementName,
      'weightValues': weightValues,
      'repValues': repValues,
      'measurementDate': measurementDates,
    };
  }
  RepsWeightStatsMeasurement({
    required this.measurementName,
    required this.weightValues,
    required this.repValues,
    required this.measurementDates,
  });

  String measurementName;
  List<double> weightValues;
  List<double> repValues;
  List<String> measurementDates;
}