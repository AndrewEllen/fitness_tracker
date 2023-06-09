import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:fitness_tracker/models/user_nutrition_history_model.dart';
import 'package:flutter/material.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../helpers/nutrition_tracker.dart';
import '../models/food_item.dart';
import '../providers/database_get.dart';
import '../providers/page_change_provider.dart';
import '../providers/user_nutrition_data.dart';
import '../widgets/food_history_list_item_box.dart';
import '../widgets/food_list_item_box.dart';
import 'diet_food_display_page.dart';

class FoodSearchPage extends StatefulWidget {
  FoodSearchPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  String category;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {

  late TextEditingController searchController = TextEditingController();

  late final searchKey = GlobalKey<FormState>();


  Future<void> AddFoodItem(String barcode, String servings, String servingSize) async {

    try {

      print("Firebase");
      FoodItem newFoodItem = await GetFoodDataFromFirebase(barcode);

      context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);

      context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

    } catch (error){

      print("OpenFF");
      ProductResultV3 product = await checkFoodBarcodeOpenFF(barcode);

      context.read<UserNutritionData>().setCurrentFoodItemFromOpenFF(product, barcode);

      context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

    }

    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));

  }


  @override
  Widget build(BuildContext context) {

    UserNutritionHistoryModel foodHistory = context.watch<UserNutritionData>().userNutritionHistory;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      appBar: AppBar(
        toolbarHeight: height/9,
        backgroundColor: appTertiaryColour,
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          children: [
            Container(
              width: width,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: appPrimaryColour,
                  ),
                ),
              ),
              child: Center(
                  child:
                  FittedBox(
                    child: Text(
                      widget.category,
                      style: const TextStyle(
                        color: appSecondaryColour,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              constraints: BoxConstraints(
                maxWidth: width,
                maxHeight: height/30,
              ),
              child: Form(
                key: searchKey,
                child: TextFormField(
                  //inputFormatters: textInputFormatter,
                  keyboardType: TextInputType.text,
                  controller: searchController,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: (20),
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: appSecondaryColour.withAlpha(20),
                    contentPadding: const EdgeInsets.only(left: 5, right: 5,),
                    hintText: 'Search for a food...',
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                      fontSize: (18),
                    ),
                    errorStyle: const TextStyle(
                      height: 0,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onTapOutside: (value) => FocusManager.instance.primaryFocus?.unfocus(),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: foodHistory.foodListItemNames.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return FoodHistoryListDisplayBox(
                      width: width,
                      foodHistoryName: foodHistory.foodListItemNames[index],
                      foodHistoryServings: foodHistory.foodServings[index],
                      foodHistoryServingSize: foodHistory.foodServingSize[index],
                      icon: Icons.add_box,
                      iconColour: appSecondaryColour,
                      onTapIcon: () => AddFoodItem(
                          foodHistory.barcodes[index],
                          foodHistory.foodServings[index],
                          foodHistory.foodServingSize[index],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}