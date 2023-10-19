import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';

class FoodListItemBoxNew extends StatefulWidget {
  const FoodListItemBoxNew({Key? key,
    required this.foodObject,
    this.onTap,
  }) : super(key: key);

  final ListFoodItem foodObject;
  final VoidCallback? onTap;

  @override
  State<FoodListItemBoxNew> createState() => _FoodListItemBoxNewState();
}

class _FoodListItemBoxNewState extends State<FoodListItemBoxNew> {

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

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
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
                                widget.foodObject.foodItemData.foodName,
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
                      ((double.parse(widget.foodObject.foodItemData.calories)/100)*(double.parse(widget.foodObject.foodServingSize) * double.parse(widget.foodObject.foodServings))).toStringAsFixed(0) + " Kcal",
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
    );
  }
}
