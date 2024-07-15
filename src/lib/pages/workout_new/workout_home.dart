import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/models/workout/reps_weight_stats_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_logs_home.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../models/workout/routines_model.dart';
import '../../models/workout/training_plan_model.dart';
import '../../providers/general/database_get.dart';
import '../../providers/general/database_write.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/training_plan_list.dart';
import '../../widgets/workout_new/workout_daily_tracker.dart';
import '../../widgets/workout_new/workout_home_stats_dropdown.dart';
import 'exercise_database_search.dart';

class WorkoutHomePageNew extends StatefulWidget {
  WorkoutHomePageNew({Key? key}) : super(key: key);

  @override
  State<WorkoutHomePageNew> createState() => _WorkoutHomePageNewState();
}

class _WorkoutHomePageNewState extends State<WorkoutHomePageNew> {
  late GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  final GlobalKey<FormState> _formShareKey = GlobalKey<FormState>();
  final TextEditingController inputShareController = TextEditingController();

  newTrainingPlan(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'training_plan_creation_pressed');
    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create a Training Plan",
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
                          .checkForTrainingPlanData(value!)) {
                        print("EXISTS");
                        return "Training Plan Already Exists";
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
                        "Training Plan Name *",
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

              Flexible(
                child: Form(
                  key: _formShareKey,
                  child: TextFormField(
                    controller: inputShareController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Import Training Plan Code (Optional)",
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
                      onTap: () async {
                          if (_formKey.currentState!.validate()) {

                            if (inputShareController.text.isNotEmpty) {

                              List trainingPlanData = await GetTrainingPlanByCode(inputShareController.text);

                              debugPrint("Returned");

                              if (trainingPlanData.isNotEmpty) {

                                String uniqueTag = const Uuid().v4().toString().substring(0,13);

                                final TrainingPlan trainingPlan = trainingPlanData[0];

                                if (inputController.text.isNotEmpty) {
                                  trainingPlan.trainingPlanName = inputController.text;
                                } else {
                                  trainingPlan.trainingPlanName = trainingPlan.trainingPlanName + " - $uniqueTag";
                                }

                                final List<RoutinesModel> trainingPlanRoutines = trainingPlanData[1];

                                debugPrint("Resolved Training Plan");

                                List<ExerciseListModel> exerciseList = [];

                                for (final RoutinesModel routine in trainingPlanRoutines) {
                                  routine.routineName += " - $uniqueTag";

                                  if (routine.exerciseSetsAndRepsPlan != null) {

                                    Map<String, dynamic> oldMap = routine.exerciseSetsAndRepsPlan!;
                                    Map<String, dynamic> newMap = {};
                                    oldMap.forEach((key, value) {
                                      newMap["$key - $uniqueTag"] = value;
                                    });
                                    routine.exerciseSetsAndRepsPlan = newMap;
                                  }

                                  for (ExerciseListModel exercise in routine.exercises) {
                                    exercise.exerciseName += " - $uniqueTag";
                                    if (!exerciseList.contains(exercise)) {
                                      exerciseList.add(exercise);
                                    }
                                  }
                                  context.read<WorkoutProvider>().createNewRoutineFromRoutine(routine);
                                }

                                for (ExerciseListModel exercise in exerciseList) {

                                  context.read<WorkoutProvider>().AddNewWorkout(
                                      ExerciseModel(
                                        exerciseName: exercise.exerciseName,
                                        exerciseTrackingData: RepsWeightStatsMeasurement(
                                            measurementName: '',
                                            dailyLogs: []
                                        ),
                                        exerciseMaxRepsAndWeight: {},
                                        category: exercise.category,
                                        exerciseTrackingType: exercise.exerciseTrackingType,
                                        type: exercise.mainOrAccessory,
                                          primaryMuscle: trainingPlanData[2][
                                            exercise.exerciseName.substring(0,exercise.exerciseName.length-16)
                                          ]["primaryMuscle"],
                                          secondaryMuscle: trainingPlanData[2][
                                          exercise.exerciseName.substring(0,exercise.exerciseName.length-16)
                                          ]["secondaryMuscle"],
                                          tertiaryMuscle: trainingPlanData[2][
                                          exercise.exerciseName.substring(0,exercise.exerciseName.length-16)
                                          ]["tertiaryMuscle"]
                                      )
                                  );
                                }

                                context.read<WorkoutProvider>().addNewTrainingPlanFromTrainingPlan(trainingPlan);
                              }

                              inputController.text = "";
                              inputShareController.text = "";

                            } else {

                              context
                                  .read<WorkoutProvider>()
                                  .addNewTrainingPlan(inputController.text);
                              inputController.text = "";

                            }

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: const Text(
          "Workout Tracking",
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
              glowCount:
                  context.watch<WorkoutProvider>().workoutStarted ? 3 : 0,
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
                size: 48.w,
              ),
              onPressed: onPressed,
            );
          },
        ),
        children: [
          SizedBox(
            width: 48.w,
            child: FloatingActionButton(
              tooltip: "Add Routine",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                Icons.add,
              ),
              onPressed: () => newTrainingPlan(
                this.context,
              ),
            ),
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
                context.read<PageChange>().changePageCache(WorkoutLogsHome());
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
                    Icons.access_time,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const WorkoutDailyTracker(),
              SizedBox(height: 14.h),
              const workoutHomeStatsDropdown(),
              SizedBox(height: 14.h),
              Container(
                color: appTertiaryColour,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Training Plans",
                    style: boldTextStyle.copyWith(fontSize: 18.h),
                  ),
                ),
              ),
              context.read<WorkoutProvider>().trainingPlanList.isNotEmpty
                  ? TrainingPlanList(
                      trainingPlans:
                          context.read<WorkoutProvider>().trainingPlanList)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 24.h),
                        Icon(
                          MdiIcons.formatListBulleted,
                          size: 90.h,
                        ),
                        Text(
                          "No Training Plans Yet",
                          style: boldTextStyle.copyWith(fontSize: 30.h),
                        ),
                        Text(
                          "Try Creating One",
                          style: boldTextStyle.copyWith(fontSize: 14.h),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FloatingActionButton(
                            backgroundColor: appSecondaryColour,
                            child: const Icon(Icons.add),
                            onPressed: () {
                              _key.currentState?.toggle();
                              newTrainingPlan(context);
                            },
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
