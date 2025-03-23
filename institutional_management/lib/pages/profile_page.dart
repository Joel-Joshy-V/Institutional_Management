import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final User user =
        authProvider.currentUser ??
        User(
          id: 1,
          name: 'Guest User',
          email: 'guest@example.com',
          role: 'Guest',
        );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Profile',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1522071820081-009f0129c71c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(user),
                  SizedBox(height: 24),
                  _buildSectionHeader('Account Settings'),
                  _buildMenuItems(context),
                  SizedBox(height: 24),
                  _buildSectionHeader('Your Activity'),
                  _buildActivityItems(context),
                  SizedBox(height: 24),
                  _buildLogoutButton(context, authProvider),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'G',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                user.email,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.role,
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            Icons.person,
            'Personal Information',
            'Update your personal details',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.notifications,
            'Notifications',
            'Manage your notification preferences',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.lock,
            'Privacy & Security',
            'Manage your password and security settings',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.settings,
            'Settings',
            'App preferences and more',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItems(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            Icons.restaurant,
            'Food Orders',
            'View your food order history',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.hotel,
            'Accommodation Bookings',
            'View your accommodation bookings',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.meeting_room,
            'Hall Bookings',
            'View your hall reservations',
            () {},
          ),
          Divider(height: 1),
          _buildMenuItem(
            context,
            Icons.event,
            'Event Registrations',
            'Events you have registered for',
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12)),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider authProvider) {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(Icons.logout),
        label: Text('Logout'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          authProvider.logout();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }
}
