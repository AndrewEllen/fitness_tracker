import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/pages/workout_new/workout_exercise_anatomy_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_exercise_graphs_page.dart';
import 'package:fitness_tracker/pages/workout_new/workout_log_page.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/workout/routines_model.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/incremental_counter.dart';
import '../../widgets/workout_new/routine_page_exercise_list.dart';
import '../../widgets/workout_new/workout_log_box.dart';

class WorkoutExercisePage extends StatefulWidget {
  WorkoutExercisePage({Key? key, required this.exercise, required this.routine}) : super(key: key);
  ExerciseModel exercise;
  RoutinesModel routine;

  @override
  State<WorkoutExercisePage> createState() => _WorkoutExercisePageState();
}

class _WorkoutExercisePageState extends State<WorkoutExercisePage> {

  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  final TextEditingController weightController = TextEditingController();

  final TextEditingController repsController = TextEditingController();


  @override
  void initState() {

    weightController.addListener(_addressControllerListener);

    weightController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["weightValues"][0].toString().replaceAll(removeTrailingZeros, "") : "10";

    repsController.text = widget.exercise.exerciseTrackingData.dailyLogs.isNotEmpty
        ? widget.exercise.exerciseTrackingData.dailyLogs[0]["repValues"][0].toString().replaceAll(removeTrailingZeros, "") : "6";

    super.initState();
  }

  void _addressControllerListener() {
    if (num.tryParse(weightController.text) != null) {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    weightController.removeListener(_addressControllerListener);
    super.dispose();
  }


  Widget sliderText(double value) {

    if (value >= 1 && value <= 3.5) {
      return const Text(
        "Normal Breathing: Could have a conversation or sing",
        style: boldTextStyle,
      );
    } else if (value > 3.5 && value <= 7.5) {
      return const Text(
        "Heavy Breathing: Could have a short conversation",
        style: boldTextStyle,
      );
    } else {
      return const Text(
        "Short of Breath: Could only speak in short sentences",
        style: boldTextStyle,
      );
    }
  }


  double intensitySlider = 5;

  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().exerciseList;
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            context.read<WorkoutProvider>().workoutStarted ? Padding(
              padding: EdgeInsets.only(top:8.h, bottom: 8.h),
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
                  context.read<PageChange>().changePageCache(WorkoutLogPage());
          },
        ),
            ) : const SizedBox.shrink(),
          ],
          backgroundColor: appTertiaryColour,
          title: Text(
            widget.exercise.exerciseName.capitalize() + " - " + widget.routine.routineName.capitalize(),
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
                      bottom: BorderSide(color: appSenaryColourDark, width: 2.0),
                    ),
                  ),
                ),
                const TabBar(
                  indicatorColor: appSenaryColour,
                  tabs: [
                    Tab(icon: Icon(
                      MdiIcons.human,
                    )),
                    Tab(icon: Icon(
                      MdiIcons.notebookPlusOutline
                    )),
                    Tab(icon: Icon(
                      MdiIcons.chartBar,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: TabBarView(
            children: [

              AnatomyDiagramPage(exerciseModel: widget.exercise),

              ListView(
                children: [

                  Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    color: appTertiaryColour,
                    width: double.maxFinite,
                    height: 320.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top:24.h),
                            child: Text(
                              "Create Exercise Log",
                              style: boldTextStyle.copyWith(fontSize: 18),
                            ),
                          ),
                        ),
                        const Spacer(),
                        IncrementalCounter(
                          inputController: weightController,
                          suffix: widget.exercise.type == 0 ? "Kg" : "Km",
                          label: widget.exercise.type == 0 ? "Weight *" : "Distance *",
                          smallButtons: true,
                          smallIncrementAmount: widget.exercise.type == 0 ? 2.5 : 0.1,
                        ),
                        IncrementalCounter(
                          inputController: repsController,
                          suffix: widget.exercise.type == 0 ? "Reps" : "Mins",
                          label: widget.exercise.type == 0 ?  "Reps *" : "Time *",
                          smallButtons: widget.exercise.type == 0 ? false : true,
                          smallIncrementAmount: .5,
                          bigIncrementAmount: widget.exercise.type == 0 ? 1 : 5,
                        ),
                        widget.exercise.type == 1 ? Theme(
                          data: ThemeData(
                            sliderTheme: const SliderThemeData(
                              showValueIndicator: ShowValueIndicator.always
                            )
                          ),
                          child: Slider(
                            value: intensitySlider,
                            onChanged: (double value) {
                              setState(() {
                                intensitySlider = value;
                              });
                            },
                            min: 1,
                            max: 10,
                            //divisions: 14,
                            label: ((intensitySlider*2).floorToDouble()/2).toString(),
                            activeColor: appSecondaryColour,
                            inactiveColor: appSecondaryColourDark,
                          ),
                        ) : const SizedBox.shrink(),
                        widget.exercise.type == 1 ? sliderText(intensitySlider) : const SizedBox.shrink(),
                        const Spacer(),
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0.h, right: 20.w),
                                child: ElevatedButton(
                                  onPressed: () {
                                    FirebaseAnalytics.instance.logEvent(name: 'save_log_pressed');
                                    if (weightController.text.isNotEmpty && repsController.text.isNotEmpty) {
                                      Map newLog = {
                                        "measurementDate": DateFormat("dd/MM/yyy").format(DateTime.now()).toString(),
                                        "type": widget.exercise.type ?? 0,
                                        "weightValues": <double>[

                                          double.parse(weightController.text),

                                        ],
                                        "repValues": <double>[

                                          double.parse(repsController.text),

                                        ],
                                        "measurementTimeStamp": <String>[

                                          DateFormat("HH:mm").format(DateTime.now()).toString(),

                                        ],
                                        "intensityValues": <double>[

                                          intensitySlider

                                        ]
                                      };

                                      try {

                                        if (
                                        DateFormat("dd/MM/yyyy").parse(widget.exercise.exerciseTrackingData.dailyLogs[0]["measurementDate"])
                                            == DateFormat("dd/MM/yyyy").parse(newLog["measurementDate"])
                                        ) {

                                          widget.exercise.exerciseTrackingData.dailyLogs[0]["weightValues"].insert(0, newLog["weightValues"][0]);
                                          widget.exercise.exerciseTrackingData.dailyLogs[0]["repValues"].insert(0, newLog["repValues"][0]);
                                          widget.exercise.exerciseTrackingData.dailyLogs[0]["measurementTimeStamp"].insert(0, newLog["measurementTimeStamp"][0]);
                                          widget.exercise.exerciseTrackingData.dailyLogs[0]["intensityValues"].insert(0, newLog["intensityValues"][0]);
                                          widget.exercise.type = newLog["type"];

                                        } else {

                                          widget.exercise.exerciseTrackingData.dailyLogs.insert(0, newLog);

                                        }

                                        context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog, widget.routine);
                                        context.read<WorkoutProvider>().updateMaxWeightAtRep(repsController.text, weightController.text, widget.exercise.exerciseName);

                                      } catch (e) {
                                        debugPrint(e.toString());

                                        try {
                                          widget.exercise.exerciseTrackingData.dailyLogs.insert(0, newLog);

                                          context.read<WorkoutProvider>().addNewLog(widget.exercise, newLog, widget.routine);
                                          context.read<WorkoutProvider>().updateMaxWeightAtRep(repsController.text, weightController.text, widget.exercise.exerciseName);

                                        } catch (e) {

                                          debugPrint(e.toString());

                                        }

                                      }

                                    }


                                  },
                                  child: const Text("Save Log"),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0.h, left: 20.w, top: 8.h),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 2,
                                    bottom: 2,
                                    left: 6,
                                    right: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: appQuinaryColour,
                                    borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Icon(
                                            Icons.star,
                                            color: context.read<WorkoutProvider>().exerciseMaxRepAndWeight.containsKey(double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")) ? appSenaryColour : appQuarternaryColour,
                                          ),
                                        ),
                                        widget.exercise.type == 0 ? TextSpan(
                                          text: context.read<WorkoutProvider>().exerciseMaxRepAndWeight.containsKey(double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, ""))
                                              ? " Highest reps for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Kg: " + context.read<WorkoutProvider>().exerciseMaxRepAndWeight[double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")].toString()
                                              : double.tryParse(weightController.text) == null ? " No Weight Value" : " No Data for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Kg",
                                          style: boldTextStyle,
                                        ) : TextSpan(
                                          text: context.read<WorkoutProvider>().exerciseMaxRepAndWeight.containsKey(double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, ""))
                                              ? " Best time for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Km: " + context.read<WorkoutProvider>().exerciseMaxRepAndWeight[double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")].toString() + " mins"
                                              : double.tryParse(weightController.text) == null ? " No Distance Value" : " No Data for ${double.tryParse(weightController.text).toString().replaceAll(removeTrailingZeros, "")} Km",
                                          style: boldTextStyle,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.exercise.exerciseTrackingData.dailyLogs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.h),
                            width: double.maxFinite,
                            height: 60.h,
                            color: appTertiaryColour,
                            child: Center(
                              child: Text(
                                widget.exercise.exerciseTrackingData.dailyLogs[index]["measurementDate"],
                                style: boldTextStyle.copyWith(fontSize: 18.h),
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: widget.exercise.exerciseTrackingData.dailyLogs[index]["weightValues"].length,
                            itemBuilder: (BuildContext context, int index2) {
                              return WorkoutLogBox(exercise: widget.exercise, index: index, index2: index2, key: UniqueKey(),);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(name: 'exercise_load_more_pressed');
                      context.read<WorkoutProvider>().fetchMoreExerciseData(widget.exercise);

                    },
                    child: const Text("Load More"),
                  ),
                ],
              ),

              ExerciseGraphsPage(type: widget.exercise.type!),

            ],
          ),
        ),
      ),
    );
  }
}
