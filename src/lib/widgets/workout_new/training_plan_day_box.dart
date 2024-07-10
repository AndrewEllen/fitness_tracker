import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_box.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_page_exercise_box.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_page_exercise_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../general/default_modal.dart';
import 'home_page_routines_list.dart';

class TrainingPlanDayBox extends StatelessWidget {
  TrainingPlanDayBox({
    Key? key,
    required this.day,
    required this.dayIndex,
    required this.trainingPlanWeek,
    required this.trainingPlanIndex,
  }) : super(key: key);
  String day;
  final dayIndex, trainingPlanWeek, trainingPlanIndex;


  RoutinesModel fetchTrainingPlanRoutine(int dayIndex, BuildContext context) {

    if (context.mounted) {

      debugPrint(dayIndex.toString());
      debugPrint(trainingPlanWeek.toString());
      debugPrint(trainingPlanIndex.toString());

      try {

        switch(dayIndex) {

          case 0:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .mondayRoutineID)];
          case 1:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .tuesdayRoutineID)];
          case 2:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .wednesdayRoutineID)];
          case 3:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .thursdayRoutineID)];
          case 4:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .fridayRoutineID)];
          case 5:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .saturdayRoutineID)];
          case 6:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == context.read<WorkoutProvider>()
                        .trainingPlanList[trainingPlanIndex]
                        .trainingPlanWeeks[trainingPlanWeek]
                        .sundayRoutineID)];

        }

      } catch (error) {
        debugPrint(error.toString());

      }

    }

    return RoutinesModel(
        routineID: "-1", routineDate: "", routineName: "Rest", exercises: []
    );
  }


  @override
  Widget build(BuildContext context) {
    context.watch<WorkoutProvider>().trainingPlanList;

    RoutinesModel selectedRoutine = fetchTrainingPlanRoutine(dayIndex, context);

    return Column(
      children: [

        selectedRoutine.routineID.isNotEmpty && selectedRoutine.routineID != "-1" ? Container(
          color: appTertiaryColour,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              selectedRoutine.routineName,
              style: boldTextStyle.copyWith(fontSize: 18.h),
            ),
          ),
        ) : const SizedBox.shrink(),

        Expanded(
          child: RoutinePageExerciseList(
            routine: selectedRoutine,
            dayIndex: dayIndex,
            trainingPlanWeek: trainingPlanWeek,
            trainingPlanIndex: trainingPlanIndex,
          ),
        ),

      ],
    );
  }
}
