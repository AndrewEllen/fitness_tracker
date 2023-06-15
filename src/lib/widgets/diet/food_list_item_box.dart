import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:provider/provider.dart';

import '../../models/diet/food_data_list_item.dart';
import '../../models/diet/food_item.dart';

class FoodListDisplayBox extends StatefulWidget {
  FoodListDisplayBox({Key? key,
    required this.foodObject,
    required this.width,
    this.onTap,
    this.onTapIcon,
    this.onTapIcon2,
    this.icon,
    this.icon2,
    this.iconColour,
    this.icon2Colour,
  }) : super(key: key);

  late ListFoodItem foodObject;
  final IconData? icon, icon2;
  late Color? iconColour, icon2Colour;
  final VoidCallback? onTap, onTapIcon, onTapIcon2;
  late double width;

  @override
  State<FoodListDisplayBox> createState() => _FoodListDisplayBoxState();
}

class _FoodListDisplayBoxState extends State<FoodListDisplayBox> {

  final ScrollController scrollController = ScrollController();

  ScrollToEnd() async {

    await Future.delayed(const Duration(milliseconds: 200), (){});

    await scrollController.animateTo(
        scrollController.position.maxScrollExtent / 25,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
    );

    await scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance
    //    .addPostFrameCallback((_) => ScrollToEnd());
  }

  @override
  Widget build(BuildContext context) {

    if (widget.iconColour?.value == null) {
      widget.iconColour = Colors.white;
    }
    if (widget.icon2Colour?.value == null) {
      widget.icon2Colour = Colors.white;
    }

    return widget.foodObject.foodItemData.foodName.isNotEmpty ? Container(
      key: UniqueKey(),
      margin: const EdgeInsets.all(4),
      height: 60,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color: appQuinaryColour,
      ),
      child: ListTile(
        onTap: widget.onTap,
        leading: Padding(
          padding: const EdgeInsets.only(
            bottom: 15,
            top: 5,
          ),
          child: Container(
            width: 55,
            height: 55,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(
                  color: appSecondaryColour,
                  width: 2
              ),
              borderRadius: const BorderRadius.all(Radius.circular(45)),
              color: Colors.transparent,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                  minHeight: 10,
                  maxWidth: 100,
                  minWidth: 100,
                ),
                child: FittedBox(
                  clipBehavior: Clip.antiAlias,
                  child: Text(
                      ((double.parse(widget.foodObject.foodItemData.calories)/100)*(double.parse(widget.foodObject.foodServingSize) * double.parse(widget.foodObject.foodServings))).toStringAsFixed(0) + "\n Kcal",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(
              left: widget.width/30,
            bottom: 10,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 25,
              minHeight: 15,
            ),
            child: FittedBox(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 25,
                  minHeight: 15,
                  maxWidth: widget.width/1.25,
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  clipBehavior: Clip.hardEdge,
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.foodObject.foodItemData.foodName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
              left: widget.width/8,
            bottom: 10,
          ),
          child: Text(
            widget.foodObject.foodServings + " Servings, " +
                (double.parse(widget.foodObject.foodServingSize) * double.parse(widget.foodObject.foodServings)).toStringAsFixed(1)
                + "g",
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 14
            ),
          ),
        ),
        trailing: widget.icon != null && widget.icon2 != null ?
        Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: Stack(
            //mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: widget.onTapIcon,
                icon: Icon(
                  widget.icon,
                  color: widget.iconColour,
                ),
              ),
              IconButton(
                onPressed: widget.onTapIcon2,
                icon: Icon(
                  widget.icon2,
                  color: widget.icon2Colour,
                ),
              ),
            ],
          ),
        ) : widget.icon != null ?
        IconButton(
          onPressed: widget.onTapIcon,
          icon: Icon(
            widget.icon,
            color: widget.iconColour,
          ),
        ) :
        null,
      ),
    ) : const SizedBox.shrink();

  }
}
