import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:fitness_tracker/widgets/groceries/grocery_list_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: GroceryListBox(
            groceryObject: context.read<GroceryProvider>().groceryList[index],
            index: index,
          ),
        );
      },
    );
  }
}

class GroceryListCupboard extends StatefulWidget {
  const GroceryListCupboard({Key? key}) : super(key: key);

  @override
  State<GroceryListCupboard> createState() => _GroceryListCupboardState();
}

class _GroceryListCupboardState extends State<GroceryListCupboard> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: context.read<GroceryProvider>().groceryList[index].cupboard ? GroceryListBox(
            groceryObject: context.read<GroceryProvider>().groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListFridge extends StatefulWidget {
  const GroceryListFridge({Key? key}) : super(key: key);

  @override
  State<GroceryListFridge> createState() => _GroceryListFridgeState();
}

class _GroceryListFridgeState extends State<GroceryListFridge> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: context.read<GroceryProvider>().groceryList[index].fridge ? GroceryListBox(
            groceryObject: context.read<GroceryProvider>().groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListFreezer extends StatefulWidget {
  const GroceryListFreezer({Key? key}) : super(key: key);

  @override
  State<GroceryListFreezer> createState() => _GroceryListFreezerState();
}

class _GroceryListFreezerState extends State<GroceryListFreezer> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: context.read<GroceryProvider>().groceryList[index].freezer ? GroceryListBox(
            groceryObject: context.read<GroceryProvider>().groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}

class GroceryListNeeded extends StatefulWidget {
  const GroceryListNeeded({Key? key}) : super(key: key);

  @override
  State<GroceryListNeeded> createState() => _GroceryListNeededState();
}

class _GroceryListNeededState extends State<GroceryListNeeded> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: context.watch<GroceryProvider>().groceryList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: context.read<GroceryProvider>().groceryList[index].needed ? GroceryListBox(
            groceryObject: context.read<GroceryProvider>().groceryList[index],
            index: index,
          ) : const SizedBox.shrink(),
        );
      },
    );
  }
}
