import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_logs_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/workout/workoutProvider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/training_plan_day_box.dart';
import 'exercise_database_search.dart';

class TrainingPlanPage extends StatefulWidget {
  TrainingPlanPage({Key? key, required this.trainingPlan}) : super(key: key);
  TrainingPlan trainingPlan;

  @override
  State<TrainingPlanPage> createState() => _TrainingPlanPageState();
}

class _TrainingPlanPageState extends State<TrainingPlanPage> {
  late GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  newRoutine(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'routine_creation_pressed');
    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create a Routine",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Required";
                      }
                      if (context
                          .read<WorkoutProvider>()
                          .checkForRoutineData(value!)) {
                        print("EXISTS");
                        return "Routine Already Exists";
                      }
                      return null;
                    },
                    controller: inputController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Routine Name *",
                        style: boldTextStyle.copyWith(fontSize: 14),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appQuarternaryColour,
                      )),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appSecondaryColour,
                      )),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                        color: appSecondaryColour,
                      )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Create",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          context
                              .read<WorkoutProvider>()
                              .createNewRoutine(inputController.text);
                          inputController.text = "";

                          Navigator.pop(context);
                        }
                      },
                    )),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      final menuState = _key.currentState;
      if (menuState != null) {
        menuState.toggle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //_key = GlobalKey<ExpandableFabState>();

    ///Currently focusing on one week only training plans. Index is here for future support
    int trainingPlanWeekIndex = 0;

    return DefaultTabController(
      length: 7,
      initialIndex: DateTime.now().weekday-1,
      child: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Scaffold(
          backgroundColor: appPrimaryColour,
          appBar: AppBar(
            actions: [
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
                  const TabBar(
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
