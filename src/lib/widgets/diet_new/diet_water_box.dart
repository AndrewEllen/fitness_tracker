import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class DietWaterDisplay extends StatefulWidget {
  const DietWaterDisplay({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title,
  }) : super(key: key);
  final double bigContainerMin, height, margin, width;
  final String title;

  @override
  State<DietWaterDisplay> createState() => _DietWaterDisplayState();
}

class _DietWaterDisplayState extends State<DietWaterDisplay> {

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
             // borderRadius: BorderRadius.only(
             //   topRight: Radius.circular(10),
             //   topLeft: Radius.circular(10),
             // ),
              color: appTertiaryColour,
            ),
            width: double.maxFinite.w,
            //height: 240.h,
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: boldTextStyle.copyWith(
                              color: appSecondaryColour,
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${context.read<UserNutritionData>().userDailyNutrition.water/2}L",
                            style: boldTextStyle.copyWith(
                              color: const Color.fromRGBO(43, 103, 217, 1.0),
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RatingBar(
                  allowHalfRating: true,
                  ratingWidget: RatingWidget(
                    full: const Icon(
                        MdiIcons.water,
                      color: Color.fromRGBO(43, 103, 217, 1.0),
                    ),
                    half: const Icon(
                      MdiIcons.waterOutline,
                      color: Color.fromRGBO(43, 103, 217, 1.0),
                    ),
                    empty: const Icon(
                        MdiIcons.plusBoxOutline,
                    ),
                  ),
                  tapOnlyMode: false,
                  onRatingUpdate: (rating) {
                    FirebaseAnalytics.instance.logEvent(name: 'updated_water');
                    context.read<UserNutritionData>().updateWater(rating);
                  },
                  itemCount: context.read<UserNutritionData>().userDailyNutrition.water.round() + 1,
                  initialRating: context.read<UserNutritionData>().userDailyNutrition.water,
                )
              ],
            ),
          ),
          Container(
            height: 24.h,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: appTertiaryColour,
              //borderRadius: BorderRadius.only(
              //  bottomLeft: Radius.circular(10),
              //  bottomRight: Radius.circular(10),
              //)
            ),
          )
        ],
      ),
    );
  }
}
