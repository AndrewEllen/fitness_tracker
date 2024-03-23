import 'dart:ffi';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCircle extends StatefulWidget {
  const CalorieCircle({Key? key, required this.caloriesGoal, required this.calories}) : super(key: key);
  final double caloriesGoal, calories;

  @override
  State<CalorieCircle> createState() => _CalorieCircleState();
}

class _CalorieCircleState extends State<CalorieCircle> {

  bool _displayCalories = false;

  double barProgress(double progress, double goal) {
    double barProgressDouble;
    try {
      barProgressDouble = progress / goal;
      if (barProgressDouble > 2) {
        barProgressDouble = 2;
      }
    } catch (error) {
      barProgressDouble = 0;
    }
    return barProgressDouble;
  }

  void displayCalories() {
    FirebaseAnalytics.instance.logEvent(name: 'changed_calories_display');
    setState(() {
      _displayCalories = !_displayCalories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            spreadRadius: 6,
            blurRadius: 6,
          ),
          BoxShadow(
            color: appTertiaryColour,
            spreadRadius: -4.0,
            blurRadius: 6,
          ),
        ],
      ),
      width: 160.h,
      height: 160.h,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: displayCalories,
          child: Stack(
            children: [
              Container(

              ),
              Positioned(
                child: SizedBox(
                  width: 160.h,
                  height: 160.h,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: barProgress(widget.calories, widget.caloriesGoal) - 1),
                    duration: const Duration(milliseconds: 750),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: value,
                      valueColor: AlwaysStoppedAnimation<Color>(streakColourOrange),
                      strokeWidth: 14.h,
                      backgroundColor: appSecondaryColour,
                    ),
                  ),
                ),
              ),
              Positioned(
                child: SizedBox(
                  width: 160.h,
                  height: 160.h,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.0, end: barProgress(widget.calories, widget.caloriesGoal)),
                    duration: const Duration(milliseconds: 750),
                    builder: (context, value, _) => value < 1 ? CircularProgressIndicator(
                      value: value,
                      valueColor: AlwaysStoppedAnimation<Color>(appSecondaryColour),
                      backgroundColor: appSecondaryColourDark,
                      strokeWidth: 14.h,
                    ) : const SizedBox.shrink(),
                  ),
                ),
              ),
              Center(
                child: _displayCalories ?
                Column(
                  children: [
                    const Spacer(),
                    Text(
                      "${(widget.calories).toStringAsFixed(0)} Kcal Eaten",
                      style: boldTextStyle.copyWith(
                        fontSize: 14.h,
                      ),
                    ),
                    Text(
                      "of ${widget.caloriesGoal.toStringAsFixed(0)} Kcal",
                      style: boldTextStyle.copyWith(
                        fontSize: 14.h,
                      ),
                    ),
                    const Spacer(),
                  ],
                ) :
                Column(
                  children: [
                    const Spacer(),
                    Text(
                      "${(widget.caloriesGoal - widget.calories).toStringAsFixed(0)} Kcal Remaining",
                      style: boldTextStyle.copyWith(
                        fontSize: 14.h,
                      ),
                    ),
                    Text(
                      "of ${widget.caloriesGoal.toStringAsFixed(0)} Kcal",
                      style: boldTextStyle.copyWith(
                        fontSize: 14.h,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
