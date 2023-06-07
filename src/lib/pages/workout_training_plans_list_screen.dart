import 'package:fitness_tracker/providers/page_change_provider.dart';
import 'package:fitness_tracker/providers/user_routines_data.dart';
import 'package:fitness_tracker/widgets/app_default_button.dart';
import 'package:fitness_tracker/widgets/exercise_display_box.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../exports.dart';
import '../constants.dart';
import '../providers/database_write.dart';

class TrainingPlansScreen extends StatefulWidget {
  const TrainingPlansScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlansScreenState createState() => _TrainingPlansScreenState();
}

class _TrainingPlansScreenState extends State<TrainingPlansScreen> {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
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
                    itemCount: context
                        .read<TrainingPlanProvider>()
                        .trainingPlans.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExerciseDisplayBox(
                        title: context
                            .read<TrainingPlanProvider>()
                            .trainingPlans[index]
                            .trainingPlanName,
                        subtitle: "Tap to View Routine",
                        icon: Icons.edit,
                        icon2: Icons.check_circle,
                        icon2Colour: (index == context.watch<TrainingPlanProvider>().currentlySelectedPlanIndex) ? appSecondaryColour : Colors.white,
                        onTap: () => context.read<PageChange>().changePageCache(
                          ShowTrainingPlanScreen(
                            trainingPlanIndex: index,
                            returnScreen: TrainingPlansScreen(),
                          ),
                        ),
                        onTapIcon: () => context.read<PageChange>().changePageCache(
                          CreateTrainingPlanScreen(
                            trainingPlan: context
                                .read<TrainingPlanProvider>()
                                .trainingPlans[index],
                            returnScreen: TrainingPlansScreen(
                            ),
                          ),
                        ),
                        onTapIcon2: () {
                          context.read<TrainingPlanProvider>().selectTrainingPlan(
                            context
                                .read<TrainingPlanProvider>()
                                .trainingPlans[index].trainingPlanID,
                          );
                          UpdateUserDocumentUserData(
                            context
                              .read<TrainingPlanProvider>()
                              .trainingPlans[index].trainingPlanID,);
                        },
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
                  buttonText: "Create Training Plan",
                  onTap: () {
                    context
                        .read<PageChange>()
                        .changePageCache(const CreateTrainingPlanScreen(
                      returnScreen: TrainingPlansScreen(),
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
