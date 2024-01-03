import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class WorkoutHomePageNew extends StatefulWidget {
  const WorkoutHomePageNew({Key? key}) : super(key: key);

  @override
  State<WorkoutHomePageNew> createState() => _WorkoutHomePageNewState();
}

class _WorkoutHomePageNewState extends State<WorkoutHomePageNew> {
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
          child: Column(children: [
            Container(
              color: appTertiaryColour,
              width: double.maxFinite,
              height: 200.h,
            ),
          ],
          ),
        ),
      ),
    );
  }
}
