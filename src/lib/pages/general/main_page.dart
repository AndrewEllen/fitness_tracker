import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/pages/general/splashscreen.dart';
import 'package:fitness_tracker/pages/general_new/auth_landing_page.dart';
import 'package:fitness_tracker/widgets/general/app_default_button.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../diet_new/diet_home.dart';
import '../general_new/user_registration_confirmation_email.dart';
import '../general_new/user_setup_calories_page.dart';
import '../workout_new/workout_home.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<CurvedNavigationBarState> _NavigationBarKey = GlobalKey();

  late bool _isUserEmailVerified = false;

  final pages = [
    WorkoutHomePageNew(),
    DietHomePage(),
    const HomePage(),
    const MeasurementsHomePage(),
    const InformationHomePage(),
  ];

  int _currentNavigatorIndex = 1;
  int _previousIndex = 1;

  static const List<Widget> itemsUnselected = [
    Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
    Icon(
      MdiIcons.foodApple,
      color: Colors.white,
    ),
    Icon(
      Icons.home,
      color: Colors.white,
    ),
    Icon(
      MdiIcons.ruler,
      color: Colors.white,
    ),
    Icon(
      MdiIcons.informationOutline,
      color: Colors.white,
    ),
  ];

  static final List<Widget> itemsSelected = [
    const Icon(
      Icons.fitness_center,
      color: Colors.white,
    ),
    const Icon(
      MdiIcons.foodApple,
      color: Colors.white,
    ),
    const Icon(
      Icons.home,
      color: Colors.white,
    ),
    const Icon(
      MdiIcons.ruler,
      color: Colors.white,
    ),
    const Icon(
      MdiIcons.informationOutline,
      color: Colors.white,
    ),
  ];

  late List<Widget> items;

  @override
  void initState() {

    readFromPrefs();

    if (FirebaseAuth.instance.currentUser != null) {
      checkUserVerificationStatus();
    }

    items = [...itemsUnselected];
    items[_currentNavigatorIndex] = itemsSelected[_currentNavigatorIndex];

    //todo replace below hardcoded values with data from database

    super.initState();
  }

  void readFromPrefs() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    context.read<PageChange>().setCaloriesCalculated(prefs.getBool('${FirebaseAuth.instance.currentUser!.uid} + userCaloriesSetup') ?? false);

  }

  void checkUserVerificationStatus() async {
    if (FirebaseAuth.instance.currentUser!.providerData[0].providerId !=
        "twitter.com") {
      _isUserEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    } else {

      _isUserEmailVerified = true;
    }
  }

  navBarColor(int index) {
    setState(() {
      _previousIndex = _currentNavigatorIndex;
      _currentNavigatorIndex = index;
      context.read<PageChange>().changePageClearCache(pages[index]);

      items[_currentNavigatorIndex] = itemsSelected[_currentNavigatorIndex];
      items[_previousIndex] = itemsUnselected[_previousIndex];
    });

    //_PageController.jumpToPage(_currentNavigatorIndex);
  }

  Future<bool> _onBackKey() async {
    if (context.read<PageChange>().pageWidgetCacheIndex == 0) {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: appTertiaryColour,
              titleTextStyle: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
              contentTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              title: const Text('Are you sure?'),
              content: const Text('Do you want to close the app?'),
              actions: <Widget>[
                AppButton(
                  onTap: () => Navigator.of(context).pop(false),
                  buttonText: "No",
                ),
                AppButton(
                  onTap: () => SystemNavigator.pop(),
                  buttonText: "Yes",
                ),
              ],
            ),
          )) ??
          false;
    } else {
      context.read<PageChange>().backPage();
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          checkUserVerificationStatus();

          if (!snapshot.hasData) {
            return LandingPage();
          }

          if (!_isUserEmailVerified) {
            UserRegistrationConfirmationEmail();
          }

          if (!context.watch<PageChange>().caloriesCalculated) {
            return UserSetupCaloriesPage();
          }

          if (context.watch<PageChange>().dataLoadingFromSplashPage) {
            return const SplashScreen();
          }

            return SafeArea(
                    bottom: false,
                    child: WillPopScope(
                      onWillPop: _onBackKey,
                      child: Scaffold(
                        backgroundColor: appPrimaryColour,
                        bottomNavigationBar: NavigationBarTheme(
                          data: NavigationBarThemeData(
                            labelTextStyle:
                                MaterialStateProperty.resolveWith<TextStyle>(
                              (Set<MaterialState> states) => states
                                      .contains(MaterialState.selected)
                                  ? const TextStyle(color: appSecondaryColour)
                                  : const TextStyle(color: Colors.white),
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  spreadRadius: 3,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: NavigationBar(
                              height: 70.h,
                              elevation: 10,
                              shadowColor: Colors.black,
                              surfaceTintColor: Colors.transparent,
                              indicatorColor: appSecondaryColour,
                              labelBehavior:
                                  NavigationDestinationLabelBehavior.alwaysHide,
                              selectedIndex: _currentNavigatorIndex,
                              onDestinationSelected: (int index) =>
                                  navBarColor(index),
                              backgroundColor: appTertiaryColour,
                              destinations: [
                                NavigationDestination(
                                  icon: itemsUnselected[0],
                                  selectedIcon: itemsSelected[0],
                                  label: "Workouts",
                                ),
                                NavigationDestination(
                                  icon: itemsUnselected[1],
                                  selectedIcon: itemsSelected[1],
                                  label: "Diet",
                                ),
                                NavigationDestination(
                                  icon: itemsUnselected[2],
                                  selectedIcon: itemsSelected[2],
                                  label: "Home",
                                ),
                                NavigationDestination(
                                  icon: itemsUnselected[3],
                                  selectedIcon: itemsSelected[3],
                                  label: "Metrics",
                                ),
                              ],
                            ),
                          ),
                        ),
                        body: IndexedStack(
                          children: context.read<PageChange>().pageWidgetCache,
                          index:
                              context.watch<PageChange>().pageWidgetCacheIndex,
                        ),
                      ),
                    ),
                  );
        }
        );
  }
}
