import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/workout_new/routine_box.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_bottom_button.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_home_log_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../pages/workout_new/workout_routine_page.dart';
import '../../providers/workout/workoutProvider.dart';

class WorkoutLogPageList extends StatefulWidget {
  const WorkoutLogPageList({Key? key}) : super(key: key);

  @override
  State<WorkoutLogPageList> createState() => _WorkoutLogPageListState();
}

class _WorkoutLogPageListState extends State<WorkoutLogPageList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: context.watch<WorkoutProvider>().workoutLogs.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return WorkoutHomeLogBox(
          key: UniqueKey(),
          index: index,
        );
        },
    );
  }
}
