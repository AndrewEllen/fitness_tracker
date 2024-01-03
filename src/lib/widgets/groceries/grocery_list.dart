import 'package:cloud_firestore/cloud_firestore.dart';
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grocery-lists')
            .doc(context.read<GroceryProvider>().groceryListID)
            .collection('grocery-data')
            .where(FieldPath.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',style: TextStyle(color: Colors.white),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",style: TextStyle(color: Colors.white),);
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.get("groceryData")! as Map<String, dynamic>;
              return Container(
                child: (widget.searchCriteria.isEmpty || data["foodName"].toLowerCase().contains(widget.searchCriteria))
                    ? GroceryListBox(
                  groceryObject: GroceryItem(
                    uuid: data["uuid"],
                    barcode: data["barcode"],
                    foodName: data["foodName"],
                    cupboard: data["cupboard"],
                    fridge: data["fridge"],
                    freezer: data["freezer"],
                    needed: data["needed"],
                  ),
                ) : const SizedBox.shrink(),
              );
              return ListTile(
                title: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                subtitle: Text(data["foodName"],style: TextStyle(color: Colors.white),),
              );
            }).toList().cast(),
          );
        }
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grocery-lists')
            .doc(context.read<GroceryProvider>().groceryListID)
            .collection('grocery-data')
            .where(FieldPath.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',style: TextStyle(color: Colors.white),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",style: TextStyle(color: Colors.white),);
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.get("groceryData")! as Map<String, dynamic>;
              return Container(
                child: data["cupboard"]
                    && (widget.searchCriteria.isEmpty || data["foodName"].toLowerCase().contains(widget.searchCriteria))
                    ? GroceryListBox(
                  groceryObject: GroceryItem(
                    uuid: data["uuid"],
                    barcode: data["barcode"],
                    foodName: data["foodName"],
                    cupboard: data["cupboard"],
                    fridge: data["fridge"],
                    freezer: data["freezer"],
                    needed: data["needed"],
                  ),
                ) : const SizedBox.shrink(),
              );
              return ListTile(
                title: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                subtitle: Text(data["foodName"],style: TextStyle(color: Colors.white),),
              );
            }).toList().cast(),
          );
        }
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grocery-lists')
            .doc(context.read<GroceryProvider>().groceryListID)
            .collection('grocery-data')
            .where(FieldPath.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',style: TextStyle(color: Colors.white),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",style: TextStyle(color: Colors.white),);
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.get("groceryData")! as Map<String, dynamic>;
              return Container(
                child: data["fridge"]
                    && (widget.searchCriteria.isEmpty || data["foodName"].toLowerCase().contains(widget.searchCriteria))
                    ? GroceryListBox(
                  groceryObject: GroceryItem(
                    uuid: data["uuid"],
                    barcode: data["barcode"],
                    foodName: data["foodName"],
                    cupboard: data["cupboard"],
                    fridge: data["fridge"],
                    freezer: data["freezer"],
                    needed: data["needed"],
                  ),
                ) : const SizedBox.shrink(),
              );
              return ListTile(
                title: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                subtitle: Text(data["foodName"],style: TextStyle(color: Colors.white),),
              );
            }).toList().cast(),
          );
        }
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grocery-lists')
            .doc(context.read<GroceryProvider>().groceryListID)
            .collection('grocery-data')
            .where(FieldPath.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',style: TextStyle(color: Colors.white),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",style: TextStyle(color: Colors.white),);
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.get("groceryData")! as Map<String, dynamic>;
                  return Container(
                    child: data["freezer"]
                        && (widget.searchCriteria.isEmpty || data["foodName"].toLowerCase().contains(widget.searchCriteria))
                        ? GroceryListBox(
                      groceryObject: GroceryItem(
                          uuid: data["uuid"],
                          barcode: data["barcode"],
                          foodName: data["foodName"],
                          cupboard: data["cupboard"],
                          fridge: data["fridge"],
                          freezer: data["freezer"],
                          needed: data["needed"],
                      ),
                    ) : const SizedBox.shrink(),
                  );
                  return ListTile(
                    title: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                    subtitle: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                  );
            }).toList().cast(),
          );
      }
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
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('grocery-lists')
            .doc(context.read<GroceryProvider>().groceryListID)
            .collection('grocery-data')
            .where(FieldPath.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong',style: TextStyle(color: Colors.white),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading",style: TextStyle(color: Colors.white),);
          }
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.get("groceryData")! as Map<String, dynamic>;
              return Container(
                child: data["needed"]
                    && (widget.searchCriteria.isEmpty || data["foodName"].toLowerCase().contains(widget.searchCriteria))
                    ? GroceryListBox(
                  groceryObject: GroceryItem(
                    uuid: data["uuid"],
                    barcode: data["barcode"],
                    foodName: data["foodName"],
                    cupboard: data["cupboard"],
                    fridge: data["fridge"],
                    freezer: data["freezer"],
                    needed: data["needed"],
                  ),
                ) : const SizedBox.shrink(),
              );
              return ListTile(
                title: Text(data["foodName"],style: TextStyle(color: Colors.white),),
                subtitle: Text(data["foodName"],style: TextStyle(color: Colors.white),),
              );
            }).toList().cast(),
          );
        }
    );
  }
}
