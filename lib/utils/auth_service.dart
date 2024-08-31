import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password, return UserCredential
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      print('Error during sign-in: ${e.message}');
      return null;
    } catch (e) {
      print('An unknown error occurred during sign-in: $e');
      return null;
    }
  }

  // Register with email and password, return UserCredential
  Future<UserCredential?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result;
    } on FirebaseAuthException catch (e) {
      print('Error during registration: ${e.message}');
      return null;
    } catch (e) {
      print('An unknown error occurred during registration: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign-out: ${e.toString()}');
    }
  }
}
