import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthenticationService {
  final FirebaseAuth firebaseAuthenticator;

  FirebaseAuthenticationService(this.firebaseAuthenticator);

  Stream<User?> get firebaseAuthStateChanges => firebaseAuthenticator.authStateChanges();

  Future<bool> firebaseSignIn(String userEmail, String userPassword) async {
    try {
      await firebaseAuthenticator.signInWithEmailAndPassword(email: userEmail, password: userPassword);
      return true;
    } on FirebaseAuthException catch (exception) {
      print(exception);
      return false;
    }
  }
  Future<bool> firebaseSignUp(String userEmail, String userPassword) async {
    try {
      await firebaseAuthenticator.createUserWithEmailAndPassword(email: userEmail, password: userPassword);
      return true;
    } on FirebaseAuthException catch (exception) {
      print(exception);
      return false;
    }
  }
  Future<void> firebaseSignOut() async {
    await firebaseAuthenticator.signOut();
  }
}