import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:fitness_tracker/widgets/groceries/grocery_list_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroceryList extends StatefulWidget {
  GroceryList({Key? key, required this.groceryList, this.searchCriteria = ""}) : super(key: key);
  List<GroceryItem> groceryList;
  String searchCriteria;

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: (widget.searchCriteria.isEmpty || widget.groceryList[index].foodName.toLowerCase().contains(widget.searchCriteria)) ? GroceryListBox(
            groceryObject: widget.groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListCupboard extends StatefulWidget {
  GroceryListCupboard({Key? key, required this.groceryList, this.searchCriteria = ""}) : super(key: key);
  List<GroceryItem> groceryList;
  String searchCriteria;

  @override
  State<GroceryListCupboard> createState() => _GroceryListCupboardState();
}

class _GroceryListCupboardState extends State<GroceryListCupboard> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: widget.groceryList[index].cupboard
              && (widget.searchCriteria.isEmpty || widget.groceryList[index].foodName.toLowerCase().contains(widget.searchCriteria))
              ? GroceryListBox(
            groceryObject: widget.groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListFridge extends StatefulWidget {
  GroceryListFridge({Key? key, required this.groceryList, this.searchCriteria = ""}) : super(key: key);
  List<GroceryItem> groceryList;
  String searchCriteria;

  @override
  State<GroceryListFridge> createState() => _GroceryListFridgeState();
}

class _GroceryListFridgeState extends State<GroceryListFridge> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: widget.groceryList[index].fridge
              && (widget.searchCriteria.isEmpty || widget.groceryList[index].foodName.toLowerCase().contains(widget.searchCriteria))
              ? GroceryListBox(
            groceryObject: widget.groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListFreezer extends StatefulWidget {
  GroceryListFreezer({Key? key, required this.groceryList, this.searchCriteria = ""}) : super(key: key);
  List<GroceryItem> groceryList;
  String searchCriteria;

  @override
  State<GroceryListFreezer> createState() => _GroceryListFreezerState();
}

class _GroceryListFreezerState extends State<GroceryListFreezer> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: widget.groceryList[index].freezer
              && (widget.searchCriteria.isEmpty || widget.groceryList[index].foodName.toLowerCase().contains(widget.searchCriteria))
              ? GroceryListBox(
            groceryObject: widget.groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListNeeded extends StatefulWidget {
  GroceryListNeeded({Key? key, required this.groceryList, this.searchCriteria = ""}) : super(key: key);
  List<GroceryItem> groceryList;
  String searchCriteria;

  @override
  State<GroceryListNeeded> createState() => _GroceryListNeededState();
}

class _GroceryListNeededState extends State<GroceryListNeeded> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: widget.groceryList[index].needed
              && (widget.searchCriteria.isEmpty || widget.groceryList[index].foodName.toLowerCase().contains(widget.searchCriteria))
              ? GroceryListBox(
            groceryObject: widget.groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}
