import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class WorkoutLogTopStatsBox extends StatelessWidget {
  WorkoutLogTopStatsBox({Key? key, required this.dataToDisplay, required this.title, this.noMargin = false, this.bottomText = "Total", this.smallFont = false, this.bigMiddleFont = false}) : super(key: key);
  late String dataToDisplay;
  late String title;
  late String bottomText;
  late bool noMargin;
  late bool smallFont;
  late bool bigMiddleFont;


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: appTertiaryColour,
            border: Border.all(
              color: appQuinaryColour,
              width: 2,
            )
        ),
        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
        margin: EdgeInsets.only(
          left: noMargin ? 0 : 12,
          right: noMargin ? 0 : 12,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: boldTextStyle,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.only(top:8.0.h, bottom:8.0.h),
              child: Text(
                dataToDisplay,
                style: smallFont ? bigMiddleFont ? boldTextStyle.copyWith(fontSize: 18) : boldTextStyle.copyWith(fontSize: 10) : boldTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              bottomText,
              style: smallFont ? boldTextStyle.copyWith(fontSize: 12) : boldTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
