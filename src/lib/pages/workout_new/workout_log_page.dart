import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:fitness_tracker/models/workout/workout_log_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_home.dart';
import 'package:fitness_tracker/pages/workout_new/workout_selected_log_page.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_log_box.dart';
import '../../widgets/workout_new/workout_log_top_stats_box.dart';

class WorkoutLogPage extends StatefulWidget {
  WorkoutLogPage({Key? key}) : super(key: key);

  @override
  State<WorkoutLogPage> createState() => _WorkoutLogPageState();
}

class _WorkoutLogPageState extends State<WorkoutLogPage> {
  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  String totalVolume(WorkoutLogModel? workoutLog) {

    if (workoutLog == null) {
      return "0";
    }

    double volume = 0;

    for (WorkoutLogExerciseDataModel exerciseData in workoutLog.exercises) {
      volume += exerciseData.weight * exerciseData.reps;
    }

    return volume.toString().replaceAll(removeTrailingZeros, "");
  }

  String timeStartedFunction(DateTime time) {

    String stringToDisplay = "Time Started: ";

    String date;

    if (time.day == DateTime.now().day && time.month == DateTime.now().month && time.year == DateTime.now().year) {
      date = "Today";
    } else {
      date = DateFormat("dd/MM/y").format(time).toString();
    }

    Duration timePassedDuration = DateTime.now().difference(time);
    String timePassedString;

    if (timePassedDuration.inHours != 0) {
      timePassedString = DateTime.now().difference(time).inHours.toString() + " Hours ago";
    } else if (timePassedDuration.inMinutes != 0) {
      timePassedString = DateTime.now().difference(time).inMinutes.toString() + " Minutes ago";
    } else {
      timePassedString = DateTime.now().difference(time).inSeconds.toString() + " Seconds ago";
    }

    return stringToDisplay + date + " - " + timePassedString;
  }


  @override
  Widget build(BuildContext context) {
    context.watch<WorkoutProvider>().workoutStarted;

    List workoutExerciseNamesSet = [];
    WorkoutLogModel workout = WorkoutLogModel(
      startOfWorkout: DateTime.now(),
      exercises: [],
      routineNames: [],
    );

    try {
      workout = context.read<WorkoutProvider>().currentWorkout;

      workoutExerciseNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.measurementName}.toList();
    } catch (error) {
      debugPrint(error.toString());
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: appSecondaryColour,
          onPressed: () => context.read<WorkoutProvider>().workoutStarted ?
          {
            if (context.read<WorkoutProvider>().currentWorkout.exercises.isNotEmpty) {
              context.read<WorkoutProvider>().endWorkout(DateTime.now()),
              context.read<WorkoutProvider>().selectLog(context.read<WorkoutProvider>().workoutLogs.length-1),
              context.read<PageChange>().changePageRemovePreviousCache(SelectedWorkoutLogPage()),
            } else {
              context.read<WorkoutProvider>().endWorkout(DateTime.now()),
              context.read<PageChange>().changePageRemovePreviousCache(WorkoutHomePageNew()),
            }

          } : {
            context.read<WorkoutProvider>().startWorkout(),
            context.read<PageChange>().backPage(),
          },
          child: Icon(
            Icons.save,
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 14.h),
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 50.h,
                child: Center(
                  child: Text(
                    "Current Workout",
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),

              Row(
                children: [

                  WorkoutLogTopStatsBox(
                    dataToDisplay: workoutExerciseNamesSet.length.toString(),
                    title: "Exercises",
                  ),

                  context.read<WorkoutProvider>().workoutStarted ? WorkoutLogTopStatsBox(
                    dataToDisplay: totalVolume(workout),
                    title: "Volume",
                    noMargin: true,
                  ) : WorkoutLogTopStatsBox(
                    dataToDisplay: "0",
                    title: "Volume",
                    noMargin: true,
                  ) ,

                  context.read<WorkoutProvider>().workoutStarted ? WorkoutLogTopStatsBox(
                    dataToDisplay: DateTime.now().difference(workout.startOfWorkout).inMinutes.toString(),
                    title: "Duration",
                    bottomText: "Minutes",
                  ) : WorkoutLogTopStatsBox(
                        dataToDisplay: "0",
                        title: "Duration",
                        bottomText: "Minutes",
                      ) ,

                ],
              ),

              context.read<WorkoutProvider>().workoutStarted ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  timeStartedFunction(context.read<WorkoutProvider>().currentWorkout.startOfWorkout),
                  style: boldTextStyle,
                ),
              ) : const SizedBox.shrink(),

              context.read<WorkoutProvider>().workoutStarted ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: workoutExerciseNamesSet.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Text(
                          workoutExerciseNamesSet[index],
                          style: boldTextStyle,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: workout!.exercises.length,
                          itemBuilder: (BuildContext context, int index2) {
                            return workout!.exercises[index2].measurementName == workoutExerciseNamesSet[index] ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  workout!.exercises[index2].reps.toString() + " reps",
                                  style: boldTextStyle,
                                ),
                                Text(
                                  workout!.exercises[index2].weight.toString() + " kg",
                                  style: boldTextStyle,
                                ),
                                Text(
                                  workout!.exercises[index2].timestamp.toString(),
                                  style: boldTextStyle,
                                ),
                                SizedBox(
                                  height: 10.h,
                                )
                              ],
                            ) : const SizedBox.shrink();
                          },
                        ),
                      ],
                    );
                }
              ) : const SizedBox.shrink(),
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ),
    );
  }
}
