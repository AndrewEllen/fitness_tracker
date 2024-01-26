import 'dart:math';
import 'package:collection/collection.dart';

import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HorizontalBarChart extends StatefulWidget {
  HorizontalBarChart({Key? key, required this.values, required this.label}) : super(key: key);
  Map values;
  String label;

  @override
  State<HorizontalBarChart> createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {

  late List<BarModel> bars;
  late double realMaxValue;
  late double maxValue;
  late double minValue;

  double getWidth(double barValue) {
    double scalingFactor = 1;

    if (maxValue/minValue > 30) {
      scalingFactor = 1 + (minValue/maxValue)*30;
    }

    if (barValue >= realMaxValue) {
      return 1;
    } else if (barValue > maxValue) {
      return 0.99;
    }

    double fractionalValue = barValue/maxValue;

    if (fractionalValue < 0.08) {
      return 0.08;
    }

    if (barValue < realMaxValue) {
      return fractionalValue-0.025;//*scalingFactor;
    }

    return fractionalValue;

  }

  double getRealisticMaxValue(List<double> items) {
    items.sort();

    // Calculate Q1 and Q3
    int length = items.length;
    int q1Index = (length / 4).floor();
    int q3Index = (3 * length / 4).floor();

    double q1 = items[q1Index];
    double q3 = items[q3Index];

    // Calculate the interquartile range (IQR)
    double iqr = q3 - q1;

    // Define a multiplier to set the threshold for outliers (e.g., 1.5 times the IQR)
    double outlierMultiplier = 1.5;

    // Calculate the lower and upper bounds for outliers
    double lowerBound = q1 - outlierMultiplier * iqr;
    double upperBound = q3 + outlierMultiplier * iqr;

    // Filter out values outside the outlier bounds
    List<double> filteredValues = items.where((value) => value >= lowerBound && value <= upperBound).toList();

    // Find the maximum value in the filtered list
    double realisticMax = filteredValues.isNotEmpty ? filteredValues.reduce(max) : 0;

    print(realisticMax);
    return realisticMax;
  }

  @override
  Widget build(BuildContext context) {

    bars = widget.values.entries.map((entry) => BarModel(label: entry.key.toString(), value: double.parse(entry.value))).toList();
    List<double> barValues = widget.values.entries.map((entry) => double.parse(entry.value)).toList();
    realMaxValue = barValues.reduce(max);
    maxValue = getRealisticMaxValue(barValues);
    minValue = barValues.reduce(min);

    return Container(
      color: appTertiaryColour,
      child: ListView(
        children: [
          SizedBox(height: 10.h),

          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Text(
              widget.label,
              style: boldTextStyle.copyWith(
                fontSize: 24
              ),
            ),
          ),

          Divider(
            height: 25.h,
            thickness: 2,
            color: appQuinaryColour,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: bars.length+1,
              itemBuilder: (BuildContext context, int index) {
                return index == bars.length ? const SizedBox(height: 50) : Container(
                  margin: EdgeInsets.only(top: 18),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        width: 50,
                        child: Text(
                          bars[index].label + " Kg",
                          style: boldTextStyle,
                        ),
                      ),
                      SizedBox(
                        width: 280.w,
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: getWidth(bars[index].value),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                              color: appSecondaryColour,
                            ),
                            height: 24,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0, left: 2.5),
                                child: Text(
                                  bars[index].value.round().toString(),
                                  style: boldTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
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