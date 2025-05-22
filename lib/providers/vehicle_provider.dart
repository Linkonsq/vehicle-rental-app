import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vehicle_rental_app/models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  static const String baseUrl =
      'https://682f4d24f504aa3c70f3847a.mockapi.io/api/vehicles';

  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
        _error = null;
      } else {
        _error = 'Failed to load vehicles';
      }
    } catch (e) {
      _error = 'Failed to connect to the server';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
