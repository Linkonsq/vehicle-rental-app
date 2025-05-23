import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_rental_app/core/routes/app_routes.dart';
import 'package:vehicle_rental_app/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Rental App',
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.initial,
      routes: AppRoutes.routes,
    );
  }
}
