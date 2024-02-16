import 'dart:math';

import 'package:fitness_tracker/helpers/general/list_extensions.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:fitness_tracker/widgets/stats/stats_line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/stats/stats_model.dart';

class WorkoutLineChart extends StatelessWidget {
  const WorkoutLineChart({
    required this.routineName,
    this.currentVolume = 0,
    this.currentDate = "",
    Key? key,
  }) : super(key: key);
  final String routineName;
  final String currentDate;
  final double currentVolume;

  @override
  Widget build(BuildContext context) {

    final List<StatsMeasurement> data = [...context.read<WorkoutProvider>().routineVolumeStats.map(
            (element) => StatsMeasurement.clone(element))];

    int index = data.indexWhere((element) => element.measurementID == routineName);

    if (currentVolume > 0) {

      data[index].measurementValues.add(currentVolume);
      data[index].measurementDates.add(currentDate);

    }

    print(context.read<WorkoutProvider>().routineVolumeStats[index].measurementValues.length);
    print(data[index].measurementValues.length);

    return index == -1 ? const SizedBox.shrink() : Container(
      decoration: BoxDecoration(
          color: appTertiaryColour,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 4,
                offset: const Offset(0, 1)
            ),
          ]
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        child: Column(
          children: [
            AppBar(
              backgroundColor: appTertiaryColour,
              elevation: 1.25,
              title: Text(
                  data[index].measurementName.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: boldTextStyle
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  left: 6.w,
                ),
                height: (337/1.34).h,
                child: data[index].measurementValues.isEmpty || data[index].measurementValues.length < 2  ? const Center(
                    child: Text(
                      "Not Enough Data to Display",
                      style: TextStyle(
                        color: appQuarternaryColour,
                        fontSize: 22,
                      ),
                    )
                ) : WorkoutStatsLineChart(data: data[index]),
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: appQuarternaryColour,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutStatsLineChart extends StatefulWidget {
  const WorkoutStatsLineChart({Key? key, required this.data}) : super(key: key);
  final StatsMeasurement data;
  @override
  _WorkoutStatsLineChartState createState() => _WorkoutStatsLineChartState();
}

class _WorkoutStatsLineChartState extends State<WorkoutStatsLineChart> {
  late StatsMeasurement data = widget.data;
  late List<FlSpot> chartDisplayPoints;
  late double xAxisMin, xAxisMax;
  late double intervalY;
  late List<double> listDisplayRange;
  bool displayDataYAxis = false;

  @override
  Widget build(BuildContext context) {
    context.watch<UserStatsMeasurements>().statsMeasurement;
    chartDisplayPoints = data.measurementValues.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    xAxisMax = data.measurementValues.length.toDouble()-1;
    xAxisMin = 0; //xAxisMax - 11;
    if (xAxisMin < 0) {
      xAxisMin = 0;
    }

    listDisplayRange = data.measurementValues.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1);
    intervalY = (listDisplayRange.reduce(max) / 3).roundToDouble();
    if (intervalY < 1) {
      intervalY = 1;
    }

    if (chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1).every((e) => e.y == chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1).first.y)) {
      displayDataYAxis = false;
    } else {
      displayDataYAxis = true;
    }

    return Container(
      margin: EdgeInsets.only(left: displayDataYAxis ? 0 : 48, right: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(18),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            right: 8, left: 2, top: 16, bottom: 0),
        child: LineChart(
          chartData(),
        ),
      ),
    );
  }

  Widget horizontalAxis(double value, TitleMeta meta) {
    return Transform.rotate(
      angle: -pi/6,
      child: Container(
        margin: const EdgeInsets.only(top:5, right: 25),
        child: Text(
          DateFormat('dd/MM/yy').format(DateTime.parse(data.measurementDates[value.toInt()])),
          style: const TextStyle(
            color: appQuarternaryColour,
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget verticalAxis(double value, TitleMeta meta) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    String valueString;
    if (value < 0) {
      valueString = value.toStringAsPrecision(3).replaceAll(regex, '');
    } else if (value > 9999) {
      valueString = value.toStringAsPrecision(5).replaceAll(regex, '');
    } else {
      valueString = value.toString().replaceAll(regex, '');
    }
    return Text(
      valueString,
      style: const TextStyle(
        color: appQuarternaryColour,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      textAlign: TextAlign.left,
    );
  }

  LineChartData chartData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: appQuinaryColour.withOpacity(0.9),
          getTooltipItems: (value) {
            return value.map((e) => LineTooltipItem(
              "${data.measurementValues[e.x.toInt()]} \n ${DateFormat('dd/MM/yy').format(DateTime.parse(data.measurementDates[e.x.toInt()]))} ",
              const TextStyle(
                color: appSecondaryColour,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )).toList();
          },
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        //horizontalInterval: intervalY,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: appQuarternaryColour.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: appQuarternaryColour.withOpacity(0.3),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 2,
            getTitlesWidget: horizontalAxis,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: displayDataYAxis,
            //interval: intervalY,
            getTitlesWidget: verticalAxis,
            reservedSize: 28,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: appQuarternaryColour, width: 1),
          left: BorderSide(color: appQuarternaryColour, width: 1),
          top: BorderSide(color: appQuarternaryColour, width: 1),
          right: BorderSide(color: appQuarternaryColour, width: 1),
        ),
      ),
      minX: xAxisMin,
      maxX: xAxisMax,
      minY: (listDisplayRange.reduce(min).roundToDouble()-0.6).roundToDouble(),
      maxY: (listDisplayRange.reduce(max).roundToDouble()+0.6).roundToDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1),
          isCurved: true,
          curveSmoothness: 0.3,
          color: appSecondaryColour,
          barWidth: 2,
          isStrokeCapRound: true,
          preventCurveOverShooting: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            //color: appSecondaryColour.withOpacity(0.1),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  appSecondaryColour.withOpacity(0.2),
                  appSecondaryColour.withBlue(140).withOpacity(0.2),
                ]),
          ),
        ),
      ],
    );
  }
}
