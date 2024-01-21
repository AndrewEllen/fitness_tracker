import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.all(10),
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
              padding: const EdgeInsets.all(8.0),
              child: Text(
                dataToDisplay,
                style: smallFont ? bigMiddleFont ? boldTextStyle.copyWith(fontSize: 20) : boldTextStyle.copyWith(fontSize: 10) : boldTextStyle,
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
