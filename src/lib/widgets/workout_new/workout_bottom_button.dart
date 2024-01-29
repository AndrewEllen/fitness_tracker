import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/general/page_change_provider.dart';

class WorkoutBottomButton extends StatelessWidget {
  WorkoutBottomButton({Key? key, required this.onTap, required this.text, this.compact = false, this.altColour = false}) : super(key: key);
  VoidCallback onTap;
  String text;
  bool compact, altColour;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
         // borderRadius: BorderRadius.only(
         //   bottomRight: Radius.circular(10),
         //   bottomLeft: Radius.circular(10),
         // ),
          boxShadow: const [
            basicAppShadow
          ],
          color: altColour ? appTertiaryColour : appSecondaryColour,
        ),
        child: SizedBox(
          width: double.maxFinite.w,
          height: compact ? 24.h : 30.h,
          child: Center(
              child: Text(
                text,
                style: boldTextStyle.copyWith(
                  fontSize: compact ? 14.w : 17.w,
                  color: altColour ? appSecondaryColour : Colors.white,
                ),
              )
          ),
        ),
      ),
    );
  }
}
