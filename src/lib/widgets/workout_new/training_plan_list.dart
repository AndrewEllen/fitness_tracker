import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_page_exercise_box.dart';
import 'package:fitness_tracker/widgets/workout_new/training_plan_box.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_exercise_page.dart';
import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/general/database_write.dart';

class TrainingPlanList extends StatefulWidget {
  TrainingPlanList({Key? key, required this.trainingPlans}) : super(key: key);
  List<TrainingPlan> trainingPlans;

  @override
  State<TrainingPlanList> createState() => _TrainingPlanListState();
}

class _TrainingPlanListState extends State<TrainingPlanList> {

  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().trainingPlanList;

    //final filteredMain = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 1)
    //    .toList();

    //final filteredAccessories = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 0)
    //    .toList();

    return ReorderableListView.builder(
      itemCount: widget.trainingPlans.length,
      shrinkWrap: true,
      proxyDecorator: (child, index, d) {

        return Material(
          color: Colors.transparent,
          child: TrainingPlanBox(
            key: Key(widget.trainingPlans[index].trainingPlanName),
            trainingPlan: widget.trainingPlans[index],
            index: index,
          ),
        );

      },

      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = widget.trainingPlans.removeAt(oldIndex);
          widget.trainingPlans.insert(newIndex, item);
          //updateRoutineOrder(widget.trainingPlans);
        });
        context.read<WorkoutProvider>().updateTrainingPlanListOrder(widget.trainingPlans);
      },
      itemBuilder: (BuildContext context, int index) {

        return TrainingPlanBox(
          key: Key(widget.trainingPlans[index].trainingPlanName),
          trainingPlan: widget.trainingPlans[index],
          index: index,
        );
      },
    );
  }
}
