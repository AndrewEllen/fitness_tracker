import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/pages/general/auth_choose_login_signup.dart';
import 'package:fitness_tracker/pages/general/splashscreen.dart';
import 'package:fitness_tracker/providers/general/general_data_provider.dart';
import 'package:fitness_tracker/providers/grocery/groceries_provider.dart';
import 'package:fitness_tracker/providers/stats/user_data.dart';
import 'package:fitness_tracker/providers/workout/workoutProvider.dart';
import 'package:flutter/material.dart';
import 'exports.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'helpers/general/firebase_auth_service.dart';
import 'openfoodfacts_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  setOpenFoodFactsAPISettings;

  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => PageChange()),
          ChangeNotifierProvider(create: (context) => UserNutritionData()),
          ChangeNotifierProvider(create: (context) => WorkoutProvider()),
          ChangeNotifierProvider(create: (context) => UserStatsMeasurements()),
          ChangeNotifierProvider(create: (context) => UserData()),
          ChangeNotifierProvider(create: (context) => GroceryProvider()),
          ChangeNotifierProvider(create: (context) => GeneralDataProvider()),
        ],
        child: const AppMain()
    ),
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance
        .recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance
        .recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: appTertiaryColour,
  ));
}

class AppMain extends StatefulWidget {
  const AppMain({Key? key}) : super(key: key);

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(393, 851),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        scaffoldMessengerKey: _scaffoldKey,
        title: 'FIT',
        theme: ThemeData(
          useMaterial3: false,
          //fontFamily: 'Impact',
          iconTheme: const IconThemeData(
            color: appSecondaryColour,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              side: const BorderSide(
                width: 3,
                color: Colors.transparent,
              ), backgroundColor: appSecondaryColour,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
              ),
            ),
          ),
          unselectedWidgetColor: Colors.white,
        ),
        color: appPrimaryColour,
        debugShowCheckedModeBanner: false,

        builder: (context, child) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
          );
        },
        home: const MainPage(),
      ),
    );
  }
}