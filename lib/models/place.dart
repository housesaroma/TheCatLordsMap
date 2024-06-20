import 'package:latlong2/latlong.dart';

class Place {
  LatLng point;
  String desctioption;

  Place({
    required this.point,
    required this.desctioption,
  });

  Place.fromJson(Map<String, Object?> json)
      : this(
          point: json['point'] as LatLng,
          desctioption: json['description'] as String,
        );

  Place copyWith({
    LatLng? point,
    String? description,
  }) {
    return Place(
      point: point ?? this.point,
      desctioption: desctioption ?? this.desctioption,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'point': point,
      'description': desctioption,
    };
  }
}
