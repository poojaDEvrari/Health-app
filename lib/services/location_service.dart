import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationService {
  static const _kSelectedLocation = 'selected_location_city';

  static Future<String?> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kSelectedLocation);
  }

  static Future<void> save(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedLocation, city);
  }

  static Future<String?> fetchCurrentCity() async {
    final permission = await Geolocator.checkPermission();
    LocationPermission granted = permission;
    if (permission == LocationPermission.denied) {
      granted = await Geolocator.requestPermission();
    }
    if (granted == LocationPermission.denied || granted == LocationPermission.deniedForever) {
      return null;
    }
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    final placemarks = await geocoding.placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) return null;
    final p = placemarks.first;
    final city = p.locality?.isNotEmpty == true ? p.locality! : (p.subAdministrativeArea ?? p.administrativeArea ?? '');
    if (city.isNotEmpty) {
      await save(city);
      return city;
    }
    return null;
  }
}
