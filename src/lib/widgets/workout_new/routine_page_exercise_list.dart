import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.routine.exercises.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: InkWell(
            onTap: () {
              if (context.read<WorkoutProvider>().checkForExerciseData(widget.routine.exercises[index].exerciseName)) {

                context.read<WorkoutProvider>().fetchExerciseData(widget.routine.exercises[index].exerciseName);

                context.read<PageChange>().changePageCache(WorkoutExercisePage(
                  exercise: context.read<WorkoutProvider>().exerciseList[
                  context.read<WorkoutProvider>().exerciseList.indexWhere((element) => element.exerciseName == widget.routine.exercises[index].exerciseName)
                  ],
                ));

              }
            },
            child: Column(
              children: [
                ListTile(
                  tileColor: appTertiaryColour,
                  leading: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: appSecondaryColour,
                    ),
                    width: 40.h,
                    height: 40.h,
                    child: Center(
                      child: Text(
                        widget.routine.exercises[index].exerciseName[0],
                        style: boldTextStyle,
                      ),
                    ),
                  ),
                  title: Text(
                    widget.routine.exercises[index].exerciseName,
                    style: boldTextStyle,
                  ),
                  subtitle: Text(
                    widget.routine.exercises[index].exerciseDate,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                    ),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert, color: Colors.white,
                      ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (context.read<WorkoutProvider>().checkForExerciseData(widget.routine.exercises[index].exerciseName)) {

                      context.read<WorkoutProvider>().fetchExerciseData(widget.routine.exercises[index].exerciseName);

                      context.read<PageChange>().changePageCache(WorkoutExercisePage(
                        exercise: context.read<WorkoutProvider>().exerciseList[
                        context.read<WorkoutProvider>().exerciseList.indexWhere((element) => element.exerciseName == widget.routine.exercises[index].exerciseName)
                        ],
                      ));

                    }
                  },
                  child: Ink(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Colors.white30,
                        )
                      ),
                      boxShadow: [
                        basicAppShadow
                      ],
                      color: appTertiaryColour,
                    ),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 24.h,
                      child: Center(
                        child: Text(
                          "Open",
                          style: boldTextStyle.copyWith(
                            color: appSecondaryColour,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        },
    );
  }
}
