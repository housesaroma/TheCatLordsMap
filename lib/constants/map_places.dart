import 'package:latlong2/latlong.dart';

class MapPlace {
  String name;
  LatLng point;

  MapPlace(this.name, this.point);
}

List<MapPlace> points = [
  MapPlace(
    "Жизньмарт Шейнкмана",
    const LatLng(56.82645992333245, 60.58738581859867),
  ),
  MapPlace(
    "Simple Coffee Хохрякова",
    const LatLng(56.83358802833377, 60.592662849956994),
  ),
];
