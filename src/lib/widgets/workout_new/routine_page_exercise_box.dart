import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/widgets/general/incremental_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/workout_exercise_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';


class RoutinePageExerciseBox extends StatefulWidget {
  RoutinePageExerciseBox({Key? key, required this.routine, required this.index}) : super(key: key);
  RoutinesModel routine;
  int index;

  @override
  State<RoutinePageExerciseBox> createState() => _RoutinePageExerciseBoxState();
}

class _RoutinePageExerciseBoxState extends State<RoutinePageExerciseBox> {


  late bool _expandPanel = false;

  String daysPassedCalculator(String oldDate) {

    if (oldDate.isEmpty) {
      return "";
    }

    DateTime oldDateFormatted = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateFormat("dd/MM/yyyy")
        .parse(oldDate)));

    DateTime newUnformatted = DateTime.now();

    DateTime newDateFormatted = DateTime(newUnformatted.year, newUnformatted.month, newUnformatted.day);

    String daysPassed = (newDateFormatted.difference(oldDateFormatted).inHours / 24).round().toString();

    if (daysPassed == "0") {
      return "Today";
    }

    return "-$daysPassed days ago ($oldDate)";

  }


  newSetMenu(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'new_set_pressed');

    double repsSliderStart = 6;
    double repsSliderEnd = 8;
    double setsSlider = 4;
    TextEditingController repsControllerStart = TextEditingController(text: "6");
    TextEditingController repsControllerEnd = TextEditingController(text: "8");
    TextEditingController setsController = TextEditingController(text: "4");

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,

            content: SizedBox(
              height: 400.h,
              width: double.maxFinite,
              child: Material(

                type: MaterialType.transparency,

                child: Column(

                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add new set plan",
                        style: boldTextStyle.copyWith(fontSize: 20.h),
                      ),
                    ),

                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          children: [

                            IncrementalCounter(
                              inputController: setsController,
                              suffix: "",
                              label: "Sets",
                              smallButtons: false,
                              function: () {
                                setState(() {

                                  if (double.parse(setsController.text) == 0) {
                                    setsController.text = "1";
                                  }

                                  if (double.parse(setsController.text) >= 1
                                      && double.parse(setsController.text) <= 6)
                                  {
                                    setsSlider = double.parse(setsController.text);
                                  }
                                  double.parse(setsController.text);
                                });
                              },
                            ),

                            Slider(
                              value: setsSlider,
                              onChanged: (double value) {
                                setState(() {
                                  setsSlider = value;
                                  setsController.text = value.toStringAsFixed(0);
                                });
                              },
                              min: 1,
                              max: 6,
                              divisions: 5,
                              label: ((double.parse(setsController.text)*2).floorToDouble()/2).toStringAsFixed(0) + " Sets",
                              activeColor: appSecondaryColour,
                              inactiveColor: appSecondaryColourDark,
                            ),
                          ],
                        );
                      }
                    ),


                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [

                              IncrementalCounter(
                                inputController: repsControllerStart,
                                suffix: "",
                                label: "Reps",
                                smallButtons: false,
                                function: () {
                                  setState(() {

                                    if (double.parse(repsControllerStart.text) == 0) {
                                      repsControllerStart.text = "1";
                                    }

                                    if (double.parse(repsControllerStart.text) > double.parse(repsControllerEnd.text)) {
                                      repsControllerStart.text =  repsControllerEnd.text;
                                    }

                                    if (double.parse(repsControllerStart.text) >= 1
                                        && double.parse(repsControllerStart.text) <= 14
                                        && double.parse(repsControllerStart.text) <= double.parse(repsControllerEnd.text)
                                    )
                                    {
                                      repsSliderStart = double.parse(repsControllerStart.text);
                                    }
                                    double.parse(repsControllerStart.text);
                                  });
                                },
                              ),
                              IncrementalCounter(
                                inputController: repsControllerEnd,
                                suffix: "",
                                label: "Reps",
                                smallButtons: false,
                                function: () {
                                  setState(() {

                                    if (double.parse(repsControllerEnd.text) == 0) {
                                      repsControllerEnd.text = "1";
                                    }

                                    if (double.parse(repsControllerEnd.text) < double.parse(repsControllerStart.text)) {
                                      repsControllerEnd.text =  repsControllerStart.text;
                                    }

                                    if (double.parse(repsControllerEnd.text) >= 1
                                        && double.parse(repsControllerEnd.text) <= 14
                                        && double.parse(repsControllerEnd.text) >= double.parse(repsControllerStart.text)
                                    )
                                    {
                                      repsSliderEnd = double.parse(repsControllerEnd.text);
                                    }
                                    double.parse(repsControllerEnd.text);
                                  });
                                },
                              ),

                              RangeSlider(
                                values: RangeValues(
                                  repsSliderStart,
                                  repsSliderEnd,
                                ),
                                onChanged: (RangeValues values) {
                                  setState(() {
                                    repsSliderStart = values.start;
                                    repsSliderEnd = values.end;
                                    repsControllerStart.text = values.start.toStringAsFixed(0);
                                    repsControllerEnd.text = values.end.toStringAsFixed(0);
                                  });
                                },
                                min: 1,
                                max: 14,
                                divisions: 13,
                                labels: RangeLabels(
                                    ((double.parse(repsControllerStart.text)*2).floorToDouble()/2).toStringAsFixed(0) + " Reps",
                                    ((double.parse(repsControllerEnd.text)*2).floorToDouble()/2).toStringAsFixed(0) + " Reps"
                                ),
                                activeColor: appSecondaryColour,
                                inactiveColor: appSecondaryColourDark,
                              ),
                            ],
                          );
                        }
                    ),


                  ],

                ),

              ),
            ),

            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Spacer(),

                  FloatingActionButton(
                    backgroundColor: appSecondaryColour,
                    child: const Icon(
                        MdiIcons.close
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(),

                  FloatingActionButton(
                    backgroundColor: appSecondaryColour,
                    child: const Icon(
                        MdiIcons.check
                    ),
                    onPressed: () {

                      context.read<WorkoutProvider>().addSetsPlanToRoutine(
                        setsController.text,
                        repsControllerStart.text,
                        repsControllerEnd.text,
                        widget.routine.exercises[widget.index].exerciseName,
                        widget.routine
                      );

                    },
                  ),

                  const Spacer(),

                ],
              ),
            ],
          ),
        );
      },
    );
  }


  onTap() async {
    if (context.read<WorkoutProvider>().checkForExerciseData(widget.routine.exercises[widget.index].exerciseName)) {

      try {

        bool result = await InternetConnection().hasInternetAccess;
        GetOptions options = const GetOptions(source: Source.serverAndCache);

        if (!result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("No Internet Connection \nAttempting to load"),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.6695,
                right: 20,
                left: 20,
              ),
              dismissDirection: DismissDirection.none,
              duration: const Duration(milliseconds: 700),
            ),
          );
          options = const GetOptions(source: Source.cache);
        }

        await context.read<WorkoutProvider>().fetchExerciseData(widget.routine.exercises[widget.index].exerciseName, options);

        context.read<PageChange>().changePageCache(WorkoutExercisePage(
          routine: widget.routine,
          exercise: context.read<WorkoutProvider>().exerciseList[
          context.read<WorkoutProvider>().exerciseList.indexWhere((element) => element.exerciseName == widget.routine.exercises[widget.index].exerciseName)
          ],
        ));
      } catch (error) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Couldn't load data"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.6695,
              right: 20,
              left: 20,
            ),
            dismissDirection: DismissDirection.none,
            duration: const Duration(milliseconds: 700),
          ),
        );

      }

    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 40,
      shadowColor: Colors.black,
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
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
                      daysPassedCalculator(widget.routine.exercises[widget.index].exerciseDate),
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
                            onTap: () async {
                              bool _delete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: appTertiaryColour,
                                    titleTextStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                    ),
                                    contentTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                    title: const Text('Do you want to remove this Exercise?'),
                                    content: const Text("It can be added again later"),
                                    actions: <Widget>[
                                      AppButton(
                                        onTap: () => Navigator.of(context).pop(false),
                                        buttonText: "No",
                                      ),
                                      AppButton(
                                        onTap: () => Navigator.of(context).pop(true),
                                        buttonText: "Yes",
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (_delete) {
                                context.read<WorkoutProvider>().deleteExerciseFromRoutine(widget.index, widget.routine);
                              }
                            },
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
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  color: appTertiaryColour,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sets And Reps Plan",
                      style: boldTextStyle,
                    ),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  color: appTertiaryColour,
                  child: ListView.builder(

                    shrinkWrap: true,
                    itemCount: widget.routine.exerciseSetsAndRepsPlan?.length ?? 1,

                    itemBuilder: (BuildContext context, int index) {

                      return widget.routine.exerciseSetsAndRepsPlan != null ?

                      Container(

                      )
                      :
                      Container(

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "No Sets Yet",
                                style: boldTextStyle.copyWith(fontSize: 16.h),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12.0,
                                bottom: 12.0,
                                right: 24.0,
                                left: 12.0,
                              ),
                              child: SizedBox(
                                width: 30.h,
                                child: FloatingActionButton(
                                  backgroundColor: appSecondaryColour,
                                  child: Icon(
                                    Icons.add,
                                    size: 20.h,
                                  ),
                                  onPressed: () => newSetMenu(context),
                                ),
                              ),
                            ),
                          ],
                        ),

                      );

                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
