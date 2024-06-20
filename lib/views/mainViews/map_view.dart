import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:the_cat_lords_map/constants/dimensions.dart';
import 'package:the_cat_lords_map/design/colors.dart';

import '../../constants/map_routes.dart';
import '../../utilities/map_utils.dart';

class MapView extends StatefulWidget {
  final List<LatLng> mapPoints;
  final LatLng initialCenter;

  const MapView({
    super.key,
    required this.mapPoints,
    required this.initialCenter,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late final MapController _mapController;
  int currentIndex = 0;
  final OpenRouteService client = OpenRouteService(apiKey: apiKey);

  List<Marker> _markers = [];

  List<LatLng>? _routePoints;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _markers = widget.mapPoints
        .map((point) => MapUtils.makeMarker(point, contrastBlue))
        .toList();

    _getRoute();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getRoute() async {
    List<List<LatLng>> allRoutes = [];

    List<LatLng> markerPoints = _markers.map((marker) => marker.point).toList();

    for (int i = 0; i < markerPoints.length - 1; i++) {
      List<LatLng>? route = await MapUtils.getRouteBetweenTwoPoints(
          client, markerPoints[i], markerPoints[i + 1]);
      allRoutes.add(route);
    }

    setState(() {
      _routePoints = allRoutes.expand((route) => route).toList();
    });
  }

  Marker? _getNearbyMarker(LatLng tapPosition) {
    const double threshold = 0.001;
    for (var marker in _markers) {
      if ((marker.point.latitude - tapPosition.latitude).abs() < threshold &&
          (marker.point.longitude - tapPosition.longitude).abs() < threshold) {
        return marker;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _saveCurrentRoute,
        backgroundColor: primaryBlue,
        child: const Icon(Icons.save, color: contrastBlue),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(56.816783, 60.598461),
          initialZoom: 15,
          onLongPress: (tapPos, latLng) {
            Marker? nearbyMarker = _getNearbyMarker(latLng);
            if (nearbyMarker != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Удалить точку"),
                    content: const Text("Вы хотите удалить этот маркер?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Отмена"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Удалить"),
                        onPressed: () {
                          setState(() {
                            _markers.remove(nearbyMarker);
                            _getRoute();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              setState(() {
                _markers.add(MapUtils.makeMarker(latLng, contrastBlue));
                _getRoute();
              });
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_map_example',
          ),
          MarkerLayer(markers: _markers),
          if (_routePoints != null)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: _routePoints!,
                  color: contrastBlue,
                  strokeWidth: 5,
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _saveCurrentRoute() async {
    // Get the current route points
    List<LatLng> routePoints = [];

    for (var marker in _markers) {
      routePoints.add(marker.point);
    }

    // Prompt the user to enter a name for the route
    final TextEditingController _controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Введите название маршрута",
            style: TextStyle(color: textColorLight),
          ),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "Название маршрута:",
              labelStyle: TextStyle(color: textColorLight), // label text color
              hintStyle: TextStyle(color: textColorLight),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColorLight),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColorLight),
              ),
            ),
            style: const TextStyle(color: textColorLight),
            cursorColor: textColorLight,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Отмена",
                style: TextStyle(color: textColorLight),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Сохранить",
                style: TextStyle(color: textColorLight),
              ),
              onPressed: () {
                // Create a new route with the current route points and the entered name
                MapRoute newRoute = MapRoute(_controller.text, routePoints);

                // Add the new route to your routes list
                routes.add(newRoute);

                // Show a snackbar to confirm the route has been saved
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Маршрут успешно сохранен'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
