import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/canteen/canteen_page.dart';
import '../services/accommodation/accommodation_page.dart';
import '../pages/profile_page.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../providers/auth_provider.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CanteenPage(),
    AccommodationPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Check authentication on startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Canteen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hotel),
            label: 'Accommodation',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
