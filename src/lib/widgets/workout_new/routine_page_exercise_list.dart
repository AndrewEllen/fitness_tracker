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
  RoutinePageExerciseList({Key? key, required this.routine, required this.dragList}) : super(key: key);
  RoutinesModel routine;
  bool dragList;

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

    return Column(
      children: [

        ReorderableListView.builder(
          buildDefaultDragHandles: widget.dragList,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.routine.exercises.length,
          shrinkWrap: true,
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
              dragList: widget.dragList,
              key: UniqueKey(),
              routine: widget.routine,
              index: index,
            );
          },
        ),

        /*filteredMain.isNotEmpty ? Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
                  color: Colors.black26,
                )
            ),
            boxShadow: [
              basicAppShadow
            ],
            color: appTertiaryColour,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "- Main Exercises",
              style: boldTextStyle.copyWith(
                fontSize: 18,
              ),
            ),
          ),
        ) : const SizedBox.shrink(),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.routine.exercises.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {

            return widget.routine.exercises[index].mainOrAccessory == 1 ? RoutinePageExerciseBox(
              key: UniqueKey(),
              routine: widget.routine,
              index: index,
            ) : const SizedBox.shrink();
            },
        ),

        filteredAccessories.isNotEmpty ? Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            width: double.maxFinite,
            decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                    color: Colors.black26,
                  )
              ),
              boxShadow: [
                basicAppShadow
              ],
              color: appTertiaryColour,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                " -Accessory Exercises",
                style: boldTextStyle.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ) : const SizedBox.shrink(),

        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.routine.exercises.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return widget.routine.exercises[index].mainOrAccessory == 0 ? RoutinePageExerciseBox(
              key: UniqueKey(),
              routine: widget.routine,
              index: index,
            ) : const SizedBox.shrink();
          },
        ),*/
      ],
    );
  }
}
