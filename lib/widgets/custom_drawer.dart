
import 'package:serenity_tasks/screens/home_screen.dart';
import 'package:serenity_tasks/screens/login_screen.dart';
import 'package:serenity_tasks/screens/notes_screen.dart';
import 'package:serenity_tasks/screens/settings_screen.dart';
import 'package:serenity_tasks/utils/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: UserProfileService().getUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile'));
        }

        final userProfile = snapshot.data;
        final userName = userProfile?['name'] ?? 'John Doe';
        final userProfilePicture = userProfile?['profilePicture'] ??
            'https://static.vecteezy.com/system/resources/thumbnails/011/675/374/small_2x/man-avatar-image-for-profile-png.png';

        return Drawer(
          child: Container(
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [Colors.white, Colors.blueAccent],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    FirebaseAuth.instance.currentUser?.email ?? '',
                    // style: const TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(userProfilePicture),
                  ),
                  decoration: const BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [Colors.teal, Colors.blueAccent],
                      //   begin: Alignment.topLeft,
                      //   end: Alignment.bottomRight,
                      // ),
                      ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _buildDrawerItem(
                          icon: Icons.toc_outlined,
                          text: 'ToDo',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.note_alt_sharp,
                          text: 'Notes',
                          trailingText: 'Beta',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NotesScreen()),
                            );
                          },
                        ),
                        _buildDrawerItem(
                          icon: Icons.settings,
                          text: 'Settings',
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(
                                  isDarkTheme: false,
                                  onThemeChanged: (bool value) {},
                                ),
                              ),
                            );
                          },
                        ),
                        // _buildDrawerItem(
                        //   icon: Icons.help,
                        //   text: 'Help',
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) => const HelpScreen()),
                        //     );
                        //   },
                        // ),
                        const Divider(),
                        _buildDrawerItem(
                          icon: Icons.logout,
                          text: 'Logout',
                          iconColor: Colors.redAccent,
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyLoginPage()),
                              );
                            } catch (e) {
                              if (kDebugMode) {
                                print('Logout failed: $e');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    String? trailingText,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        // color: iconColor ?? Colors.white70,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              // color: Colors.white,
            ),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
