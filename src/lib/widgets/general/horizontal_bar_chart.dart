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
  late double maxValue;

  double getWidth(double barValue) {

    if (barValue > maxValue) {
      return 1;
    }

    return (barValue/maxValue);

  }

  double getRealisticMaxValue(List<double> items) {

    items.sort((b, a) => a.compareTo(b));

    double actualMax = items[0];

    print(items);

    double realisticMax = 0;

    int loopChecks = 0;

    double loopMax = actualMax;

    for (double item in items) {
      if (item == actualMax) {
        continue;
      }
      if (loopMax/item >= 10) {
        print(item);
        loopMax = item;
      }

      if (loopChecks > 3 || loopChecks == items.length-2) {
        print("break");
        realisticMax += loopMax;
        break;
      }
      loopChecks += 1;
    }

    return realisticMax;
  }

  @override
  Widget build(BuildContext context) {

    bars = widget.values.entries.map((entry) => BarModel(label: entry.key.toString(), value: double.parse(entry.value))).toList();
    List<double> barValues = widget.values.entries.map((entry) => double.parse(entry.value)).toList();
    maxValue = getRealisticMaxValue(barValues);

    return Container(
      color: appTertiaryColour,
      child: ListView(
        children: [
          SizedBox(height: 10.h),

          Text(
            widget.label,
            style: boldTextStyle.copyWith(
              fontSize: 24
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