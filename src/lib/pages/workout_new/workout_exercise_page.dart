import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';

class WorkoutExercisePage extends StatelessWidget {
  WorkoutExercisePage({Key? key, required this.exercise}) : super(key: key);
  ExerciseModel exercise;

  final TextEditingController weightController =
      TextEditingController(text: "10");
  final TextEditingController repsController = TextEditingController(text: "6");

  @override
  Widget build(BuildContext context) {
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
                    exercise.exerciseName,
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 14.h),
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 225.h,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Log",
                        style: boldTextStyle.copyWith(fontSize: 18),
                      ),
                    ),
                    IncrementalCounter(
                      inputController: weightController,
                      suffix: "Kg",
                      label: "Weight *",
                      smallButtons: true,
                    ),
                    IncrementalCounter(
                      inputController: repsController,
                      suffix: "Reps",
                      label: "Reps *",
                      smallButtons: false,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Save Log"),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: exercise.exerciseTrackingData.dailyLogs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        width: double.maxFinite,
                        height: 60.h,
                        color: appTertiaryColour,
                        child: Center(
                          child: Text(
                            exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"],
                            style: boldTextStyle,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: exercise.exerciseTrackingData.dailyLogs[index]["weightValues"].length,
                        itemBuilder: (BuildContext context, int index2) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            width: double.maxFinite,
                            height: 60.h,
                            color: appTertiaryColour,
                            child: Column(
                              children: [
                                Text(
                                  exercise.exerciseTrackingData
                                          .dailyLogs[index]["weightValues"][index2]
                                          .toString() +
                                      " Kg",
                                  style: boldTextStyle,
                                ),
                                Text(
                                  exercise.exerciseTrackingData
                                          .dailyLogs[index]["repValues"][index2]
                                          .toString() +
                                      " Reps",
                                  style: boldTextStyle,
                                ),
                                Text(
                                  exercise.exerciseTrackingData.dailyLogs[index]
                                      ["measurementTimeStamp"][index2],
                                  style: boldTextStyle,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
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
