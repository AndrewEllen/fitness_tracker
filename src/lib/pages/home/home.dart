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

import '../../helpers/general/numerical_range_formatter_extension.dart';
import '../../helpers/general/firebase_auth_service.dart';
import '../../models/stats/user_data_model.dart';
import '../../providers/general/database_write.dart';
import '../../providers/stats/user_data.dart';
import '../general/auth_choose_login_signup.dart';
import '../general/calculate_calories_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<void> signOutUser() async {

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().disconnect();
    }

    await FirebaseAuth.instance.signOut();
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
                      Container(
                        margin: const EdgeInsets.only(top:16),
                        child: ScreenWidthContainer(
                          minHeight: 80.h,
                          maxHeight: 80.h,
                          height: 80.h,
                          margin: _margin/2,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                child: const Text(
                                  "Daily Streak",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Center(
                                child: Text(
                                  context.read<GeneralDataProvider>().dailyStreak["dailyStreak"].toString() + " Days Streak",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Spacer(),
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
