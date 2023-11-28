import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/diet/exercise_calories_list_item.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/page_change_provider.dart';
import '../general/app_default_button.dart';

class ScreenWidthButton extends StatelessWidget {
  const ScreenWidthButton({Key? key, required this.label, required this.onTap}) : super(key: key);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //borderRadius: BorderRadius.only(
      //  bottomRight: Radius.circular(10),
      //  bottomLeft: Radius.circular(10),
      //),
      onTap: onTap,
      child: Ink(
        decoration: const BoxDecoration(
         // borderRadius: BorderRadius.only(
         //   bottomRight: Radius.circular(10),
         //   bottomLeft: Radius.circular(10),
         // ),
          boxShadow: [
            basicAppShadow
          ],
          color: appSecondaryColour,
        ),
        child: SizedBox(
          width: double.maxFinite.w,
          height: 30.h,
          child: Center(
              child: Text(
                label,
                style: boldTextStyle.copyWith(
                  fontSize: 16.h,
                ),
              )
          ),
        ),
      ),
    );
  }
}
