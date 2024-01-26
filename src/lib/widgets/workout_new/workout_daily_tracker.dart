import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
              WorkoutTrackerCircle(size: 40.w, text: "Monday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Tuesday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Wednesday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Thursday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Friday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Saturday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
              WorkoutTrackerCircle(size: 40.w, text: "Sunday", workoutComplete: context.read<WorkoutProvider>().weekDayExerciseTracker,),
            ],
          ),
          const Spacer(flex: 6),
        ],
      ),
    );
  }
}
