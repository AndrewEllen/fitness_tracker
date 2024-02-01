import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker/models/workout/exercise_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/workout/reps_weight_stats_model.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/app_dropdown_form.dart';

class NewExercisePage extends StatefulWidget {
  const NewExercisePage({Key? key}) : super(key: key);

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {

  String? selectedValue;
  bool _newAdded = false;

  final GlobalKey<FormState> exerciseKey = GlobalKey<FormState>();
  final TextEditingController exerciseController = TextEditingController();

  final GlobalKey<FormState> categoriesKey = GlobalKey<FormState>();
  final TextEditingController categoriesController = TextEditingController();

  late int typeDropDownMenuValue = 0;
  late int weightTypeDropDownMenuValue = 0;


  @override
  Widget build(BuildContext context) {

    List<String> exerciseList = <String>[
      "Bench Press",
      "Barbell Deadlift",
      "Sumo Barbell Deadlift",
      "Bent Over Row"
    ] + context.read<WorkoutProvider>().exerciseNamesList;

    List<String> categoriesList = <String>[
      "Biceps",
      "Triceps",
      "Forearms",
      "Shoulders",
      "Chest",
      "Back",
      "Core",
      "Glutes",
      "Quads",
      "Hamstrings",
      "Calves",
      "Cardio"
    ] + context.read<WorkoutProvider>().categoriesNamesList;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        appBar: AppBar(
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create New Exercise",
          ),
        ),
        body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
          child: Padding(
            padding: const EdgeInsets.only(top: 22.0),
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: DropDownForm(
                        label: "Search Exercises *",
                        formController: exerciseController,
                        formKey: exerciseKey,
                        listOfItems: exerciseList,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
                      child: DropDownForm(
                        label: "Search Categories",
                        formController: categoriesController,
                        formKey: categoriesKey,
                        listOfItems: categoriesList,
                        validate: false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
                      child: DropdownMenu(
                        initialSelection: 0,
                        enableSearch: false,
                        requestFocusOnTap: false,
                        width: 294.w,
                        hintText: "Select Exercise Type *",
                        textStyle: boldTextStyle,
                        menuStyle: MenuStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(appQuinaryColour),
                        ),
                        trailingIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        selectedTrailingIcon: const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appQuarternaryColour,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: appSecondaryColour,
                              )
                          ),
                        ),
                        dropdownMenuEntries: [

                          DropdownMenuEntry(
                              value: 0,
                              label: "Weight and Reps",
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                          ),
                          DropdownMenuEntry(
                              value: 1,
                              label: "Distance and Time",
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            setState(() {
                              typeDropDownMenuValue = value;
                            });
                          }
                        },
                      ),
                    ),

                    typeDropDownMenuValue == 0 ? Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
                      child: DropdownMenu(
                        initialSelection: 0,
                        enableSearch: false,
                        requestFocusOnTap: false,
                        width: 294.w,
                        hintText: "Select Exercise Type *",
                        textStyle: boldTextStyle,
                        menuStyle: MenuStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(appQuinaryColour),
                        ),
                        trailingIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        selectedTrailingIcon: const Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white,
                        ),
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appQuarternaryColour,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: appSecondaryColour,
                              )
                          ),
                        ),
                        dropdownMenuEntries: [

                          DropdownMenuEntry(
                            value: 0,
                            label: "Main",
                            style: ButtonStyle(
                              textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                          ),
                          DropdownMenuEntry(
                            value: 1,
                            label: "Accessory",
                            style: ButtonStyle(
                              textStyle: MaterialStateProperty.all<TextStyle>(boldTextStyle),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value != null) {
                            setState(() {
                              weightTypeDropDownMenuValue = value;
                            });
                          }
                        },
                      ),
                    ) : const SizedBox.shrink(),

                    SizedBox(
                      height: 100.h,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: appTertiaryColour,
                    height: 70.h,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 12.w),
                            child: AppButton(
                              onTap: () {

                                if (exerciseController.text.isNotEmpty && !context.read<WorkoutProvider>().checkForExerciseName(exerciseController.text)) {
                                  context.read<WorkoutProvider>().AddNewWorkout(
                                      ExerciseModel(
                                        exerciseName: exerciseController.text,
                                        exerciseTrackingData: RepsWeightStatsMeasurement(
                                          measurementName: '',
                                          dailyLogs: [],
                                        ),
                                        exerciseMaxRepsAndWeight: {},
                                        category: categoriesController.text,
                                        type: typeDropDownMenuValue,
                                        exerciseTrackingType: typeDropDownMenuValue == 0 ? weightTypeDropDownMenuValue : null,
                                      )
                                  );
                                  context.read<PageChange>().backPage();
                                } else {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Exercise already exists"),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height * 0.6695,
                                        right: 20,
                                        left: 20,
                                      ),
                                      dismissDirection: DismissDirection.none,
                                      duration: const Duration(milliseconds: 1500),
                                    ),
                                  );

                                }

                              },
                              buttonText: 'Save Exercise',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
