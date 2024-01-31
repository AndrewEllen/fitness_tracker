import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/home/email_validator.dart';
import 'package:fitness_tracker/pages/general_new/user_registration_confirmation_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';


class SignupPage extends StatefulWidget {
  SignupPage({Key? key, required this.videoController}) : super(key: key);
  late VideoPlayerController videoController;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  Future<void> sendVerificationEmail(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserRegistrationConfirmationEmail(videoController: widget.videoController),
        ),
      );
    }
  }

  Future<void> signUpUser(BuildContext context) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser!
          .updateDisplayName(userNameController.text.trim());

      if (context.mounted) {
        sendVerificationEmail(context);
      }
    }
  }


  late Color signInColour = appSecondaryColour;
  late bool _error = false;
  late bool _emailValid = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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

                      TextFormField(
                        key: emailKey,
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: boldTextStyle,
                        cursorColor: appSecondaryColour,
                        decoration: InputDecoration(
                          labelText: "Email",
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
                              _error = true;
                              _emailValid = true;
                            });
                          } else if (value.isEmpty) {
                            setState(() {
                              signInColour = appSecondaryColour;
                              _error = false;
                              _emailValid = false;
                            });
                          } else {
                            setState(() {
                              signInColour = Colors.red;
                              _error = true;
                              _emailValid = false;
                            });
                          }
                        },
                        validator: (value) {
                          if (!value!.isValidEmail() && value.isNotEmpty) {
                            return "Invalid Email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),

                      TextFormField(
                        key: userNameKey,
                        controller: userNameController,
                        style: boldTextStyle,
                        cursorColor: appSecondaryColour,
                        decoration: InputDecoration(
                          labelText: "Username",
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
                      ),
                      const SizedBox(height: 20.0),

                      TextFormField(
                        key: passwordKey,
                        controller: passwordController,
                        style: boldTextStyle,
                        cursorColor: appSecondaryColour,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
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
                          errorBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      ElevatedButton(
                        onPressed: () => signUpUser(context),
                        child: const Text('Signup'),
                      ),
                      const SizedBox(height: 15.0),
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
