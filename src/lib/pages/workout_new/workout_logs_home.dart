
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/workout/workoutProvider.dart';
import '../../widgets/workout_new/workout_log_page_list.dart';

class WorkoutLogsHome extends StatefulWidget {
  WorkoutLogsHome({Key? key}) : super(key: key);

  @override
  State<WorkoutLogsHome> createState() => _WorkoutLogsHomeState();
}

class _WorkoutLogsHomeState extends State<WorkoutLogsHome> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: Text(
          "Workout Logs",
          style: boldTextStyle,
        ),
      ),
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
