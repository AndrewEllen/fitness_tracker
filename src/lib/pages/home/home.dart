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
import 'dart:math';

import '../../helpers/general/numerical_range_formatter_extension.dart';
import '../../helpers/general/firebase_auth_service.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_data.dart';
import '../general/auth_choose_login_signup.dart';
import '../general/calculate_calories_page.dart';
import "package:fitness_tracker/helpers/general/custom_icons.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signOutUser() async {

    context.read<PageChange>().setCaloriesCalculated(false);

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }

    await FirebaseAuth.instance.signOut();
  }

  double fireScalingFactor(int dailyStreak) {

    double scalingFactor = ((log(0.5*(dailyStreak+8)) / log(10))/1.4)+0.4;
    print("scalingFactor");
    print(scalingFactor);

    return scalingFactor;
  }

  @override
  Widget build(BuildContext context) {
    double _margin = 15.w;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTertiaryColour,
        title: const Text(
          "Home",
          style: boldTextStyle,
        ),
      ),
      endDrawer: Drawer(
        backgroundColor: appPrimaryColour,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return true;
          },
          child: Column(
            children: [
              AppBar(
                backgroundColor: appTertiaryColour,
                title: const Text(
                  "Settings",
                  style: boldTextStyle,
                ),
                automaticallyImplyLeading: false,
                actions: [Container()],
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculateCaloriesPage(),
                  ),
                ),
                child: Text(
                  "Update Calorie Goal",
                  style: boldTextStyle.copyWith(color: appSecondaryColour),
                ),
              ),
              const Spacer(flex: 20),
              TextButton(
                  onPressed: () => signOutUser(),
                  child: Text(
                    "Logout",
                    style: boldTextStyle.copyWith(color: Colors.red),
                  ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      backgroundColor: appPrimaryColour,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Stack(
              children: [
                ListView(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 300.h,
                        ),
                        child: Container(
                          color: appTertiaryColour,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 20.h),
                              Stack(
                                children: [
                                  Center(
                                    child: Icon(
                                      MyFlutterApp.campfire,
                                      color: streakColourOrange,
                                      size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 38.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"])),
                                        child: Text(
                                          context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString(),
                                          style: boldTextStyle.copyWith(
                                            color: Colors.white,
                                            fontSize: 18*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                                            shadows: [
                                              const Shadow(
                                                offset: Offset(01.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.black,
                                              ),
                                            ]
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
      ),
    );
  }
}
