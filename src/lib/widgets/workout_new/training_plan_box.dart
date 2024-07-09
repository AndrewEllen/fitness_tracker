import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/training_plan_page.dart';
import '../../pages/workout_new/workout_exercise_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';


class TrainingPlanBox extends StatefulWidget {
  TrainingPlanBox({Key? key, required this.trainingPlan}) : super(key: key);
  TrainingPlan trainingPlan;

  @override
  State<TrainingPlanBox> createState() => _TrainingPlanBoxState();
}

class _TrainingPlanBoxState extends State<TrainingPlanBox> {


  late bool _expandPanel = false;


  onTap() async {

    context.read<PageChange>().changePageCache(
        TrainingPlanPage(trainingPlan: widget.trainingPlan)
    );

  }


  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.h),
        child: InkWell(
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
                      widget.trainingPlan.trainingPlanName[0],
                      style: boldTextStyle,
                    ),
                  ),
                ),
                title: Text(
                  widget.trainingPlan.trainingPlanName,
                  style: boldTextStyle,
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
                onTap: onTap,
                child: Ink(
                  decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(
                          color: Colors.black26,
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
                                title: const Text('Do you want to remove this Training Plan?'),
                                content: const Text("This action cannot be undone"),
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
                            //context.read<WorkoutProvider>().deleteExerciseFromRoutine(widget.index, widget.trainingPlan);
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
      ),
    );
  }
}
