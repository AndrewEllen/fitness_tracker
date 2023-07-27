import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:collection';

List sortByDates(dates, values) {

  /* final DateFormat dateFormat = DateFormat('dd-MM-yyyy hh:mm:ss');

 final tuples = [
    for (var i = 0; i < dates.length; i++)
      (dateFormat.parse(dates[i]), dates[i], values[i])
  ];
  tuples.sort(
        (a, b) => a.$1.compareTo(b.$1),
  );
  for (final e in tuples) {
    print('${e.$2} ${e.$3}');
  }*/

  SplayTreeMap<String, double> sortedMap = SplayTreeMap.fromIterables(
      dates,
      values,
  );

  List<String> sortedDates = [...sortedMap.keys];
  List<double> sortedValues = [...sortedMap.values];

  return [sortedDates, sortedValues];
}

class UserStatsMeasurements with ChangeNotifier {
  late List<StatsMeasurement> _statsMeasurements = [];
  List<StatsMeasurement> get statsMeasurement => _statsMeasurements;

  void initialiseStatsMeasurements(List<StatsMeasurement> loadStatsMeasurement) {
    _statsMeasurements = loadStatsMeasurement;
    notifyListeners();
  }
  void updateStatsMeasurement(String newValue, int listIndex, int index) {
    _statsMeasurements[index].measurementValues[listIndex] = double.parse(newValue);
    notifyListeners();
  }
  void updateStatsMeasurementName(String newName, int index) {
    _statsMeasurements[index].measurementName = newName;
    notifyListeners();
  }
  void addStatsMeasurement(double newValue, String newDate, int index) {

    _statsMeasurements[index].measurementValues.add(newValue);
    _statsMeasurements[index].measurementDates.add(newDate);

    List sortedList = sortByDates(
      _statsMeasurements[index].measurementDates,
      _statsMeasurements[index].measurementValues,
    );

    _statsMeasurements[index].measurementDates = sortedList[0];
    _statsMeasurements[index].measurementValues = sortedList[1];

    notifyListeners();
  }
  void addNewMeasurement(String newMeasurementName, String Uuid) {

    _statsMeasurements.add(
        StatsMeasurement(
            measurementID: Uuid,
            measurementName: newMeasurementName,
            measurementValues: [],
            measurementDates: [],
        )
    );

    notifyListeners();
  }
  void deleteStat(int listIndex, int index) {
    print(_statsMeasurements[index].measurementValues[listIndex]);
    print(_statsMeasurements[index].measurementDates[listIndex]);
    print(listIndex);
    _statsMeasurements[index].measurementValues.removeAt(listIndex);
    _statsMeasurements[index].measurementDates.removeAt(listIndex);
    notifyListeners();
  }
  void deleteMeasurement(int index) {
    print(_statsMeasurements[index].measurementName);
    _statsMeasurements.removeAt(index);

    notifyListeners();
  }
}