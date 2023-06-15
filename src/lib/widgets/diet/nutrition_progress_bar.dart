import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants.dart';
import 'dart:async';

class NutritionProgressBar extends StatefulWidget {
  NutritionProgressBar({
    required this.title, required this.currentProgress,
    required this.goal, required this.width,
    this.barColour = appSecondaryColour,
    this.units = "mg"
  });
  late String title, units;
  late double currentProgress, goal;
  late double width;
  late Color barColour;

  @override
  _NutritionProgressBarState createState() => _NutritionProgressBarState();
}

class _NutritionProgressBarState extends State<NutritionProgressBar> with SingleTickerProviderStateMixin {

  ProgressDistanceValidation(double currentProgress, double goal) {

    double progressDistance;

    if (goal == 0) {
      progressDistance = currentProgress;
    } else {
      progressDistance = currentProgress/goal;
    }

    if (progressDistance > 1) {
      progressDistance = 1;
      return progressDistance;
    } else if (progressDistance < 0) {
      progressDistance = 0;
      return progressDistance;
    }
    return progressDistance;
  }

  @override
  Widget build(BuildContext context) {

    print(widget.currentProgress);

    double _width = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        width: (_width / 100) * 90,
        margin: const EdgeInsets.only(top:8,bottom:12),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: _width/3.25,
                ),
                height: 16,
                margin: const EdgeInsets.only(left:10),
                child: FittedBox(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      //fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Text(
                "${widget.currentProgress.toStringAsFixed(1)}/${widget.goal} ${widget.units}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(top:20),
                child: LinearPercentIndicator(
                  backgroundColor: appQuarternaryColour,
                  progressColor: widget.barColour,
                  percent: ProgressDistanceValidation(widget.currentProgress, widget.goal),
                  width: (widget.width / 100) * 90,
                  barRadius: const Radius.circular(10),
                  animation: true,
                  animationDuration: 400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
