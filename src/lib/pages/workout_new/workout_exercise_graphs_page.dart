import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../constants.dart";
import "../../providers/workout/workoutProvider.dart";
import "../../widgets/general/horizontal_bar_chart.dart";


class ExerciseGraphsPage extends StatefulWidget {
  const ExerciseGraphsPage({Key? key}) : super(key: key);

  @override
  State<ExerciseGraphsPage> createState() => _ExerciseGraphsPageState();
}

class _ExerciseGraphsPageState extends State<ExerciseGraphsPage> {

  int touchedIndex = -1;


  @override
  Widget build(BuildContext context) {

    context.read<WorkoutProvider>().exerciseMaxRepAndWeight;


    BarChartGroupData makeGroupData(
        int x,
        double y, {
          bool isTouched = false,
          Color? barColor,
          double width = 18,
          List<int> showTooltips = const [],
        }) {
      barColor ??= appSecondaryColour;
      return BarChartGroupData(
        x: x,
        barRods: [
          BarChartRodData(
            toY: isTouched ? y + 1 : y,
            color: isTouched ? appSecondaryColourDark : barColor,
            width: width,
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 20,
              color: appTertiaryColour,
            ),
          ),
        ],
        showingTooltipIndicators: showTooltips,
      );
    }

    List<BarChartGroupData> showingGroups() => List.generate(14, (i) {
      switch (i) {
        case 0:
          return makeGroupData(0, 5, isTouched: i == touchedIndex);
        case 1:
          return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
        case 2:
          return makeGroupData(2, 5, isTouched: i == touchedIndex);
        case 3:
          return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
        case 4:
          return makeGroupData(4, 9, isTouched: i == touchedIndex);
        case 5:
          return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
        case 6:
          return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
        case 7:
          return makeGroupData(0, 5, isTouched: i == touchedIndex);
        case 8:
          return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
        case 9:
          return makeGroupData(2, 5, isTouched: i == touchedIndex);
        case 10:
          return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
        case 11:
          return makeGroupData(4, 9, isTouched: i == touchedIndex);
        case 12:
          return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
        case 13:
          return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
        case 14:
          return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
        default:
          return throw Error();
      }
    });

    Widget getTitles(double value, TitleMeta meta) {
      const style = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      Widget text;
      switch (value.toInt()) {
        case 0:
          text = const Text('M', style: style);
          break;
        case 1:
          text = const Text('T', style: style);
          break;
        case 2:
          text = const Text('W', style: style);
          break;
        case 3:
          text = const Text('T', style: style);
          break;
        case 4:
          text = const Text('F', style: style);
          break;
        case 5:
          text = const Text('S', style: style);
          break;
        case 6:
          text = const Text('S', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: text,
      );
    }

    Map data = context.read<WorkoutProvider>().exerciseMaxRepAndWeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: data.isEmpty ? const Center(
          child: Text(
            "No data yet",
            style: boldTextStyle,
          ),
        ) : HorizontalBarChart(
          label: "Max Reps Per Weight",
          values: data,
        ),
      ),
    );
  }
}

