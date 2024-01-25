import 'package:avatar_glow/avatar_glow.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_log_box.dart';

class WorkoutExercisePage extends StatefulWidget {
  WorkoutExercisePage({Key? key, required this.exercise, required this.routine}) : super(key: key);
  ExerciseModel exercise;
  RoutinesModel routine;

  @override
  State<WorkoutExercisePage> createState() => _WorkoutExercisePageState();
}

class _WorkoutExercisePageState extends State<WorkoutExercisePage> {
  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  final TextEditingController weightController = TextEditingController();

  final TextEditingController repsController = TextEditingController();


  @override
  void initState() {

    weightController.addListener(_addressControllerListener);

    weightController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["weightValues"][0].toString().replaceAll(removeTrailingZeros, "") : "10";

    repsController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["repValues"][0].toString().replaceAll(removeTrailingZeros, "") : "6";

    super.initState();
  }

  void _addressControllerListener() {
    setState(() {
    });
  }

  @override
  void dispose() {
    weightController.removeListener(_addressControllerListener);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().exerciseList;
    return Scaffold(
      appBar: AppBar(
        actions: [
          context.read<WorkoutProvider>().workoutStarted ? Padding(
            padding: EdgeInsets.only(top:8.h, bottom: 8.h),
            child: FloatingActionButton(
              tooltip: "View Current Workout",
                backgroundColor: appSenaryColour,
                heroTag: null,
                child: AvatarGlow(
                  glowCount: 3,
                  glowColor: Colors.red,
                  glowRadiusFactor: 0.7,
                  child: const Material(
                    type: MaterialType.transparency,
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.access_time,
                    ),
                  ),
                ),
                onPressed: () {
                context.read<PageChange>().changePageCache(WorkoutLogPage());
        },
      ),
          ) : const SizedBox.shrink(),
        ],
        backgroundColor: appTertiaryColour,
        title: Text(
          widget.exercise.exerciseName.capitalize() + " - " + widget.routine.routineName.capitalize(),
          style: boldTextStyle.copyWith(fontSize: 18),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 14.h),
              color: appTertiaryColour,
              width: double.maxFinite,
              height: 320.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top:24.h),
                      child: Text(
                        "Create Exercise Log",
                        style: boldTextStyle.copyWith(fontSize: 18),
                      ),
                    ),
                  ),
                  Spacer(),
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
                  Spacer(),
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0.h, right: 20.w),
                          child: ElevatedButton(
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

                                  context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog, widget.routine);
                                  context.read<WorkoutProvider>().updateMaxWeightAtRep(repsController.text, weightController.text, widget.exercise.exerciseName);

                                } catch (e) {
                                  debugPrint(e.toString());

                                  try {
                                    widget.exercise.exerciseTrackingData.dailyLogs.insert(0, newLog);

                                    context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog, widget.routine);
                                    context.read<WorkoutProvider>().updateMaxWeightAtRep(repsController.text, weightController.text, widget.exercise.exerciseName);

                                  } catch (e) {

                                    debugPrint(e.toString());

                                  }

                                }

                              }


                            },
                            child: const Text("Save Log"),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0.h, left: 20.w, top: 8.h),
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 2,
                              bottom: 2,
                              left: 6,
                              right: 8,
                            ),
                            decoration: const BoxDecoration(
                              color: appQuinaryColour,
                              borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.star,
                                      color: context.read<WorkoutProvider>().exerciseMaxRepAndWeight.containsKey(double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")) ? appSenaryColour : appQuarternaryColour,
                                    ),
                                  ),
                                  TextSpan(
                                    text: context.read<WorkoutProvider>().exerciseMaxRepAndWeight.containsKey(double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, ""))
                                        ? " Highest reps for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Kg: " + context.read<WorkoutProvider>().exerciseMaxRepAndWeight[double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")].toString()
                                        : double.tryParse(weightController.text) == null ? " No Weight Value" : " No Data for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Kg",
                                    style: boldTextStyle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}
