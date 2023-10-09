import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:flutter/material.dart';
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

class DietHomeFoodDisplay extends StatefulWidget {
  const DietHomeFoodDisplay({Key? key, required this.bigContainerMin,
    required this.height, required this.margin, required this.width,
    required this.title, required this.foodList, required this.caloriesTotal
  }) : super(key: key);
  final double bigContainerMin, height, margin, width, caloriesTotal;
  final String title;
  final List<ListFoodItem> foodList;

  @override
  State<DietHomeFoodDisplay> createState() => _DietHomeFoodDisplayState();
}

class _DietHomeFoodDisplayState extends State<DietHomeFoodDisplay> {
  editEntry(BuildContext context, int index, String value, double width) {

    double buttonSize = width/17;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Edit Selection",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: RichText(
            text: TextSpan(text: 'Editing: ',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 16.h,
              ),
              children: <TextSpan>[
                TextSpan(text: value,
                  style: TextStyle(
                    color: appSecondaryColour,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.h,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: Colors.red,
                      buttonText: "Delete",
                      onTap: () {

                        context.read<UserNutritionData>().deleteFoodFromDiary(index, widget.title);

                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Edit",
                      onTap: () {
                        context.read<UserNutritionData>().setCurrentFoodItem(widget.foodList[index].foodItemData);

                        context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.foodList[index].foodServings);
                        context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.foodList[index].foodServingSize);
                        print(widget.foodList[index].foodItemData.recipe);
                        context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.title, editDiary: true, index: index, recipeEdit: widget.foodList[index].foodItemData.recipe ?? false,));

                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    );
  }






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
                            "${widget.caloriesTotal.toStringAsFixed(0)} Kcal",
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
                context.read<UserNutritionData>().isCurrentFoodItemLoaded ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.foodList.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {

                    return FoodListDisplayBox(
                      key: UniqueKey(),
                      width: widget.width,
                      foodObject: widget.foodList[index],
                      icon: MdiIcons.squareEditOutline,
                      iconColour: Colors.white,
                      onTapIcon: () => editEntry(
                        this.context,
                        index,
                        widget.foodList[index].foodItemData.foodName,
                        widget.width,
                      ),
                    );
                  },
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
          Stack(
            children: [
              DietHomeBottomButton(
                category: widget.title,
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 60.w,
                    height: 29.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                      child: Material(
                        type: MaterialType.transparency,
                        //shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            MdiIcons.barcodeScan,
                            color: Colors.white,
                          ),
                          onPressed: () => context.read<PageChange>().changePageCache(BarcodeScannerPage(category: widget.title)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}