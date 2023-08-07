import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';


class FoodHistoryListDisplayBox extends StatefulWidget {
  const FoodHistoryListDisplayBox({Key? key,
    required this.foodHistoryName,
    required this.foodHistoryServings,
    required this.foodHistoryServingSize,
    required this.width,
    this.onTap,
    this.onTapIcon,
    this.onTapIcon2,
    this.icon,
    this.icon2,
    this.iconColour = Colors.white,
    this.icon2Colour = Colors.white,
  }) : super(key: key);

  final String foodHistoryName;
  final String foodHistoryServings;
  final String foodHistoryServingSize;
  final IconData? icon, icon2;
  final Color? iconColour, icon2Colour;
  final VoidCallback? onTap, onTapIcon, onTapIcon2;
  final double width;

  @override
  State<FoodHistoryListDisplayBox> createState() => _FoodHistoryListDisplayBoxState();
}

class _FoodHistoryListDisplayBoxState extends State<FoodHistoryListDisplayBox> {

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
                    widget.foodHistoryName,
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
            widget.foodHistoryServings + " Servings, " +
                (double.parse(widget.foodHistoryServingSize) * double.parse(widget.foodHistoryServings)).toStringAsFixed(1)
                + "g",
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 14
            ),
          ),
        ),
        trailing: widget.icon != null && widget.icon2 != null ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: widget.onTapIcon,
                  icon: Icon(
                    widget.icon,
                    color: widget.iconColour,
                  ),
                ),
              ),
              Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  onPressed: widget.onTapIcon2,
                  icon: Icon(
                    widget.icon2,
                    color: widget.icon2Colour,
                  ),
                ),
              ),
            ],
          ),
        ) : widget.icon != null ?
        Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: IconButton(
            onPressed: widget.onTapIcon,
            icon: Icon(
              widget.icon,
              color: widget.iconColour,
            ),
          ),
        ) :
        null,
      ),
    );

  }
}
