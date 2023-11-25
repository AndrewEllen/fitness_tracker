import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../helpers/diet/nutrition_tracker.dart';
import '../../models/diet/food_item.dart';
import '../../models/groceries/grocery_item.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/groceries/grocery_list.dart';
import '../diet/diet_barcode_scanner.dart';

class GroceriesHome extends StatefulWidget {
  const GroceriesHome({Key? key}) : super(key: key);

  @override
  State<GroceriesHome> createState() => _GroceriesHomeState();
}

class _GroceriesHomeState extends State<GroceriesHome> {
  late bool _displayDropDown = false;
  late TextEditingController searchController = TextEditingController();
  late final searchKey = GlobalKey<FormState>();
  late List<GroceryItem> groceryList;
  late String searchCriteria = "";

  late final newItemKey = GlobalKey<FormState>();
  late TextEditingController newItemController = TextEditingController();

  @override
  void initState() {
    groceryList = context.read<GroceryProvider>().groceryList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        appBar: AppBar(
          toolbarHeight: height / 9,
          backgroundColor: appTertiaryColour,
          automaticallyImplyLeading: false,
          bottom: TabBar(
            indicatorColor: appSecondaryColour,
            labelStyle: TextStyle(
              fontSize: 10.w,
            ),
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Cupboard"),
              Tab(text: "Fridge"),
              Tab(text: "Freezer"),
              Tab(text: "Needed"),
            ],
          ),
          flexibleSpace: Stack(
            children: [
              Container(
                width: width,
                height: height / 20,
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
                        "Groceries",
                        style: TextStyle(
                          color: appSecondaryColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    )),
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
                        fontSize: 18 - (height * heightFactor),
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
                        hintText: 'Search for a grocery item...',
                        hintStyle: TextStyle(
                          color: Colors.white30,
                          fontSize: 18 - (height * heightFactor),
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
                      onChanged: (value) {
                        setState(() {
                          searchCriteria = value;
                        });
                      },
                      onTapOutside: (value) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onFieldSubmitted: (value) => setState(() {
                        searchCriteria = value;
                      }),
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
            /// Groceries All Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
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
                              width: width / 4,
                              decoration: BoxDecoration(
                                color: appTertiaryColour,
                                border: Border.all(
                                    color: appSecondaryColour, width: 1),
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
                                          MdiIcons.foodForkDrink,
                                          size: height / 26,
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
                              width: width / 4,
                              decoration: BoxDecoration(
                                color: appTertiaryColour,
                                border: Border.all(
                                    color: appSecondaryColour, width: 1),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => context
                                      .read<PageChange>()
                                      .changePageCache(const BarcodeScannerPage(
                                          category: "Groceries")),
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
                                          size: height / 26,
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
                      Expanded(
                        child: GroceryList(
                          groceryList: groceryList,
                          searchCriteria: searchCriteria,
                        ),
                      ),
                    ],
                  ),
                  _displayDropDown
                      ? Positioned(
                          top: height / 4,
                          left: width / 10,
                          right: width / 10,
                          child: Container(
                            height: height / 5,
                            width: width / 1.5,
                            margin: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: appTertiaryColour,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Stack(children: [
                              Container(
                                height: 32,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 2, color: appQuinaryColour),
                                  ),
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    height: 24,
                                    child: Text(
                                      "Add Grocery Item",
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
                                bottom: width / 5.5,
                                left: width / 30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appTertiaryColour,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    border: Border.all(
                                      color: appQuarternaryColour,
                                    ),
                                  ),
                                  width: width / 1.5,
                                  height: width / 12,
                                  child: Form(
                                    key: newItemKey,
                                    child: TextFormField(
                                      controller: newItemController,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: (20),
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          bottom: (width / 12) / 2.5,
                                          left: 5,
                                          right: 5,
                                        ),
                                        hintText: 'Item Name...',
                                        hintStyle: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: (18),
                                        ),
                                        errorStyle: const TextStyle(
                                          height: 0,
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
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
                                bottom: width / 42,
                                right: width / 4.33,
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
                                bottom: width / 42,
                                right: width / 33,
                                child: SizedBox(
                                  height: 30,
                                  child: AppButton(
                                      buttonText: "Add",
                                      onTap: () {
                                        if (newItemKey.currentState!.validate()) {
                                          context.read<GroceryProvider>().addGroceryItem(newItemController.text);
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ]),
                          ))
                      : const SizedBox.shrink()
                ],
              ),
            ),

            ///
            ///
            /// Groceries Cupboard Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: GroceryListCupboard(
                groceryList: groceryList,
                searchCriteria: searchCriteria,
              ),
            ),

            ///
            ///
            /// Groceries Fridge Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: GroceryListFridge(
                groceryList: groceryList,
                searchCriteria: searchCriteria,
              ),
            ),

            ///
            ///
            /// Groceries Freezer Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: GroceryListFreezer(
                groceryList: groceryList,
                searchCriteria: searchCriteria,
              ),
            ),

            ///
            ///
            /// Groceries Needed Page
            ///
            ///
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: GroceryListNeeded(
                groceryList: groceryList,
                searchCriteria: searchCriteria,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
