/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget

-Lewis
 */

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/pages/general_new/user_registration_confirmation_page.dart';
import 'package:flutter/material.dart';

import '../general/main_page.dart';

class UserRegistrationConfirmationEmail extends StatefulWidget {
  const UserRegistrationConfirmationEmail({Key? key}) : super(key: key);

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
            builder: (context) => const EnterConfirmationPage(),
          ),
        );
      }

    }
  }

  @override
  void initState() {
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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold widget provides a basic structure for the app screen
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            timer?.cancel();
            if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            }
            },
        ),
        backgroundColor:
            Colors.white, // Sets the background color of the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Email Confirmation',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'We have sent a confirmation link to ${FirebaseAuth.instance.currentUser!.email}. Please follow the link to continue.',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30.0),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser!.emailVerified) {
                        timer?.cancel();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EnterConfirmationPage(),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors
                          .blue), // Sets the background color of the button
                    ),
                    child:
                        const Text('Continue'), // Text displayed on the button
                  ),
                  TextButton(
                    onPressed: () => sendVerificationEmail(user),
                    child: const Text(
                        'Send new Email Verification Link'), // Text displayed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
