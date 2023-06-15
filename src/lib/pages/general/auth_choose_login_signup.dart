import 'package:fitness_tracker/helpers/general/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../widgets/general/app_default_button.dart';
import '../../widgets/general/screen_width_container.dart';
import 'auth_signin.dart';
import 'auth_signup.dart';

class ChooseLoginSignUp extends StatelessWidget {
  ChooseLoginSignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double _margin = 15;
    double _bigContainerMin = 450;
    double _smallContainerMin = 95;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appPrimaryColour,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: (_height/100)*20),
                child: const Text(
                  "FIT",
                  style: TextStyle(
                    color: appSecondaryColour,
                    fontSize: 60,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 10,
                  left: 8,
                  right: 8,
                ),
                decoration: homeBoxDecoration,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ScreenWidthContainer(
                      minHeight: _smallContainerMin * 0.2,
                      maxHeight: _smallContainerMin * 1.5,
                      height: (_height / 100) * 6,
                      margin: _margin / 1.5,
                      child: FractionallySizedBox(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: AppButton(
                          buttonText: "Sign up",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
                        ),
                      ), //ExerciseExpansionPanel(),
                    ),
                    ScreenWidthContainer(
                      minHeight: _smallContainerMin * 0.2,
                      maxHeight: _smallContainerMin * 1.5,
                      height: (_height / 100) * 6,
                      margin: _margin / 1.5,
                      child: FractionallySizedBox(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: AppButton(
                          buttonText: "Sign in",
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => SignInScreen(),
                              ),
                            );
                          },
                        ),
                      ), //ExerciseExpansionPanel(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
