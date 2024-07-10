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
import '../general/default_modal.dart';
import 'home_page_routines_list.dart';

class RoutinePageExerciseList extends StatefulWidget {
  RoutinePageExerciseList({Key? key,
    required this.routine,
    required this.dayIndex,
    required this.trainingPlanWeek,
    required this.trainingPlanIndex,
  }) : super(key: key);
  RoutinesModel routine;
  final dayIndex, trainingPlanWeek, trainingPlanIndex;


  @override
  State<RoutinePageExerciseList> createState() => _RoutinePageExerciseListState();
}

class _RoutinePageExerciseListState extends State<RoutinePageExerciseList> {

  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().trainingPlanList;

    //final filteredMain = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 1)
    //    .toList();

    //final filteredAccessories = widget.routine.exercises
    //    .where((exercise) => exercise.mainOrAccessory == 0)
    //    .toList();

    return widget.routine.routineID != "-1" && widget.routine.routineID != "" && widget.routine.routineID.isNotEmpty ?
    ReorderableListView.builder(
      itemCount: widget.routine.exercises.length,
      shrinkWrap: true,
      proxyDecorator: (child, index, d) {

        return Material(
          color: appTertiaryColour,
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
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          MdiIcons.sleep,
          size: 90.h,
        ),
        Text(
          "Rest Day",
          style: boldTextStyle.copyWith(fontSize: 40.h),
        ),
        Text(
          "Take the day off, relax a little",
          style: boldTextStyle.copyWith(fontSize: 14.h),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: appSecondaryColour,
            child: const Icon(
                Icons.add
            ),
            onPressed: () {
              if (context.mounted) {
                ModalBottomSheet.showModal(
                  context,
                  SingleChildScrollView(
                    child: RoutinesList(
                      dayIndex: widget.dayIndex,
                      trainingPlanWeek: widget.trainingPlanWeek,
                      trainingPlanIndex: widget.trainingPlanIndex,
                    ),
                  ),
                );
              }
            },
          ),
        ),

      ],
    );
  }
}
