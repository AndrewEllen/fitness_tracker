import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
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
    return Padding(
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
                          print("deleting");
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
    );
  }
}
