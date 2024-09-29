import 'dart:async';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:provider/provider.dart';
import 'package:serenity_tasks/provider/provider.dart';
import 'package:serenity_tasks/screens/home_screen.dart';
import 'package:serenity_tasks/widgets/glassmorphism_button.dart';
import 'package:serenity_tasks/widgets/sign_up_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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

  Future<void> _checkIfUserIsLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLogin") ?? false;

    if (isLoggedIn && firebaseAuth.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLogin", isLoggedIn);
  }

  Future<void> _signUp(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (!mounted) return;

      final user = userCredential.user;

      if (user != null) {
        await _saveLoginState(true);
        _navigateToHomeScreen();
        _showSnackBar(
            context, "Yess!", "Sign up successful!", ContentType.success);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _showSnackBar(context, "On Snap!", errorMessage, ContentType.failure);
    }
  }

  Future<void> _signIn(
      BuildContext context, String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (!mounted) return;

      final user = userCredential.user;

      if (user != null) {
        await _saveLoginState(true);
        _navigateToHomeScreen();
        _showSnackBar(
            context, "Yess!", "Login successful!", ContentType.success);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = _getErrorMessage(e.code);
      _showSnackBar(context, "On Snap!", errorMessage, ContentType.failure);
    }
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

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

  Widget _buildAdvancedTextField(
      String labelText, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            obscureText: obscureText,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: labelText,
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Consumer<UiProvider>(
            builder: (context, UiProvider notifier, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: IconButton(
                  onPressed: () {
                    notifier.changeTheme();
                  },
                  icon: Icon(
                      notifier.isDark ? Icons.light_mode : Icons.dark_mode),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: GoogleFonts.rubikMonoOne(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                _buildAdvancedTextField("Email", emailController, false),
                _buildAdvancedTextField("Password", passwordController, true),
                const SizedBox(height: 20),
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
                          "Missing Fields",
                          "Please enter both Email and Password",
                          ContentType.warning);
                    }
                  },
                ),
                const SizedBox(height: 20),
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
                          "Missing Fields",
                          "Please enter both Email and Password",
                          ContentType.warning);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
