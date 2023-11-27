import 'package:fitness_tracker/providers/general/database_get.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../constants.dart';
import '../../helpers/diet/nutrition_tracker.dart';
import '../../models/diet/food_item.dart';
import '../../models/groceries/grocery_item.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/groceries/grocery_list.dart';
import '../diet/diet_barcode_scanner.dart';

class GroceriesHome extends StatefulWidget {
  GroceriesHome({Key? key, this.foodName = "", this.foodBarcode = "", this.dropdown = false}) : super(key: key);
  String foodName, foodBarcode;
  bool dropdown;

  @override
  State<GroceriesHome> createState() => _GroceriesHomeState();
}

class _GroceriesHomeState extends State<GroceriesHome> {
  late bool _displayDropDown;
  late TextEditingController searchController = TextEditingController();
  late final searchKey = GlobalKey<FormState>();
  late List<GroceryItem> groceryList;
  late String searchCriteria = "";
  late int _radioButtonValue = 0;


  late bool _cupboard = true;
  late bool _fridge = false;
  late bool _freezer = false;
  late bool _needed = false;


  late final newItemKey = GlobalKey<FormState>();
  late TextEditingController newItemController = TextEditingController();

  @override
  void initState() {

    if (context.read<GroceryProvider>().groceryListID.isEmpty) {
      context.read<GroceryProvider>().setGroceryListID(const Uuid().v4());
    }


    if (context.read<GroceryProvider>().groceryList.isEmpty) {
      try {
        context.read<GroceryProvider>().setGroceryList();

      } catch (error) {
        print(error);
      }
    }

    newItemController.text = widget.foodName;
    groceryList = context.read<GroceryProvider>().groceryList;
    _displayDropDown = widget.dropdown;
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
                              width: width / 2.5,
                              decoration: BoxDecoration(
                                color: appTertiaryColour,
                                border: Border.all(
                                    color: appSecondaryColour, width: 1),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    print(context.read<GroceryProvider>().groceryList[0].foodName);
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
                              width: width / 2.5,
                              decoration: BoxDecoration(
                                color: appTertiaryColour,
                                border: Border.all(
                                    color: appSecondaryColour, width: 1),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context
                                        .read<PageChange>()
                                        .changePageCache(const BarcodeScannerPage(
                                        category: "groceries")
                                    );
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
                          top: height / 18.h,
                          left: width / 10,
                          right: width / 10,
                          child: Container(
                            height: height / 2.4.h,
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
                                top: width / 8.5.h,
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
                                  height: width / 10,
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
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 88.0.h,
                                    bottom: 18.0.h,
                                    left: 8.0,
                                    right: 8.0,
                                ),
                                child: Column(
                                  children: [
                                    RadioListTile(
                                        value: 0,
                                        groupValue: _radioButtonValue,
                                        onChanged: (value) {
                                          setState(() {

                                            _radioButtonValue = value!;
                                            _cupboard = true;
                                            _fridge = false;
                                            _freezer = false;
                                            _needed = false;

                                          });
                                        },
                                      title: const Text("Cupboard"),
                                    ),
                                    RadioListTile(
                                      value: 1,
                                      groupValue: _radioButtonValue,
                                      onChanged: (value) {
                                        setState(() {

                                          _radioButtonValue = value!;
                                          _cupboard = false;
                                          _fridge = true;
                                          _freezer = false;
                                          _needed = false;

                                        });
                                      },
                                      title: const Text("Fridge"),
                                    ),
                                    RadioListTile(
                                      value: 2,
                                      groupValue: _radioButtonValue,
                                      onChanged: (value) {
                                        setState(() {

                                          _radioButtonValue = value!;
                                          _cupboard = false;
                                          _fridge = false;
                                          _freezer = true;
                                          _needed = false;

                                        });
                                      },
                                      title: const Text("Freezer"),
                                    ),
                                    RadioListTile(
                                      value: 3,
                                      groupValue: _radioButtonValue,
                                      onChanged: (value) {
                                        setState(() {

                                          _radioButtonValue = value!;
                                          _cupboard = false;
                                          _fridge = false;
                                          _freezer = false;
                                          _needed = true;

                                        });
                                      },
                                      title: const Text("Needed"),
                                    ),
                                  ],
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
                                          context.read<GroceryProvider>().addGroceryItem(
                                            name: newItemController.text,
                                            barcode: widget.foodBarcode,
                                            cupboard: _cupboard,
                                            fridge: _fridge,
                                            freezer: _freezer,
                                            needed: _needed,
                                          );

                                          setState(() {
                                            newItemController.text = "";
                                            widget.foodBarcode = "";
                                            _displayDropDown = false;
                                          });
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
