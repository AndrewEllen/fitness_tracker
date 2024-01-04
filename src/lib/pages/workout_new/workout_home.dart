import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/workout_daily_tracker.dart';
import '../../widgets/workout_new/workout_home_stats_dropdown.dart';

class WorkoutHomePageNew extends StatefulWidget {
  const WorkoutHomePageNew({Key? key}) : super(key: key);

  @override
  State<WorkoutHomePageNew> createState() => _WorkoutHomePageNewState();
}

class _WorkoutHomePageNewState extends State<WorkoutHomePageNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              WorkoutDailyTracker(),
              SizedBox(height: 14.h),
              workoutHomeStatsDropdown(),
              SizedBox(height: 14.h),
              HomePageRoutinesList(),
            ],
          ),
        ),
      ),
    );
  }
}
