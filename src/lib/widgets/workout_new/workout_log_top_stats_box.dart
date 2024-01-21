import 'package:flutter/material.dart';

import '../../constants.dart';

class WorkoutLogTopStatsBox extends StatelessWidget {
  WorkoutLogTopStatsBox({Key? key, required this.dataToDisplay, required this.title, this.noMargin = false, this.bottomText = "Total"}) : super(key: key);
  late String dataToDisplay;
  late String title;
  late String bottomText;
  late bool noMargin;

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
            ),
            Text(
              dataToDisplay,
              style: boldTextStyle,
            ),
            Text(
              bottomText,
              style: boldTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
