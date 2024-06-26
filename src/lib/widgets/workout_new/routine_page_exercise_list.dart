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
import '../../providers/general/database_write.dart';

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

    //final filteredMain = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 1)
    //    .toList();

    //final filteredAccessories = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 0)
    //    .toList();

    return ReorderableListView.builder(
      itemCount: widget.routine.exercises.length,
      shrinkWrap: true,
      proxyDecorator: (child, index, d) {

        return Material(
          color: Colors.transparent,
          child: RoutinePageExerciseBox(
            key: Key(widget.routine.exercises[index].exerciseName),
            routine: widget.routine,
            index: index,
          ),
        );

      },

      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.routine.exercises.removeAt(oldIndex);
          widget.routine.exercises.insert(newIndex, item);
          updateRoutineOrder(widget.routine);
        });
      },
      itemBuilder: (BuildContext context, int index) {

        return RoutinePageExerciseBox(
          key: Key(widget.routine.exercises[index].exerciseName),
          routine: widget.routine,
          index: index,
        );
      },
    );
  }
}
