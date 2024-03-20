import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/providers/general/general_data_provider.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:fitness_tracker/widgets/general/screen_width_container.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../helpers/general/numerical_range_formatter_extension.dart';
import '../../helpers/general/firebase_auth_service.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_data.dart';
import '../general/auth_choose_login_signup.dart';
import '../general_new/calculate_calories_page.dart';
import "package:fitness_tracker/helpers/general/custom_icons.dart";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signOutUser() async {
    FirebaseAnalytics.instance.logEvent(name: 'sign_out');
    context.read<PageChange>().setCaloriesCalculated(false);

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }

    await FirebaseAuth.instance.signOut();
  }

  double fireScalingFactor(int dailyStreak) {

    double scalingFactor = ((log(0.5*(dailyStreak+8)) / log(10))/0.6)-0.3;

    return scalingFactor;
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double _margin = 15.w;
    return Scaffold(
      key: _scaffoldKey,
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
                onPressed: () {
                  FirebaseAnalytics.instance.logEvent(name: 'opened_update_calorie_goal');
                  _scaffoldKey.currentState?.closeEndDrawer();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalculateCaloriesPage(),
                    ),
                  );
                },
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
        child: Center(
          child: Tilt(
            clipBehavior: Clip.hardEdge,
            border: Border.all(
              color: Colors.orangeAccent
            ),
            borderRadius: BorderRadius.circular(30),
            tiltConfig: const TiltConfig(
              enableSensorRevert: true,
              sensorFactor: 5,
              angle: 20,
              leaveDuration: Duration(seconds: 2),
              leaveCurve: Curves.elasticOut,
            ),
            shadowConfig: const ShadowConfig(
              disable: false,
              color: Colors.orangeAccent,
              minBlurRadius: 0,
              maxBlurRadius: 0,
              offsetFactor: 0.015,
            ),
            lightConfig: const LightConfig(
              color: Color.fromRGBO(255, 246, 163, 0.0),
              minIntensity: 0,
              maxIntensity: 0.3,
            ),
            childLayout: ChildLayout(

              outer: [
                Positioned.fill(
                  bottom: 60,
                  child: TiltParallax(
                    size: const Offset(36, 36),
                    child: Center(
                      child: Icon(
                        MyFlutterApp.campfire,
                        color: streakColourOrangeDark,
                        size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: TiltParallax(
                    size: const Offset(37, 37),
                    child: Center(
                      child: Icon(
                        MyFlutterApp.campfire,
                        color: streakColourOrangeDark,
                        size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: TiltParallax(
                    size: const Offset(38, 38),
                    child: Center(
                      child: Icon(
                        MyFlutterApp.campfire,
                        color: streakColourOrangeDark,
                        size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: TiltParallax(
                    size: const Offset(39, 39),
                    child: Center(
                      child: Icon(
                        MyFlutterApp.campfire,
                        color: streakColourOrangeDark,
                        size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: TiltParallax(
                    size: const Offset(40, 40),
                    child: Center(
                      child: Icon(
                        MyFlutterApp.campfire,
                        color: streakColourOrange,
                        size: 60.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: TiltParallax(
                      size: const Offset(76, 76),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"])),
                        child: Text(
                          context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString(),
                          style: boldTextStyle.copyWith(
                              color: Colors.grey,
                              fontSize: 18*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: TiltParallax(
                      size: const Offset(77, 77),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"])),
                        child: Text(
                          context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString(),
                          style: boldTextStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 18*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: TiltParallax(
                      size: const Offset(78, 78),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"])),
                        child: Text(
                          context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString(),
                          style: boldTextStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 18*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: TiltParallax(
                      size: const Offset(79, 79),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38.h*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"])),
                        child: Text(
                          context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString(),
                          style: boldTextStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 18*fireScalingFactor(context.read<GeneralDataProvider>().dailyStreak["dailyStreak"]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: TiltParallax(
                      size: const Offset(80, 80),
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
                ),
              ],

              inner: [

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TiltParallax(
                      size: const Offset(-80, -80),
                      child: Text(
                        "Daily Streak",
                        style: boldTextStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 42,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TiltParallax(
                      size: const Offset(-79, -79),
                      child: Text(
                        "Daily Streak",
                        style: boldTextStyle.copyWith(
                            color: Colors.grey,
                            fontSize: 42,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TiltParallax(
                      size: const Offset(-78, -78),
                      child: Text(
                        "Daily Streak",
                        style: boldTextStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 42,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TiltParallax(
                      size: const Offset(-77, -77),
                      child: Text(
                        "Daily Streak",
                        style: boldTextStyle.copyWith(
                          color: Colors.grey,
                          fontSize: 42,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned.fill(
                  bottom: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TiltParallax(
                      size: const Offset(-76, -76),
                      child: Text(
                        "Daily Streak",
                        style: boldTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 42,
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
            child: Container(
              width: 300.w,
              height: 580.h,
              color: appTertiaryColour,
            ),
          ),
        ),
      ),
    );
  }
}
