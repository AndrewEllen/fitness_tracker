import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_share.dart';
import 'package:fitness_tracker/models/workout/training_plan_week_share_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_logs_home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/workout/routines_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/default_modal.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/training_plan_day_box.dart';
import 'exercise_database_search.dart';
import 'exercise_selection_page.dart';

class TrainingPlanPage extends StatefulWidget {
  TrainingPlanPage({Key? key, required this.trainingPlan}) : super(key: key);
  TrainingPlan trainingPlan;

  @override
  State<TrainingPlanPage> createState() => _TrainingPlanPageState();
}

class _TrainingPlanPageState extends State<TrainingPlanPage> {
  late GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();

  int trainingPlanDayOfTheWeekIndex = DateTime.now().weekday-1;

  RoutinesModel fetchTrainingPlanRoutine(int dayIndex, int trainingPlanWeekIndex, BuildContext context) {

    if (context.mounted) {

      debugPrint(dayIndex.toString());
      try {

        switch(dayIndex) {

          case 0:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                            .mondayRoutineID)];
          case 1:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .tuesdayRoutineID)];
          case 2:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .wednesdayRoutineID)];
          case 3:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .thursdayRoutineID)];
          case 4:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .fridayRoutineID)];
          case 5:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .saturdayRoutineID)];
          case 6:
            return context.read<WorkoutProvider>().routinesList[
            context.read<WorkoutProvider>().routinesList.indexWhere(
                    (value) => value.routineID
                    == widget.trainingPlan.trainingPlanWeeks[trainingPlanWeekIndex]
                        .sundayRoutineID)];

        }

      } catch (error) {
        debugPrint(error.toString());

      }

    }

    return RoutinesModel(
        routineID: "-1", routineDate: "", routineName: "Rest", exercises: []
    );
  }


  @override
  Widget build(BuildContext context) {
    //_key = GlobalKey<ExpandableFabState>();

    ///Currently focusing on one week only training plans. Index is here for future support
    int trainingPlanWeekIndex = 0;

    return DefaultTabController(
      length: 7,
      initialIndex: trainingPlanDayOfTheWeekIndex,
      child: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Scaffold(
          floatingActionButton: fetchTrainingPlanRoutine(
              trainingPlanDayOfTheWeekIndex,
              trainingPlanWeekIndex,
              context
          ).routineID != "-1" ? ExpandableFab(


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
                          Builder(builder: (context){
                            final index = DefaultTabController.of(context).index;
                            // use index at here...
                            return const SizedBox.shrink();
                          });
                          context.read<PageChange>().changePageCache(ExerciseSelectionPage(routine: fetchTrainingPlanRoutine(
                              trainingPlanDayOfTheWeekIndex,
                            trainingPlanWeekIndex,
                            context
                          )));
                        }
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 14.0.w),
                    child: SizedBox(
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
                  ),

                  SizedBox(
                    width: 48.w,
                    child: FloatingActionButton(
                      tooltip: "Change Routine",
                      backgroundColor: appSecondaryColour,
                      heroTag: null,
                      child: const Icon(
                        MdiIcons.playlistEdit,
                      ),
                      onPressed: () {
                        final menuState = _key.currentState;
                        if (menuState != null) {
                          menuState.toggle();
                        }
                        if (context.mounted) {
                          ModalBottomSheet.showModal(
                            context,
                            SingleChildScrollView(
                              child: RoutinesList(
                                dayIndex: trainingPlanDayOfTheWeekIndex,
                                trainingPlanWeek: trainingPlanWeekIndex,
                                trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexOf(widget.trainingPlan),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
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
          ) : const SizedBox.shrink(),
          backgroundColor: appTertiaryColour,
          appBar: AppBar(
            actions: [

              IconButton(
                icon: const Icon(
                  Icons.share,
                ),
                onPressed: () async {

                  final String uuid;
                  if (widget.trainingPlan.trainingPlanID != null) {
                    uuid = widget.trainingPlan.trainingPlanID!;


                    


                  } else {
                    uuid = const Uuid().v4().toString();
                  }

                  final trainingPlanShare =
                  TrainingPlanShare(
                      trainingPlanName: widget.trainingPlan.trainingPlanName,
                      ///Type is a List for future when I add multi week plans. For now its just the one week.
                      trainingPlanWeeks: [TrainingPlanWeekShare(
                          weekNumber: 1,
                        mondayRoutine: fetchTrainingPlanRoutine(
                            0,
                            trainingPlanWeekIndex,
                            context
                        ),
                        tuesdayRoutine: fetchTrainingPlanRoutine(
                            1,
                            trainingPlanWeekIndex,
                            context
                        ),
                        wednesdayRoutine: fetchTrainingPlanRoutine(
                            2,
                            trainingPlanWeekIndex,
                            context
                        ),
                        thursdayRoutine: fetchTrainingPlanRoutine(
                            3,
                            trainingPlanWeekIndex,
                            context
                        ),
                        fridayRoutine: fetchTrainingPlanRoutine(
                            4,
                            trainingPlanWeekIndex,
                            context
                        ),
                        saturdayRoutine: fetchTrainingPlanRoutine(
                            5,
                            trainingPlanWeekIndex,
                            context
                        ),
                        sundayRoutine: fetchTrainingPlanRoutine(
                            6,
                            trainingPlanWeekIndex,
                            context
                        ),

                      )],
                    trainingPlanID: uuid,
                  );

                  debugPrint(trainingPlanShare.toMap().toString());

                  try {

                    await FirebaseFirestore.instance
                        .collection('training-plans')
                        .doc(trainingPlanShare.trainingPlanID)
                        .set({
                      "data": trainingPlanShare.toMap()
                    });

                    widget.trainingPlan.trainingPlanID = uuid;

                    UpdateTrainingPlan(
                        widget.trainingPlan
                    );

                  } catch (error, stacktrace) {
                    debugPrint(error.toString());
                    debugPrint(stacktrace.toString());
                  }


                },
              ),

              context.read<WorkoutProvider>().workoutStarted
                  ? Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                      child: FloatingActionButton(
                        tooltip: "View Current Workout",
                        backgroundColor: appSenaryColour,
                        heroTag: null,
                        child: AvatarGlow(
                          glowCount: 3,
                          glowColor: Colors.red,
                          glowRadiusFactor: 0.7,
                          child: const Material(
                            type: MaterialType.transparency,
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: Icon(
                              Icons.access_time,
                            ),
                          ),
                        ),
                        onPressed: () {
                          context
                              .read<PageChange>()
                              .changePageCache(WorkoutLogPage());
                        },
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
            backgroundColor: appTertiaryColour,
            title: Text(
              widget.trainingPlan.trainingPlanName.capitalize(),
              style: boldTextStyle.copyWith(fontSize: 18),
            ),
            //elevation: 1.5,
            //shadowColor: appSenaryColour,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.h),
              child: Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: appSenaryColourDark, width: 2.0),
                      ),
                    ),
                  ),
                  TabBar(
                    onTap: (index) => {
                      print("changing tab index " + index.toString()),
                      setState(() {
                        trainingPlanDayOfTheWeekIndex = index;
                      }),
                    },
                    isScrollable: true,
                    indicatorColor: appSenaryColour,
                    tabs: [
                      Tab(text: "Monday"),
                      Tab(text: "Tuesday"),
                      Tab(text: "Wednesday"),
                      Tab(text: "Thursday"),
                      Tab(text: "Friday"),
                      Tab(text: "Saturday"),
                      Tab(text: "Sunday"),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TrainingPlanDayBox(
                  dayIndex: 0,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Monday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 1,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Tuesday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 2,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Wednesday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 3,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Thursday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 4,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Friday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 5,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Saturday",
                ),
                TrainingPlanDayBox(
                  dayIndex: 6,
                  trainingPlanIndex: context.read<WorkoutProvider>().trainingPlanList.indexWhere((value) => value == widget.trainingPlan),
                  trainingPlanWeek: trainingPlanWeekIndex,
                  day: "Sunday",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
