import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class workoutHomeStatsDropdown extends StatelessWidget {
  const workoutHomeStatsDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTertiaryColour,
      width: double.maxFinite,
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.bar_chart),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Workout Statistics",
              style: boldTextStyle.copyWith(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.keyboard_arrow_down,color: Colors.white,),
          ),
        ],
      ),
    );
  }
}
