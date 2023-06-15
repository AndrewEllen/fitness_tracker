class StatsMeasurement {
  Map<String, dynamic> toMap() {
    return {
      'measurementID' : measurementID,
      'measurementName': measurementName,
      'measurementData': measurementValues,
      'measurementDate': measurementDates,
    };
  }
  StatsMeasurement({
    required this.measurementID,
    required this.measurementName,
    required this.measurementValues,
    required this.measurementDates,
  });

  String measurementID;
  String measurementName;
  List<double> measurementValues;
  List<String> measurementDates;
}