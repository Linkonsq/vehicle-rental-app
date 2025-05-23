import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'total_trips': totalTrips,
      'id': id,
    };
  }
}

class UserProfileProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;
  String? _error;
  static const String _cacheKey = 'cached_user_profile';

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
        await _cacheUserProfile(data);
      } else {
        _error = 'Failed to load profile';
      }
    } catch (e) {
      _error = 'Error: ${e.toString()}';
      await loadCachedProfile();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cacheUserProfile(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, json.encode(data));
    } catch (e) {
      debugPrint('Error caching user profile: $e');
    }
  }

  Future<void> loadCachedProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData != null) {
        final data = json.decode(cachedData);
        _userProfile = UserProfile.fromJson(data);
        _error = null;
      } else {
        _error = 'No cached profile data available';
      }
    } catch (e) {
      _error = 'Error loading cached profile: ${e.toString()}';
    }
  }
}
