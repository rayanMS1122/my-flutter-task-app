import 'package:serenity_tasks/screens/login_screen.dart';
import 'package:serenity_tasks/utils/update_profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = false; // Local state for notification switch

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  // Load the saved notification preference from local storage
  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  // Save the notification preference to local storage
  Future<void> _setNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', value);
    setState(() {
      _isNotificationsEnabled = value;
    });

    // Here you can also add code to enable or disable actual notifications.
    // For example, call your method to turn notifications on or off.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Row(
              children: [
                Text(
                  'Enable Notifications ',
                  style: TextStyle(decoration: TextDecoration.lineThrough),
                ),
                Text(
                  "Working on it",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
              ],
            ),
            value: _isNotificationsEnabled,
            onChanged: (bool value) {
              _setNotificationPreference(value);
            },
          ),
          ListTile(
            title: const Text('Change Theme'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeSettingsScreen(
                    isDarkTheme: widget.isDarkTheme,
                    onThemeChanged: widget.onThemeChanged,
                  ),
                ),
              );
            },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Account Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
              );
            },
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => const AccountSettingsScreen()),
            //   );
            // },
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Serenity Tasks',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.task),
                children: [
                  const Text(
                      'This app helps you manage your daily tasks efficiently.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class ThemeSettingsScreen extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const ThemeSettingsScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme'),
      ),
      body: Consumer<UiProvider>(
        builder: (context, UiProvider notifier, child) {
          return SwitchListTile(
            title: const Text('Dark Theme'),
            value: notifier.isDark,
            onChanged: (bool value) {
              notifier.changeTheme();
              widget.onThemeChanged(
                value,
              ); // Notify parent about the theme change
            },
          );
        },
      ),
    );
  }
}

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  // Function to change the user's email
  Future<void> _changeEmail(BuildContext context) async {
    final TextEditingController emailController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Email'),
          content: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'New Email',
              hintText: 'Enter your new email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  try {
                    await user?.updateEmail(emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email updated successfully.'),
                      ),
                    );
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    print(e.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to update email: ${e.message}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Function to change the user's password
  Future<void> _changePassword(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final user = FirebaseAuth.instance.currentUser;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              hintText: 'Enter your new password',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (passwordController.text.isNotEmpty) {
                  try {
                    await user?.updatePassword(passwordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password updated successfully.'),
                      ),
                    );
                    Navigator.pop(context);
                  } on FirebaseAuthException catch (e) {
                    if (kDebugMode) {
                      print(e.message);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to update password: ${e.message}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
      ),
      body: ListView(
        children: [
          // ListTile(
          //   title: const Text('Change Email'),
          //   onTap: () => _changeEmail(context),
          //   trailing: const Icon(Icons.email),
          // ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () => _changePassword(context),
            trailing: const Icon(Icons.lock),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () async {
              // Perform sign-out and navigate to login screen
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyLoginPage(),
                ),
              );
            },
            trailing: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
