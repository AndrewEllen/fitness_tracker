import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/providers/general/general_data_provider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../helpers/general/numerical_range_formatter_extension.dart';
import '../../helpers/general/firebase_auth_service.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_data.dart';
import '../general/auth_choose_login_signup.dart';

class CalculateCaloriesPage extends StatefulWidget {
  const CalculateCaloriesPage({Key? key}) : super(key: key);

  @override
  _CalculateCaloriesPageState createState() => _CalculateCaloriesPageState();
}

class _CalculateCaloriesPageState extends State<CalculateCaloriesPage> {

  late UserDataModel userData = context.read<UserData>().userData;
  late String _dropdownActivityValue = userData.activityLevel;
  late String _dropdownWeightValue = userData.weightGoal;
  late String _dropdownGenderValue = userData.biologicalSex;

  late TextEditingController heightController = TextEditingController(text: userData.height);
  late final heightKey = GlobalKey<FormState>();

  late TextEditingController weightController = TextEditingController(text: userData.weight);
  late final weightKey = GlobalKey<FormState>();

  late TextEditingController ageController = TextEditingController(text: userData.age);
  late final ageKey = GlobalKey<FormState>();

  calculateCalories() async {

    if (heightController.text.isNotEmpty && weightController.text.isNotEmpty
        && ageController.text.isNotEmpty) {
      late double calories;
      late double calAdjustment;
      late double bmrMult;
      late double weightGain;

      switch (double.parse(_dropdownActivityValue)) {
        case 0:
          bmrMult = 1.2;
        case 1:
          bmrMult = 1.375;
        case 2:
          bmrMult = 1.55;
        case 3:
          bmrMult = 1.725;
        case 4:
          bmrMult = 1.9;
      }

      switch (double.parse(_dropdownWeightValue)) {
        case 0:
          weightGain = -500;
        case 1:
          weightGain = -250;
        case 2:
          weightGain = 0;
        case 3:
          weightGain = 250;
        case 4:
          weightGain = 500;
      }

      switch (double.parse(_dropdownGenderValue)) {
        case 0:
          calAdjustment = 5;
        case 1:
          calAdjustment = -161;
      }

      calories = ((
          10 * double.parse(weightController.text) + 6.25 * double.parse(heightController.text)
              - 5 * double.parse(ageController.text) + calAdjustment
      ) * bmrMult) + weightGain;

      debugPrint(calories.toString());

      context.read<UserData>().updateUserBioData(UserDataModel(
          height: heightController.text,
          weight: weightController.text,
          age: ageController.text,
          activityLevel: _dropdownActivityValue,
          weightGoal: _dropdownWeightValue,
          biologicalSex: _dropdownGenderValue,
          calories: calories.toStringAsFixed(2)
      ));

      context.read<UserNutritionData>().setCalories(calories.toStringAsFixed(2));

    }
  }

  late VideoPlayerController videoController;

  @override
  void initState() {

    videoController = VideoPlayerController.asset("assets/FITBackgroundVideo.mp4")
      ..initialize().then((_) {

        videoController.play();
        videoController.setLooping(true);

        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: const Text(
          "Update Calories Goal",
          style: boldTextStyle,
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(

            child: FittedBox(

              fit: BoxFit.fill,
              child: SizedBox(

                width: videoController.value.size?.width ?? 0,
                height: videoController.value.size?.height ?? 0,
                child: VideoPlayer(videoController),

              ),
            ),
          ),

          SizedBox.expand(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 30.w,
                    right: 30.w,
                  ),
                  decoration: BoxDecoration(
                    color: appPrimaryColour.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 320.w,
                  height: 600.h,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0.h, bottom: 30.h),
                        child: AvatarGlow(
                          glowRadiusFactor: 0.2,
                          glowCount: 2,
                          glowColor: appSecondaryColour,
                          child: Image.asset(
                            'assets/logo/applogonobg.png',
                            height: 80.0.h,
                          ),
                        ),
                      ),

                      Form(
                        key: heightKey,
                        child: TextFormField(
                          controller: heightController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: (20),
                          ),
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            NumericalRangeFormatter(min: 1, max: 300),
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffix: Text(
                              "Centimeters",
                              style: boldTextStyle.copyWith(color: Colors.white60),
                            ),
                            labelText: "Height *",
                            labelStyle: boldTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            errorStyle: boldTextStyle.copyWith(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appQuarternaryColour,
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            }
                            return "Form Empty";
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Form(
                        key: weightKey,
                        child: TextFormField(
                          controller: weightController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: (20),
                          ),
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            NumericalRangeFormatter(min: 1, max: 800),
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffix: Text(
                              "Kilograms",
                              style: boldTextStyle.copyWith(color: Colors.white60),
                            ),
                            labelText: "Weight *",
                            labelStyle: boldTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            errorStyle: boldTextStyle.copyWith(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appQuarternaryColour,
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            }
                            return "Form Empty";
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Form(
                        key: ageKey,
                        child: TextFormField(
                          cursorColor: appSecondaryColour,
                          controller: ageController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: (20),
                          ),
                          textAlign: TextAlign.left,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            NumericalRangeFormatter(min: 1, max: 123),
                          ],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffix: Text(
                              "Years",
                              style: boldTextStyle.copyWith(color: Colors.white60),
                            ),
                            labelText: "Age *",
                            labelStyle: boldTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            errorStyle: boldTextStyle.copyWith(
                              color: Colors.red,
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appQuarternaryColour,
                                )
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appSecondaryColour,
                                )
                            ),
                            focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.isNotEmpty) {
                              return null;
                            }
                            return "Form Empty";
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: appTertiaryColour,
                        ),
                        child: DropdownButton(
                            value: _dropdownActivityValue,
                            items: const [
                              DropdownMenuItem(child: Text("Sedentary",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "0",
                              ),
                              DropdownMenuItem(child: Text("Lightly Active",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "1",
                              ),
                              DropdownMenuItem(child: Text("Moderately Active",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "2",
                              ),
                              DropdownMenuItem(child: Text("Very Active",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "3",
                              ),
                              DropdownMenuItem(child: Text("Extremely Active",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "4",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _dropdownActivityValue = value!;
                              });
                            }
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: appTertiaryColour,
                        ),
                        child: DropdownButton(
                            value: _dropdownWeightValue,
                            items: const [
                              DropdownMenuItem(child: Text("Extreme Weight Loss",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "0",
                              ),
                              DropdownMenuItem(child: Text("Mild Weight Loss",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "1",
                              ),
                              DropdownMenuItem(child: Text("Maintain Weight",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "2",
                              ),
                              DropdownMenuItem(child: Text("Mild Weight Gain",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "3",
                              ),
                              DropdownMenuItem(child: Text("Extreme Weight Gain",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "4",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _dropdownWeightValue = value!;
                              });
                            }
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          canvasColor: appTertiaryColour,
                        ),
                        child: DropdownButton(
                            value: _dropdownGenderValue,
                            items: const [
                              DropdownMenuItem(child: Text("Male",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "0",
                              ),
                              DropdownMenuItem(child: Text("Female",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                                value: "1",
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _dropdownGenderValue = value!;
                              });
                            }
                        ),
                      ),
                      AppButton(
                        onTap: () async {

                          if (heightKey.currentState!.validate()
                              && weightKey.currentState!.validate()
                              && ageKey.currentState!.validate()
                          ) {

                            await calculateCalories();
                            Navigator.pop(context);
                          }

                        },
                        buttonText: "Update Calories",
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
