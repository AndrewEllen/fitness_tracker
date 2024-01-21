import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/models/workout/workout_log_exercise_data.dart';
import 'package:fitness_tracker/models/workout/workout_log_model.dart';
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

class SelectedWorkoutLogPage extends StatefulWidget {
  SelectedWorkoutLogPage({Key? key}) : super(key: key);

  @override
  State<SelectedWorkoutLogPage> createState() => _SelectedWorkoutLogPageState();
}

class _SelectedWorkoutLogPageState extends State<SelectedWorkoutLogPage> {
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

    String stringToDisplay = "Workout Date: ";

    String date = DateFormat("dd/MM/yyyy").format(time).toString();
    String timeOfDay = DateFormat("hh:mm a").format(time).toString();

    return stringToDisplay + date + " at " + timeOfDay;
  }


  @override
  Widget build(BuildContext context) {

    List workoutExerciseNamesSet = [];
    WorkoutLogModel? workout = null;

    try {
      workout = context.read<WorkoutProvider>().currentSelectedLog;

      workoutExerciseNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.measurementName}.toList();
    } catch (error) {
      debugPrint(error.toString());
    }

    return Scaffold(
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
                  timeStartedFunction(context.read<WorkoutProvider>().currentWorkout.startOfWorkout),
                  style: boldTextStyle,
                ),
              ),

              ListView.builder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
