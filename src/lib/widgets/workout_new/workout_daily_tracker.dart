import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import 'daily_tracker_circle.dart';

class WorkoutDailyTracker extends StatefulWidget {
  const WorkoutDailyTracker({Key? key}) : super(key: key);

  @override
  State<WorkoutDailyTracker> createState() => _WorkoutDailyTrackerState();
}

class _WorkoutDailyTrackerState extends State<WorkoutDailyTracker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: appTertiaryColour,
      width: double.maxFinite,
      height: 130.h,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Workout Tracking",
              style: boldTextStyle.copyWith(fontSize: 18),
            ),
          ),
          const Spacer(),
          Text("Last 7 days", style: boldTextStyle,),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WorkoutTrackerCircle(size: 40.w, text: "Mo", workoutComplete: false,),
              WorkoutTrackerCircle(size: 40.w, text: "Tu", workoutComplete: false,),
              WorkoutTrackerCircle(size: 40.w, text: "We", workoutComplete: false,),
              WorkoutTrackerCircle(size: 40.w, text: "Th", workoutComplete: false,),
              WorkoutTrackerCircle(size: 40.w, text: "Fr", workoutComplete: true,),
              WorkoutTrackerCircle(size: 40.w, text: "Sa", workoutComplete: false,),
              WorkoutTrackerCircle(size: 40.w, text: "Su", workoutComplete: false,),
            ],
          ),
          const Spacer(flex: 6),
        ],
      ),
    );
  }
}
