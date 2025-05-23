import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/vehicle.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  static const String baseUrl =
      'https://682f4d24f504aa3c70f3847a.mockapi.io/api/vehicles';

  @override
  Future<List<Vehicle>> getVehicles() async {
    try {
      print('Making HTTP request to: $baseUrl');
      final response = await http.get(Uri.parse(baseUrl));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Decoded data length: ${data.length}');
        final vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
        print('Parsed vehicles length: ${vehicles.length}');
        return vehicles;
      } else {
        print('Error response: ${response.body}');
        throw Exception('Failed to load vehicles: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Exception occurred: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
