import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../constants.dart";
import "../../providers/workout/workoutProvider.dart";
import "../../widgets/general/horizontal_bar_chart.dart";


class ExerciseGraphsPage extends StatefulWidget {
  ExerciseGraphsPage({Key? key, required this.type}) : super(key: key);
  int type;

  @override
  State<ExerciseGraphsPage> createState() => _ExerciseGraphsPageState();
}

class _ExerciseGraphsPageState extends State<ExerciseGraphsPage> {

  int touchedIndex = -1;


  @override
  Widget build(BuildContext context) {

    context.read<WorkoutProvider>().exerciseMaxRepAndWeight;

    Map data = context.read<WorkoutProvider>().exerciseMaxRepAndWeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: data.isEmpty ? const Center(
          child: Text(
            "No data yet",
            style: boldTextStyle,
          ),
        ) : HorizontalBarChart(
          label: widget.type == 0 ? "Max Reps Per Weight" : "Best Time For Distance",
          values: data,
          type: widget.type,
        ),
      ),
    );
  }
}

