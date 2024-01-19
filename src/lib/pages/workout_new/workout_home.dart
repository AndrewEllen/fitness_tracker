import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/workout_new/home_page_routines_list.dart';
import '../../widgets/workout_new/workout_daily_tracker.dart';
import '../../widgets/workout_new/workout_home_stats_dropdown.dart';

class WorkoutHomePageNew extends StatefulWidget {
  WorkoutHomePageNew({Key? key}) : super(key: key);

  @override
  State<WorkoutHomePageNew> createState() => _WorkoutHomePageNewState();
}

class _WorkoutHomePageNewState extends State<WorkoutHomePageNew> {

  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();


  newRoutine(BuildContext context) async {

    double buttonSize = 22.h;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          backgroundColor: appTertiaryColour,
          title: const Text(
            "Create a Routine",
            style: TextStyle(
              color: appSecondaryColour,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name Required";
                      }
                      if(context.read<WorkoutProvider>().checkForRoutineData(value!)) {
                        print("EXISTS");
                        return "Routine Already Exists";
                      }
                      return null;
                    },
                    controller: inputController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: (18),
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      isDense: true,
                      label: Text(
                        "Routine Name *",
                        style: boldTextStyle.copyWith(
                            fontSize: 14
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appQuarternaryColour,
                          )
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )
                      ),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: appSecondaryColour,
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      buttonText: "Cancel",
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                ),
                const Spacer(),
                SizedBox(
                    height: buttonSize,
                    child: AppButton(
                      primaryColor: appSecondaryColour,
                      buttonText: "Create",
                      onTap: () {

                        if (_formKey.currentState!.validate()) {

                          context.read<WorkoutProvider>().createNewRoutine(inputController.text);
                          inputController.text = "";

                          Navigator.pop(context);
                        }

                      },
                    )
                ),
                const Spacer(),
              ],
            ),
          ],
        );
      },
    ).then((value){
      final menuState = _key.currentState;
      if (menuState != null) {
        menuState.toggle();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appPrimaryColour,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(

        key: _key,
        distance: 80.w,
        overlayStyle: ExpandableFabOverlayStyle(
          blur: 2,
        ),


        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(
            Icons.menu,
          ),
          fabSize: ExpandableFabSize.regular,
          foregroundColor: Colors.white,
          backgroundColor: appSenaryColour,
          shape: const CircleBorder(),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 46.w,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return FloatingActionButton(
              foregroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              heroTag: null,
              child: Icon(
                MdiIcons.closeCircle,
                color: Colors.red,
                size: 46.w,
              ),
              onPressed: onPressed,
            );
          },
        ),
        children: [
          SizedBox(
            width: 46.w,
            child: FloatingActionButton(
              tooltip: "Add Routine",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                Icons.add,
              ),
              onPressed: () => newRoutine(
                  this.context,
                ),
            ),
          ),
          SizedBox(
            width: 46.w,
            child: FloatingActionButton(
              tooltip: "View Exercise List",
              backgroundColor: appSecondaryColour,
              heroTag: null,
              child: const Icon(
                Icons.list,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              WorkoutDailyTracker(),
              SizedBox(height: 14.h),
              workoutHomeStatsDropdown(),
              SizedBox(height: 14.h),
              HomePageRoutinesList(),
            ],
          ),
        ),
      ),
    );
  }
}
