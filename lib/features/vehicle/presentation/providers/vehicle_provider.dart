import 'package:flutter/foundation.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleRepository _repository;

  VehicleProvider(this._repository);

  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  List<Vehicle> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchVehicles() async {
    print('Starting to fetch vehicles...');
    _isLoading = true;
    _error = null;
    notifyListeners();
    print('Loading state set to true');

    try {
      print('Calling repository to get vehicles...');
      _vehicles = await _repository.getVehicles();
      print('Vehicles fetched successfully: ${_vehicles.length} vehicles');
      _error = null;
    } catch (e) {
      print('Error fetching vehicles: $e');
      _error = e.toString();
    } finally {
      print('Setting loading state to false');
      _isLoading = false;
      notifyListeners();
    }
  }
}
