import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../widgets/diet_new/diet_home_daily_nutrition_display.dart';

class DietHomePageNew extends StatelessWidget {
  const DietHomePageNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
          child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Center(
                    child: DailyNutritionDisplay(),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
