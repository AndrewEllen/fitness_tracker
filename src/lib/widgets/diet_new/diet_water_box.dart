import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../pages/diet/diet_barcode_scanner.dart';
import '../../pages/diet/diet_food_display_page.dart';
import '../diet/diet_category_add_bar.dart';
import '../diet/food_list_item_box.dart';
import '../general/app_container_header.dart';
import '../general/app_default_button.dart';
import 'diet_home_bottom_button.dart';

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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
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
                            "${context.read<UserNutritionData>().water/2}L",
                            style: boldTextStyle.copyWith(
                              color: appSecondaryColour,
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RatingBar(
                  allowHalfRating: false,
                  ratingWidget: RatingWidget(
                    full: const Icon(
                        MdiIcons.cup
                    ),
                    half: const Icon(
                        MdiIcons.cupOutline
                    ),
                    empty: const Icon(
                        MdiIcons.plusBoxOutline
                    ),
                  ),
                  tapOnlyMode: true,
                  onRatingUpdate: (rating) {
                    context.read<UserNutritionData>().updateWater(rating);
                  },
                  itemCount: context.read<UserNutritionData>().water.round() + 1,
                  initialRating: context.read<UserNutritionData>().water,
                )
              ],
            ),
          ),
          Container(
            height: 30.h,
            width: double.maxFinite,
            decoration: const BoxDecoration(
              color: appTertiaryColour,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            ),
          )
        ],
      ),
    );
  }
}
