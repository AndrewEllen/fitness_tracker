import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_page_exercise_box.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_exercise_page.dart';
import '../../pages/workout_new/workout_routine_page.dart';

class RoutinePageExerciseList extends StatefulWidget {
  RoutinePageExerciseList({Key? key, required this.routine}) : super(key: key);
  RoutinesModel routine;

  @override
  State<RoutinePageExerciseList> createState() => _RoutinePageExerciseListState();
}

class _RoutinePageExerciseListState extends State<RoutinePageExerciseList> {

  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().routinesList;

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.routine.exercises.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {

            return RoutinePageExerciseBox(
              key: UniqueKey(),
              routine: widget.routine,
              index: index,
            );
            },
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.routine.exercises.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return RoutinePageExerciseBox(
              key: UniqueKey(),
              routine: widget.routine,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
