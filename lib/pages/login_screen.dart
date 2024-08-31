import 'dart:async';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:example3/pages/home_screen.dart';
import 'package:example3/widgets/background_animation.dart';
import 'package:example3/widgets/glassmorphism_button.dart';
import 'package:example3/widgets/sign_up_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _monitorAuthStateChanges();
    _checkIfUserIsLoggedIn();
    if (kDebugMode) {
      emailController.text = "1@gmail.com";
      passwordController.text = "raean11221122";
    }
  }

  /// Monitor authentication state changes.
  void _monitorAuthStateChanges() {
    _authSubscription = firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User is currently signed out!');
        }
      } else {
        print('User is signed in!');
      }
    });
  }

  /// Check if the user is already logged in and navigate to the home screen.
  Future<void> _checkIfUserIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLogin") ?? false;

    // Check if the user is logged in and a valid user is available.
    if (isLoggedIn && firebaseAuth.currentUser != null) {
      final user = firebaseAuth.currentUser;
      if (user?.uid.isNotEmpty ?? false) {
        // Navigate to HomeScreen if the user is already logged in
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              email: user!.email ?? '', // Ensure non-null email
              password: passwordController.text, // Update if needed
            ),
          ),
        );
      } else {
        throw Exception('User ID cannot be empty.');
      }
    }
  }

  /// Save the login state to SharedPreferences.
  Future<void> _saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", isLoggedIn);
  }

  /// Sign up the user and navigate to HomeScreen.
  Future<void> _signUp(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (!mounted) return;

      final user = userCredential.user;

      if (user != null && user.uid.isNotEmpty) {
        await _saveLoginState(true);
        _navigateToHomeScreen(email, password);
        _showSnackBar(
            context, "Yess!", "Sign up successful!", ContentType.success);
      } else {
        throw Exception('User ID cannot be empty.');
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _showSnackBar(context, "On Snap!", errorMessage, ContentType.failure);
    }
  }

  /// Sign in the user and navigate to HomeScreen.
  Future<void> _signIn(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (!mounted) return;

      final user = userCredential.user;

      if (user != null && user.uid.isNotEmpty) {
        await _saveLoginState(true);
        _navigateToHomeScreen(email, password);
        _showSnackBar(
            context, "Yess!", "Login successful!", ContentType.success);
      } else {
        throw Exception('User ID cannot be empty.');
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _showSnackBar(context, "On Snap!", errorMessage, ContentType.failure);
    }
  }

  /// Navigate to HomeScreen with the given email and password.
  void _navigateToHomeScreen(String email, String password) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(email: email, password: password),
      ),
    );
  }

  /// Show a SnackBar with the specified title, message, and content type.
  void _showSnackBar(
      BuildContext context, String title, String message, ContentType type) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Get a user-friendly error message based on the error code.
  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return 'The email or password is incorrect!';
      case 'user-disabled':
        return 'The user corresponding to the given email has been disabled.';
      case 'user-not-found':
        return 'No user corresponding to the given email.';
      case 'wrong-password':
        return 'The password is invalid for the given email.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      default:
        return 'An unknown error occurred.';
    }
  }

  /// Build a custom text field for input.
  Widget _buildAdvancedTextField(
      String labelText, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .98,
        height: MediaQuery.of(context).size.height * .065,
        decoration: BoxDecoration(
          color: const Color(0xFF6DD7FD),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
          child: Center(
            child: TextField(
              obscureText: obscureText,
              controller: controller,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: "Null",
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: labelText,
                hintStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(1),
      body: Stack(
        children: [
          const BackgroundAnimations(),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 66, sigmaY: 66),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 70, color: Color(0xFF0093CB)),
                  ),
                  Column(
                    children: [
                      _buildAdvancedTextField("Email", emailController, false),
                      _buildAdvancedTextField(
                          "Password", passwordController, true),
                    ],
                  ),
                  GlassmorphismButton(
                    text: "LOGIN",
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _signIn(context, emailController.text,
                            passwordController.text);
                      } else {
                        _showSnackBar(
                            context,
                            "Please enter EMAIL and PASSWORD!",
                            "The Email and the password sections cannot be empty",
                            ContentType.warning);
                      }
                    },
                  ),
                  SignUpButton(
                    text: "Sign Up",
                    onPressed: () {
                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {
                        _signUp(context, emailController.text,
                            passwordController.text);
                      } else {
                        _showSnackBar(
                          context,
                          "Please enter EMAIL and PASSWORD!",
                          "The Email and the password sections cannot be empty",
                          ContentType.warning,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
