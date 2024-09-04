import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async'; // Adicione esta linha

class LocationService {
  final Location _location = Location();
  final DatabaseReference _locationRef =
      FirebaseDatabase.instance.ref().child('locations');
  late StreamSubscription<LocationData> _locationSubscription;

  void startTracking() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData currentLocation) {
      _locationRef.child(FirebaseAuth.instance.currentUser!.uid).set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
    });
  }

  void stopTracking() {
    _locationSubscription.cancel();
  }
}
