import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/workout/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../exports.dart';
import '../../constants.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({Key? key}) : super(key: key);

  @override
  _RoutinesScreenState createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _margin = 15;
    double _bigContainerMin = 470;
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
              minHeight: _bigContainerMin * 0.96,
              maxHeight: _bigContainerMin * 1.5,
              height: (_height / 100) * 78,
              margin: _margin / 2,
              child: ListView.builder(
                  itemCount:
                      context.watch<RoutinesList>().workoutRoutines.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index > 0) {
                      return ExerciseDisplayBox(
                        title: context
                            .watch<RoutinesList>()
                            .workoutRoutines[index]
                            .routineName,
                        subtitle: "Tap to View Routine",
                        icon: Icons.edit,
                        onTap: () =>
                            context.read<PageChange>().changePageCache(
                              ShowRoutinesScreen(
                                routine: context
                                    .read<RoutinesList>()
                                    .workoutRoutines[index],
                                returnScreen: const RoutinesScreen(),
                              ),
                            ),
                        onTapIcon: () =>
                            context.read<PageChange>().changePageCache(
                              CreateRoutinesScreen(
                                routine: context
                                    .read<RoutinesList>()
                                    .workoutRoutines[index],
                                returnScreen: const RoutinesScreen(),
                              ),
                            ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
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
                  buttonText: "Create Routines",
                  onTap: () {
                    context
                        .read<PageChange>()
                        .changePageCache(const CreateRoutinesScreen(
                      returnScreen: RoutinesScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
