import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/models/groceries/grocery_item.dart';
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
    required this.index,
    this.onTap,
  }) : super(key: key);

  final GroceryItem groceryObject;
  final int index;
  final VoidCallback? onTap;

  @override
  State<GroceryListBox> createState() => _GroceryListBoxState();
}

class _GroceryListBoxState extends State<GroceryListBox> {

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
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ScrollToEnd());
  }


  List<SlidableAction> getSlidableActionList() {
    List<SlidableAction> slidableActionList = [];

    if (!widget.groceryObject.cupboard) {
      slidableActionList.add(
        SlidableAction(
          onPressed: (value) => context.read<GroceryProvider>().changeItemCategory(widget.index, "cupboard"),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          label: 'Cupboard'
        ),
      );
    }
    if (!widget.groceryObject.fridge) {
      slidableActionList.add(
        SlidableAction(
            onPressed: (value) => context.read<GroceryProvider>().changeItemCategory(widget.index, "fridge"),
            backgroundColor: Colors.cyan,
            foregroundColor: Colors.white,
            label: 'Fridge'
        ),
      );
    }
    if (!widget.groceryObject.freezer) {
      slidableActionList.add(
        SlidableAction(
            onPressed: (value) => context.read<GroceryProvider>().changeItemCategory(widget.index, "freezer"),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: 'Freezer'
        ),
      );
    }
    if (!widget.groceryObject.needed) {
      slidableActionList.add(
        SlidableAction(
            onPressed: (value) => context.read<GroceryProvider>().changeItemCategory(widget.index, "needed"),
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
        dismissible: DismissiblePane(
          onDismissed: () => context.read<GroceryProvider>().deleteItemFromList(widget.index),
        ),
        children: [
          SlidableAction(
              onPressed: (value) {},
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit'
          ),
          SlidableAction(
              onPressed: (value) => context.read<GroceryProvider>().deleteItemFromList(widget.index),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete'
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
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
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 290.w,
                              child: SingleChildScrollView(
                                controller: scrollController,
                                clipBehavior: Clip.hardEdge,
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget.groceryObject.foodName,
                                  style: boldTextStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.h,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ItemLabel(
                              item: widget.groceryObject,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "place2",
                        style: boldTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 18.h,
                        ),
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

