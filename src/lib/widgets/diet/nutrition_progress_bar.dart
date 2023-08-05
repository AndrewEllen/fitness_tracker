import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants.dart';

class NutritionProgressBar extends StatelessWidget {
  NutritionProgressBar({super.key,
    required this.title, required this.currentProgress,
    required this.goal, required this.width,
    this.barColour = appSecondaryColour,
    this.units = "mg"
  });
  final String title, units;
  late double currentProgress, goal;
  final double width;
  final Color barColour;

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

    if (units == "μg") {
      currentProgress *= 1000;
    }

    print(currentProgress);

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
                    title,
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
                "${currentProgress.toStringAsFixed(1)}/$goal $units",
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
                  progressColor: barColour,
                  percent: ProgressDistanceValidation(currentProgress, goal),
                  width: (width / 100) * 90,
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
