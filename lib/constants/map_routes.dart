import 'package:latlong2/latlong.dart';

class MapRoute {
  String name;
  List<LatLng> points;

  MapRoute(this.name, this.points);
}

List<MapRoute> routes = [
  MapRoute("Зеленая роща", [
    const LatLng(56.816783, 60.598461),
    const LatLng(56.823895, 60.595772),
  ]),
  MapRoute("ЦПКиО", [
    const LatLng(56.811248999694364, 60.63603398400258),
    const LatLng(56.81139245510512, 60.65453840539687),
  ]),
];
