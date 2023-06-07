import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/pages/auth_choose_login_signup.dart';
import 'package:fitness_tracker/pages/splashscreen.dart';
import 'package:fitness_tracker/providers/user_exercises.dart';
import 'package:flutter/material.dart';
import 'exports.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'helpers/firebase_auth_service.dart';
import 'openfoodfacts_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  setOpenFoodFactsAPISettings;

  runApp(
    MultiProvider(
        providers: [
          Provider<FirebaseAuthenticationService>(
            create: (_) => FirebaseAuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<FirebaseAuthenticationService>().firebaseAuthStateChanges,
            initialData: null,
            updateShouldNotify: (_, __) => true,
            child: const FireBaseAuthenticationCheck(),
          ),
          ChangeNotifierProvider(create: (context) => PageChange()),
          ChangeNotifierProvider(create: (context) => UserNutritionData()),
          ChangeNotifierProvider(create: (context) => ExerciseList()),
          ChangeNotifierProvider(create: (context) => RoutinesList()),
          ChangeNotifierProvider(create: (context) => TrainingPlanProvider()),
          ChangeNotifierProvider(create: (context) => UserStatsMeasurements()),
          ChangeNotifierProvider(create: (context) => UserExercisesList()),
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

class FireBaseAuthenticationCheck extends StatelessWidget {
  const FireBaseAuthenticationCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<User?>();

    if (currentUser != null) {
      return SplashScreen();
    }
    return ChooseLoginSignUp();
  }
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

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      title: 'FIT',
      theme: ThemeData(
        fontFamily: 'Impact',
        iconTheme: const IconThemeData(
          color: appSecondaryColour,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              width: 3,
              color: Colors.transparent,
            ),
            primary: appSecondaryColour,
            shadowColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4)
            ),
          ),
        ),
      ),
      color: appPrimaryColour,
      debugShowCheckedModeBanner: false,
      home: const FireBaseAuthenticationCheck(),
    );
  }
}