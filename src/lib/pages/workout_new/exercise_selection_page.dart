import 'package:fitness_tracker/exports.dart';
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
  List<ExerciseListModel> _selectedExerciseList = [];

  ScrollController scrollController = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();
  bool newItem = false;

  //Creates a list of the index of checked items for when new item is added (and wipes the list for some reason)
  List<int> boolIndexBackupList = [];


  newExercise(BuildContext context) async {

    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create an Exercise",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Required";
                      }
                      if(context.read<WorkoutProvider>().checkForExerciseName(value!)) {
                        print("EXISTS");
                        return "Exercise Already Exists";
                      }
                      return null;
                    },
                    controller: inputController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Exercise Name *",
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
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Create",
                      onTap: () {

                        if (_formKey.currentState!.validate()) {

                          context.read<WorkoutProvider>().addNewExercise(inputController.text);

                          newItem = true;

                          inputController.text = "";

                          Navigator.pop(context);
                        }

                      },
                    )
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    context.watch<WorkoutProvider>().exerciseNamesList;

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
            SizedBox(
              height: 680.h,
              child: ListView.builder(
                padding: EdgeInsets.only(top:110.h),
                shrinkWrap: true,
                controller: scrollController,
                itemCount: checkboxList.length,
                itemBuilder: (BuildContext context, int index) {

                  return Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: appTertiaryColour,
                            titleTextStyle: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                            contentTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            title: const Text('Do you want to delete this Exercise?'),
                            content: const Text("This action can't be undone"),
                            actions: <Widget>[
                              AppButton(
                                onTap: () => Navigator.of(context).pop(false),
                                buttonText: "No",
                              ),
                              AppButton(
                                onTap: () => Navigator.of(context).pop(true),
                                buttonText: "Yes",
                              ),
                            ],
                          );
                        },
                      );
                    },
                    direction: DismissDirection.horizontal,
                    onDismissed: (DismissDirection direction) => context.read<WorkoutProvider>().DeleteExercise(checkboxList[index].exerciseName),
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {

                          if (boolIndexBackupList.contains(index)) {

                            checkboxList[index].isChecked = true;

                          }

                          if (newItem) {
                            checkboxList.last.isChecked = true;
                            boolIndexBackupList.add(checkboxList.length-1);
                            setState(() {
                              newItem = false;
                            });
                            scrollController.animateTo(
                              scrollController.position.maxScrollExtent,
                              duration: Duration(seconds: 2),
                              curve: Curves.fastOutSlowIn,
                            );
                          }

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

                              if (checkboxList[index].isChecked) {
                                boolIndexBackupList.add(index);
                              } else {
                                boolIndexBackupList.removeWhere((element) => element == index);
                              }


                            },
                          );
                        }
                    ),
                  );
                },
              ),
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
              child: Container(
                color: appTertiaryColour,
                height: 70.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Center(
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

                            context.read<PageChange>().backPage();

                          },
                          buttonText: 'Add to Routine',
                        ),
                      )
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 12.w),
                        child: Material(
                          type: MaterialType.transparency,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => newExercise(
                              this.context,
                            ),
                            icon: const Icon(
                              Icons.add_box
                            ),
                            tooltip: "New Exercise",
                          ),
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
    );
  }
}
