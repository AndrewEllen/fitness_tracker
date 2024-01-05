import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';

class WorkoutExercisePage extends StatelessWidget {
  WorkoutExercisePage({Key? key, required this.exercise}) : super(key: key);
  ExerciseModel exercise;

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
              ListView.builder(
                shrinkWrap: true,
                itemCount: exercise.exerciseTrackingData.repValues.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    width: double.maxFinite,
                    height: 60.h,
                    color: appTertiaryColour,
                    child: Column(
                      children: [
                        Text(
                          exercise.exerciseTrackingData.weightValues[index].toString() + " Kg",
                          style: boldTextStyle,
                        ),
                        Text(
                          exercise.exerciseTrackingData.repValues[index].toString() + " Reps",
                          style: boldTextStyle,
                        ),
                        Text(
                          exercise.exerciseTrackingData.measurementDates[index],
                          style: boldTextStyle,
                        ),
                      ],
                    ),
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
