import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehicle_rental_app/core/routes/app_routes.dart';
import 'package:vehicle_rental_app/core/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:vehicle_rental_app/features/vehicle/data/repositories/vehicle_repository_impl.dart';
import 'package:vehicle_rental_app/features/vehicle/presentation/providers/vehicle_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //runApp(const MyApp());

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          Provider<VehicleRepositoryImpl>(
            create: (_) => VehicleRepositoryImpl(),
          ),
          ChangeNotifierProvider<VehicleProvider>(
            create: (context) => VehicleProvider(
              context.read<VehicleRepositoryImpl>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
