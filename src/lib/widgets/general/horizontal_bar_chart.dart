import 'dart:math';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalBarChart extends StatefulWidget {
  HorizontalBarChart({Key? key, required this.values}) : super(key: key);
  Map values;

  @override
  State<HorizontalBarChart> createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {

  late List<BarModel> bars;
  late double maxValue;

  double getWidth(double barValue) {

    if (barValue > maxValue) {
      return 1;
    }

    return (barValue/maxValue);

  }

  @override
  Widget build(BuildContext context) {

    bars = widget.values.entries.map((entry) => BarModel(label: entry.key.toString(), value: double.parse(entry.value))).toList();
    maxValue = widget.values.entries.map((entry) => double.parse(entry.value)).toList().reduce(max);

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: bars.length,
        itemBuilder: (BuildContext context, int index) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: getWidth(bars[index].value),
            child: Container(
              margin: const EdgeInsets.only(top: 14),
              decoration: const BoxDecoration(
                color: appSecondaryColour,
              ),
              height: 14,
            ),
          );
        },
      ),
    );
  }
}

class BarModel {

  BarModel({
    required this.label,
    required this.value,
  });

  String label;
  double value;
}