/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to Flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget.

-Lewis
 */

import 'package:fitness_tracker/helpers/home/email_validator.dart';
import 'package:fitness_tracker/helpers/home/phone_validator.dart';
import 'package:fitness_tracker/pages/general_new/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
  late bool _phoneSignin = false;
  late bool _showPasswordBox = false;
  late String signInLabelText = "Sign in with Email or Mobile Number";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded( // Added Expanded
            child: SingleChildScrollView( // Added SingleChildScrollView
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 80.0),
                    Image.asset(
                      'assets/logo.png',
                      height: 80.0,
                    ),
                    const SizedBox(height: 40.0),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: userNameKey,
                      controller: userNameController,
                      decoration: InputDecoration(
                        labelText: signInLabelText,
                        labelStyle: _showPasswordBox ? boldTextStyle.copyWith(
                          color: signInColour,
                        ): null,
                        errorStyle: boldTextStyle.copyWith(
                          color: Colors.red,
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
                            signInColour = Colors.green;
                            signInLabelText = "Logging in with Email";
                            _phoneSignin = false;
                            _showPasswordBox = true;
                          });
                        }
                        else if (value.isValidPhoneNumber()) {
                          setState(() {
                            signInColour = Colors.green;
                            signInLabelText = "Logging in with Mobile Number";
                            _phoneSignin = true;
                            _showPasswordBox = true;
                          });
                        }
                        else if (value.isEmpty) {
                          setState(() {
                            signInColour = appSecondaryColour;
                            signInLabelText = "Login with Email or Mobile Number";
                            _phoneSignin = false;
                            _showPasswordBox = false;
                          });
                        }
                        else {
                          setState(() {
                            signInColour = Colors.red;
                            signInLabelText = "Login with Email or Mobile Number";
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
                    const SizedBox(height: 16.0),
                    _phoneSignin ? ElevatedButton(
                      onPressed: () async {
                        requestSMS();
                      },
                      child: const Text('Request SMS Code'),
                    ) : const SizedBox.shrink(),
                    _showPasswordBox ? TextFormField(
                      key: passwordKey,
                      controller: passwordController,
                      obscureText: !_phoneSignin,
                      decoration: InputDecoration(
                        labelText: _phoneSignin ? "SMS Code" : 'Password',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: appSecondaryColour,
                            )
                        ),
                      ),
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        signInUser(context);
                      },
                      child: const Text('Log In'),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Forgot Password?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ),
          ),
          Padding( // This stays at the bottom
            padding: const EdgeInsets.only(bottom: 20.0),
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
        ],
      ),
    );
  }
}
