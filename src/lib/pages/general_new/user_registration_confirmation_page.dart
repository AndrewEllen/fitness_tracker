/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to Flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget.

-Lewis
 */

import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/home/phone_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../general/main_page.dart';

class EnterConfirmationPage extends StatefulWidget {
  EnterConfirmationPage({Key? key, required this.videoController}) : super(key: key);
  late VideoPlayerController videoController;

  @override
  State<EnterConfirmationPage> createState() => _EnterConfirmationPageState();
}

class _EnterConfirmationPageState extends State<EnterConfirmationPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final GlobalKey<FormState> phoneKey = GlobalKey<FormState>();
  final GlobalKey<FormState> otpKey = GlobalKey<FormState>();

  late String verificationID;

  Future addPhoneToAccount(BuildContext context) async {

    await FirebaseAuth.instance.currentUser!.updatePhoneNumber(
        PhoneAuthProvider.credential(verificationId: verificationID, smsCode: otpController.text)
    );

    if (FirebaseAuth.instance.currentUser!.phoneNumber != null) {
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      }
    }

  }

  Future requestSMS() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {

      },
      verificationFailed: (FirebaseAuthException error) {
        if (error.code == 'invalid-phone-number') {
          debugPrint("Invalid phone number");
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        setState(() {
          _sendSMS = true;
        });

        verificationID = verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }


  late bool _sendSMS = false;
  late Color signInColour = appSecondaryColour;
  late bool _error = false;
  late bool _phoneNumber = false;

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

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Enter Mobile Phone Number',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20.0),

                              ///Needs Verification
                              TextFormField(
                                key: phoneKey,
                                controller: phoneController,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                style: boldTextStyle,
                                cursorColor: appSecondaryColour,
                                decoration: InputDecoration(
                                  labelText: "Phone Number",
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
                                  if (value.isValidPhoneNumber()) {
                                    setState(() {
                                      signInColour = appSecondaryColour;
                                      _error = true;
                                      _phoneNumber = true;
                                    });
                                  } else if (value.isEmpty) {
                                    setState(() {
                                      signInColour = appSecondaryColour;
                                      _error = false;
                                      _phoneNumber = false;
                                    });
                                  } else {
                                    setState(() {
                                      signInColour = Colors.red;
                                      _error = true;
                                      _phoneNumber = false;
                                    });
                                  }
                                },
                                validator: (value) {
                                  if (!value!.isValidPhoneNumber() && value.isNotEmpty) {
                                    return "Invalid Email";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),

                              Center(
                                child: ElevatedButton(
                                  onPressed: () => requestSMS(),

                                  child:
                                  const Text('Send SMS Code'), // Text displayed on the button
                                ),
                              ),
                              const SizedBox(height: 60),
                              Center(
                                child: TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainPage(),
                                    ),
                                  ),
                                  child: Text('Skip phone registration', style: boldTextStyle.copyWith(color: appSecondaryColour),), // Text displayed
                                ),
                              ),
                              _sendSMS
                                  ? const Text(
                                'Enter confirmation code',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                                  : const SizedBox.shrink(),
                              _sendSMS
                                  ? const SizedBox(height: 8)
                                  : const SizedBox.shrink(), // Adds vertical spacing
                              _sendSMS
                                  ? Text(
                                'We have sent a confirmation code to ${phoneController.text}. Please enter the code below to continue.',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              )
                                  : const SizedBox.shrink(),
                              _sendSMS
                                  ? const SizedBox(height: 16)
                                  : const SizedBox.shrink(), // Adds vertical spacing
                              _sendSMS
                                  ? TextFormField(
                                key: otpKey,
                                controller: otpController,
                                decoration: const InputDecoration(
                                  labelText: 'SMS Code',
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: appSecondaryColour,
                                      )),
                                ),
                              ) : const SizedBox.shrink(),
                              _sendSMS
                                  ? const SizedBox(height: 16)
                                  : const SizedBox.shrink(), // Adds vertical
                              _sendSMS
                                  ? Center(
                                child: ElevatedButton(
                                  onPressed: () => addPhoneToAccount(context),
                                  child:
                                  const Text('Confirm Code'), // Text displayed on the button
                                ),
                              )
                                  : const SizedBox.shrink(),
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
    );
  }
}
