import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Required for theme control
import 'edit_profile.dart';
import 'changepassword.dart';
import 'privacy_policy.dart';
import 'login.dart';
import 'theme_provider.dart'; // ✅ Your ThemeProvider file

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordPage()),
              );
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.notifications),
            title: Text("Notifications"),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            secondary: Icon(Icons.brightness_6),
            title: Text("Dark Mode"),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.toggleTheme(value);
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Privacy Policy'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => MyLogin()),
                              (route) => false,
                        );
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
