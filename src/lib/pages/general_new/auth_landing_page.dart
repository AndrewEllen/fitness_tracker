import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/pages/general_new/user_login_page.dart';
import 'package:fitness_tracker/pages/general_new/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:video_player/video_player.dart';
import '../../constants.dart';
import '../../widgets/general/faded_widget.dart';

void main() {
  runApp(LandingPage());
}

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final emailController = TextEditingController();

  final userNameController = TextEditingController();

  final passwordController = TextEditingController();

  final GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();

  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  Future<void> signInWithTwitter() async {
    TwitterAuthProvider twitterProvider = TwitterAuthProvider();

    await FirebaseAuth.instance.signInWithProvider(twitterProvider);
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? auth = await user?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth?.accessToken,
      idToken: auth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  late VideoPlayerController videoController;

  @override
  void initState() {


    videoController = VideoPlayerController.asset("assets/FITBackgroundVideo.mp4")
      ..initialize().then((_) {

        videoController.play();
        videoController.setLooping(true);

        setState(() {});
      });


    super.initState();
  }


  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 55.0.h),
                              AvatarGlow(
                                glowRadiusFactor: 0.2,
                                glowCount: 2,
                                glowColor: appSecondaryColour,
                                child: Image.asset(
                                  'assets/logo/applogonobg.png',
                                  height: 80.0.h,
                                ),
                              ),
                              SizedBox(height: 40.0.h),

                              Center(
                                child: Column(
                                  children: [

                                    Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                          child: FractionallySizedBox(
                                            widthFactor: 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: appQuarternaryColour, width: 2))),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.only(
                                            left: 8.0.w,
                                            right: 8.0.w,
                                          ),
                                          margin: EdgeInsets.all(8.0.w),
                                          child: Text(
                                            "SIGN IN",
                                            style: boldTextStyle.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Expanded(
                                          child: FractionallySizedBox(
                                            widthFactor: 3,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: appQuarternaryColour, width: 2),
                                                  ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),

                                    SizedBox(height: 10.0.h),

                                    SignInButton(
                                      Buttons.email,
                                      text: "Sign in with Email/Phone",
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(videoController: videoController,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SignInButton(
                                Buttons.google,
                                text: "Sign in with Google",
                                onPressed: () => signInWithGoogle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: appQuarternaryColour, width: 2),
                                    ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            color: Colors.transparent,
                            padding: EdgeInsets.only(
                              left: 8.0.w,
                              right: 8.0.w,
                            ),
                            margin: const EdgeInsets.all(8.0),
                            child: Text(
                              "SIGN UP",
                              style: boldTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: appQuarternaryColour, width: 2))),
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding( // This stays at the bottom
                        padding: EdgeInsets.only(
                          top: 20.0.h,
                          bottom: 20.0.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account?',
                              style: boldTextStyle.copyWith(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 4.0.w),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupPage(videoController: videoController,),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: appSecondaryColour,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
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