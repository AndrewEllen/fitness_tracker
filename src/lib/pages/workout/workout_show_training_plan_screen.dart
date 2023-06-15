import 'package:fitness_tracker/pages/workout/workout_show_routine_screen.dart';
import 'package:fitness_tracker/providers/workout/exercise_list_data.dart';
import 'package:fitness_tracker/providers/general/page_change_provider.dart';
import 'package:fitness_tracker/providers/workout/user_routines_data.dart';
import 'package:fitness_tracker/providers/workout/user_training_plan_data.dart';
import 'package:fitness_tracker/widgets/workout/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/exports.dart';

import '../../helpers/workout/find_routine_id.dart';
import '../../helpers/workout/find_routines.dart';

class ShowTrainingPlanScreen extends StatefulWidget {
  const ShowTrainingPlanScreen({Key? key,
    required this.returnScreen,
    required this.trainingPlanIndex,
  }) : super(key: key);
  final Widget returnScreen;
  final int trainingPlanIndex;

  @override
  _ShowTrainingPlanScreenState createState() => _ShowTrainingPlanScreenState();
}

class _ShowTrainingPlanScreenState extends State<ShowTrainingPlanScreen> {
  bool _displayDropDown = false;



  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          children: [
            ScreenWidthContainer(
              minHeight: _smallContainerMin * 0.5,
              maxHeight: _smallContainerMin * 0.7,
              height: _smallContainerMin * 0.5,
              margin: _margin / 4,
              child: Container(
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                      context
                          .read<TrainingPlanProvider>()
                          .trainingPlans[widget.trainingPlanIndex]
                          .trainingPlanName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                      )
                  ),
                ),
              ),
            ),
            ScreenWidthContainer(
              minHeight: _bigContainerMin * 0.96,
              maxHeight: _bigContainerMin * 1.5,
              height: (_height / 100) * 78,
              margin: _margin / 2,
              child: (context
                  .watch<TrainingPlanProvider>()
                  .trainingPlans[widget.trainingPlanIndex]
                  .routineIDs.isEmpty)
                  ? const Center(
                child: Text(
                  "Routines List Empty",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ) : ListView.builder(
                  itemCount: context
                      .watch<TrainingPlanProvider>()
                      .trainingPlans[widget.trainingPlanIndex]
                      .routineIDs.length,
                  itemBuilder: (BuildContext context, int index) {
                    _displayDropDown = false;
                    return ExerciseDisplayBox(
                      title:
                      context.read<RoutinesList>().workoutRoutines[
                      findRoutineID(
                        context.watch<RoutinesList>().workoutRoutines,
                        context
                              .read<TrainingPlanProvider>()
                              .trainingPlans[widget.trainingPlanIndex],
                        index,
                      )]
                          .routineName,
                      subtitle: "Tap to View Routine",
                      icon: Icons.keyboard_arrow_right,
                      onTap: () => context.read<PageChange>().changePageCache(
                        ShowRoutinesScreen(
                          routine: findRoutines(
                            context.read<RoutinesList>().workoutRoutines,
                            context
                                .read<TrainingPlanProvider>()
                                .trainingPlans[widget.trainingPlanIndex],
                          )[index],
                          returnScreen: RoutinesScreen(),
                        ),
                      ),
                      onTapIcon: () => context.read<PageChange>().changePageCache(
                        ShowRoutinesScreen(
                          routine: findRoutines(
                            context.read<RoutinesList>().workoutRoutines,
                            context
                                .read<TrainingPlanProvider>()
                                .trainingPlans[widget.trainingPlanIndex],
                          )[index],
                          returnScreen: RoutinesScreen(),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
