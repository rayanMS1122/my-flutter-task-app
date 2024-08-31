import 'package:example3/pages/help_screen.dart';
import 'package:example3/pages/login_screen.dart';
import 'package:example3/pages/notes_screen.dart';
import 'package:example3/pages/settings_screen.dart';
import 'package:example3/utils/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: UserProfileService().getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error loading profile'));
        }

        final userProfile = snapshot.data;
        final userName = userProfile?['name'] ?? 'John Doe';
        final userProfilePicture = userProfile?['profilePicture'] ??
            'https://static.vecteezy.com/system/resources/thumbnails/011/675/374/small_2x/man-avatar-image-for-profile-png.png';

        return Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(userName, style: TextStyle(fontSize: 18)),
                accountEmail:
                    Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userProfilePicture),
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.home, color: Colors.deepPurple),
                title: const Text('Home', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Navigate to the home screen or refresh current screen
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.notes_outlined, color: Colors.deepPurple),
                title: Row(
                  children: [
                    const Text('Notes:  ', style: TextStyle(fontSize: 16)),
                    const Text('Working on it',
                        style: TextStyle(fontSize: 16, color: Colors.red)),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotesScreen(),
                      )); // Close the drawer
                  // Navigate to the home screen or refresh current screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.deepPurple),
                title: const Text('Settings', style: TextStyle(fontSize: 16)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                        isDarkTheme: true,
                        onThemeChanged: (value) {
                          // Handle theme change action
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.deepPurple),
                title: const Text('Help', style: TextStyle(fontSize: 16)),
                onTap: () {
                  // Example action for Help button; replace with actual help screen navigation
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpScreen(),
                      ));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout', style: TextStyle(fontSize: 16)),
                onTap: () async {
                  try {
                    await firebaseAuth.signOut(); // Sign out the user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyLoginPage(),
                      ),
                    );
                  } catch (e) {
                    // Handle sign-out errors
                    if (kDebugMode) {
                      print('Logout failed: $e');
                    }
                  }
                },
              ),
              // Remaining drawer items
            ],
          ),
        );
      },
    );
  }
}
