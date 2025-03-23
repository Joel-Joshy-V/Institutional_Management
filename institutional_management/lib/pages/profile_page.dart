import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Personal Information'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to personal info page
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Booking History'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to booking history
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to settings
            },
          ),
        ],
      ),
    );
  }
}
