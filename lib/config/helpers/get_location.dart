import 'package:location/location.dart';

class GetLocation {

  LocationData? _locationData;
  double? latitude;
  double? longitude;

  Future<void> getLocationData() async {
    final lat = await _getLatitude();
    final lon = await _getLongitude();
    latitude = lat!;
    longitude = lon!;
  }

  Future<double?> _getLatitude() async {
    final getLocation = await Location().getLocation();
    _locationData = getLocation;
    return _locationData?.latitude;
  }

  Future<double?> _getLongitude() async {
    final getLocation = await Location().getLocation();
    _locationData = getLocation;
    return _locationData?.longitude;
  }
}