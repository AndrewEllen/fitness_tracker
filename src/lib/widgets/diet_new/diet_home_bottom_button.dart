import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class DietHomeBottomButton extends StatelessWidget {
  const DietHomeBottomButton({Key? key}) : super(key: key);

  void onTap() {
    print("Clicked");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      onTap: onTap,
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
          color: appSecondaryColour,
        ),
        child: SizedBox(
          width: double.maxFinite.w,
          height: 30.h,
          child: const Center(
              child: Text(
                "See More",
                style: boldTextStyle,
              )
          ),
        ),
      ),
    );
  }
}
