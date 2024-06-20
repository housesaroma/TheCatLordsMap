import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class RouteModel with ChangeNotifier {
  List<LatLng> _routePoints = [];

  List<LatLng> get routePoints => _routePoints;

  void setRoutePoints(List<LatLng> points) {
    _routePoints = points;
    notifyListeners();
  }
}
