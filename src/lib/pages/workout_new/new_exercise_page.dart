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
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Text(
                          'Select Item',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        items: items
                            .map((item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          decoration: BoxDecoration(
                            color: appTertiaryColour
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 40,
                          width: 200,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 400.h,
                          decoration: BoxDecoration(
                            color: appQuinaryColour
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                            overlayColor: MaterialStatePropertyAll(appQuarternaryColour),
                        ),
                        dropdownSearchData: DropdownSearchData(
                          searchController: textEditingController,
                          searchInnerWidgetHeight: 50,
                          searchInnerWidget: Container(
                            color: appQuinaryColour,
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              //expands: true,
                              controller: textEditingController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: appQuarternaryColour,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search for an item...',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),

                              ),
                              onFieldSubmitted: (value) {

                                context.read<WorkoutProvider>().addNewExercise(textEditingController.text);
                                setState(() {
                                  selectedValue = value;
                                  _newAdded = true;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          searchMatchFn: (item, searchValue) {
                            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
                          },
                        ),
                        //This to clear the search value when you close the menu
                        onMenuStateChange: (isOpen) {
                          if (!isOpen) {
                            textEditingController.clear();
                          }
                        },
                      ),
                    ),

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
