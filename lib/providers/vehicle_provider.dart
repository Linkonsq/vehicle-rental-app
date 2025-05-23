import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_rental_app/models/vehicle.dart';

class VehicleProvider extends ChangeNotifier {
  static const String baseUrl =
      'https://682f4d24f504aa3c70f3847a.mockapi.io/api/vehicles';
  static const String _cacheKey = 'cache_vehicles';

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
        await _cacheVehicles();
      } else {
        _error = 'Failed to load vehicles';
      }
    } catch (e) {
      _error = 'Failed to connect to the server';
      await loadCachedVehicles();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads cached vehicles from local storage
  Future<void> loadCachedVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData != null) {
        final List<dynamic> decodedData = json.decode(cachedData);
        _vehicles.clear();
        _vehicles
            .addAll(decodedData.map((json) => Vehicle.fromJson(json)).toList());
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cached vehicles: $e');
    }
  }

  /// Caches the current vehicle list to local storage
  Future<void> _cacheVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encodedData = json.encode(
        _vehicles
            .map(
              (vehicle) => {
                'id': vehicle.id,
                'name': vehicle.name,
                'type': vehicle.type,
                'status': vehicle.status,
                'battery': vehicle.battery,
                'location': {
                  'lat': vehicle.location.lat,
                  'lng': vehicle.location.lng,
                },
                'cost_per_minute': vehicle.costPerMinute,
                'image': vehicle.imageUrl,
              },
            )
            .toList(),
      );

      await prefs.setString(_cacheKey, encodedData);
    } catch (e) {
      debugPrint('Error caching users: $e');
    }
  }
}
