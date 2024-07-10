import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';


class RoutineBox extends StatefulWidget {
  RoutineBox({Key? key,
    required this.routineIndex,
    required this.dayIndex,
    required this.trainingPlanWeek,
    required this.trainingPlanIndex,
  }) : super(key: key);
  final int routineIndex, dayIndex, trainingPlanWeek, trainingPlanIndex;

  @override
  State<RoutineBox> createState() => _RoutineBoxState();
}

class _RoutineBoxState extends State<RoutineBox> {

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



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: InkWell(
        onTap: () {
          context.read<WorkoutProvider>().addRoutineToTrainingPlanDay(
              context.read<WorkoutProvider>().routinesList[widget.routineIndex].routineID,
              widget.dayIndex,
              widget.trainingPlanWeek,
              widget.trainingPlanIndex
          );
          Navigator.pop(context);
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
                    widget.routineIndex != -1 ? context.read<WorkoutProvider>().routinesList[widget.routineIndex].routineName[0] : "Zzz",
                    style: boldTextStyle,
                  ),
                ),
              ),
              title: Text(
                widget.routineIndex != -1 ? context.read<WorkoutProvider>().routinesList[widget.routineIndex].routineName : "Rest Day",
                style: boldTextStyle,
              ),
              subtitle: widget.routineIndex != -1 ? Text(
                daysPassedCalculator(context.read<WorkoutProvider>().routinesList[widget.routineIndex].routineDate),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ) : null,
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
            widget.routineIndex != -1 ? InkWell(
              onTap: () {
                context.read<WorkoutProvider>().addRoutineToTrainingPlanDay(
                    context.read<WorkoutProvider>().routinesList[widget.routineIndex].routineID,
                    widget.dayIndex,
                    widget.trainingPlanWeek,
                    widget.trainingPlanIndex
                );
                Navigator.pop(context);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Select Routine",
                          style: boldTextStyle.copyWith(
                            color: appSecondaryColour,
                          ),
                        ),
                        const Icon(
                            Icons.keyboard_arrow_down_outlined
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ) : const SizedBox.shrink(),
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
                        if (_delete && widget.routineIndex != -1) {
                          print("deleting");
                          context.read<WorkoutProvider>().deleteRoutine(widget.routineIndex);
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
    );
  }
}
