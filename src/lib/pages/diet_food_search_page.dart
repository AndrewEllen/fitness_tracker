import 'package:fitness_tracker/models/user_nutrition_history_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../helpers/nutrition_tracker.dart';
import '../models/food_item.dart';
import '../providers/database_get.dart';
import '../providers/page_change_provider.dart';
import '../providers/user_nutrition_data.dart';
import '../widgets/app_container_header.dart';
import '../widgets/app_default_button.dart';
import '../widgets/food_history_list_item_box.dart';
import '../widgets/food_list_item_box.dart';
import '../widgets/food_list_search_display_box.dart';
import 'diet_barcode_scanner.dart';
import 'diet_food_display_page.dart';
import 'diet_new_food_page.dart';

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
  late TextEditingController newCodeController = TextEditingController();

  late final searchKey = GlobalKey<FormState>();
  late final newCodeKey = GlobalKey<FormState>();

  late UserNutritionHistoryModel foodHistory;

  late List<FoodItem> foodItemsFromSearch = [];
  late List<FoodItem> foodItemsFromSearchFirebase = [];
  late List<FoodItem> foodItemsFromSearchTriGramFirebase = [];
  late List<FoodItem> foodItemsFromSearchOpenFF = [];

  late bool _searching = false;

  late bool _displayDropDown = false;

  @override
  void initState() {

    foodHistory = context.read<UserNutritionData>().userNutritionHistory;

    super.initState();
  }


  void SearchOFFbyString(String value) async {

    if (searchController.text.isNotEmpty && searchController.text != "") {
      setState(() {
        _searching = true;
      });

      foodItemsFromSearchFirebase = await SearchByNameFirebase(value);

      setState(() {
        foodItemsFromSearch = foodItemsFromSearchFirebase;

        if (foodItemsFromSearch.isNotEmpty) {
          _searching = false;
        }

      });

      foodItemsFromSearchTriGramFirebase = await SearchByNameTriGramFirebase(value);

      setState(() {

        for (int i = 0; i < foodItemsFromSearch.length; i++) {
          foodItemsFromSearchTriGramFirebase.removeWhere((item) => item.barcode == foodItemsFromSearch[i].barcode);
        }

        foodItemsFromSearch = foodItemsFromSearchFirebase + foodItemsFromSearchTriGramFirebase;

        if (foodItemsFromSearchTriGramFirebase.isNotEmpty) {
          _searching = false;
        }

      });

      foodItemsFromSearchOpenFF = await SearchByNameOpenff(value);

      setState(() {

        foodItemsFromSearch += foodItemsFromSearchOpenFF;

        _searching = false;
      });

    }

  }


  void SearchFoodHistory(String value) {

    print("searching");

    foodHistory = context.read<UserNutritionData>().userNutritionHistory;

    UserNutritionHistoryModel foodHistorySearch = UserNutritionHistoryModel(
        barcodes: [],
        foodListItemNames: [],
        foodServings: [],
        foodServingSize: [],
    );

    if (value.isNotEmpty) {

      foodHistory.foodListItemNames.asMap().forEach((index, item) {

        if (item.toLowerCase().contains(value.toLowerCase())) {

          print(item);

          foodHistorySearch.foodListItemNames.add(foodHistory.foodListItemNames[index]);
          foodHistorySearch.barcodes.add(foodHistory.barcodes[index]);
          foodHistorySearch.foodServings.add(foodHistory.foodServings[index]);
          foodHistorySearch.foodServingSize.add(foodHistory.foodServingSize[index]);

        }

      });

      setState(() {
        foodHistory = foodHistorySearch;
      });

    } else {
      setState(() {
        foodHistory;
      });
    }

  }

  void AddFoodItem(String barcode, String servings, String servingSize) async {

    FoodItem newFoodItem = await CheckFoodBarcode(barcode);

    context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);

    context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
    context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

    searchController.text = "";

    setState(() {
      foodHistory = context.read<UserNutritionData>().userNutritionHistory;
    });

    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));

  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().userNutritionHistory;

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
                  onChanged: (value) => SearchFoodHistory(value),
                  onTapOutside: (value) => FocusManager.instance.primaryFocus?.unfocus(),
                  onFieldSubmitted: (value) => SearchOFFbyString(value),
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
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: appTertiaryColour.withAlpha(180),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 8,
                            bottom: 5,
                          ),
                          width: width/4,
                          decoration: BoxDecoration(
                            color: appTertiaryColour,
                            border: Border.all(color: appSecondaryColour, width: 1),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _displayDropDown = true;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 8,
                                      left: 18.0,
                                      right: 18.0,
                                    ),
                                    child: Icon(
                                        MdiIcons.tagTextOutline,
                                        size: height/26,
                                      ),
                                  ),
                                  const FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 4,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "From Code",
                                          style: TextStyle(
                                            color: appSecondaryColour,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 8,
                            bottom: 5,
                          ),
                          width: width/4,
                          decoration: BoxDecoration(
                            color: appTertiaryColour,
                            border: Border.all(color: appSecondaryColour, width: 1),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 8,
                                      left: 18.0,
                                      right: 18.0,
                                    ),
                                    child: Icon(
                                      MdiIcons.foodForkDrink,
                                      size: height/26,
                                    ),
                                  ),
                                  const FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 4,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "Add New",
                                          style: TextStyle(
                                            color: appSecondaryColour,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 8,
                            bottom: 5,
                          ),
                          width: width/4,
                          decoration: BoxDecoration(
                            color: appTertiaryColour,
                            border: Border.all(color: appSecondaryColour, width: 1),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => context.read<PageChange>().changePageCache(BarcodeScannerPage(category: widget.category)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                      bottom: 8,
                                      left: 18.0,
                                      right: 18.0,
                                    ),
                                    child: Icon(
                                      MdiIcons.barcodeScan,
                                      size: height/26,
                                    ),
                                  ),
                                  const FittedBox(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 4,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "Scan Barcode",
                                          style: TextStyle(
                                            color: appSecondaryColour,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  AppHeaderBox(
                    title: "History",
                    width: width,
                    largeTitle: true,
                  ),
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

                  !_searching ? Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: foodItemsFromSearch.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  AppHeaderBox(
                                    title: "Search Data",
                                    width: width,
                                    largeTitle: true,
                                  ),
                                  FoodListSearchDisplayBox(
                                    width: width,
                                    foodObject: foodItemsFromSearch[index],
                                    icon: Icons.add_box,
                                    iconColour: appSecondaryColour,
                                    onTapIcon: () {

                                    context.read<UserNutritionData>().setCurrentFoodItem(foodItemsFromSearch[index]);

                                    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));
                                  },
                            ),
                                ],
                              );
                            }

                            return FoodListSearchDisplayBox(
                              width: width,
                              foodObject: foodItemsFromSearch[index],
                              icon: Icons.add_box,
                              iconColour: appSecondaryColour,
                              onTapIcon: () {

                                context.read<UserNutritionData>().setCurrentFoodItem(foodItemsFromSearch[index]);

                                context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));
                              },
                            );
                          }),
                    ],
                  ) : const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                      color: appSecondaryColour,
                    ),
                  ),
                ],
              ),
              _displayDropDown
                  ? Container(
                height: height,
                width: width,
                color: appPrimaryColour.withOpacity(0.5),
                child: GestureDetector(
                  onTap: (() {
                    setState(() {
                      _displayDropDown = false;
                    });
                  }),
                ),
              )
                  : const SizedBox.shrink(),
              _displayDropDown ? Positioned(
                top: height/4,
                left: width/10,
                right: width/10,
                child: Container(
                  height: height/5,
                  width: width/1.5,
                  margin: EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: appTertiaryColour,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 32,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2, color: appQuinaryColour),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 24,
                            child: const Text(
                              "Add Food",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: width/5.5,
                        left: width/30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: appTertiaryColour,
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: appQuarternaryColour,
                            ),
                          ),
                          width: width/1.5,
                          height: width/12,
                          child: Form(
                            key: newCodeKey,
                            child: TextFormField(
                              controller: newCodeController,
                              cursorColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: (20),
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: (width/12)/2.5, left: 5, right: 5,),
                                hintText: 'Food Code...',
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: (18),
                                ),
                                errorStyle: const TextStyle(
                                  height: 0,
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appSecondaryColour,
                                  ),
                                ),
                              ),
                              validator: (String? value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                }
                                return "";
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: width/42,
                        right: width/4.33,
                        child: Container(
                          height: 30,
                          child: AppButton(
                            buttonText: "Cancel",
                            onTap: () {
                              setState(() {
                                _displayDropDown = false;
                              });
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: width/42,
                        right: width/33,
                        child: Container(
                          height: 30,
                          child: AppButton(
                            buttonText: "Add",
                            onTap: () async {
                                if (newCodeKey.currentState!.validate()) {

                                  FoodItem newFoodItem = await CheckFoodBarcode(newCodeController.text);

                                  if (newFoodItem.barcode.isNotEmpty) {
                                    setState(() {
                                      newCodeController.text = "";
                                      _displayDropDown = false;
                                    });
                                    context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);
                                    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));
                                  }
                                }
                              }),
                          ),
                        ),
                    ],
                  ),
                ),
              ) : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}