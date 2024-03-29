import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/widgets/workout_new/workout_home_stats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class workoutHomeStatsDropdown extends StatefulWidget {
  const workoutHomeStatsDropdown({Key? key}) : super(key: key);

  @override
  State<workoutHomeStatsDropdown> createState() => _workoutHomeStatsDropdownState();
}

class _workoutHomeStatsDropdownState extends State<workoutHomeStatsDropdown> {

  late bool _expandPanel = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: appTertiaryColour,
          width: double.maxFinite,
          height: 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.bar_chart),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Workout Statistics",
                  style: boldTextStyle.copyWith(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    onPressed: () {
                      if (_expandPanel) {
                        FirebaseAnalytics.instance.logEvent(name: 'expanded_workout_stats');
                      } else {
                        FirebaseAnalytics.instance.logEvent(name: 'retracted_workout_stats');
                      }
                      setState(() {
                        _expandPanel = !_expandPanel;
                      });
                    },
                    icon: Icon(_expandPanel ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white,
                    )
                ),
              ),
            ],
          ),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: _expandPanel ? 680.0.h : 0.0),
          duration: const Duration(milliseconds: 250),
          builder: (context, value, _) => ClipRRect(
            child: WorkoutHomeStatsBox(value: value),
          ),
        ),
      ],
    );
  }
}
