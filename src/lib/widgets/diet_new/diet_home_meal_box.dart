import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/models/diet/food_data_list_item.dart';
import 'package:fitness_tracker/widgets/general/default_modal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../pages/diet/diet_barcode_scanner.dart';
import '../../pages/diet/diet_food_search_page.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/page_change_provider.dart';
import 'diet_home_bottom_button.dart';
import 'diet_home_food_display.dart';


class DietHomeMealBox extends StatelessWidget {
  DietHomeMealBox({Key? key,
    required this.foodList,
    required this.calorieInformation,
    required this.proteinsInformation,
    required this.carbsInformation,
    required this.fatsInformation,
    required this.title,
  }) : super(key: key);
  List<ListFoodItem> foodList;
  String calorieInformation;
  String proteinsInformation;
  String carbsInformation;
  String fatsInformation;
  String title;

  final double radius = 10;




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
                        context.read<PageChange>().changePageCache(FoodSearchPage(category: title));
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
                      context.read<PageChange>().changePageCache(BarcodeScannerPage(category: title));
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
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: Container(
        decoration: const BoxDecoration(
          color: appTertiaryColour,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: Ink(
            child: InkWell(
              onTap: () => context.read<PageChange>().changePageCache(FoodSearchPage(category: title)),
              onLongPress: () => foodMenu(context),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: boldTextStyle.copyWith(
                        color: appSecondaryColour,
                        fontSize: 18.h,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 8,
                            sections: [
                              PieChartSectionData(
                                value: proteinsInformation == "0"  && carbsInformation == "0"  && fatsInformation == "0" ? 1 : 0,
                                color: Colors.grey,
                                radius: radius,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: double.parse(proteinsInformation),
                                color: Colors.redAccent,
                                radius: radius,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: double.parse(carbsInformation),
                                color: Colors.blueAccent,
                                radius: radius,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: double.parse(fatsInformation),
                                color: Colors.purple,
                                radius: radius,
                                showTitle: false,
                              ),
                            ]
                          ),
                        ),
                        Center(
                          child: Text(
                            "${calorieInformation}Kcal",
                            style: boldTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 18.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                      left: 28.0.w,
                      right: 28.0.w,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Proteins:",
                              style: boldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16.h,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              " ${proteinsInformation}g",
                              style: boldTextStyle.copyWith(
                                color: Colors.redAccent,
                                fontSize: 16.h,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Carbs:",
                              style: boldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16.h,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              " ${carbsInformation}g",
                              style: boldTextStyle.copyWith(
                                color: Colors.blueAccent,
                                fontSize: 16.h,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Fats:",
                              style: boldTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16.h,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              " ${fatsInformation}g",
                              style: boldTextStyle.copyWith(
                                color: Colors.purple,
                                fontSize: 16.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Divider(
                      height: 4,
                      color: appQuinaryColour,
                      thickness: 2,
                    ),
                  ),
                  Ink(
                    child: InkWell(
                      onTap: () {
                        if (context.mounted) {
                          ModalBottomSheet.showModal(
                            context,
                            DietHomeFoodDisplay(
                              width: double.maxFinite,
                              title: title,
                              foodList: foodList,
                              caloriesTotal: double.parse(calorieInformation),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.book,
                              color: appSecondaryColour,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "View Meal Diary",
                                style: boldTextStyle.copyWith(fontSize: 14.w),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
