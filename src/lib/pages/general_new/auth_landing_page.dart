import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/pages/general_new/user_login_page.dart';
import 'package:fitness_tracker/pages/general_new/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../constants.dart';

void main() {
  runApp(LandingPage());
}

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: appPrimaryColour.withOpacity(0.4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80.0),
                    //Image.asset(
                    //  'assets/logo/applogo.png',
                    //  height: 80.0,
                    //),
                    const SizedBox(height: 40.0),

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
                                                color: appTertiaryColour, width: 1))),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                color: Colors.transparent,
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                  right: 8.0,
                                ),
                                margin: const EdgeInsets.all(8.0),
                                child: Text(
                                  "SIGN IN",
                                  style: boldTextStyle.copyWith(
                                    fontWeight: FontWeight.w300,
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
                                                color: appTertiaryColour, width: 1))),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),

                          const SizedBox(height: 10.0),

                          SignInButton(
                            Buttons.email,
                            text: "Sign in with Email/Phone",
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
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
                                  color: appTertiaryColour, width: 1))),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                  ),
                  margin: const EdgeInsets.all(8.0),
                  child: Text(
                    "SIGN UP",
                    style: boldTextStyle.copyWith(
                      fontWeight: FontWeight.w300,
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
                                  color: appTertiaryColour, width: 1))),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Padding( // This stays at the bottom
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t have an account?'),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
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
    );
  }
}