import 'package:fitness_tracker/providers/general/database_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../models/groceries/grocery_item.dart';

class GroceryProvider with ChangeNotifier {

  late List<GroceryItem> _groceryList = [];

  List<GroceryItem> get groceryList => _groceryList;

  void setGroceryList(List<GroceryItem> listFromDB) {

    _groceryList = listFromDB;

    notifyListeners();
  }

  void deleteItemFromList(int index) {

    deleteGrocery(_groceryList[index]);

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

    writeGrocery(_groceryList[index]);

    notifyListeners();
  }

  void addGroceryItem({required String name, String barcode = "", bool cupboard = true, bool fridge = false, bool freezer = false, bool needed = false}) {

    GroceryItem newGroceryItem = GroceryItem(
      uuid: const Uuid().v4(),
      barcode: barcode,
      foodName: name,
      cupboard: cupboard,
      fridge: fridge,
      freezer: freezer,
      needed: needed,
    );

    _groceryList.add(newGroceryItem);

    writeGrocery(newGroceryItem);

    notifyListeners();
  }

}