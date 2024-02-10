import 'package:fitness_tracker/models/diet/exercise_calories_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';
import '../../models/diet/food_data_list_item.dart';

class ExerciseListItemBoxNew extends StatefulWidget {
  const ExerciseListItemBoxNew({Key? key,
    required this.exerciseObject,
    this.onTap,
  }) : super(key: key);

  final ListExerciseItem exerciseObject;
  final VoidCallback? onTap;

  @override
  State<ExerciseListItemBoxNew> createState() => _ExerciseListItemBoxNewState();
}

class _ExerciseListItemBoxNewState extends State<ExerciseListItemBoxNew> {

  final ScrollController scrollController = ScrollController();

  ScrollToEnd() async {

    await Future.delayed(const Duration(milliseconds: 700), (){});

    if (scrollController.hasClients) {
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
                                widget.exerciseObject.name,
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
                            widget.exerciseObject.extraInfoField,
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
                      widget.exerciseObject.calories + " Kcal",
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
