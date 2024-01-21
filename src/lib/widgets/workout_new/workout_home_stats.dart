import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_log_top_stats_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutHomeStatsBox extends StatelessWidget {
  WorkoutHomeStatsBox({Key? key, required this.value}) : super(key: key);
  late double value;

  String displayDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}h $twoDigitMinutes m";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: value,
      width: double.maxFinite,
      color: appTertiaryColour,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalVolume.toString(),
                  title: "Total\nVolume",
                  bottomText: "All Time",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalVolumeThisMonth.toString(),
                  title: "Total\nVolume",
                  bottomText: "This Month",
                  noMargin: true,
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalVolumeThisYear.toString(),
                  title: "Total\nVolume",
                  bottomText: "This Year",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalReps.toString(),
                  title: "Total\nReps",
                  bottomText: "All Time",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalRepsThisMonth.toString(),
                  title: "Total\nReps",
                  bottomText: "This Month",
                  smallFont: true,
                  bigMiddleFont: true,
                  noMargin: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalRepsThisYear.toString(),
                  title: "Total\nReps",
                  bottomText: "This Year",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalSets.toString(),
                  title: "Total\nSets",
                  bottomText: "All Time",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalSetsThisMonth.toString(),
                  title: "Total\nSets",
                  bottomText: "This Month",
                  smallFont: true,
                  bigMiddleFont: true,
                  noMargin: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalSetsThisYear.toString(),
                  title: "Total\nSets",
                  bottomText: "This Year",
                  smallFont: true,
                  bigMiddleFont: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [

                WorkoutLogTopStatsBox(
                  dataToDisplay:
                  displayDuration(Duration(seconds: context.read<WorkoutProvider>().workoutOverallStatsModel.totalAverageDuration)),
                  title: "Avg.\nWorkout\nTime",
                  bottomText: "All Time",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay:
                  displayDuration(Duration(seconds: context.read<WorkoutProvider>().workoutOverallStatsModel.averageDurationThisMonth)),
                  title: "Avg.\nWorkout\nTime",
                  bottomText: "This Month",
                  smallFont: true,
                  bigMiddleFont: true,
                  noMargin: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay:
                  displayDuration(Duration(seconds: context.read<WorkoutProvider>().workoutOverallStatsModel.averageDurationThisYear)),
                  title: "Avg.\nWorkout\nTime",
                  bottomText: "This Year",
                  smallFont: true,
                  bigMiddleFont: true,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalWorkouts.toString(),
                  title: "Total\nNo. Of\nWorkouts",
                  bottomText: "All Time",
                  smallFont: true,
                  bigMiddleFont: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalWorkoutsThisMonth.toString(),
                  title: "Total\nNo. Of\nWorkouts",
                  bottomText: "This Month",
                  smallFont: true,
                  bigMiddleFont: true,
                  noMargin: true,
                ),

                WorkoutLogTopStatsBox(
                  dataToDisplay: context.read<WorkoutProvider>().workoutOverallStatsModel.totalWorkoutsThisYear.toString(),
                  title: "Total\nNo. Of\nWorkouts",
                  bottomText: "This Year",
                  smallFont: true,
                  bigMiddleFont: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
