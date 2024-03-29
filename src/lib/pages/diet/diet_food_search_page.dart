import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:text_analysis/extensions.dart';
import 'package:text_analysis/text_analysis.dart';
import 'package:text_analysis/extensions.dart';

import '../../constants.dart';
import '../../helpers/diet/nutrition_tracker.dart';
import '../../models/diet/food_item.dart';
import '../../providers/general/page_change_provider.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../widgets/general/app_container_header.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/diet/food_history_list_item_box.dart';
import '../../widgets/diet/food_list_search_display_box.dart';
import 'diet_barcode_scanner.dart';
import 'diet_food_display_page.dart';
import 'diet_new_food_page.dart';
import 'diet_recipe_creator.dart';

class FoodSearchPage extends StatefulWidget {
  const FoodSearchPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  State<FoodSearchPage> createState() => _FoodSearchPageState();
}

class _FoodSearchPageState extends State<FoodSearchPage> {

  late TextEditingController searchController = TextEditingController();
  late TextEditingController newCodeController = TextEditingController();

  late final searchKey = GlobalKey<FormState>();
  late final newCodeKey = GlobalKey<FormState>();

  late UserNutritionFoodModel foodHistory;
  late UserNutritionFoodModel customFood;
  late UserNutritionFoodModel customRecipes;

  late List<FoodItem> foodItemsFromSearch = [];
  late List<FoodItem> foodItemsFromSearchFirebase = [];
  late List<FoodItem> foodItemsFromSearchTriGramFirebase = [];
  late List<FoodItem> foodItemsFromSearchOpenFF = [];

  late bool _searching = false;

  late bool _displayDropDown = false;

  @override
  void initState() {

    foodHistory = context.read<UserNutritionData>().userNutritionHistory;
    customFood = context.read<UserNutritionData>().userNutritionCustomFood;
    customRecipes = context.read<UserNutritionData>().userNutritionCustomRecipes;

    super.initState();
  }


  void SearchOFFbyString(String value) async {

    bool result = await InternetConnection().hasInternetAccess;
    GetOptions options = const GetOptions(source: Source.serverAndCache);

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No Internet Connection \nAttempting to load"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.6695,
            right: 20,
            left: 20,
          ),
          dismissDirection: DismissDirection.none,
          duration: const Duration(milliseconds: 700),
        ),
      );
      options = const GetOptions(source: Source.cache);
    }

    if (searchController.text.isNotEmpty && searchController.text != "") {
      setState(() {
        foodItemsFromSearch = [];
        _searching = true;
      });

      Future.wait<void>([

        SearchByNameFirebase(value, options: options).then((result) =>
            setState(() {
              foodItemsFromSearch += result;
              _searching = false;
            })
        ),

        SearchByNameTriGramFirebase(value).then((result) =>
            setState(() {
              for (int i = 0; i < foodItemsFromSearch.length; i++) {
                result.removeWhere((item) => item.barcode == foodItemsFromSearch[i].barcode);
              }
              foodItemsFromSearch += result;
              _searching = false;
            })
        ),

        SearchByNameOpenff(value).then((result) =>
            setState(() {
              for (int i = 0; i < foodItemsFromSearch.length; i++) {
                result.removeWhere((item) => item.barcode == foodItemsFromSearch[i].barcode);
              }
              foodItemsFromSearch += result;
              _searching = false;
            })
        ),

      ]);

    }

  }


  void SearchFoodHistory(String value) {


    List<Map> sortListBySimilarity(List<Map> similarityMap) {

      // Create a new list with the same elements and then sort it
      List<Map<dynamic, dynamic>> sortedList = List<Map<dynamic, dynamic>>.from(similarityMap);
      sortedList.sort((a, b) => (b.values.first as num).compareTo(a.values.first as num));

      return sortedList;
    }

    List<Map> checkSimilarity(String searchWord, String searchItem, String barcode, String foodServings, String foodServingsSize) {
      List<Map> _wordsSimilarity = [];

      for(String searchWord in searchWord.split(" ")) {

        for(String itemWord in searchItem.split(" ")) {
          double _similarity = searchWord.jaccardSimilarity(itemWord);
          if (_similarity > 0.42) {

            _wordsSimilarity.add({
              searchItem: _similarity,
              "foodListItemName": searchItem,
              "barcode": barcode,
              "foodServing": foodServings,
              "foodServingSize": foodServingsSize,
            });

            return sortListBySimilarity(_wordsSimilarity);
          }

        }
      }
      return [];
    }




    foodHistory = context.read<UserNutritionData>().userNutritionHistory;
    customFood = context.read<UserNutritionData>().userNutritionCustomFood;
    customRecipes = context.read<UserNutritionData>().userNutritionCustomRecipes;

    UserNutritionFoodModel foodHistorySearch = UserNutritionFoodModel(
        barcodes: [],
        foodListItemNames: [],
        foodServings: [],
        foodServingSize: [],
        recipe: []
    );

    UserNutritionFoodModel customFoodSearch = UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );

    UserNutritionFoodModel customRecipeSearch = UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );

    if (value.isNotEmpty) {

      foodHistory.foodListItemNames.asMap().forEach((index, item) {

        if (item.toLowerCase().contains(value.toLowerCase())) {

          foodHistorySearch.foodListItemNames.add(foodHistory.foodListItemNames[index]);
          foodHistorySearch.barcodes.add(foodHistory.barcodes[index]);
          foodHistorySearch.foodServings.add(foodHistory.foodServings[index]);
          foodHistorySearch.foodServingSize.add(foodHistory.foodServingSize[index]);

        } else {
          List<Map> internalSearchList = checkSimilarity(
              value,
              item,
              foodHistory.barcodes[index],
              foodHistory.foodServings[index],
              foodHistory.foodServingSize[index],
          );

          if (internalSearchList.isNotEmpty) {

            foodHistorySearch.foodListItemNames.add(internalSearchList[0]["foodListItemName"]);
            foodHistorySearch.barcodes.add(internalSearchList[0]["barcode"]);
            foodHistorySearch.foodServings.add(internalSearchList[0]["foodServing"]);
            foodHistorySearch.foodServingSize.add(internalSearchList[0]["foodServingSize"]);

          }
        }

      });

      customRecipes.foodListItemNames.asMap().forEach((index, item) {

        if (item.toLowerCase().contains(value.toLowerCase())) {

          customRecipeSearch.foodListItemNames.add(customRecipes.foodListItemNames[index]);
          customRecipeSearch.barcodes.add(customRecipes.barcodes[index]);
          customRecipeSearch.foodServings.add(customRecipes.foodServings[index]);
          customRecipeSearch.foodServingSize.add(customRecipes.foodServingSize[index]);

        } else {
          List<Map> internalSearchList = checkSimilarity(
            value,
            item,
            customRecipes.barcodes[index],
            customRecipes.foodServings[index],
            customRecipes.foodServingSize[index],
          );

          if (internalSearchList.isNotEmpty) {

            customRecipeSearch.foodListItemNames.add(internalSearchList[0]["foodListItemName"]);
            customRecipeSearch.barcodes.add(internalSearchList[0]["barcode"]);
            customRecipeSearch.foodServings.add(internalSearchList[0]["foodServing"]);
            customRecipeSearch.foodServingSize.add(internalSearchList[0]["foodServingSize"]);

          }
        }

      });

      customFood.foodListItemNames.asMap().forEach((index, item) {

        if (item.toLowerCase().contains(value.toLowerCase())) {

          customFoodSearch.foodListItemNames.add(customFood.foodListItemNames[index]);
          customFoodSearch.barcodes.add(customFood.barcodes[index]);
          customFoodSearch.foodServings.add(customFood.foodServings[index]);
          customFoodSearch.foodServingSize.add(customFood.foodServingSize[index]);

        } else {
          List<Map> internalSearchList = checkSimilarity(
            value,
            item,
            customFood.barcodes[index],
            customFood.foodServings[index],
            customFood.foodServingSize[index],
          );

          if (internalSearchList.isNotEmpty) {

            customFoodSearch.foodListItemNames.add(internalSearchList[0]["foodListItemName"]);
            customFoodSearch.barcodes.add(internalSearchList[0]["barcode"]);
            customFoodSearch.foodServings.add(internalSearchList[0]["foodServing"]);
            customFoodSearch.foodServingSize.add(internalSearchList[0]["foodServingSize"]);

          }
        }

      });

      setState(() {
        foodHistory = foodHistorySearch;
        customFood = customFoodSearch;
        customRecipes = customRecipeSearch;
      });

    } else {
      setState(() {
        foodHistory;
        customFood;
        customRecipes;
      });
    }

  }

  void AddFoodItem(String barcode, String servings, String servingSize, bool recipe, bool noData) async {

    if (noData) {

      late UserRecipesModel recipeItem;
      late FoodItem newFoodItem;

      try {
        recipeItem = await CheckFoodBarcode(barcode, recipe: true);
        recipe = recipeItem.foodData.recipe;
      }catch (error) {
        newFoodItem = await CheckFoodBarcode(barcode);
        recipe = newFoodItem.recipe;
      }
    }


    if (recipe) {

      UserRecipesModel recipeItem = await CheckFoodBarcode(barcode, recipe: true);

      print(recipeItem.foodData.recipe);

      context.read<UserNutritionData>().setCurrentRecipe(recipeItem);
      context.read<UserNutritionData>().setCurrentFoodItem(recipeItem.foodData);

      context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

      searchController.text = "";

      setState(() {
        foodHistory = context.read<UserNutritionData>().userNutritionHistory;
        customFood = context.read<UserNutritionData>().userNutritionCustomFood;
        customRecipes = context.read<UserNutritionData>().userNutritionCustomRecipes;
      });

      context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipeEdit: true,));

    } else {

      FoodItem newFoodItem = await CheckFoodBarcode(barcode);

      context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);

      context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
      context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

      searchController.text = "";

      setState(() {
        foodHistory = context.read<UserNutritionData>().userNutritionHistory;
        customFood = context.read<UserNutritionData>().userNutritionCustomFood;
        customRecipes = context.read<UserNutritionData>().userNutritionCustomRecipes;
      });

      context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category));

    }
  }

  @override
  Widget build(BuildContext context) {

    context.watch<UserNutritionData>().userNutritionHistory;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        appBar: AppBar(
          toolbarHeight: height/9,
          backgroundColor: appTertiaryColour,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: appSecondaryColourDark, width: 2.0),
                    ),
                  ),
                ),
                const TabBar(
                  indicatorColor: appSecondaryColour,
                  tabs: [
                    Tab(text: "All"),
                    Tab(text: "Recipes"),
                    Tab(text: "Custom Food"),
                  ],
                ),
              ],
            ),
          ),
          flexibleSpace: Stack(
            children: [
              Container(
                width: width,
                height: height/20,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: appPrimaryColour,
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.category,
                        style: const TextStyle(
                          color: appSecondaryColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                    left: 20,
                    right: 20,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: width,
                    maxHeight: 35,
                  ),
                  child: Form(
                    key: searchKey,
                    child: TextFormField(
                      //inputFormatters: textInputFormatter,
                      keyboardType: TextInputType.text,
                      controller: searchController,
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18-(height * heightFactor),
                      ),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appSecondaryColour.withAlpha(20),
                        contentPadding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 4,
                          bottom: 0,
                        ),
                        hintText: 'Search for a food...',
                        hintStyle: TextStyle(
                          color: Colors.white30,
                          fontSize: 18-(height * heightFactor),
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
                      onChanged: (value) => EasyDebounce.debounce(
                          "levenshteinDistanceDebouncerExercise",
                          const Duration(milliseconds: 200),
                              () => SearchFoodHistory(value)
                      ),
                      onTapOutside: (value) => FocusManager.instance.primaryFocus?.unfocus(),
                      onFieldSubmitted: (value) => SearchOFFbyString(value),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ///
            ///
            /// Food All Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              ///Search Page All
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
                                  bottom: 8,
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
                                  bottom: 8,
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
                                      context.read<UserNutritionData>().resetCurrentFood();
                                      context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category));
                                    } ,
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
                                  bottom: 8,
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
                        foodHistory.foodListItemNames.isNotEmpty ? AppHeaderBox(
                          title: "History",
                          width: width,
                          largeTitle: true,
                        ) : AppHeaderBox(
                          titleColor: Colors.white70,
                          title: "Items will appear here...",
                          width: width,
                          largeTitle: false,
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
                                    foodHistory.recipe.isNotEmpty ? foodHistory.recipe[index] : false,
                                    foodHistory.recipe.isEmpty,
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

                                          if (foodItemsFromSearch[index].firebaseItem == true) {
                                            context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: false,));
                                          } else {
                                            context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, fromBarcode: true, recipe: false, saveAsCustom: false));
                                          }
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

                                      if (foodItemsFromSearch[index].firebaseItem == true) {
                                        context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: false,));
                                      } else {
                                        context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, fromBarcode: true, recipe: false, saveAsCustom: false));
                                      }
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
                        margin: const EdgeInsets.all(15),
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
                              child: const Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 24,
                                  child: Text(
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
                              child: SizedBox(
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
                              child: SizedBox(
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
            ///
            ///
            /// Food Recipes Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
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
                                  bottom: 8,
                                ),
                                width: width/2.5,
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
                                              left: 4,
                                              right: 4,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "Import Recipe From Code",
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
                                  bottom: 8,
                                ),
                                width: width/2.5,
                                decoration: BoxDecoration(
                                  color: appTertiaryColour,
                                  border: Border.all(color: appSecondaryColour, width: 1),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<UserNutritionData>().resetCurrentRecipe();
                                      context.read<PageChange>().changePageCache(FoodRecipeCreator(category: widget.category, editDiary: false,));
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
                                            MdiIcons.foodForkDrink,
                                            size: height/26,
                                          ),
                                        ),
                                        const FittedBox(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 4,
                                              left: 4,
                                              right: 4,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                "Create New Recipe",
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
                        customRecipes.barcodes.isNotEmpty ? AppHeaderBox(
                          title: "Recipes",
                          width: width,
                          largeTitle: true,
                        ) : AppHeaderBox(
                          titleColor: Colors.white70,
                          title: "Recipes will display here...",
                          width: width,
                          largeTitle: true,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: customRecipes.foodListItemNames.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return FoodHistoryListDisplayBox(
                                width: width,
                                foodHistoryName: customRecipes.foodListItemNames[index].capitalize(),
                                foodHistoryServings: customRecipes.foodServings[index],
                                foodHistoryServingSize: (double.parse(customRecipes.foodServingSize[index]) / double.parse(customRecipes.foodServings[index])).toStringAsFixed(1),
                                icon: Icons.add_box,
                                iconColour: appSecondaryColour,
                                onTapIcon: () => AddFoodItem(
                                  customRecipes.barcodes[index],
                                  "1",
                                  customRecipes.foodServingSize[index],
                                  true,
                                  foodHistory.recipe.isEmpty,
                                ),
                              );
                            }),
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
                        margin: const EdgeInsets.all(15),
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
                              child: const Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 24,
                                  child: Text(
                                    "Add Recipe",
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
                                      hintText: 'Recipe Code...',
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
                              child: SizedBox(
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
                              child: SizedBox(
                                height: 30,
                                child: AppButton(
                                    buttonText: "Add",
                                    onTap: () async {
                                      if (newCodeKey.currentState!.validate()) {

                                        UserRecipesModel newRecipeItem = await CheckFoodBarcode(newCodeController.text, recipe: true);

                                        if (newRecipeItem.barcode.isNotEmpty) {
                                          setState(() {
                                            newCodeController.text = "";
                                            _displayDropDown = false;
                                          });

                                          context.read<UserNutritionData>().setCurrentRecipe(newRecipeItem);
                                          context.read<UserNutritionData>().setCurrentFoodItem(newRecipeItem.foodData);
                                          context.read<UserNutritionData>().updateCurrentFoodItemServings("1");

                                          context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipeEdit: true,));
                                        }
                                      }
                                    }
                                    ),
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
            ///
            ///
            /// Food Custom Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
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
                                  bottom: 8,
                                ),
                                width: width/1.04,
                                decoration: BoxDecoration(
                                  color: appTertiaryColour,
                                  border: Border.all(color: appSecondaryColour, width: 1),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.read<UserNutritionData>().resetCurrentFood();
                                      context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category));
                                    } ,
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
                            ],
                          ),
                        ),
                        customFood.foodListItemNames.isNotEmpty ? AppHeaderBox(
                          title: "Custom Food",
                          width: width,
                          largeTitle: true,
                        ) : AppHeaderBox(
                          titleColor: Colors.white70,
                          title: "Items will appear here...",
                          width: width,
                          largeTitle: false,
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: customFood.foodListItemNames.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return FoodHistoryListDisplayBox(
                                width: width,
                                foodHistoryName: customFood.foodListItemNames[index],
                                foodHistoryServings: customFood.foodServings[index],
                                foodHistoryServingSize: customFood.foodServingSize[index],
                                icon: Icons.add_box,
                                iconColour: appSecondaryColour,
                                onTapIcon: () => AddFoodItem(
                                  customFood.barcodes[index],
                                  customFood.foodServings[index],
                                  customFood.foodServingSize[index],
                                  false,
                                  foodHistory.recipe.isEmpty,
                                ),
                              );
                            }),
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
                        margin: const EdgeInsets.all(15),
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
                              child: const Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 24,
                                  child: Text(
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
                              child: SizedBox(
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
                              child: SizedBox(
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
          ],
        ),
      ),
    );
  }
}