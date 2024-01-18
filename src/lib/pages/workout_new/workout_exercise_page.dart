import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_log_box.dart';

class WorkoutExercisePage extends StatefulWidget {
  WorkoutExercisePage({Key? key, required this.exercise}) : super(key: key);
  ExerciseModel exercise;

  @override
  State<WorkoutExercisePage> createState() => _WorkoutExercisePageState();
}

class _WorkoutExercisePageState extends State<WorkoutExercisePage> {
  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  final TextEditingController weightController = TextEditingController();

  final TextEditingController repsController = TextEditingController();

  @override
  void initState() {

    weightController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["weightValues"][0].toString().replaceAll(removeTrailingZeros, "") : "10";

    repsController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["repValues"][0].toString().replaceAll(removeTrailingZeros, "") : "6";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<WorkoutProvider>().exerciseList;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 14.h),
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 50.h,
                child: Center(
                  child: Text(
                    widget.exercise.exerciseName,
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 14.h),
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 225.h,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Log",
                        style: boldTextStyle.copyWith(fontSize: 18),
                      ),
                    ),
                    IncrementalCounter(
                      inputController: weightController,
                      suffix: "Kg",
                      label: "Weight *",
                      smallButtons: true,
                    ),
                    IncrementalCounter(
                      inputController: repsController,
                      suffix: "Reps",
                      label: "Reps *",
                      smallButtons: false,
                    ),
                    ElevatedButton(
                      onPressed: () {

                        if (weightController.text.isNotEmpty && repsController.text.isNotEmpty) {
                          Map newLog = {
                            "measurementDate": DateFormat("dd/MM/yyy").format(DateTime.now()).toString(),
                            "weightValues": <double>[

                              double.parse(weightController.text),

                            ],
                            "repValues": <double>[

                              double.parse(repsController.text),

                            ],
                            "measurementTimeStamp": <String>[

                              DateFormat("HH:mm").format(DateTime.now()).toString(),

                            ]
                          };

                          try {

                            if (
                            DateFormat("dd/MM/yyyy").parse(widget.exercise.exerciseTrackingData.dailyLogs[0]["measurementDate"])
                                == DateFormat("dd/MM/yyyy").parse(newLog["measurementDate"])
                            ) {

                              widget.exercise.exerciseTrackingData.dailyLogs[0]["weightValues"].insert(0, newLog["weightValues"][0]);
                              widget.exercise.exerciseTrackingData.dailyLogs[0]["repValues"].insert(0, newLog["repValues"][0]);
                              widget.exercise.exerciseTrackingData.dailyLogs[0]["measurementTimeStamp"].insert(0, newLog["measurementTimeStamp"][0]);

                            } else {

                              widget.exercise.exerciseTrackingData.dailyLogs.insert(0, newLog);

                            }

                            context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog);

                          } catch (e) {
                            debugPrint(e.toString());

                            try {
                              widget.exercise.exerciseTrackingData.dailyLogs.insert(0, newLog);

                              context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog);

                            } catch (e) {

                              debugPrint(e.toString());

                            }

                          }

                        }


                      },
                      child: const Text("Save Log"),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.exercise.exerciseTrackingData.dailyLogs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        width: double.maxFinite,
                        height: 60.h,
                        color: appTertiaryColour,
                        child: Center(
                          child: Text(
                            widget.exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"],
                            style: boldTextStyle.copyWith(fontSize: 18.h),
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.exercise.exerciseTrackingData.dailyLogs[index]["weightValues"].length,
                        itemBuilder: (BuildContext context, int index2) {
                          return WorkoutLogBox(exercise: widget.exercise, index: index, index2: index2, key: UniqueKey(),);
                        },
                      ),
                    ],
                  );
                },
              ),

              ElevatedButton(
                onPressed: () {

                  context.read<WorkoutProvider>().fetchMoreExerciseData(widget.exercise);

                },
                child: const Text("Load More"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
