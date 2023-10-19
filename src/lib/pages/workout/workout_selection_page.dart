import 'package:fitness_tracker/providers/workout/user_exercises.dart';
import 'package:fitness_tracker/widgets/workout_new/exercise_selection_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SelectionPage extends StatefulWidget {
  const SelectionPage({Key? key}) : super(key: key);

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    color: appTertiaryColour,
                    width: double.maxFinite,
                    height: 680.h,
                    child: ListView.builder(
                      itemCount: context.read<UserExercisesList>().exerciseList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExerciseSelectionBox(
                          key: UniqueKey(),
                          title: context.read<UserExercisesList>().exerciseList[index].exerciseName,
                        );
                      },
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
