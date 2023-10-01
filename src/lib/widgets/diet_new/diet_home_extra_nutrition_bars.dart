import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants.dart';

class DietHomeExtraNutritionBars extends StatefulWidget {
  const DietHomeExtraNutritionBars({Key? key}) : super(key: key);

  @override
  State<DietHomeExtraNutritionBars> createState() => _DietHomeExtraNutritionBarsState();
}

class _DietHomeExtraNutritionBarsState extends State<DietHomeExtraNutritionBars> {
  double expandContainer = 0;

  void onTap() {
    updateContainerSize();
    print(expandContainer);
  }

  void updateContainerSize() {
    setState(() {
      if (expandContainer > 0) {
        expandContainer = 0;
      } else {
        expandContainer = 460;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.h, end: expandContainer.h),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, _) {
          return Column(
            children: [
              Container(
                width: double.maxFinite,
                height: value,
                color: appTertiaryColour,
              ),
              InkWell(
                borderRadius: const BorderRadius.only(
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
                    child: Center(
                        child: Text(
                          value > 0 ? "Hide" : "See More",
                          style: boldTextStyle,
                        )
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
