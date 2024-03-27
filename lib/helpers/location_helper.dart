import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationHelper {
  LocationHelper._internal();

  static double distance(LatLng fromLatLng, LatLng toLatLng) {
    const R = 6371;
    final dLat = deg2rad(toLatLng.latitude - fromLatLng.latitude);
    final dLong = deg2rad(toLatLng.longitude - fromLatLng.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(deg2rad(fromLatLng.latitude)) * cos(deg2rad(toLatLng.latitude)) * sin(dLong / 2) * sin(dLong / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c; // Distance in km
  }

  static double deg2rad(double deg) {
    return deg * pi / 180;
  }

  static double radiusToZoom(double radius /*km*/) {
    final radiusInMile = radius / 1.60934;
    return 14 - log(radiusInMile) / ln2;
  }
}
