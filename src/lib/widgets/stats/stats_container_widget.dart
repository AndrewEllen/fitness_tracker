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
    required this.index,
    Key? key,
  }) : super(key: key);
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

    onTap() {
      context.read<PageChange>().changePageCache(
        MeasurementTrackingPage(
          index: index,
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                  ) : StatsLineChart(index: index),
                ),
              ),
              SizedBox(height: 15),
              Divider(
                color: appQuarternaryColour,
                height: 0,
              ),
              Material(
                type: MaterialType.transparency,
                child: SizedBox(
                  height: 30,
                  child: Ink(
                    child: InkWell(
                      onTap: onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Open Measurement",
                            style: boldTextStyle.copyWith(color: appSecondaryColour),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: appSecondaryColour,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
