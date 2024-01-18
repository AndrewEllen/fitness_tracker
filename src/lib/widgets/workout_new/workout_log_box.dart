import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../models/workout/exercise_model.dart';

class WorkoutLogBox extends StatefulWidget {
  WorkoutLogBox({Key? key, required this.exercise, required this.index, required this.index2}) : super(key: key);
  ExerciseModel exercise;
  int index, index2;

  @override
  State<WorkoutLogBox> createState() => _WorkoutLogBoxState();
}

class _WorkoutLogBoxState extends State<WorkoutLogBox> {

  final RegExp removeTrailingZeros = RegExp(r'([.]*0)(?!.*\d)');

  late bool _expandPanel = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: appTertiaryColour,
            border: Border(
              bottom: BorderSide(
                color: appQuinaryColour,
              ),
              top: BorderSide(
                color: appQuinaryColour,
              ),
            ),
          ),
          width: double.maxFinite,
          height: 60.h,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (widget.exercise.exerciseTrackingData.dailyLogs[widget.index]["weightValues"].length - widget.index2).toString() +
                      " - " + widget.exercise.exerciseTrackingData.dailyLogs[widget.index]["measurementTimeStamp"][widget.index2],
                  style: boldTextStyle,
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.exercise.exerciseTrackingData
                      .dailyLogs[widget.index]["weightValues"][widget.index2]
                      .toString().replaceAll(removeTrailingZeros, "") +
                      " Kg",
                  style: boldTextStyle,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.exercise.exerciseTrackingData
                      .dailyLogs[widget.index]["repValues"][widget.index2]
                      .toString().replaceAll(removeTrailingZeros, "") +
                      " Reps",
                  style: boldTextStyle,
                ),
              ),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _expandPanel = !_expandPanel;
                      });
                    },
                    icon: const Icon(
                      Icons.more_vert, color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: _expandPanel ? 60 : 0),
          duration: const Duration(milliseconds: 450),
          builder: (context, value, _) => ClipRRect(
            child: Container(
              color: Colors.red,
              height: value.h,
              child: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
