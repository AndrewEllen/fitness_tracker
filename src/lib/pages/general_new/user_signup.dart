import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/home/email_validator.dart';
import 'package:fitness_tracker/pages/general_new/user_registration_confirmation_email.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

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
          builder: (context) => const UserRegistrationConfirmationEmail(),
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
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80.0),
              Image.asset(
                'assets/logo.png',
                height: 80.0,
              ),
              const SizedBox(height: 40.0),

              ///Needs Verification
              TextFormField(
                key: emailKey,
                controller: emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                labelText: "Email",
                errorStyle: boldTextStyle.copyWith(
                  color: Colors.red,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: appSecondaryColour,
                    )
                ),
                focusedBorder: OutlineInputBorder(
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
                decoration: InputDecoration(
                  labelText: "Username",
                  errorStyle: boldTextStyle.copyWith(
                    color: Colors.red,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
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
              const SizedBox(height: 20.0),

              TextFormField(
                key: passwordKey,
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorStyle: boldTextStyle.copyWith(
                    color: Colors.red,
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appSecondaryColour,
                      )
                  ),
                  focusedBorder: OutlineInputBorder(
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
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () => signUpUser(context),
                child: const Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
