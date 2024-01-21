import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../general/app_default_button.dart';


class WorkoutHomeLogBox extends StatefulWidget {
  WorkoutHomeLogBox({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<WorkoutHomeLogBox> createState() => _WorkoutHomeLogBoxState();
}

class _WorkoutHomeLogBoxState extends State<WorkoutHomeLogBox> {


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
        onTap: () {},
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
                    "",
                    style: boldTextStyle,
                  ),
                ),
              ),
              title: Text(
                context.read<WorkoutProvider>().workoutLogs[widget.index].routineNames.join(", "),
                style: boldTextStyle,
              ),
              subtitle: Text(
                DateFormat("dd/MM/yyyy").format(context.read<WorkoutProvider>().workoutLogs[widget.index].startOfWorkout).toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            InkWell(
              onTap: () {},
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
                          "Open Workout Log",
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
            ),
          ],
        ),
      ),
    );
  }
}
