import 'dart:async';
import 'dart:io';
import 'package:fitness_tracker/pages/food_nutrition_list_edit.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import '../helpers/analyse_barcode.dart';
import '../helpers/extract_image_byte_data.dart';
import '../helpers/nutrition_tracker.dart';
import '../models/food_item.dart';
import '../providers/database_get.dart';
import 'package:provider/provider.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../widgets/app_default_button.dart';
import '../widgets/diet_category_box.dart';
import '../widgets/diet_home_macro_nutrition_display.dart';
import '../widgets/screen_width_container.dart';
import 'diet_barcode_scanner.dart';
import 'diet_food_display_page.dart';

class DietHomePage extends StatefulWidget {
  DietHomePage({Key? key}) : super(key: key);

  @override
  State<DietHomePage> createState() => _DietHomePageState();
}

class _DietHomePageState extends State<DietHomePage> {

  void scanBarcode(dynamic displayImage) async {
    //[LO3.7.3.5]

    final imageFile = await getImageFileFromAssets(displayImage);

    String barcodeDisplayValue = await analyseBarcode(imageFile) as String;

    print("Checking Food");

    if (barcodeDisplayValue != null) {

      print("Firebase");
      FoodItem newFoodItem = CheckFoodBarcode(barcodeDisplayValue);
      context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);


      print(context.read<UserNutritionData>().currentFoodItem.foodName);

    }

    context.read<PageChange>().changePageCache(FoodDisplayPage(category: 'Breakfast',));

  }


  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().isCurrentFoodItemLoaded;

    double _margin = 15;
    double _bigContainerMin = 230;
    double _smallContainerMin = 95;
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
      return true;
    },
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                NutritionHomeStats(
                  bigContainerMin: _bigContainerMin,
                  height: _height,
                  margin: _margin,
                  width: _width,
                ),

                Container(
                  height: _height/1.8,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: ScrollController(),
                    children: [
                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Breakfast",
                        foodList: context.read<UserNutritionData>().foodListItemsBreakfast,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Lunch",
                        foodList: context.read<UserNutritionData>().foodListItemsLunch,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Dinner",
                        foodList: context.read<UserNutritionData>().foodListItemsDinner,
                      ),

                      DietCategoryBox(
                        bigContainerMin: _smallContainerMin,
                        height: _height,
                        margin: _margin,
                        width: _width,
                        title: "Snacks",
                        foodList: context.read<UserNutritionData>().foodListItemsSnacks,
                      ),

                      ScreenWidthContainer(
                        minHeight: _smallContainerMin * 0.2,
                        maxHeight: _smallContainerMin * 1.5,
                        height: (_height / 100) * 6,
                        margin: _margin / 1.5,
                        child: FractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: AppButton(
                          buttonText: "Barcode Test",
                          onTap: () => scanBarcode("assets/barcode1.jpg"),
                          ),
                        ),
                      ),
                      ScreenWidthContainer(
                        minHeight: _smallContainerMin * 0.2,
                        maxHeight: _smallContainerMin * 1.5,
                        height: (_height / 100) * 6,
                        margin: _margin / 1.5,
                        child: FractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: 1,
                          child: AppButton(
                            buttonText: "Barcode Scanner",
                            onTap: () => context.read<PageChange>().changePageCache(BarcodeScannerPage(category: "Breakfast")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
