import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/providers/page_change_provider.dart';
import 'package:fitness_tracker/providers/user_nutrition_data.dart';
import 'package:fitness_tracker/widgets/app_default_button.dart';
import 'package:fitness_tracker/widgets/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as chartColour;
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/widgets/nutrition_progress_bar.dart';
import 'package:fitness_tracker/widgets/home_bar_chart.dart';
import 'package:provider/provider.dart';

import '../helpers/find_routine_id.dart';
import '../helpers/firebase_auth_service.dart';
import 'auth_choose_login_signup.dart';
import 'auth_signin.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loading = true;
  late int userDailyStreak;

  late Color streakColour;

  late List caloriesProgress,
      proteinProgress,
      fatProgress,
      carbohydratesProgress;
  late List<dailyWorkoutVolume> workoutData;
  late String currentWorkoutName;

  @override
  void initState() {
    userDailyStreak = 4;
    if (userDailyStreak > 0) {
      streakColour = streakColourOrange;
    } else {
      streakColour = streakColourGrey;
    }

    workoutData = [
      dailyWorkoutVolume(
        routine: "Monday",
        volume: 8145,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Tuesday",
        volume: 12656,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Wednesday",
        volume: 10653,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Thursday",
        volume: 8145,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Friday",
        volume: 9453,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Saturday",
        volume: 14593,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
      dailyWorkoutVolume(
        routine: "Sunday",
        volume: 13592,
        barChartColour: chartColour.ColorUtil.fromDartColor(appSecondaryColour),
      ),
    ];

    _loading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _margin = 15;
    double _bigContainerMin = 160;
    double _smallContainerMin = 95;
    return Scaffold(
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(
                color: appSecondaryColour,
              ))
            : Stack(
              children: [
                ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top:16),
                        child: ScreenWidthContainer(
                          minHeight: _bigContainerMin * 0.96,
                          maxHeight: _bigContainerMin * 1.5,
                          height: (_height / 100) * 26,
                          margin: _margin/2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: const Text(
                                  "Workout Volume Daily (Kg)",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              HomeBarChart(
                                chartWorkoutData: workoutData,
                                chartHeight: (_height / 100) * 23.2,
                                chartWidth: (_width / 100) * 97,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ScreenWidthContainer(
                        minHeight: _smallContainerMin,
                        maxHeight: _smallContainerMin * 1.5,
                        height: (_height / 100) * 13,
                        margin: _margin,
                        child: Column(
                          children: [
                            const Spacer(flex: 1),
                            Icon(
                              MdiIcons.fire,
                              color: streakColour,
                              size: 50,
                            ),
                            Text(
                              "$userDailyStreak Day Streak",
                              style: TextStyle(
                                color: streakColour,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                      ScreenWidthContainer(
                        minHeight: _bigContainerMin,
                        maxHeight: _bigContainerMin * 1.6,
                        height: (_height / 100) * 18,
                        margin: _margin,
                        child: Stack(
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
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(top: 15),
                                height: (_height / 100) * 21,
                                width: (_width / 100) * 93,
                                child: FractionallySizedBox(
                                  heightFactor: 0.45,
                                  widthFactor: 0.65,
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
                                          returnScreen: WorkoutsHomePage(),
                                        ),
                                      );
                                    } : () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(9),
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: FittedBox(
                        child: FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            context.read<FirebaseAuthenticationService>().firebaseSignOut();
                            auth.signOut().then((response) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => ChooseLoginSignUp(),
                                ),
                              );
                              }
                            );
                          },
                          child: const Icon(
                            Icons.logout,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
