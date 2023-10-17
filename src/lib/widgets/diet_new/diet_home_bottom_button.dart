import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/general/page_change_provider.dart';

class DietHomeBottomButton extends StatelessWidget {
  const DietHomeBottomButton({Key? key, required this.category}) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      onTap: () => context.read<PageChange>().changePageCache(FoodSearchPage(category: category)),
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
                "Add Food",
                style: boldTextStyle.copyWith(
                  fontSize: 17.w,
                ),
              )
          ),
        ),
      ),
    );
  }
}
