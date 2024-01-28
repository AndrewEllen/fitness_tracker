/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to Flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget.

-Lewis
 */

import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:fitness_tracker/helpers/home/email_validator.dart';
import 'package:fitness_tracker/helpers/home/phone_validator.dart';
import 'package:fitness_tracker/pages/general_new/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.videoController}) : super(key: key);
  late VideoPlayerController videoController;


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();

  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  late String verificationID;

  Future requestSMS() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userNameController.text,
      verificationCompleted: (PhoneAuthCredential credential) {

      },
      verificationFailed: (FirebaseAuthException error) {
        if (error.code == 'invalid-phone-number') {
          debugPrint("Invalid phone number");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {

        verificationID = verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> signInUser(BuildContext context) async {
    //Uses this method if the username is an email

    if (userNameController.text.isValidEmail()) {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        //Trim removes any spaces at the beginning and end of the string.
        email: userNameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (FirebaseAuth.instance.currentUser != null) {
        //Use context.mounted to avoid error message
        //Not entirely sure what the difference it makes is
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }

    }
    else if (userNameController.text.isValidPhoneNumber()) {

      await FirebaseAuth.instance.signInWithCredential(
          PhoneAuthProvider.credential(verificationId: verificationID, smsCode: passwordController.text)
      );

      if (FirebaseAuth.instance.currentUser!.phoneNumber != null) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      }

    }
  }

  late Color signInColour = appSecondaryColour;
  late bool _error = false;
  late bool _phoneSignin = false;
  late bool _showPasswordBox = false;
  late String signInLabelText = "Sign in with Email or Mobile Number";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Stack(
          children: [

            SizedBox.expand(

              child: FittedBox(

                fit: BoxFit.fill,
                child: SizedBox(

                  width: widget.videoController.value.size?.width ?? 0,
                  height: widget.videoController.value.size?.height ?? 0,
                  child: VideoPlayer(widget.videoController),

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
                    height: 490.h,
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 10.0),
                                TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    key: userNameKey,
                                    controller: userNameController,
                                    style: boldTextStyle,
                                    cursorColor: appSecondaryColour,
                                    decoration: InputDecoration(
                                      labelText: signInLabelText,
                                      labelStyle: _error ? boldTextStyle.copyWith(
                                        color: signInColour,
                                        fontSize: 14,
                                      ) : boldTextStyle.copyWith(
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
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: signInColour,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: signInColour,
                                          )
                                      ),
                                      focusedErrorBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          )
                                      ),
                                      errorBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isValidEmail()) {
                                        setState(() {
                                          signInColour = appSecondaryColour;
                                          signInLabelText = "Logging in with Email";
                                          _error = true;
                                          _phoneSignin = false;
                                          _showPasswordBox = true;
                                        });
                                      }
                                      else if (value.isValidPhoneNumber()) {
                                        setState(() {
                                          signInColour = appSecondaryColour;
                                          signInLabelText = "Logging in with Mobile Number";
                                          _error = true;
                                          _phoneSignin = true;
                                          _showPasswordBox = true;
                                        });
                                      }
                                      else if (value.isEmpty) {
                                        setState(() {
                                          signInColour = appSecondaryColour;
                                          signInLabelText = "Login with Email or Mobile Number";
                                          _error = false;
                                          _phoneSignin = false;
                                          _showPasswordBox = false;
                                        });
                                      }
                                      else {
                                        setState(() {
                                          signInColour = Colors.red;
                                          signInLabelText = "Login with Email or Mobile Number";
                                          _error = true;
                                          _phoneSignin = false;
                                          _showPasswordBox = false;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      if (value!.isNotEmpty && !(value.isValidPhoneNumber() || value.isValidEmail())) {
                                        return "Invalid Email or Mobile Number";
                                      }
                                      return null;
                                    }
                                ),

                                SizedBox(height: _phoneSignin ? 8.0 : 16.0),
                                _phoneSignin ? ElevatedButton(
                                  onPressed: () async {
                                    requestSMS();
                                  },
                                  child: const Text('Request SMS Code'),
                                ) : const SizedBox.shrink(),
                                _phoneSignin ? SizedBox(height: _phoneSignin ? 8.0 : 16.0) : const SizedBox.shrink(),
                                _showPasswordBox ? TextFormField(
                                  key: passwordKey,
                                  controller: passwordController,
                                  obscureText: !_phoneSignin,
                                  style: boldTextStyle,
                                  cursorColor: appSecondaryColour,
                                  decoration: InputDecoration(
                                    labelText: _phoneSignin ? "SMS Code" : 'Password',
                                    labelStyle: boldTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appQuarternaryColour,
                                        )
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: appSecondaryColour,
                                        )
                                    ),
                                  ),
                                ) : const SizedBox.shrink(),
                                _showPasswordBox ? const SizedBox(height: 6.0) : const SizedBox.shrink(),
                                _showPasswordBox || _phoneSignin ? ElevatedButton(
                                  onPressed: () async {
                                    signInUser(context);
                                  },
                                  child: const Text('Log In'),
                                ) : const SizedBox.shrink(),
                                SizedBox(height: _phoneSignin ? 18.0 : 70),
                                const Text(
                                  'Forgot Password?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: appSecondaryColour,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
