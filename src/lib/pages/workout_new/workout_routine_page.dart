import 'package:avatar_glow/avatar_glow.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_logs_home.dart';
import 'package:fitness_tracker/providers/general/page_change_provider.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import 'exercise_database_search.dart';
import 'exercise_selection_page.dart';

class WorkoutRoutinePage extends StatefulWidget {
  WorkoutRoutinePage({Key? key, required this.routine}) : super(key: key);
  RoutinesModel routine;

  @override
  State<WorkoutRoutinePage> createState() => _WorkoutRoutinePageState();
}

class _WorkoutRoutinePageState extends State<WorkoutRoutinePage> {
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: Text(
          widget.routine.routineName,
          style: boldTextStyle,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(


        key: _key,
        distance: 80.w,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
        ),


        openButtonBuilder: FloatingActionButtonBuilder(
          size: 16.w,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return AvatarGlow(
              glowCount: context.watch<WorkoutProvider>().workoutStarted ? 3 : 0,
              glowColor: Colors.red,
              glowRadiusFactor: 0.3,
              child: Material(
                color: appSenaryColour,
                elevation: 8.0,
                shape: const CircleBorder(),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
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
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 14.0.w),
                child: SizedBox(
                  width: 48.w,
                  child: FloatingActionButton(
                      tooltip: "Search New Exercises",
                      backgroundColor: appSecondaryColour,
                      heroTag: null,
                      child: const Icon(
                        Icons.search,
                      ),
                      onPressed: () {
                        final menuState = _key.currentState;
                        if (menuState != null) {
                          menuState.toggle();
                        }
                        context.read<PageChange>().changePageCache(ExerciseDatabaseSearch());
                      }
                  ),
                ),
              ),
              SizedBox(
                width: 48.w,
                child: FloatingActionButton(
                  tooltip: "Add Exercise",
                  backgroundColor: appSecondaryColour,
                  heroTag: null,
                  child: const Icon(
                    Icons.add,
                  ),
                  onPressed: () {
                    final menuState = _key.currentState;
                    if (menuState != null) {
                      menuState.toggle();
                    }
                    context.read<PageChange>().changePageCache(ExerciseSelectionPage(routine: widget.routine));
                  }
                ),
              ),
            ],
          ),
          SizedBox(
            width: 48.w,
            child: FloatingActionButton(
              tooltip: "View Past Workouts",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                MdiIcons.clipboardClock,
              ),
              onPressed: () {
                final menuState = _key.currentState;
                if (menuState != null) {
                  menuState.toggle();
                }
                context
                    .read<PageChange>()
                    .changePageCache(WorkoutLogsHome());
              },
            ),
          ),
          SizedBox(
            width: 48.w,
            child: FloatingActionButton(
              tooltip: "View Current Workout",
              backgroundColor: context.watch<WorkoutProvider>().workoutStarted
                  ? appSenaryColour
                  : appSecondaryColour,
              heroTag: null,
              child: AvatarGlow(
                glowCount:
                context.watch<WorkoutProvider>().workoutStarted ? 3 : 0,
                glowColor: Colors.red,
                glowRadiusFactor: 0.7,
                child: const Material(
                  type: MaterialType.transparency,
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: Icon(
                    Icons.access_time_outlined,
                  ),
                ),
              ),
              onPressed: () {
                final menuState = _key.currentState;
                if (menuState != null) {
                  menuState.toggle();
                }
                context.read<PageChange>().changePageCache(WorkoutLogPage());
              },
            ),
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: const SizedBox.shrink()
      ),
    );
  }
}
