import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/providers/general/general_data_provider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../helpers/general/numerical_range_formatter_extension.dart';
import '../../helpers/general/firebase_auth_service.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_data.dart';
import '../general/auth_choose_login_signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late UserDataModel userData = context.read<UserData>().userData;
  late String _dropdownActivityValue = userData.activityLevel;
  late String _dropdownWeightValue = userData.weightGoal;
  late String _dropdownGenderValue = userData.biologicalSex;

  late TextEditingController heightController = TextEditingController(text: userData.height);
  late final heightKey = GlobalKey<FormState>();

  late TextEditingController weightController = TextEditingController(text: userData.weight);
  late final weightKey = GlobalKey<FormState>();

  late TextEditingController ageController = TextEditingController(text: userData.age);
  late final ageKey = GlobalKey<FormState>();

  bool _loading = true;
  late int userDailyStreak;

  late Color streakColour;

  late List caloriesProgress,
      proteinProgress,
      fatProgress,
      carbohydratesProgress;

  late String currentWorkoutName;


  void calculateCalories() {

    if (heightController.text.isNotEmpty && weightController.text.isNotEmpty
    && ageController.text.isNotEmpty) {
      late double calories;
      late double calAdjustment;
      late double bmrMult;
      late double weightGain;

      switch (double.parse(_dropdownActivityValue)) {
        case 0:
          bmrMult = 1.2;
        case 1:
          bmrMult = 1.375;
        case 2:
          bmrMult = 1.55;
        case 3:
          bmrMult = 1.725;
        case 4:
          bmrMult = 1.9;
      }

      switch (double.parse(_dropdownWeightValue)) {
        case 0:
          weightGain = -500;
        case 1:
          weightGain = -250;
        case 2:
          weightGain = 0;
        case 3:
          weightGain = 250;
        case 4:
          weightGain = 500;
      }

      switch (double.parse(_dropdownGenderValue)) {
        case 0:
          calAdjustment = 5;
        case 1:
          calAdjustment = -161;
      }

      calories = ((
          10 * double.parse(weightController.text) + 6.25 * double.parse(heightController.text)
              - 5 * double.parse(ageController.text) + calAdjustment
      ) * bmrMult) + weightGain;

      print(calories);

      context.read<UserData>().updateUserBioData(UserDataModel(
          height: heightController.text,
          weight: weightController.text,
          age: ageController.text,
          activityLevel: _dropdownActivityValue,
          weightGoal: _dropdownWeightValue,
          biologicalSex: _dropdownGenderValue,
          calories: calories.toStringAsFixed(2)
      ));

      context.read<UserNutritionData>().setCalories(calories.toStringAsFixed(2));
    }
  }


  @override
  void initState() {
    userDailyStreak = 4;
    if (userDailyStreak > 0) {
      streakColour = streakColourOrange;
    } else {
      streakColour = streakColourGrey;
    }

    _loading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = 393.w;
    double _height = 851.h;
    double _margin = 15.w;
    double _bigContainerMin = 160.h;
    double _smallContainerMin = 95.h;
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
                          minHeight: 80.h,
                          maxHeight: 80.h,
                          height: 80.h,
                          margin: _margin/2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: const Text(
                                  "Daily Streak",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Center(
                                child: Text(
                                  context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString() + " Days Streak",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
/*                      ScreenWidthContainer(
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
                      ),*/
/*                      ScreenWidthContainer(
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
                                          returnScreen: const WorkoutsHomePage(),
                                        ),
                                      );
                                    } : () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      ScreenWidthContainer(
                        minHeight: _smallContainerMin,
                        maxHeight: _smallContainerMin * 20,
                        height: (_height / 100) * 55,
                        margin: _margin,
                        child: Column(
                          children: [
                            Form(
                              key: heightKey,
                              child: TextFormField(
                                controller: heightController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: (20),
                                ),
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  NumericalRangeFormatter(min: 1, max: 300),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                                  hintText: 'Height (CM)...',
                                  suffix: const Text("Cm"),
                                  hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: (18),
                                  ),
                                  errorStyle: const TextStyle(
                                    height: 0,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: appSecondaryColour,
                                    ),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  }
                                  return "";
                                },
                              ),
                            ),
                            Form(
                              key: weightKey,
                              child: TextFormField(
                                controller: weightController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: (20),
                                ),
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  NumericalRangeFormatter(min: 1, max: 800),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                                  hintText: 'Weight (KG)...',
                                  suffix: const Text("Kg"),
                                  hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: (18),
                                  ),
                                  errorStyle: const TextStyle(
                                    height: 0,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: appSecondaryColour,
                                    ),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  }
                                  return "";
                                },
                              ),
                            ),
                            Form(
                              key: ageKey,
                              child: TextFormField(
                                controller: ageController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: (20),
                                ),
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  NumericalRangeFormatter(min: 1, max: 123),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: (_width/12)/2.5, left: 5, right: 5,),
                                  hintText: 'Age (Years)...',
                                  suffix: const Text("Years"),
                                  hintStyle: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: (18),
                                  ),
                                  errorStyle: const TextStyle(
                                    height: 0,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: appSecondaryColour,
                                    ),
                                  ),
                                ),
                                validator: (String? value) {
                                  if (value!.isNotEmpty) {
                                    return null;
                                  }
                                  return "";
                                },
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: appTertiaryColour,
                              ),
                              child: DropdownButton(
                                value: _dropdownActivityValue,
                                items: const [
                                  DropdownMenuItem(child: Text("Sedentary",
                                    style: TextStyle(
                                        color: Colors.white,
                                    ),
                                  ),
                                    value: "0",
                                  ),
                                  DropdownMenuItem(child: Text("Lightly Active",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                    value: "1",
                                  ),
                                  DropdownMenuItem(child: Text("Moderately Active",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                    value: "2",
                                  ),
                                  DropdownMenuItem(child: Text("Very Active",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                    value: "3",
                                  ),
                                  DropdownMenuItem(child: Text("Extremely Active",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                    value: "4",
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _dropdownActivityValue = value!;
                                  });
                                }
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: appTertiaryColour,
                              ),
                              child: DropdownButton(
                                  value: _dropdownWeightValue,
                                  items: const [
                                    DropdownMenuItem(child: Text("Extreme Weight Loss",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "0",
                                    ),
                                    DropdownMenuItem(child: Text("Mild Weight Loss",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "1",
                                    ),
                                    DropdownMenuItem(child: Text("Maintain Weight",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "2",
                                    ),
                                    DropdownMenuItem(child: Text("Mild Weight Gain",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "3",
                                    ),
                                    DropdownMenuItem(child: Text("Extreme Weight Gain",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "4",
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _dropdownWeightValue = value!;
                                    });
                                  }
                              ),
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: appTertiaryColour,
                              ),
                              child: DropdownButton(
                                  value: _dropdownGenderValue,
                                  items: const [
                                    DropdownMenuItem(child: Text("Male",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "0",
                                    ),
                                    DropdownMenuItem(child: Text("Female",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                      value: "1",
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _dropdownGenderValue = value!;
                                    });
                                  }
                              ),
                            ),
                            AppButton(
                              onTap: calculateCalories,
                              buttonText: "Calculate Calories",
                            ),
                            Text(
                              "Calories: " + context.watch<UserNutritionData>().caloriesGoal.toString() + " Kcal",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Protein: " + context.read<UserNutritionData>().proteinGoal.toString() + " g",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Carbs: " + context.read<UserNutritionData>().carbohydratesGoal.toString() + " g",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Fat: " + context.read<UserNutritionData>().fatGoal.toString() + " g",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(flex: 1),
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
                                MaterialPageRoute(builder: (context) => const ChooseLoginSignUp(),
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
