import 'package:fitness_tracker/models/workout/exercise_list_model.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/workout/exercise_list_checkbox.dart';
import '../../models/workout/routines_model.dart';

class ExerciseSelectionPage extends StatefulWidget {
  ExerciseSelectionPage({Key? key, required this.routine}) : super(key: key);
  final RoutinesModel routine;

  @override
  State<ExerciseSelectionPage> createState() => _ExerciseSelectionPageState();
}

class _ExerciseSelectionPageState extends State<ExerciseSelectionPage> {

  late TextEditingController searchController = TextEditingController();
  late final searchKey = GlobalKey<FormState>();


  //todo Add selected routine on exercise selection page. Add function to add exercises to that routine.
  //todo create new exercise creation page/modal.


  List<ExerciseListModel> _selectedExerciseList = [];




  
  @override
  Widget build(BuildContext context) {

    List<ExerciseListCheckbox> checkboxList = [
      for (String exerciseName in context.read<WorkoutProvider>().exerciseNamesList)
        ExerciseListCheckbox(
            exerciseName: exerciseName,
            isChecked: false,
        )
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(top:100.h),
              shrinkWrap: true,
              itemCount: checkboxList.length,
              itemBuilder: (BuildContext context, int index) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return CheckboxListTile(
                        key: UniqueKey(),
                        title: Text(
                          checkboxList[index].exerciseName,
                          style: boldTextStyle,
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: checkboxList[index].isChecked,
                        onChanged: (value) {

                          setState(() {
                            checkboxList[index].isChecked = value!;
                          });

                        },
                      );
                    }
                );
              },
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: appTertiaryColour,
                  width: double.maxFinite,
                  height: 50.h,
                  child: Center(
                    child: Text(
                      "Search Your Exercises",
                      style: boldTextStyle.copyWith(fontSize: 18),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 14.h),
                    color: appTertiaryColour,
                    padding: EdgeInsets.only(
                      left: 75.w,
                      right: 75.w,
                      bottom: 18.h,
                    ),
                    child: SizedBox(
                      height: 40.h,
                      child: Form(
                        key: searchKey,
                        child: TextFormField(
                          //inputFormatters: textInputFormatter,
                          keyboardType: TextInputType.text,
                          controller: searchController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: (18),
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            isDense: true,
                            label: Text(
                              "Search",
                              style: boldTextStyle.copyWith(
                                  fontSize: 14
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appQuarternaryColour,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: appTertiaryColour,
                      height: 70.h,
                      child: Center(
                        child: SizedBox(
                          height: 35.h,
                          child: AppButton(
                            onTap: () {

                              setState(() {
                                _selectedExerciseList = [
                                  for(ExerciseListCheckbox exercise in checkboxList)
                                    if (exercise.isChecked)
                                      ExerciseListModel(
                                          exerciseName: exercise.exerciseName,
                                          exerciseDate: "",
                                      ),
                                ];
                              });

                              context.read<WorkoutProvider>().addExerciseToRoutine(widget.routine, _selectedExerciseList);

                            },
                            buttonText: 'Add to Routine',
                          ),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
