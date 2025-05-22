import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfile {
  final String name;
  final String email;
  final int totalTrips;
  final String id;

  UserProfile({
    required this.name,
    required this.email,
    required this.totalTrips,
    required this.id,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      totalTrips: json['total_trips'],
      id: json['id'],
    );
  }
}

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchUserProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://682f4d24f504aa3c70f3847a.mockapi.io/api/users/1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _userProfile = UserProfile.fromJson(data);
        _error = null;
      } else {
        _error = 'Failed to load profile';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
