import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

import 'model.dart';

void main() {
  runApp(MaterialApp(
    home: NearbyUsersScreen(),
  ));
}

class NearbyUsersScreen extends StatefulWidget {
  @override
  _NearbyUsersScreenState createState() => _NearbyUsersScreenState();
}

class _NearbyUsersScreenState extends State<NearbyUsersScreen> {
  //final Geolocator geolocator = Geolocator();
  late Position _currentPosition;
  List<User> _nearbyUsers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    // Send the user's location to the server and receive nearby user data.
    _fetchNearbyUsers();
  }

  void _fetchNearbyUsers() {
    // Simulated nearby user data received from the server.
    List<User> simulatedNearbyUsers = [
      User(
          name: 'User A',
          location: LatLng(
            longitude: 37.7752,
            latitude: -122.4186,
          )),
      User(
          name: 'User B',
          location: LatLng(
            longitude: 37.7752,
            latitude: -122.4186,
          )),
    ];

    setState(() {
      _nearbyUsers = simulatedNearbyUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Users'),
      ),
      body: ListView.builder(
        itemCount: _nearbyUsers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_nearbyUsers[index].name),
            subtitle: Text(
              'Distance: ${Geolocator.distanceBetween(_currentPosition.latitude, _currentPosition.longitude, _nearbyUsers[index].location.latitude, _nearbyUsers[index].location.longitude)} meters',
            ),
          );
        },
      ),
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers
    final double dLat = radians(lat2 - lat1);
    final double dLon = radians(lon2 - lon1);
    final double a = pow(sin(dLat / 2), 2) +
        cos(radians(lat1)) * cos(radians(lat2)) * pow(sin(dLon / 2), 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  List<User> filterNearbyUsers(List<User> allUsers, double maxDistance) {
    final List<User> nearbyUsers = [];

    for (final user in allUsers) {
      final double distance = calculateDistance(
        _currentPosition.latitude,
        _currentPosition.longitude,
        user.location.latitude,
        user.location.longitude,
      );

      if (distance <= maxDistance) {
        nearbyUsers.add(user);
      }
    }

    return nearbyUsers;
  }

// Simulated list of all users retrieved from the server(assumed list of all users)
  ///List<User> allUsers = [];

// this code will Filter nearby users within a radius of 5 kilometers
  //double maxDistance = 5; // in kilometers
  //List<User> nearbyUsers = filterNearbyUsers(allUsers, maxDistance);
}
