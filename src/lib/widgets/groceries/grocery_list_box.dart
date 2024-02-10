import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/helpers/general/string_extensions.dart';
import 'package:fitness_tracker/models/groceries/grocery_item.dart';
import 'package:fitness_tracker/providers/general/database_write.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';
import '../../providers/grocery/groceries_provider.dart';

class GroceryListBox extends StatefulWidget {
  const GroceryListBox({Key? key,
    required this.groceryObject,
    this.onTap,
  }) : super(key: key);

  final GroceryItem groceryObject;
  final VoidCallback? onTap;

  @override
  State<GroceryListBox> createState() => _GroceryListBoxState();
}

class _GroceryListBoxState extends State<GroceryListBox> {

  bool _editing = false;
  final TextEditingController editItemController = TextEditingController();
  final GlobalKey<FormState> editKey = GlobalKey<FormState>();

  final ScrollController scrollController = ScrollController();

  ScrollToEnd() async {

    await Future.delayed(const Duration(milliseconds: 700), (){});

    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
    );

    await scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    editItemController.text = widget.groceryObject.foodName;
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ScrollToEnd());
  }


  List<SlidableAction> getSlidableActionList() {
    List<SlidableAction> slidableActionList = [];

    if (!widget.groceryObject.cupboard) {
      slidableActionList.add(
        SlidableAction(
            padding: const EdgeInsets.all(1),
            onPressed: (value) {
              writeGrocery(
                GroceryItem(
                  uuid: widget.groceryObject.uuid,
                  barcode: widget.groceryObject.barcode,
                  foodName: widget.groceryObject.foodName,
                  cupboard: true,
                  fridge: false,
                  freezer: false,
                  needed: false,
                ),
                context.read<GroceryProvider>().groceryListID,
              );
            },
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          label: 'Cupboard'
        ),
      );
    }
    if (!widget.groceryObject.fridge) {
      slidableActionList.add(
        SlidableAction(
            padding: const EdgeInsets.all(1),
            onPressed: (value) {
              writeGrocery(
                GroceryItem(
                  uuid: widget.groceryObject.uuid,
                  barcode: widget.groceryObject.barcode,
                  foodName: widget.groceryObject.foodName,
                  cupboard: false,
                  fridge: true,
                  freezer: false,
                  needed: false,
                ),
                context.read<GroceryProvider>().groceryListID,
              );
            },
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
            label: 'Fridge'
        ),
      );
    }
    if (!widget.groceryObject.freezer) {
      slidableActionList.add(
        SlidableAction(
            padding: const EdgeInsets.all(1),
            onPressed: (value) {
              writeGrocery(
                  GroceryItem(
                      uuid: widget.groceryObject.uuid,
                      barcode: widget.groceryObject.barcode,
                      foodName: widget.groceryObject.foodName,
                      cupboard: false,
                      fridge: false,
                      freezer: true,
                      needed: false,
                  ),
                  context.read<GroceryProvider>().groceryListID,
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Freezer'
        ),
      );
    }
    if (!widget.groceryObject.needed) {
      slidableActionList.add(
        SlidableAction(
            padding: const EdgeInsets.all(1),
            onPressed: (value) {
              writeGrocery(
                GroceryItem(
                  uuid: widget.groceryObject.uuid,
                  barcode: widget.groceryObject.barcode,
                  foodName: widget.groceryObject.foodName,
                  cupboard: false,
                  fridge: false,
                  freezer: false,
                  needed: true,
                ),
                context.read<GroceryProvider>().groceryListID,
              );
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Needed'
        ),
      );
    }

    return slidableActionList;
  }


  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),

      direction: Axis.horizontal,

      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: getSlidableActionList(),
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        //dismissible: DismissiblePane(
        //  onDismissed: () {
        //    deleteGrocery(widget.groceryObject, context.read<GroceryProvider>().groceryListID);
         // },
        //),
        children: [
          SlidableAction(
              padding: const EdgeInsets.all(1),
              onPressed: (value) {
                setState(() {
                  _editing = !_editing;
                });
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit'
          ),
          SlidableAction(
              padding: const EdgeInsets.all(1),
              onPressed: (value) {
                deleteGrocery(widget.groceryObject, context.read<GroceryProvider>().groceryListID);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete'
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          height: 70.h,
          decoration: const BoxDecoration(
            color: appTertiaryColour,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.35),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: widget.onTap,
              child: Row(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 9.7.h,
                            bottom: 8.0,
                            left: 12.0,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 290.w,
                              child: !_editing ? SingleChildScrollView(
                                controller: scrollController,
                                clipBehavior: Clip.hardEdge,
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.groceryObject.foodName.capitalize(),
                                  style: boldTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.h,
                                  ),
                                ),
                              ) : Padding(
                                padding: const EdgeInsets.only(
                                  //top: 1.h,
                                  //bottom: 8.0,
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                child: SizedBox(
                                  height: 20,
                                  child: Form(
                                    key: editKey,
                                    child: TextFormField(
                                      onTapOutside: (value) {

                                        writeGrocery(
                                          GroceryItem(
                                              uuid: widget.groceryObject.uuid,
                                              barcode: widget.groceryObject.barcode,
                                              foodName: editItemController.text,
                                              cupboard: widget.groceryObject.cupboard,
                                              fridge: widget.groceryObject.fridge,
                                              freezer: widget.groceryObject.freezer,
                                              needed: widget.groceryObject.needed,
                                          ),
                                          context.read<GroceryProvider>().groceryListID,
                                        );

                                        setState(() {
                                          _editing = false;
                                        });
                                      },
                                      onFieldSubmitted: (value) {

                                        writeGrocery(
                                          GroceryItem(
                                            uuid: widget.groceryObject.uuid,
                                            barcode: widget.groceryObject.barcode,
                                            foodName: editItemController.text,
                                            cupboard: widget.groceryObject.cupboard,
                                            fridge: widget.groceryObject.fridge,
                                            freezer: widget.groceryObject.freezer,
                                            needed: widget.groceryObject.needed,
                                          ),
                                          context.read<GroceryProvider>().groceryListID,
                                        );

                                        setState(() {
                                          _editing = false;
                                        });
                                      },
                                      autofocus: true,
                                      controller: editItemController,
                                      cursorColor: Colors.white,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: (15),
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          bottom: 12,
                                          left: 5,
                                          right: 5,
                                        ),
                                        hintText: 'Enter Item Name...',
                                        hintStyle: TextStyle(
                                          color: Colors.white54,
                                          fontSize: (15),
                                        ),
                                        errorStyle: TextStyle(
                                          height: 0,
                                        ),
                                        focusedBorder:
                                        UnderlineInputBorder(
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
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ItemLabel(
                        item: widget.groceryObject,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemLabel extends StatefulWidget {
  ItemLabel({Key? key, required this.item}) : super(key: key);
  GroceryItem item;

  @override
  State<ItemLabel> createState() => _ItemLabelState();
}

class _ItemLabelState extends State<ItemLabel> {

  late String label;
  late Color labelColour;

  labelSetup(GroceryItem item) {

    if (item.cupboard) {
      label = "Cupboard";
      labelColour = Colors.brown;
    }
    else if (item.fridge) {
      label = "Fridge";
      labelColour = Colors.cyan;
    }
    else if (item.freezer) {
      label = "Freezer";
      labelColour = Colors.blue;
    }
    else if (item.needed) {
      label = "Needed";
      labelColour = Colors.green;
    }

  }


  @override
  void initState() {
    labelSetup(widget.item);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 16.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: labelColour,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.h,
            fontWeight: FontWeight.w700,
            shadows: const [
              Shadow(
                offset: Offset(0.5, 1),
                color: Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}

