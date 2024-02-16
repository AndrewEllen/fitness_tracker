import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/stats/stats_model.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:fitness_tracker/models/workout/workout_log_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/general/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_line_chart.dart';
import '../../widgets/workout_new/workout_log_box.dart';
import '../../widgets/workout_new/workout_log_top_stats_box.dart';

class SelectedWorkoutLogPage extends StatefulWidget {
  SelectedWorkoutLogPage({Key? key}) : super(key: key);

  @override
  State<SelectedWorkoutLogPage> createState() => _SelectedWorkoutLogPageState();
}

class _SelectedWorkoutLogPageState extends State<SelectedWorkoutLogPage> {
  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  void getData(List<String> routineNames) async {

    bool result = await InternetConnection().hasInternetAccess;
    GetOptions options = const GetOptions(source: Source.serverAndCache);

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No Internet Connection"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.6695,
            right: 20,
            left: 20,
          ),
          dismissDirection: DismissDirection.none,
          duration: const Duration(milliseconds: 700),
        ),
      );
      options = const GetOptions(source: Source.cache);
    }


    for (String routineName in routineNames) {
      if (!context.read<WorkoutProvider>().routineVolumeStats.any((e) => e.measurementID == routineName)) {
        context.read<WorkoutProvider>().addVolumeDataToList(routineName, options);
      }
    }

  }

  String totalVolume(WorkoutLogModel? workoutLog) {

    if (workoutLog == null) {
      return "0";
    }

    double volume = 0;

    for (WorkoutLogExerciseDataModel exerciseData in workoutLog.exercises) {
      if (exerciseData.type == 0) {
        volume += exerciseData.weight * exerciseData.reps;
      }
    }

    return volume.toString().replaceAll(removeTrailingZeros, "");
  }

  String timeStartedFunction(DateTime time) {

    String stringToDisplay = "Workout Date: ";

    String date = DateFormat("dd/MM/yyyy").format(time).toString();
    String timeOfDay = DateFormat("hh:mm a").format(time).toString();

    return stringToDisplay + date + " at " + timeOfDay;
  }


  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().routineVolumeStats;

    List workoutExerciseNamesSet = [];
    List workoutRoutineNamesSet = [];
    WorkoutLogModel? workout;

    try {
      workout = context.read<WorkoutProvider>().currentSelectedLog;
      workoutRoutineNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.routineName}.toList();
      workoutExerciseNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.measurementName}.toList();

      getData(List<String>.from(workoutRoutineNamesSet));

    } catch (error) {
      debugPrint(error.toString());
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: Text(
          workoutRoutineNamesSet.join(", "),
          style: boldTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 12.h),
              Row(
                children: [

                  WorkoutLogTopStatsBox(
                    dataToDisplay: workoutExerciseNamesSet.length.toString(),
                    title: "Exercises",
                  ),

                  WorkoutLogTopStatsBox(
                    dataToDisplay: totalVolume(workout),
                    title: "Volume",
                    noMargin: true,
                  ),

                  WorkoutLogTopStatsBox(
                    dataToDisplay: DateTime.now().difference(workout!.startOfWorkout).inMinutes.toString(),
                    title: "Duration",
                    bottomText: "Minutes",
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  timeStartedFunction(context.read<WorkoutProvider>().currentSelectedLog.startOfWorkout),
                  style: boldTextStyle,
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: workoutRoutineNamesSet.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24.w),
                            child: Text(
                              workoutRoutineNamesSet[index],
                              style: boldTextStyle.copyWith(
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: workoutExerciseNamesSet.length,
                              itemBuilder: (BuildContext context, int index2) {
                                List<
                                    WorkoutLogExerciseDataModel> filteredExercises = workout!
                                    .exercises
                                    .where((exercise) =>
                                exercise.routineName ==
                                    workoutRoutineNamesSet[index] &&
                                    exercise.measurementName ==
                                        workoutExerciseNamesSet[index2] &&
                                    exercise.measurementName.isNotEmpty)
                                    .toList();

                                return filteredExercises.isNotEmpty
                                    ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 24.w, top: 24.h),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 20.w),
                                            child: const Icon(
                                              MdiIcons.dumbbell,
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 260.w,
                                            child: SingleChildScrollView(
                                              clipBehavior: Clip.hardEdge,
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                workoutExerciseNamesSet[index2],
                                                style: boldTextStyle.copyWith(
                                                    fontSize: 18),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex:8),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: filteredExercises.length,
                                      itemBuilder: (BuildContext context,
                                          int index3) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: 24.w, top: 12.h),
                                          child: Row(
                                            //mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(right: 36.w),
                                                child: Text(
                                                  (index3 + 1).toString(),
                                                  // Use index3 for set number
                                                  style: boldTextStyle,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: 36.w),
                                                child: filteredExercises[index3].type == 0 ? Text(
                                                  filteredExercises[index3].weight.toString().replaceAll(removeTrailingZeros, "")
                                                      .toString() + " kg x " + filteredExercises[index3].reps.toString().replaceAll(removeTrailingZeros, "") + " reps",
                                                  style: boldTextStyle,
                                                  textAlign: TextAlign.left,
                                                ) : Text(
                                                  filteredExercises[index3].weight.toString().replaceAll(removeTrailingZeros, "")
                                                      .toString() + " km in " + filteredExercises[index3].reps.toString().replaceAll(removeTrailingZeros, "") + " mins",
                                                  style: boldTextStyle,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding: EdgeInsets.only(right: 48.w),
                                                child: Text(
                                                  filteredExercises[index3].timestamp
                                                      .toString(),
                                                  style: boldTextStyle,
                                                  textAlign: TextAlign.right,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                                    : const SizedBox.shrink();
                              },
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      );
                    }
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: workoutRoutineNamesSet.length,
                itemBuilder: (BuildContext context, int index) {
                  return WorkoutLineChart(
                    routineName: workoutRoutineNamesSet[index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
