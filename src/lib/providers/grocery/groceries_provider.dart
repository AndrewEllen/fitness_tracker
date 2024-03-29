import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/providers/general/database_write.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import '../../models/groceries/grocery_item.dart';

class GroceryProvider with ChangeNotifier {

  late String _groceryListID = "";

  String get groceryListID => _groceryListID;

  late List<String> _groceryLists = [];

  List<String> get groceryLists => _groceryLists;

  late List<GroceryItem> _groceryList = [];

  List<GroceryItem> get groceryList => _groceryList;

  void setGroceryListID(String newGroceryListID) {

    if (!_groceryLists.contains(newGroceryListID)) {
      _groceryLists.add(newGroceryListID);
      writeGroceryLists(_groceryLists);
    }

    _groceryListID = newGroceryListID;
    writeGroceryListID(newGroceryListID);
    notifyListeners();
  }

  void setGroceryLists(List<String> listFromDB) {

    _groceryLists = listFromDB;

    writeGroceryLists(listFromDB);

    notifyListeners();
  }

  void setGroceryList() {

    if (false) {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

      final snapshot = FirebaseFirestore.instance
          .collection('grocery-lists')
          .doc(_groceryListID)
          .collection('grocery-data')
          .where(FieldPath.documentId)
          .snapshots()
          .listen((event) {

        List<GroceryItem> groceryItems = [
          for (QueryDocumentSnapshot document in event.docs)
            GroceryItem(
              uuid: document.get("groceryData")["uuid"],
              barcode: document.get("groceryData")["barcode"],
              foodName: document.get("groceryData")["foodName"],
              cupboard: document.get("groceryData")["cupboard"],
              fridge: document.get("groceryData")["fridge"],
              freezer: document.get("groceryData")["freezer"],
              needed: document.get("groceryData")["needed"],
            ),
        ];

      });
    }

  }

  void deleteItemFromList(int index) {

    deleteGrocery(_groceryList[index], _groceryListID);

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

    writeGrocery(_groceryList[index], _groceryListID);

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

    writeGrocery(newGroceryItem, _groceryListID);

    notifyListeners();
  }

}