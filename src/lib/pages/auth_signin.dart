import 'package:fitness_tracker/helpers/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../widgets/app_default_button.dart';
import '../widgets/screen_width_container.dart';
import 'auth_signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userEmailController = TextEditingController();
  final userEmailKey = GlobalKey<FormState>();
  final TextEditingController userPasswordController = TextEditingController();
  final userPasswordKey = GlobalKey<FormState>();
  bool _showPassword = false;

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
                    Form(
                      key: userEmailKey,
                      child: TextFormField(
                        controller: userEmailController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: (20),
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Enter Email...',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                            fontSize: (20),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          suffix: IconButton(
                            iconSize: 22,
                            onPressed: null,
                            icon: Icon(
                              Icons.visibility_off,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isNotEmpty && RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                              .hasMatch(userEmailController.text)) {
                            return null;
                          }
                          return "Please Enter a Valid Email";
                        },
                      ),
                    ),
                    Form(
                      key: userPasswordKey,
                      child: TextFormField(
                        obscureText: !_showPassword,
                        obscuringCharacter: "*",
                        keyboardType: TextInputType.text,
                        controller: userPasswordController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: (20),
                        ),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: 'Enter Password...',
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                            fontSize: (20),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          suffix: IconButton(
                              iconSize: 22,
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_outlined,
                                color: Colors.white54,
                              ))
                        ),
                        validator: (String? value) {
                          if (value!.isNotEmpty && value.length >= 6) {
                            return null;
                          }
                          return "Please Enter a Valid Password";
                        },
                      ),
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
                          buttonText: "Login",
                          onTap: () {
                            if (userEmailKey.currentState!.validate() & userPasswordKey.currentState!.validate()) {
                              context.read<FirebaseAuthenticationService>().firebaseSignIn(
                                userEmailController.text,
                                userPasswordController.text,
                              );
                            }
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
                          buttonText: "Back",
                          onTap: () {
                            Navigator.of(context).pop();
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
