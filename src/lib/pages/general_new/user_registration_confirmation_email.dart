/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget

-Lewis
 */

import 'dart:async';
import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/exports.dart';
import 'package:fitness_tracker/pages/general_new/user_registration_confirmation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';
import '../general/main_page.dart';

class UserRegistrationConfirmationEmail extends StatefulWidget {
  UserRegistrationConfirmationEmail({Key? key, this.videoController}) : super(key: key);
  late VideoPlayerController? videoController;

  @override
  State<UserRegistrationConfirmationEmail> createState() =>
      _UserRegistrationConfirmationEmailState();
}

class _UserRegistrationConfirmationEmailState
    extends State<UserRegistrationConfirmationEmail> {
  final user = FirebaseAuth.instance.currentUser!;
  late bool _isUserEmailVerified =
      FirebaseAuth.instance.currentUser!.emailVerified;
  Timer? timer;

  Future<void> sendVerificationEmail(User user) async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future isUserVerified(User user) async {

    await user.reload();

    setState(() {
      _isUserEmailVerified = user.emailVerified;
    });

    if (_isUserEmailVerified) {
      timer?.cancel();

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterConfirmationPage(videoController: videoController,),
          ),
        );
      }

    }
  }

  late VideoPlayerController videoController;

  @override
  void initState() {


    if (widget.videoController == null) {
      videoController = VideoPlayerController.asset("assets/FITBackgroundVideo.mp4")
        ..initialize().then((_) {

          videoController.play();
          videoController.setLooping(true);

          setState(() {});
        });
    } else {
      videoController = widget.videoController!;
    }


    if (!_isUserEmailVerified) {
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => isUserVerified(user),
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    //videoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Scaffold widget provides a basic structure for the app screen
    return Scaffold(
      body: Stack(
        children: [


          SizedBox.expand(

            child: FittedBox(

              fit: BoxFit.fill,
              child: SizedBox(

                width: videoController.value.size?.width ?? 0,
                height: videoController.value.size?.height ?? 0,
                child: VideoPlayer(videoController),

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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Email Confirmation',
                              style: boldTextStyle.copyWith(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              )
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              'We have sent a confirmation link to ${FirebaseAuth.instance.currentUser!.email}. Please follow the link to continue.',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                                        timer?.cancel();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EnterConfirmationPage(videoController: videoController,),
                                          ),
                                        );
                                      }
                                    },
                                    child:
                                    const Text('Continue'), // Text displayed on the button
                                  ),
                                  TextButton(
                                    onPressed: () => sendVerificationEmail(user),
                                    child: Text(
                                      'Send new Email Verification Link',
                                      style: boldTextStyle.copyWith(color: appSecondaryColour),
                                    ), // Text displayed
                                  ),
                                ],
                              ),
                            ),
                          ],
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
