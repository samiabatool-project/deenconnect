import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static Future<Map<String, double>> getCoordinates() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return {
      'lat': position.latitude,
      'lng': position.longitude,
    };
  }

  static Future<Map<String, String>> getLocationData() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Service check
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        'city': 'Location Off',
        'country': '',
      };
    }

    // 2. Permission check
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          'city': 'Permission Denied',
          'country': '',
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        'city': 'Permission Blocked',
        'country': '',
      };
    }

    // 3. Get position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // 4. Convert lat/lng to address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks.first;

    return {
      'city': place.locality ?? '',
      'country': place.country ?? '',
    };
  }
}
