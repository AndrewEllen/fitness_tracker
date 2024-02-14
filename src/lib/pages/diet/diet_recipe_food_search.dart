import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/models/diet/user__foods_model.dart';
import 'package:fitness_tracker/models/diet/user_recipes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
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

class FoodRecipeSearchPage extends StatefulWidget {
  const FoodRecipeSearchPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  final String category;

  @override
  State<FoodRecipeSearchPage> createState() => _FoodRecipeSearchPageState();
}

class _FoodRecipeSearchPageState extends State<FoodRecipeSearchPage> {

  late TextEditingController searchController = TextEditingController();
  late TextEditingController newCodeController = TextEditingController();

  late final searchKey = GlobalKey<FormState>();
  late final newCodeKey = GlobalKey<FormState>();

  late UserNutritionFoodModel customFood;
  late List<UserRecipesModel> customRecipes;

  late List<FoodItem> foodItemsFromSearch = [];
  late List<FoodItem> foodItemsFromSearchFirebase = [];
  late List<FoodItem> foodItemsFromSearchTriGramFirebase = [];
  late List<FoodItem> foodItemsFromSearchOpenFF = [];

  late bool _searching = false;

  late bool _displayDropDown = false;

  @override
  void initState() {



    customFood = context.read<UserNutritionData>().userNutritionCustomFood;
    customRecipes = context.read<UserNutritionData>().userRecipesList;

    super.initState();
  }


  void SearchOFFbyString(String value) async {

    bool result = await InternetConnection().hasInternetAccess;
    GetOptions options = const GetOptions(source: Source.serverAndCache);

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("No Internet Connection"),
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

  void AddFoodItem(String barcode, String servings, String servingSize) async {

    FoodItem newFoodItem = await CheckFoodBarcode(barcode);

    context.read<UserNutritionData>().setCurrentFoodItem(newFoodItem);
    context.read<UserNutritionData>().updateCurrentFoodItemServings(servings);
    context.read<UserNutritionData>().updateCurrentFoodItemServingSize(servingSize);

    searchController.text = "";

    context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: true,));

  }

  void SearchCustomFood(String value) {

    print("searching");

    customFood = context.read<UserNutritionData>().userNutritionCustomFood;

    UserNutritionFoodModel customFoodSearch = UserNutritionFoodModel(
      barcodes: [],
      foodListItemNames: [],
      foodServings: [],
      foodServingSize: [],
      recipe: [],
    );

    if (value.isNotEmpty) {

      customFood.foodListItemNames.asMap().forEach((index, item) {

        if (item.toLowerCase().contains(value.toLowerCase())) {

          print(item);

          customFoodSearch.foodListItemNames.add(customFood.foodListItemNames[index]);
          customFoodSearch.barcodes.add(customFood.barcodes[index]);
          customFoodSearch.foodServings.add(customFood.foodServings[index]);
          customFoodSearch.foodServingSize.add(customFood.foodServingSize[index]);

        }

      });

      setState(() {
        customFood = customFoodSearch;
      });

    } else {
      setState(() {
        customFood;
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
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
                child: const Align(
                    alignment: Alignment.topCenter,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "Search for Ingredients",
                        style: TextStyle(
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
                        hintText: 'Search for an ingredient...',
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
                      onChanged: (value) => SearchCustomFood(value),
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
                                    onTap: () => context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, recipe: true)),
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
                                    onTap: () => context.read<PageChange>().changePageCache(BarcodeScannerPage(category: widget.category, recipe: true)),
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
                        foodItemsFromSearch.isNotEmpty ? Column(
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
                                              context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: true,));
                                            } else {
                                              context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, fromBarcode: true, recipe: true, saveAsCustom: false));
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
                                        context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: true,));
                                      } else {
                                        context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, fromBarcode: true, recipe: true, saveAsCustom: false));
                                      }
                                    },
                                  );
                                }),
                          ],
                        ) : const Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Search for ingredients...",
                              style: TextStyle(
                                color: appQuarternaryColour,
                                fontSize: 20,
                              ),
                            ),
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
                                          context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: true,));
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
                                    onTap: () => context.read<PageChange>().changePageCache(FoodNewNutritionEdit(category: widget.category, recipe: true,)),
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
                                          context.read<PageChange>().changePageCache(FoodDisplayPage(category: widget.category, recipe: true));
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