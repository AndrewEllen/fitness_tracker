import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_box.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';

class RoutinesList extends StatefulWidget {
  RoutinesList({
    Key? key,
    required this.dayIndex,
    required this.trainingPlanWeek,
    required this.trainingPlanIndex,
  }) : super(key: key);

  final int dayIndex, trainingPlanWeek, trainingPlanIndex;


  @override
  State<RoutinesList> createState() => _RoutinesListState();
}

class _RoutinesListState extends State<RoutinesList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  newRoutine(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'routine_creation_pressed');
    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create a Routine",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Required";
                      }
                      if (context
                          .read<WorkoutProvider>()
                          .checkForRoutineData(value!)) {
                        print("EXISTS");
                        return "Routine Already Exists";
                      }
                      return null;
                    },
                    controller: inputController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Routine Name *",
                        style: boldTextStyle.copyWith(fontSize: 14),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appQuarternaryColour,
                          )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Create",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<WorkoutProvider>()
                              .createNewRoutine(inputController.text);
                          inputController.text = "";

                          Navigator.pop(context);
                        }
                      },
                    )),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.watch<WorkoutProvider>().routinesList.isNotEmpty ? Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: context.watch<WorkoutProvider>().routinesList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return RoutineBox(
              key: UniqueKey(),
              routineIndex: index,
              dayIndex: widget.dayIndex,
              trainingPlanIndex: widget.trainingPlanIndex,
              trainingPlanWeek: widget.trainingPlanWeek,
            );
            },
        ),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: appSecondaryColour,
                child: const Icon(
                    MdiIcons.playlistRemove
                ),
                onPressed: () {
                  context.read<WorkoutProvider>().removeRoutineFromTrainingPlanDay(
                      widget.dayIndex,
                      widget.trainingPlanWeek,
                      widget.trainingPlanIndex,
                  );
                  Navigator.pop(context);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                backgroundColor: appSecondaryColour,
                child: const Icon(
                    MdiIcons.playlistPlus
                ),
                onPressed: () {
                  newRoutine(context);
                },
              ),
            ),

          ],
        ),

      ],
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        Icon(
          MdiIcons.formatListBulleted,
          size: 90.h,
        ),
        Text(
          "No Routines Yet",
          style: boldTextStyle.copyWith(fontSize: 30.h),
        ),
        Text(
          "Try Creating One",
          style: boldTextStyle.copyWith(fontSize: 14.h),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: appSecondaryColour,
            child: const Icon(
                MdiIcons.playlistPlus
            ),
            onPressed: () {
              newRoutine(context);
            },
          ),
        ),
      ],
    );
  }
}
