import 'package:charts_flutter/flutter.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as chartColour;

class dailyWorkoutVolume {
  final String routine;
  final double volume;
  final Color barChartColour;

  dailyWorkoutVolume({
    required this.routine,
    required this.volume,
    required this.barChartColour,
  });
}

class HomeBarChart extends StatelessWidget {
  HomeBarChart({required this.chartWorkoutData, required this.chartHeight, required this.chartWidth});
  final List<dailyWorkoutVolume> chartWorkoutData;
  final double chartHeight, chartWidth;

  @override
  Widget build(BuildContext context) {

    List <Series<dailyWorkoutVolume, String>> series = [
      Series(
          id: "Routine",
          data: chartWorkoutData,
          domainFn: (dailyWorkoutVolume series, _) {
            return series.routine[0] + series.routine[1];
          },
          measureFn: (dailyWorkoutVolume series, _) {
            return series.volume;
          },
          colorFn: (dailyWorkoutVolume series, _) {
            return series.barChartColour;
          },
          labelAccessorFn: (dailyWorkoutVolume series, _) {
            if (series.volume > 9999) {
              return '  ${series.volume.toStringAsFixed(0)}  '; //Place holder incase of changing format
            } else {
              return '  ${series.volume.toStringAsFixed(0)}  ';
            }

          },
      ),
    ];

    return Container(
      height: chartHeight,
      width: chartWidth,
      margin: EdgeInsets.all(2),
      child: BarChart(
        series,
        animate: true,
        animationDuration: Duration(milliseconds: 250),
        defaultRenderer: BarRendererConfig(
          maxBarWidthPx: 50,
          barRendererDecorator: BarLabelDecorator(

            insideLabelStyleSpec: TextStyleSpec(
              color: chartColour.ColorUtil.fromDartColor(Colors.white),
            ),
            outsideLabelStyleSpec: TextStyleSpec(
              color: chartColour.ColorUtil.fromDartColor(Colors.white),
              fontSize: 11,
            ),
            //labelPlacement: ,
          ),
        ),
        domainAxis: OrdinalAxisSpec(
          renderSpec: SmallTickRendererSpec(
            labelStyle: TextStyleSpec(
              color: chartColour.ColorUtil.fromDartColor(Colors.white),
            ),
            lineStyle: LineStyleSpec(
              color: chartColour.ColorUtil.fromDartColor(appQuarternaryColour),
            ),
          ),
        ),
        primaryMeasureAxis: NumericAxisSpec(
          renderSpec: GridlineRendererSpec(
            labelStyle: TextStyleSpec(
              fontSize: 0,
            ),
            lineStyle: LineStyleSpec(
              color: chartColour.ColorUtil.fromDartColor(appQuarternaryColour),
            ),
          ),
        ),
        layoutConfig: LayoutConfig(
          topMarginSpec: MarginSpec.fixedPixel(18),
          bottomMarginSpec: MarginSpec.fixedPixel(18),
          rightMarginSpec: MarginSpec.fixedPixel(0),
          leftMarginSpec: MarginSpec.fixedPixel(0),
        ),
      ),
    );
  }
}
