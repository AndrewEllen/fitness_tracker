import 'package:avatar_glow/avatar_glow.dart';
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
import '../../widgets/general/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_line_chart.dart';
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
      //print(exerciseData.intensityNumber);
      if (exerciseData.type == 0) {
        volume += exerciseData.weight * exerciseData.reps;
      }
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
    List workoutRoutineNamesSet = [];
    WorkoutLogModel workout = WorkoutLogModel(
      startOfWorkout: DateTime.now(),
      exercises: [],
      routineNames: [],
    );

    try {
      workout = context.read<WorkoutProvider>().currentWorkout;

      workoutRoutineNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.routineName}.toList();

      workoutExerciseNamesSet = {for (WorkoutLogExerciseDataModel exercise in workout.exercises)
        exercise.measurementName}.toList();

    } catch (error) {
      debugPrint(error.toString());
    }


    List<String> routineNames = {
      for(WorkoutLogExerciseDataModel exercise in context.read<WorkoutProvider>().currentWorkout.exercises)
        exercise.routineName!
    }.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: const Text(
          "Current Workout Log",
          style: boldTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AvatarGlow(
          glowCount:
          3,
          glowColor: context.watch<WorkoutProvider>().workoutStarted ? appSenaryColour : appSecondaryColour,
          glowRadiusFactor: 0.7,
          child: FloatingActionButton(
            backgroundColor: context.watch<WorkoutProvider>().workoutStarted ? appSenaryColour : appSecondaryColour,
            onPressed: () => context.read<WorkoutProvider>().workoutStarted ?
            {
              if (context.read<WorkoutProvider>().currentWorkout.exercises.isNotEmpty) {
                context.read<UserNutritionData>().addCardioCalories(context.read<WorkoutProvider>().currentWorkout),
                context.read<WorkoutProvider>().endWorkout(DateTime.now()),
                context.read<WorkoutProvider>().selectLog(0),
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
                context.read<WorkoutProvider>().workoutStarted ? workoutRoutineNamesSet.isEmpty ? Icons.stop : Icons.save : Icons.timer,
            ),
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

              FloatingActionButton(onPressed: context.read<WorkoutProvider>().calculateRoutineStats),

              SizedBox(height: 12.h,),

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
                itemCount: routineNames.length,
                itemBuilder: (BuildContext context, int index) {
                  return WorkoutLineChart(
                    routineName: routineNames[index],
                  );
                },
              ),
        ]
      )
    ),
    ),
    );
  }
}
