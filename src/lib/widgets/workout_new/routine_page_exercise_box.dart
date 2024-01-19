import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/workout_exercise_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';


class RoutinePageExerciseBox extends StatefulWidget {
  RoutinePageExerciseBox({Key? key, required this.routine, required this.index}) : super(key: key);
  RoutinesModel routine;
  int index;

  @override
  State<RoutinePageExerciseBox> createState() => _RoutinePageExerciseBoxState();
}

class _RoutinePageExerciseBoxState extends State<RoutinePageExerciseBox> {

  late bool _expandPanel = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () {
          if (context.read<WorkoutProvider>().checkForExerciseData(widget.routine.exercises[widget.index].exerciseName)) {

            context.read<WorkoutProvider>().fetchExerciseData(widget.routine.exercises[widget.index].exerciseName);

            context.read<PageChange>().changePageCache(WorkoutExercisePage(
              exercise: context.read<WorkoutProvider>().exerciseList[
              context.read<WorkoutProvider>().exerciseList.indexWhere((element) => element.exerciseName == widget.routine.exercises[widget.index].exerciseName)
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
                    widget.routine.exercises[widget.index].exerciseName[0],
                    style: boldTextStyle,
                  ),
                ),
              ),
              title: Text(
                widget.routine.exercises[widget.index].exerciseName,
                style: boldTextStyle,
              ),
              subtitle: Text(
                widget.routine.exercises[widget.index].exerciseDate,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expandPanel = !_expandPanel;
                  });
                },
                icon: const Icon(
                  Icons.more_vert, color: Colors.white,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                if (context.read<WorkoutProvider>().checkForExerciseData(widget.routine.exercises[widget.index].exerciseName)) {

                  context.read<WorkoutProvider>().fetchExerciseData(widget.routine.exercises[widget.index].exerciseName);

                  context.read<PageChange>().changePageCache(WorkoutExercisePage(
                    exercise: context.read<WorkoutProvider>().exerciseList[
                    context.read<WorkoutProvider>().exerciseList.indexWhere((element) => element.exerciseName == widget.routine.exercises[widget.index].exerciseName)
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
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: _expandPanel ? 40 : 0),
              duration: const Duration(milliseconds: 250),
              builder: (context, value, _) => ClipRRect(
                child: Material(
                  type: MaterialType.transparency,
                  child: Ink(
                    height: value.h,
                    color: Colors.red,
                    child: InkWell(
                      onTap: () => context.read<WorkoutProvider>().deleteExerciseFromRoutine(widget.index, widget.routine),
                      child: const Center(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
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
  }
}
