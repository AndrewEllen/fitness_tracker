import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../providers/general/page_change_provider.dart';
import '../../widgets/general/app_default_button.dart';


class NewExercisePage extends StatefulWidget {
  const NewExercisePage({Key? key}) : super(key: key);

  @override
  State<NewExercisePage> createState() => _NewExercisePageState();
}

class _NewExercisePageState extends State<NewExercisePage> {

  String? selectedValue;
  bool _newAdded = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  late List<String> items;



  @override
  Widget build(BuildContext context) {


    ///todo change search function code to my own
    ///style page and put drop down in better spot
    ///add second drop down for category types
    ///add third drop down for exercise types
    ///add code to add them to the exercise object and save the new exercise on the list as well as adding it to the selection page



    items = context.read<WorkoutProvider>().exerciseNamesList;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appPrimaryColour,
        body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
          child: ListView(
            children: [
              Container(
                color: appTertiaryColour,
                width: double.maxFinite,
                height: 50.h,
                child: Center(
                  child: Text(
                    "Create New Exercise",
                    style: boldTextStyle.copyWith(fontSize: 18),
                  ),
                ),
              ),

              Container(
                color: appTertiaryColour,
                child: Column(
                  children: [

                    

                    SizedBox(
                      height: 100.h,
                    ),

                    Center(
                        child: SizedBox(
                          height: 35.h,
                          child: AppButton(
                            onTap: () {

                              context.read<PageChange>().backPage();

                            },
                            buttonText: 'Add New Exercise',
                          ),
                        )
                    ),
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
