import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_box.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_page_exercise_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TrainingPlanDayBox extends StatelessWidget {
  TrainingPlanDayBox({Key? key, required this.day, required this.routineIndex}) : super(key: key);
  String day;
  int routineIndex;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Container(
          color: appTertiaryColour,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              day,
              style: boldTextStyle.copyWith(fontSize: 18.h),
            ),
          ),
        ),

        RoutineBox(
          index: routineIndex,
        )

      ],
    );
  }
}
