import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/providers/general/page_change_provider.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import 'exercise_selection_page.dart';

class WorkoutRoutinePage extends StatelessWidget {
  WorkoutRoutinePage({Key? key, required this.routine}) : super(key: key);
  RoutinesModel routine;

  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(


        key: _key,
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
                context.read<PageChange>().changePageCache(ExerciseSelectionPage(routine: routine));
              }
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 14.h),
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 50.h,
                child: Center(
                  child: Text(
                    routine.routineName,
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),
              RoutinePageExerciseList(
                routine: routine,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
