import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/groceries/grocery_list.dart';

class GroceriesHome extends StatefulWidget {
  const GroceriesHome({Key? key}) : super(key: key);

  @override
  State<GroceriesHome> createState() => _GroceriesHomeState();
}

class _GroceriesHomeState extends State<GroceriesHome> {

  late TextEditingController searchController = TextEditingController();
  late final searchKey = GlobalKey<FormState>();

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
          toolbarHeight: height/9,
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
                        "Groceries",
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
                      onChanged: (value) {},
                      onTapOutside: (value) => FocusManager.instance.primaryFocus?.unfocus(),
                      onFieldSubmitted: (value) => {},
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
              child: const GroceryList(),
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
              child: const GroceryListCupboard(),
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
              child: const GroceryListFridge(),
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
              child: const GroceryListFreezer(),
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
              child: const GroceryListNeeded(),
            ),
          ],
        ),
      ),
    );
  }
}
