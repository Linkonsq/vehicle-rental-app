import 'package:flutter/material.dart';
import 'package:vehicle_rental_app/models/vehicle.dart';

class VehicleDetailsScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (vehicle.imageUrl.isNotEmpty)
              SizedBox(
                width: double.infinity,
                height: 250,
                child: Image.network(
                  vehicle.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(
                    title: 'Vehicle Information',
                    children: [
                      _buildInfoRow('Type', vehicle.type),
                      _buildInfoRow('Status', vehicle.status),
                      _buildInfoRow('Battery Level', '${vehicle.battery}%'),
                      _buildInfoRow(
                        'Cost',
                        '\$${vehicle.costPerMinute.toStringAsFixed(2)}/min',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Location',
                    children: [
                      _buildInfoRow(
                        'Latitude',
                        vehicle.location.lat?.toStringAsFixed(4) ?? 'N/A',
                      ),
                      _buildInfoRow(
                        'Longitude',
                        vehicle.location.lng?.toStringAsFixed(4) ?? 'N/A',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement rental start functionality
              _startRental(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: vehicle.status.toLowerCase() == 'available'
                  ? Colors.green
                  : Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              vehicle.status.toLowerCase() == 'available'
                  ? 'Start Rental'
                  : 'Not Available',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startRental(BuildContext context) async {
    if (vehicle.status.toLowerCase() != 'available') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This vehicle is not available for rental'),
        ),
      );
      return;
    }

    try {
      // TODO: Implement the actual rental start API call
      // For now, just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rental started successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start rental: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
