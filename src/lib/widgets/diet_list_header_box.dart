import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';

class DietListHeaderBox extends StatefulWidget {
  DietListHeaderBox({Key? key, required this.width, required this.title,
    this.largeTitle = false, this.color = appSecondaryColour,
  }) : super(key: key);
  double width;
  String title;
  Color color;
  bool largeTitle;

  @override
  State<DietListHeaderBox> createState() => _DietListHeaderBoxState();
}

class _DietListHeaderBoxState extends State<DietListHeaderBox> {

  final ScrollController scrollController = ScrollController();

  ScrollToEnd() async {

    await Future.delayed(const Duration(milliseconds: 1000), (){});

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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: widget.largeTitle ? const BorderSide(width: 3, color: appPrimaryColour) : const BorderSide(width: 3, color: appPrimaryColour),
          bottom: widget.largeTitle ? const BorderSide(width: 0, color: appPrimaryColour) : const BorderSide(width: 1, color: appPrimaryColour),
        ),
      ),
      width: widget.width,
      height: 40,
      child: Center(
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
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: widget.largeTitle ? 18 : 15,
                    fontWeight: widget.largeTitle ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
