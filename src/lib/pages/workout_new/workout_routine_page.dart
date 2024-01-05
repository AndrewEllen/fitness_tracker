import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';

class WorkoutRoutinePage extends StatelessWidget {
  WorkoutRoutinePage({Key? key, required this.routine}) : super(key: key);
  RoutinesModel routine;

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
                    routine.routineName,
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
              RoutinePageExerciseList(
                routine: routine,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
