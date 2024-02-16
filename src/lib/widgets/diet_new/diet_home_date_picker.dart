import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_tracker/providers/stats/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:health/health.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../models/diet/user_nutrition_model.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/diet/user_nutrition_data.dart';
import '../../providers/general/database_get.dart';
import '../general/app_container_header.dart';


class DietDatePicker extends StatefulWidget {
  const DietDatePicker({Key? key}) : super(key: key);

  @override
  State<DietDatePicker> createState() => _DietDatePickerState();
}

class _DietDatePickerState extends State<DietDatePicker> {


  void loadNewData() async {

    UserNutritionModel userNutritionData;
    String date = context.read<UserNutritionData>().nutritionDate.toString();

    if (
    context.read<UserNutritionData>().userDailyNutritionCache.any((element) => element.date.toString() == date)
    ) {

      print("Found");

      print(date);
      print(context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)].date);

      userNutritionData = context.read<UserNutritionData>()
          .userDailyNutritionCache[
      context.read<UserNutritionData>().userDailyNutritionCache
          .indexWhere((element) => element.date == date)
      ];

    } else {

      bool result = await InternetConnection().hasInternetAccess;
      GetOptions options = const GetOptions(source: Source.serverAndCache);

      if (!result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("No Internet Connection \nAttempting to load"),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.6695,
              right: 20,
              left: 20,
            ),
            dismissDirection: DismissDirection.none,
            duration: const Duration(milliseconds: 700),
          ),
        );
        options = const GetOptions(source: Source.cache);
      }

      print("Not Found");

      userNutritionData = await GetUserNutritionData(
        date,
        options: options,
      );

      context.read<UserNutritionData>()
          .addToNutritionDataCache(userNutritionData);

    }

    context.read<UserNutritionData>().setCurrentFoodDiary(
        userNutritionData
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime? newDateUnformatted = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: appTertiaryColour,
            colorScheme: const ColorScheme.light(
              primary: appSecondaryColour,
              onPrimary: Colors.white,
              onSurface: appSecondaryColour,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              headlineMedium: TextStyle(
                fontSize: 26,
              ),
              headlineSmall: TextStyle(
                fontSize: 26,
              ),
              titleSmall: TextStyle(
                fontSize: 20,
              ),
              bodyMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                foregroundColor: Colors.white,
                backgroundColor: appSecondaryColour,
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: context.read<UserNutritionData>().nutritionDate,
      firstDate: DateTime(2012),
      lastDate: DateTime(DateTime.now().year, 12, 31).difference(context.read<UserNutritionData>().nutritionDate) < const Duration(days: 0) ?
      context.read<UserNutritionData>().nutritionDate : DateTime(DateTime.now().year, 12, 31),
    );
    if (newDateUnformatted != null) {
      print(newDateUnformatted);
      context
          .read<UserNutritionData>()
          .updateNutritionDate(newDateUnformatted);
      loadNewData();
    }
  }


  @override
  Widget build(BuildContext context) {

    double _width = 600.w;

    return SizedBox(
      height: 38.h,
      child: Stack(
        children: [
          Center(
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(const Color.fromRGBO(
                    121, 121, 121, 0.36)),
              ),
              onPressed: () => _selectDate(context),
              child: Text(
                context.read<UserNutritionData>().formattedNutritionDate,
                style: boldTextStyle.copyWith(
                  fontSize: 17.h,
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: 200.w,
              child: Row(
                children: [
                  SizedBox(
                    width: 35.h,
                    child: Material(
                      type: MaterialType.transparency,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.keyboard_arrow_left_outlined,
                          ),
                          color: appSecondaryColour,
                          onPressed: () {
                            context
                                .read<UserNutritionData>()
                                .updateNutritionDateArrows(true);
                            loadNewData();
                          }),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 35.h,
                    child: Material(
                      type: MaterialType.transparency,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                          ),
                          color: appSecondaryColour,
                          onPressed: () {
                            context
                                .read<UserNutritionData>()
                                .updateNutritionDateArrows(false);
                            loadNewData();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child: Align(
              alignment: Alignment.centerRight,
              child: Material(
                type: MaterialType.transparency,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
