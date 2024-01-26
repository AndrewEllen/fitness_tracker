import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';

class WorkoutTrackerCircle extends StatefulWidget {
  WorkoutTrackerCircle({Key? key, required this.size, required this.text, required this.workoutComplete}) : super(key: key);
  final double size;
  final String text;
  final Map workoutComplete;

  @override
  State<WorkoutTrackerCircle> createState() => _WorkoutTrackerCircleState();
}

class _WorkoutTrackerCircleState extends State<WorkoutTrackerCircle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.workoutComplete[widget.text] == true ? appSenaryColour : appQuarternaryColour,
      ),
      width: widget.size,
      height: widget.size,
      child: Center(
        child: Text(
          widget.text.substring(0, 2),
          style: boldTextStyle,
        ),
      ),
    );
  }
}

