/*
Under normal circumstances I wouldn't comment such obvious code, but due
to being new to Flutter and wanting to make sure I understand what is going on,
and being able to refer back to the code later on, I have left comments so
I don't forget.

-Lewis
 */

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_tracker/helpers/home/phone_validator.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../general/main_page.dart';

class EnterConfirmationPage extends StatefulWidget {
  const EnterConfirmationPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
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
                ),
              ),
              const SizedBox(height: 20.0),

              ///Needs Verification
              TextFormField(
                key: phoneKey,
                controller: phoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: appSecondaryColour,
                  )),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.red,
                  )),
                ),
                validator: (value) {
                  if (!value!.isValidPhoneNumber() && value.isNotEmpty) {
                    return "Invalid Mobile Number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              Center(
                child: ElevatedButton(
                  onPressed: () => requestSMS(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue), // Sets the background color of the button
                  ),
                  child:
                      const Text('Send SMS Code'), // Text displayed on the button
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainPage(),
                    ),
                  ),
                  child: const Text('Skip phone registration'), // Text displayed
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
                decoration: InputDecoration(
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
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue), // Sets the background color of the button
                ),
                child:
                const Text('Confirm Code'), // Text displayed on the button
              ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
