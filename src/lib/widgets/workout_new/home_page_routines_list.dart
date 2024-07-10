import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_box.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/workout/workoutProvider.dart';

class RoutinesList extends StatefulWidget {
  RoutinesList({
    Key? key,
    required this.dayIndex,
    required this.trainingPlanWeek,
    required this.trainingPlanIndex,
  }) : super(key: key);

  final int dayIndex, trainingPlanWeek, trainingPlanIndex;


  @override
  State<RoutinesList> createState() => _RoutinesListState();
}

class _RoutinesListState extends State<RoutinesList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: context.watch<WorkoutProvider>().routinesList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return RoutineBox(
          key: UniqueKey(),
          routineIndex: index,
          dayIndex: widget.dayIndex,
          trainingPlanIndex: widget.trainingPlanIndex,
          trainingPlanWeek: widget.trainingPlanWeek,
        );
        },
    );
  }
}
