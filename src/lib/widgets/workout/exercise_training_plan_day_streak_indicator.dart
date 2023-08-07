import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TrainingPlanStreakIndicator extends StatelessWidget {
  const TrainingPlanStreakIndicator({Key? key, required this.width, required this.streakColour, required this.backgroundColour, required this.dayNumber}) : super(key: key);
  final Color streakColour, backgroundColour;
  final int dayNumber;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.only(top: width/36),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              color: backgroundColour,
            ),
            child: Center(
              child: Icon(
                MdiIcons.fire,
                color: streakColour,
                size: width/8.64,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            "Day $dayNumber",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }
}
