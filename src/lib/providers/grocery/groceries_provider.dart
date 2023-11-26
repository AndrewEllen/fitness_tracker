import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../models/groceries/grocery_item.dart';

class GroceryProvider with ChangeNotifier {

  late List<GroceryItem> _groceryList = [
    GroceryItem(
      uuid: "1",
      barcode: "1",
      foodName: "Test Item 1",
      cupboard: true,
      fridge: false,
      freezer: false,
      needed: false,
    ),
    GroceryItem(
      uuid: "2",
      barcode: "2",
      foodName: "Test Item 2",
      cupboard: false,
      fridge: true,
      freezer: false,
      needed: false,
    ),
    GroceryItem(
      uuid: "3",
      barcode: "3",
      foodName: "Test Item 3",
      cupboard: false,
      fridge: false,
      freezer: true,
      needed: false,
    ),
    GroceryItem(
      uuid: "4",
      barcode: "4",
      foodName: "Test Item 4",
      cupboard: false,
      fridge: false,
      freezer: false,
      needed: true,
    ),
  ];

  List<GroceryItem> get groceryList => _groceryList;

  void deleteItemFromList(int index) {

    groceryList.removeAt(index);

    notifyListeners();
  }

  void changeItemCategory(int index, String category) {

    if (category.toLowerCase() == "cupboard") {

      _groceryList[index].cupboard = true;
      _groceryList[index].fridge = false;
      _groceryList[index].freezer = false;
      _groceryList[index].needed = false;

    }
    else if (category.toLowerCase() == "fridge") {

      _groceryList[index].cupboard = false;
      _groceryList[index].fridge = true;
      _groceryList[index].freezer = false;
      _groceryList[index].needed = false;

    }
    else if (category.toLowerCase() == "freezer") {

      _groceryList[index].cupboard = false;
      _groceryList[index].fridge = false;
      _groceryList[index].freezer = true;
      _groceryList[index].needed = false;

    }
    else if (category.toLowerCase() == "needed") {

      _groceryList[index].cupboard = false;
      _groceryList[index].fridge = false;
      _groceryList[index].freezer = false;
      _groceryList[index].needed = true;

    }

    notifyListeners();
  }

  void addGroceryItem({required String name, String barcode = "", bool cupboard = true, bool fridge = false, bool freezer = false, bool needed = false}) {

    _groceryList.add(
      GroceryItem(
          uuid: const Uuid().v4(),
          barcode: barcode,
          foodName: name,
          cupboard: cupboard,
          fridge: fridge,
          freezer: freezer,
          needed: needed,
      )
    );

    notifyListeners();
  }

}