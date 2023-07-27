import 'package:fitness_tracker/pages/workout/workout_exercises_screen.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/workout/exercise_training_plan_day_streak_indicator.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:provider/provider.dart';

import '../../helpers/workout/find_routine_id.dart';

class WorkoutsHomePage extends StatelessWidget {
  const WorkoutsHomePage({Key? key}) : super(key: key);

  final int trainingDaysComplete = 4;
  final Color streakColour = streakColourOrange;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    double _width = MediaQuery.of(context).size.width;

    double _margin = 15;
    double _bigContainerMin = 230;
    double _smallContainerMin = 95;
    return Scaffold(
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _height,
            maxWidth: _width,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              ScreenWidthContainer(
                minHeight: _smallContainerMin * 0.4,
                maxHeight: _smallContainerMin * 0.5,
                height: _smallContainerMin * 0.7,
                margin: _margin / 3,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      "Current Plan: ${context
                          .watch<TrainingPlanProvider>()
                          .currentlySelectedPlan.trainingPlanName}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                      ),
                    ),
                  ),
                ),
              ),
              ScreenWidthContainer(
                minHeight: _bigContainerMin * 0.4,
                maxHeight: _bigContainerMin * 0.86,
                height: _height * 0.7,
                margin: _margin,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: const Center(
                          child: Text(
                            "Congratulations!",
                            style: TextStyle(
                              color: appSecondaryColour,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 12, left: 2, right: 2),
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                                text: "You've Completed ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: _width/26.875),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "$trainingDaysComplete ",
                                    style: TextStyle(
                                        color: streakColour, fontSize: _width/26.875),
                                  ),
                                  TextSpan(
                                    text: "Scheduled Workouts this week!",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: _width/26.875),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.7,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: context
                                .watch<TrainingPlanProvider>()
                                .trainingPlans[0]
                                .routineIDs
                                .length,
                            itemBuilder: (BuildContext context, int index) {
                              return TrainingPlanStreakIndicator(
                                streakColour: streakColour,
                                backgroundColour: Colors.transparent,
                                dayNumber: index + 1,
                                width: _width,
                              );
                            },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 5,
                            );
                            },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ScreenWidthContainer(
                minHeight: _bigContainerMin * 0.4,
                maxHeight: _bigContainerMin * 0.8,
                height: (_height / 100) * 16,
                margin: _margin,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Text(
                          "Today's Scheduled Workout",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(_margin),
                      child: ScreenWidthContainer(
                        minHeight: _smallContainerMin * 0.2,
                        maxHeight: _smallContainerMin * 1.5,
                        height: (_height / 100) * 6,
                        margin: _margin / 1.5,
                        child: FractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: AppButton(
                            buttonText:
                            (context.watch<TrainingPlanProvider>().currentlySelectedPlan.trainingPlanName.isNotEmpty) ?
                            context.read<RoutinesList>().workoutRoutines[
                            findRoutineID(
                              context.read<RoutinesList>().workoutRoutines,
                              context
                                  .read<TrainingPlanProvider>()
                                  .currentlySelectedPlan,
                              0,
                            )]
                                .routineName
                                : "None Selected",
                            onTap: (context.watch<TrainingPlanProvider>().currentlySelectedPlan.trainingPlanName.isNotEmpty) ? () {
                              context.read<PageChange>().changePageCache(
                                ShowRoutinesScreen(
                                  //hard coded currently
                                  routine: context.read<RoutinesList>().workoutRoutines[
                                  findRoutineID(
                                    context.read<RoutinesList>().workoutRoutines,
                                    context
                                        .read<TrainingPlanProvider>()
                                        .currentlySelectedPlan,
                                    0,
                                  )],
                                  returnScreen: const WorkoutsHomePage(),
                                ),
                              );
                            } : () {},
                          ),
                        ),
                      ), //ExerciseExpansionPanel(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: (_height / 100) * 15),
              ScreenWidthContainer(
                minHeight: _smallContainerMin * 0.2,
                maxHeight: _smallContainerMin * 1.5,
                height: (_height / 100) * 6,
                margin: _margin / 1.5,
                child: FractionallySizedBox(
                  heightFactor: 1,
                  widthFactor: 1,
                  child: AppButton(
                    buttonText: "Exercises",
                    onTap: () {
                      context.read<PageChange>().changePageCache(const ExercisesScreen());
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
                    buttonText: "Routines",
                    onTap: () {
                      context.read<PageChange>().changePageCache(const RoutinesScreen());
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
                      buttonText: "Training Plans",
                      onTap: () {
                        context.read<PageChange>().changePageCache(const TrainingPlansScreen());
                      },
                    ),
                ), //ExerciseExpansionPanel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
