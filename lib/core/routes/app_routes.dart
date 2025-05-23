import 'package:flutter/material.dart';
import 'package:vehicle_rental_app/features/user/presentation/screens/login_screen.dart';
import 'package:vehicle_rental_app/features/user/presentation/screens/register_screen.dart';
import 'package:vehicle_rental_app/features/user/presentation/widgets/auth_wrapper.dart';
import 'package:vehicle_rental_app/features/vehicle/presentation/screens/vehicle_list_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const AuthWrapper(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const VehicleListScreen(),
        // profile: (context) => const ProfileScreen(),
      };
}
