class Vehicle {
  final String id;
  final String name;
  final String type;
  final String status;
  final int battery;
  final Location location;
  final double costPerMinute;
  final String imageUrl;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.battery,
    required this.location,
    required this.costPerMinute,
    required this.imageUrl,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'].toString(),
      name: json['name'],
      type: json['type'],
      status: json['status'],
      battery: json['battery'],
      location: Location.fromJson(json['location'] ?? {}),
      costPerMinute: (json['cost_per_minute'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? '',
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'type': type,
  //     'status': status,
  //     'battery': battery,
  //     'location': location.toJson(),
  //     'cost_per_minute': costPerMinute,
  //     'image': imageUrl,
  //   };
  // }
}

class Location {
  final double? lat;
  final double? lng;

  Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'lat': lat,
  //     'lng': lng,
  //   };
  // }
}
