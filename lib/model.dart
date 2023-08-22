class User {
  final String name;
  final LatLng location;

  User({required this.name, required this.location});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'], location: LatLng.fromJson(json['location']));
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng({required this.latitude, required this.longitude});

  factory LatLng.fromJson(Map<String, dynamic> json) {
    return LatLng(latitude: json['latitude'], longitude: json['longitude']);
  }
}
