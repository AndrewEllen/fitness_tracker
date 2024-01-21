
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutOverallStatsModel {
  Map<String, dynamic> toMap() {
    return {
      'totalVolume': totalVolume,
      'totalReps': totalReps,
      'totalSets': totalSets,
      'totalWorkouts': totalWorkouts,
      'totalAverageDuration': totalAverageDuration,
      'totalVolumeThisYear': totalVolumeThisYear,
      'totalVolumeThisMonth': totalVolumeThisMonth,
      'totalRepsThisYear': totalRepsThisYear,
      'totalRepsThisMonth': totalRepsThisMonth,
      'totalSetsThisYear': totalSetsThisYear,
      'totalSetsThisMonth': totalSetsThisMonth,
      'totalWorkoutsThisYear': totalWorkoutsThisYear,
      'totalWorkoutsThisMonth': totalWorkoutsThisMonth,
      'averageDurationThisYear': averageDurationThisYear,
      'averageDurationThisMonth': averageDurationThisMonth,
      'lastLog': lastLog,
    };
  }
  WorkoutOverallStatsModel({
    required this.totalVolume,
    required this.totalReps,
    required this.totalSets,
    required this.totalWorkouts,
    required this.totalAverageDuration,
    required this.totalVolumeThisYear,
    required this.totalVolumeThisMonth,
    required this.totalRepsThisYear,
    required this.totalRepsThisMonth,
    required this.totalSetsThisYear,
    required this.totalSetsThisMonth,
    required this.totalWorkoutsThisYear,
    required this.totalWorkoutsThisMonth,
    required this.averageDurationThisYear,
    required this.averageDurationThisMonth,
    required this.lastLog,
  });

  double totalVolume;
  double totalVolumeThisYear;
  double totalVolumeThisMonth;

  int totalReps;
  int totalRepsThisMonth;
  int totalRepsThisYear;

  int totalSets;
  int totalSetsThisYear;
  int totalSetsThisMonth;

  int totalWorkouts;
  int totalWorkoutsThisYear;
  int totalWorkoutsThisMonth;

  int totalAverageDuration;
  int averageDurationThisYear;
  int averageDurationThisMonth;

  DateTime lastLog;
}