import 'package:fitness_tracker/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../models/stats_model.dart';
import '../providers/user_measurements.dart';

class StatsLineChart extends StatefulWidget {
  StatsLineChart({Key? key, required this.index}) : super(key: key);
  late int index;
  @override
  _StatsLineChartState createState() => _StatsLineChartState();
}

class _StatsLineChartState extends State<StatsLineChart> {
  late List<StatsMeasurement> data = context.read<UserStatsMeasurements>().statsMeasurement;
  late List<FlSpot> chartDisplayPoints;
  late double xAxisMin, xAxisMax;
  late double intervalY;
  late List<double> listDisplayRange;
  bool displayDataYAxis = false;

  @override
  Widget build(BuildContext context) {
    context.watch<UserStatsMeasurements>().statsMeasurement;
    chartDisplayPoints = data[widget.index].measurementValues.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    xAxisMax = data[widget.index].measurementValues.length.toDouble()-1;
    xAxisMin = xAxisMax - 11;
    if (xAxisMin < 0) {
      xAxisMin = 0;
    };

    listDisplayRange = data[widget.index].measurementValues.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1);
    intervalY = (listDisplayRange.reduce(max) / 3).roundToDouble();
    if (intervalY < 1) {
      intervalY = 1;
    }

    if (chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1).every((e) => e.y == chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1).first.y)) {
      displayDataYAxis = false;
    } else {
      displayDataYAxis = true;
    }

    return AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            margin: EdgeInsets.only(left: displayDataYAxis ? 0 : 48),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 20, left: 4, top: 16, bottom: 12),
              child: LineChart(
                chartData(),
              ),
            ),
          ),
    );
  }

  Widget horizontalAxis(double value, TitleMeta meta) {
    return Transform.rotate(
      angle: -pi/5,
      child: Container(
        margin: const EdgeInsets.only(top:5, right: 45),
        child: Text(
          DateFormat('dd/MM/yyyy').format(DateTime.parse(data[widget.index].measurementDates[value.toInt()])),
          style: const TextStyle(
            color: appQuarternaryColour,
            fontWeight: FontWeight.w500,
            fontSize: 12,
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
        fontSize: 15,
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
                "${data[widget.index].measurementValues[e.x.toInt()]} \n ${data[widget.index].measurementDates[e.x.toInt()]} ",
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
        drawVerticalLine: false,
        horizontalInterval: intervalY,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: appQuarternaryColour,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: appQuarternaryColour,
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
            reservedSize: 30,
            interval: 3,
            getTitlesWidget: horizontalAxis,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: displayDataYAxis,
            interval: intervalY,
            getTitlesWidget: verticalAxis,
            reservedSize: 48,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: appQuarternaryColour, width: 1),
            left: BorderSide(color: appQuarternaryColour, width: 1),
          ),
      ),
      minX: xAxisMin,
      maxX: xAxisMax,
      minY: listDisplayRange.reduce(min),
      maxY: listDisplayRange.reduce(max),
      lineBarsData: [
        LineChartBarData(
          spots: chartDisplayPoints.sublist(xAxisMin.toInt(),xAxisMax.toInt()+1),
          isCurved: false,
          color: appSecondaryColour,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: appSecondaryColour.withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}