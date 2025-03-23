import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'providers/auth_provider.dart';
import 'providers/hall_provider.dart';
import 'providers/accommodation_provider.dart';
import 'providers/news_provider.dart';
import 'providers/event_provider.dart';
import 'providers/appointment_provider.dart';
import 'services/api_service.dart';
import 'providers/canteen_provider.dart';
import 'pages/main_navigation_page.dart';
import 'config/api_config.dart';

void main() {
  // Create a single instance of apiService to be used throughout the app
  final apiService = ApiService(baseUrl: ApiConfig.baseUrl);

  runApp(
    // Use a single MultiProvider at the root
    MultiProvider(
      providers: [
        // Provide all providers here
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => CanteenProvider(apiService)),
        ChangeNotifierProvider(
          create: (_) => AccommodationProvider(apiService),
        ),
        ChangeNotifierProvider(create: (_) => HallProvider(apiService)),
        ChangeNotifierProvider(create: (_) => NewsProvider(apiService)),
        ChangeNotifierProvider(create: (_) => EventProvider(apiService)),
        ChangeNotifierProvider(create: (_) => AppointmentProvider(apiService)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Institutional Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: MainNavigationPage(),
    );
  }
}
