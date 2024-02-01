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

  late List<String> items;

  @override
  Widget build(BuildContext context) {


    ///todo change search function code to my own
    ///style page and put drop down in better spot
    ///add second drop down for category types
    ///add third drop down for exercise types
    ///add code to add them to the exercise object and save the new exercise on the list as well as adding it to the selection page



    items = context.read<WorkoutProvider>().exerciseNamesList;

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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: DropDownForm(
                        label: "Search Exercises *",
                        formController: exerciseController,
                        formKey: exerciseKey,
                        listOfItems: context.read<WorkoutProvider>().exerciseNamesList,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 50.0, right: 50.0),
                      child: DropDownForm(
                        label: "Search Categories",
                        formController: categoriesController,
                        formKey: categoriesKey,
                        listOfItems: context.read<WorkoutProvider>().exerciseNamesList,
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

                                if (exerciseKey.currentState!.validate()
                                    && categoriesKey.currentState!.validate()
                                ) {
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
                                }

                                context.read<PageChange>().backPage();

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
