import 'package:fitness_tracker/models/workout/routines_model.dart';
import 'package:fitness_tracker/pages/workout/workout_selection_page.dart';
import 'package:fitness_tracker/providers/workout/exercise_list_data.dart';
import 'package:fitness_tracker/providers/general/page_change_provider.dart';
import 'package:fitness_tracker/providers/workout/user_routines_data.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/workout/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/general/database_write.dart';

class CreateRoutinesScreen extends StatefulWidget {
  const CreateRoutinesScreen({
    Key? key,
    required this.returnScreen,
    this.routine,
  }) : super(key: key);
  final Widget returnScreen;
  final WorkoutRoutine? routine;

  @override
  _CreateRoutinesScreenState createState() => _CreateRoutinesScreenState();
}

class _CreateRoutinesScreenState extends State<CreateRoutinesScreen> {
  late final routineNameController = TextEditingController();
  late final routineNameKey = GlobalKey<FormState>();
  late String routineID = const Uuid().v4().toString();
  late List<String> routineExercises =
      context.watch<RoutinesList>().newRoutineExerciseList;

  @override
  Widget build(BuildContext context) {
    if (widget.routine != null) {
      routineNameController.text = widget.routine!.routineName;
      routineExercises = widget.routine!.exercises;
      routineID = widget.routine!.routineID;
      context
          .read<ExerciseList>()
          .editRoutineAndSetupBooleanList(routineExercises);
    }
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
                      key: routineNameKey,
                      child: TextFormField(
                        controller: routineNameController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: (20),
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Enter Routine Name...',
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
                  child: (routineExercises.isEmpty)
                      ? const Center(
                          child: Text(
                            "Exercise List Empty",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: routineExercises.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ExerciseDisplayBox(
                              title: routineExercises[index],
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
                      buttonText: "Add Exercises",
                      onTap: () {
                        context.read<PageChange>().changePageCache(const SelectionPage());
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
                      buttonText: "Save Routine",
                      onTap: () {
                        if (routineNameKey.currentState!.validate() &
                                context
                                    .read<RoutinesList>()
                                    .newRoutineExerciseList
                                    .isNotEmpty &&
                            widget.routine == null) {
                          context
                              .read<RoutinesList>()
                              .addNewRoutine(WorkoutRoutine(
                                routineID: routineID,
                                routineName: routineNameController.text,
                                exercises: context
                                    .read<RoutinesList>()
                                    .newRoutineExerciseList,
                              ));
                          UpdateUserDocumentRoutines(context.read<RoutinesList>().workoutRoutines);
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
                        } else if (routineNameKey.currentState!.validate() &
                                context
                                    .read<RoutinesList>()
                                    .newRoutineExerciseList
                                    .isNotEmpty &&
                            widget.routine != null) {

                          context.read<RoutinesList>().editExistingRoutine(
                              WorkoutRoutine(
                                routineID: routineID,
                                routineName: routineNameController.text,
                                exercises: context
                                    .read<RoutinesList>()
                                    .newRoutineExerciseList,
                              ),
                              widget.routine!.routineID
                          );
                          UpdateUserDocumentRoutines(context.read<RoutinesList>().workoutRoutines);
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

                        }
                      },
                    ),
                  ), //ExerciseExpansionPanel(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
