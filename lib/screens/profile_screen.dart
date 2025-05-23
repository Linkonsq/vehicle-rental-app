import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_profile_provider.dart';
import '../services/connectivity_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _connectivityService = ConnectivityService();
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _isConnected = _connectivityService.isConnected;
    _connectivityService.checkConnectivity();
    _connectivityService.setupConnectivityListener();
    _connectivityService.connectionStatus
        .addListener(_onConnectionStatusChanged);

    Future.microtask(() {
      if (_isConnected) {
        context.read<UserProfileProvider>().fetchUserProfile();
      } else {
        context.read<UserProfileProvider>().loadCachedProfile();
      }
    });
  }

  void _onConnectionStatusChanged() {
    setState(() {
      _isConnected = _connectivityService.isConnected;
    });
  }

  @override
  void dispose() {
    _connectivityService.connectionStatus
        .removeListener(_onConnectionStatusChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          if (!_isConnected)
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode - Showing cached data',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Consumer<UserProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (profileProvider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          profileProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (_isConnected) {
                              profileProvider.fetchUserProfile();
                            } else {
                              profileProvider.loadCachedProfile();
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final userProfile = profileProvider.userProfile;
                if (userProfile == null) {
                  return const Center(child: Text('No profile data available'));
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                        radius: 50,
                      ),
                      const SizedBox(height: 24),
                      _buildInfoCard(
                        title: 'Name',
                        value: userProfile.name,
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Email',
                        value: userProfile.email,
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        title: 'Total Trips',
                        value: userProfile.totalTrips.toString(),
                        icon: Icons.directions_car_outlined,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
