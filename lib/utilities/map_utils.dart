import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:the_cat_lords_map/design/colors.dart';

class MapUtils {
  static Marker makeMarker(LatLng point, Color color) {
    // print(point.latitude);
    // print(point.longitude);
    return Marker(
      point: point,
      child: Icon(
        Icons.location_on,
        color: color,
        size: 50,
      ),
      alignment: Alignment.center,
    );
  }

// Метод генерации маркеров
  static List<Marker> getMarkers(List<LatLng> mapPoints) {
    return List.generate(
      mapPoints.length,
      (index) => makeMarker(mapPoints[index], contrastBlue),
    );
  }

  static Future<List<LatLng>> getRouteBetweenTwoPoints(
      OpenRouteService client, LatLng start, LatLng end) async {
    var routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate:
          ORSCoordinate(latitude: start.latitude, longitude: start.longitude),
      endCoordinate:
          ORSCoordinate(latitude: end.latitude, longitude: end.longitude),
    );

    return routeCoordinates
        .map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude))
        .toList();
  }
}
