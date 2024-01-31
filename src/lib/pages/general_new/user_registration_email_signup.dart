import 'package:fitness_tracker/constants.dart';
import 'package:fitness_tracker/helpers/home/email_validator.dart';
import 'package:flutter/material.dart';
import 'user_registration_confirmation_email.dart';

class UserRegistrationEmailSignup extends StatelessWidget {
  final _emailController = TextEditingController();

  final GlobalKey<FormState> validatorKey = GlobalKey<FormState>();

  UserRegistrationEmailSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 80.0),
                  Image.asset(
                    'assets/instaclone.png',
                    height: 80.0,
                  ),
                  const SizedBox(height: 40.0),
                  const Text(
                    'Enter your email address',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: validatorKey,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: boldTextStyle,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                    validator: (value) => value!.isValidEmail() ? null : "Invalid Email",
                  ),
                  const SizedBox(height: 30.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserRegistrationConfirmationEmail(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Add your onPressed code here
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text("Sign up with mobile number"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
