import 'package:example3/firebase_options.dart';
import 'package:example3/pages/login_screen.dart';
import 'package:example3/provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UiProvider()..init(),
      child:
          Consumer<UiProvider>(builder: (context, UiProvider notifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'To Do',
          theme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
          // our custom theme applied
          darkTheme: notifier.isDark ? notifier.darkTheme : notifier.lightTheme,

          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          home: MyLoginPage(),
        );
      }),
    );
  }
}
