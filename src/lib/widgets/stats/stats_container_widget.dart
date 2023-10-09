import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:fitness_tracker/widgets/stats/stats_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/stats/stats_model.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    required this.minHeight,
    required this.maxHeight,
    required this.height,
    required this.width,
    required this.margin,
    required this.index,
    Key? key,
  }) : super(key: key);
  final double
      minHeight,
      maxHeight,
      height,
      margin,
      width;
  final int index;

  @override
  Widget build(BuildContext context) {

    final List<StatsMeasurement> data = context.read<UserStatsMeasurements>().statsMeasurement;

    double fontSize = 21;
    if (data[index].measurementName.length > 15) {
      fontSize -= data[index].measurementName.length.toDouble()/15;
      if (fontSize < 18) {
        fontSize = 18;
      }
    }
    double _height = 344;
    return ScreenWidthContainer(
        minHeight: _height,
        maxHeight: _height,
        height: _height,
        margin: 0,
        child: Column(
          children: [
            Container(
              height: 32,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2, color: appQuinaryColour),
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 24.h,
                  child: Text(
                    data[index].measurementName.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  left: margin/4,
                  right: margin*0.01,
                ),
                height: (337/1.34).h,
                width: width,
                child: data[index].measurementValues.isEmpty || data[index].measurementValues.length < 2  ? const Center(
                    child: Text(
                      "Not Enough Data to Display",
                      style: TextStyle(
                        color: appQuarternaryColour,
                        fontSize: 22,
                      ),
                    )
                ) : StatsLineChart(index: index),
              ),
            ),
            Container(
              height: 42,
              width: double.infinity,
              margin: EdgeInsets.only(top: (6 + margin/2)),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2, color: appQuinaryColour),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                    top: margin/2,
                    left: margin/2,
                    right: margin/2,
                  ),
                  width: double.infinity,
                  child: AppButton(
                      onTap: () => context.read<PageChange>().changePageCache(
                          MeasurementTrackingPage(
                            index: index,
                          ),
                      ),
                      buttonText: "Open",
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
