
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/workout/workoutProvider.dart';
import '../../widgets/workout_new/workout_log_page_list.dart';

class WorkoutRoutinesHome extends StatefulWidget {
  WorkoutRoutinesHome({Key? key}) : super(key: key);

  @override
  State<WorkoutRoutinesHome> createState() => _WorkoutRoutinesHomeState();
}

class _WorkoutRoutinesHomeState extends State<WorkoutRoutinesHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              WorkoutLogPageList(),
              ElevatedButton(
                onPressed: () {

                  context.read<WorkoutProvider>().loadMoreWorkoutLogs();

                },
                child: const Text("Load More"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
