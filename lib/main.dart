import 'package:serenity_tasks/firebase_options.dart';
import 'package:serenity_tasks/screens/login_screen.dart';
import 'package:serenity_tasks/provider/provider.dart';
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
      child: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: '',
            theme:
                notifier.isDark ? notifier.darkTheme : notifier.lightTheme,
            darkTheme:
                notifier.isDark? notifier.darkTheme : notifier.lightTheme,
            themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
            home: const MyLoginPage(),
            onGenerateRoute: (settings) {
              return PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    _getPage(settings.name),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _getPage(String? name) {
    switch (name) {
      case '/login':
        return const MyLoginPage();
      // Add more pages/routes if necessary
      default:
        return const MyLoginPage();
    }
  }
}
