import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../constants.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/workout_daily_tracker.dart';
import '../../widgets/workout_new/workout_home_stats_dropdown.dart';

class WorkoutHomePageNew extends StatefulWidget {
  WorkoutHomePageNew({Key? key}) : super(key: key);

  @override
  State<WorkoutHomePageNew> createState() => _WorkoutHomePageNewState();
}

class _WorkoutHomePageNewState extends State<WorkoutHomePageNew> {

  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(


        distance: 80.w,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
        ),


        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(
            Icons.menu,
          ),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: appSenaryColour,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 46.w,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return FloatingActionButton(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              heroTag: null,
              child: Icon(
                MdiIcons.closeCircle,
                color: Colors.red,
                size: 46.w,
              ),
              onPressed: onPressed,
            );
          },
        ),
        children: [
          SizedBox(
            width: 46.w,
            child: FloatingActionButton(
              tooltip: "Add Routine",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                Icons.add,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(
            width: 46.w,
            child: FloatingActionButton(
              tooltip: "View Exercise List",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                Icons.list,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Column(
          children: [
            SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}
