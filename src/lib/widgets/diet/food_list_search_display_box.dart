import 'package:fitness_tracker/models/diet/food_item.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';


class FoodListSearchDisplayBox extends StatefulWidget {
  const FoodListSearchDisplayBox({Key? key,
    required this.foodObject,
    required this.width,
    this.onTap,
    this.onTapIcon,
    this.onTapIcon2,
    this.icon,
    this.icon2,
    this.iconColour = Colors.white,
    this.icon2Colour = Colors.white,
    this.verifiedFood = false,
  }) : super(key: key);

  final FoodItem foodObject;
  final IconData? icon, icon2;
  final Color? iconColour, icon2Colour;
  final VoidCallback? onTap, onTapIcon, onTapIcon2;
  final double width;
  final bool verifiedFood;

  @override
  State<FoodListSearchDisplayBox> createState() => _FoodListSearchDisplayBoxState();
}

class _FoodListSearchDisplayBoxState extends State<FoodListSearchDisplayBox> {

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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ScrollToEnd());
  }

  @override
  Widget build(BuildContext context) {

    return Container(
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
            padding: const EdgeInsets.all(2),
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
                    double.parse(widget.foodObject.calories).toStringAsFixed(0) + "\n Kcal",
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
                    widget.foodObject.foodName,
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
          child: widget.foodObject.firebaseItem ? RichText(
            text: const TextSpan(
                text: "Kcal Per 100g. ",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Verified Food.",
                    style: TextStyle(
                        color: appSecondaryColour,
                        fontSize: 12
                    ),
                  )
                ]
            ),
          ) : const Text(
            "Kcal Per 100g",
            style: TextStyle(
                color: Colors.white70,
                fontSize: 12
            ),
          ),
        ),
        trailing: widget.icon != null && widget.icon2 != null ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
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
    );

  }
}
