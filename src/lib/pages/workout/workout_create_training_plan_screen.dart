import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/models/workout/training_plan_model.dart';
import 'package:fitness_tracker/providers/general/database_write.dart';
import 'package:fitness_tracker/providers/workout/exercise_list_data.dart';
import 'package:fitness_tracker/providers/general/page_change_provider.dart';
import 'package:fitness_tracker/providers/workout/user_routines_data.dart';
import 'package:fitness_tracker/providers/workout/user_training_plan_data.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/workout/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/workout/find_routines.dart';
import '../../widgets/workout/search_menu_widget.dart';

class CreateTrainingPlanScreen extends StatefulWidget {
  const CreateTrainingPlanScreen({
    Key? key,
    required this.returnScreen,
    this.trainingPlan,
  }) : super(key: key);
  final Widget returnScreen;
  final TrainingPlan? trainingPlan;

  @override
  _CreateTrainingPlanScreenState createState() => _CreateTrainingPlanScreenState();
}

class _CreateTrainingPlanScreenState extends State<CreateTrainingPlanScreen> {
  late final TrainingPlanController = TextEditingController();
  late final planNameKey = GlobalKey<FormState>();
  late String trainingPlanID = const Uuid().v4().toString();
  late List<String> planRoutineIDs =
      context.watch<TrainingPlanProvider>().newTrainingPlanListIDs;

  late List<WorkoutRoutine> planRoutines =
      context.watch<TrainingPlanProvider>().newTrainingPlanList;
  bool _displayDropDown = false;

  @override
  Widget build(BuildContext context) {
    if (widget.trainingPlan != null) {
      TrainingPlanController.text = widget.trainingPlan!.trainingPlanName;
      planRoutines = findRoutines(
        context.read<RoutinesList>().workoutRoutines,
        widget.trainingPlan!,
      );
      trainingPlanID = widget.trainingPlan!.trainingPlanID;
      //context
      //    .read<ExerciseList>()
      //    .editRoutineAndSetupBooleanList(planRoutines);
    }
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _margin = 15;
    double _bigContainerMin = 450;
    double _smallContainerMin = 95;
    return Scaffold(
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Stack(
          children: [
            ListView(
              children: [
                ScreenWidthContainer(
                  minHeight: _smallContainerMin * 0.5,
                  maxHeight: _smallContainerMin * 0.7,
                  height: _smallContainerMin * 0.7,
                  margin: _margin / 4,
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    child: Form(
                      key: planNameKey,
                      child: TextFormField(
                        controller: TrainingPlanController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: (20),
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Enter Training Plan Name...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: (20),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return "Please Enter a Routine Name";
                        },
                      ),
                    ),
                  ),
                ),
                ScreenWidthContainer(
                  minHeight: _bigContainerMin * 0.96,
                  maxHeight: _bigContainerMin * 1.5,
                  height: (_height / 100) * 64,
                  margin: _margin / 2,
                  child: (planRoutines.isEmpty)
                      ? const Center(
                    child: Text(
                      "Routine List Empty",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  )
                      : ListView.builder(
                      itemCount: planRoutines.length,
                      itemBuilder: (BuildContext context, int index) {
                        _displayDropDown = false;
                        return ExerciseDisplayBox(
                          title: planRoutines[index].routineName,
                          onTap: () {},
                          onTapIcon: () {},
                        );
                      }),
                ),
                ScreenWidthContainer(
                  minHeight: _smallContainerMin * 0.2,
                  maxHeight: _smallContainerMin * 1.5,
                  height: (_height / 100) * 6,
                  margin: _margin / 1.5,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: AppButton(
                      buttonText: "Add Routines",
                      onTap: () {
                        setState(() {
                          _displayDropDown = true;
                        });
                      },
                    ),
                  ), //ExerciseExpansionPanel(),
                ),
                ScreenWidthContainer(
                  minHeight: _smallContainerMin * 0.2,
                  maxHeight: _smallContainerMin * 1.5,
                  height: (_height / 100) * 6,
                  margin: _margin / 1.5,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: AppButton(
                      buttonText: "Save Training Plan",
                      onTap: () {
                        if (planNameKey.currentState!.validate() &
                        context
                            .read<TrainingPlanProvider>()
                            .newTrainingPlanList
                            .isNotEmpty &&
                            widget.trainingPlan == null) {

                          context
                              .read<TrainingPlanProvider>()
                              .addNewTrainingPlan(TrainingPlan(
                            trainingPlanName: TrainingPlanController.text,
                            trainingPlanID: trainingPlanID,
                            routineIDs: List<String>.generate(planRoutines.length, (int index) {
                              return planRoutines[index].routineID;
                            }),
                          ));
                          UpdateUserDocumentTrainingPlans(context.read<TrainingPlanProvider>().trainingPlans);
                          Future.delayed(const Duration(milliseconds: 250), () {
                            context
                                .read<ExerciseList>()
                                .resetValueUserSelectedExercises;
                            context
                                .read<RoutinesList>()
                                .updateNewRoutineExerciseList([]);
                            context
                                .read<PageChange>()
                                .changePageCache(widget.returnScreen);
                          });

                        } else if (planNameKey.currentState!.validate() &
                        context
                            .read<TrainingPlanProvider>()
                            .newTrainingPlanList
                            .isNotEmpty &&
                            widget.trainingPlan != null) {

                          context.read<TrainingPlanProvider>().editExistingTrainingPlan(
                              TrainingPlan(
                                trainingPlanID: trainingPlanID,
                                trainingPlanName: TrainingPlanController.text,
                                routineIDs: List<String>.generate(planRoutines.length, (int index) {
                                  return planRoutines[index].routineID;
                                }),
                              ),
                              widget.trainingPlan!.trainingPlanID
                          );
                          UpdateUserDocumentTrainingPlans(context.read<TrainingPlanProvider>().trainingPlans);
                          Future.delayed(const Duration(milliseconds: 250), () {
                            context
                                .read<RoutinesList>()
                                .resetValueUserSelectedRoutines;
                            context
                                .read<TrainingPlanProvider>()
                                .updateNewTrainingPlan([]);
                            context
                                .read<PageChange>()
                                .changePageCache(widget.returnScreen);
                          });

                        }
                      },
                    ),
                  ), //ExerciseExpansionPanel(),
                ),
              ],
            ),
            _displayDropDown
                ? Container(
              height: _height,
              width: _width,
              color: appPrimaryColour.withOpacity(0.5),
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    _displayDropDown = false;
                  });
                }),
              ),
            )
                : const SizedBox.shrink(),
            _displayDropDown
                ? const SearchMenu()
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
