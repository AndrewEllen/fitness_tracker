import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/widgets/general/screen_width_expanding_container.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../pages/diet/diet_barcode_scanner.dart';
import '../../pages/diet/diet_food_display_page.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../diet/diet_category_add_bar.dart';
import '../diet/food_list_item_box.dart';
import '../general/app_container_header.dart';
import '../general/app_default_button.dart';
import 'diet_home_bottom_button.dart';
import 'food_list_item_box_new.dart';

class DietHomeFoodDisplay extends StatefulWidget {
  const DietHomeFoodDisplay({Key? key, required this.width,
    required this.title, required this.foodList, required this.caloriesTotal
  }) : super(key: key);
  final double width, caloriesTotal;
  final String title;
  final List<ListFoodItem> foodList;

  @override
  State<DietHomeFoodDisplay> createState() => _DietHomeFoodDisplayState();
}

class _DietHomeFoodDisplayState extends State<DietHomeFoodDisplay> {

  foodMenu(BuildContext context) async {
    FirebaseAnalytics.instance.logEvent(name: 'food_add_pressed');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Spacer(),

                  FloatingActionButton(
                    backgroundColor: appSecondaryColour,
                    child: const Icon(
                        Icons.search
                    ),
                    onPressed: () {
                      context.read<PageChange>().changePageCache(FoodSearchPage(category: widget.title));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(),

                  FloatingActionButton(
                    backgroundColor: appSecondaryColour,
                    child: const Icon(
                        MdiIcons.barcodeScan
                    ),
                    onPressed: () {
                      context.read<PageChange>().changePageCache(BarcodeScannerPage(category: widget.title));
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(),

                ],
              ),
            ],
          ),
        );
      },
    );
  }


  editEntry(BuildContext context, int index, String value) async {
    FirebaseAnalytics.instance.logEvent(name: 'food_edit_pressed');
    final double radius = 10;

    String servingCalculation(String nutritionValue) {
      try {
        return ((double.parse(nutritionValue) / 100)
            * (double.parse(widget.foodList[index].foodServingSize) *
                double.parse(widget.foodList[index].foodServings))).toStringAsFixed(0);
      } catch (error) {
        return "0";
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,

            content: SizedBox(
              width: 1000.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: appSecondaryColour,
                      fontWeight: FontWeight.bold,
                      fontSize: 22.h,
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Divider(
                      color: Colors.transparent,
                      thickness: 1,
                    ),
                  ),

                  Row(
                    children: [
                      const Spacer(),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            PieChart(
                              PieChartData(
                                  sectionsSpace: 8,
                                  sections: [
                                    PieChartSectionData(
                                      value: (widget.foodList[index].foodItemData.proteins == "0" || widget.foodList[index].foodItemData.proteins == "")
                                          && (widget.foodList[index].foodItemData.carbs == "0" || widget.foodList[index].foodItemData.carbs == "")
                                          && (widget.foodList[index].foodItemData.fat == "0" || widget.foodList[index].foodItemData.fat == "")
                                          ? 1 : 0,
                                      color: Colors.grey,
                                      radius: radius,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: double.tryParse(widget.foodList[index].foodItemData.proteins) ?? 0,
                                      color: Colors.redAccent,
                                      radius: radius,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: double.tryParse(widget.foodList[index].foodItemData.carbs) ?? 0,
                                      color: Colors.blueAccent,
                                      radius: radius,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: double.tryParse(widget.foodList[index].foodItemData.fat) ?? 0,
                                      color: Colors.purple,
                                      radius: radius,
                                      showTitle: false,
                                    ),
                                  ]
                              ),
                            ),
                            Center(
                              child: Text(
                                "${servingCalculation(widget.foodList[index].foodItemData.calories)}Kcal",
                                style: boldTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 18.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            servingCalculation(widget.foodList[index].foodItemData.proteins)
                                + "g of Protein",
                            style: const TextStyle(
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            servingCalculation(widget.foodList[index].foodItemData.carbs)
                                + "g of Carbs",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            servingCalculation(widget.foodList[index].foodItemData.fat)
                                + "g of Fat",
                            style: const TextStyle(
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.transparent,
                      thickness: 1,
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

                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(
                        MdiIcons.delete
                    ),
                    onPressed: () {
                      context.read<UserNutritionData>().deleteFoodFromDiary(index, widget.title);
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(flex: 4,),

                  FloatingActionButton(
                    backgroundColor: appSecondaryColour,
                    child: const Icon(
                        Icons.edit
                    ),
                    onPressed: () {
                      context.read<UserNutritionData>().setCurrentFoodItem(widget.foodList[index].foodItemData);
                      context.read<UserNutritionData>().updateCurrentFoodItemServings(widget.foodList[index].foodServings);
                      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(widget.foodList[index].foodServingSize);
                      print(widget.foodList[index].foodItemData.recipe);
                      context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.title, editDiary: true, index: index, recipeEdit: widget.foodList[index].foodItemData.recipe ?? false,));

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),

                  const Spacer(),

                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              //borderRadius: BorderRadius.only(
              //  topRight: Radius.circular(10),
              //  topLeft: Radius.circular(10),
              //),
              color: appTertiaryColour,
            ),
            width: double.maxFinite.w,
            //height: 240.h,
            child: Column(
              children: [
                SizedBox(
                  height: 60.h,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.title,
                            style: boldTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 24.h,
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
                              color: Colors.white,
                              fontSize: 24.h,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: appPrimaryColour,
                ),
                context.read<UserNutritionData>().isCurrentFoodItemLoaded ? Padding(
                  padding: const EdgeInsets.only(top:4.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.foodList.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {

                      return FoodListItemBoxNew(
                        key: UniqueKey(),
                        foodObject: widget.foodList[index],
                        onTap: () => editEntry(
                          this.context,
                          index,
                          widget.foodList[index].foodItemData.foodName,
                        ),
                      );
                    },
                  ),
                ) : const SizedBox.shrink(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              backgroundColor: appSecondaryColour,
              child: const Icon(
                  Icons.add
              ),
              onPressed: () => foodMenu(context)
            ),
          ),
        ],
      ),
    );
  }
}
