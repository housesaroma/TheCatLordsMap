import 'package:flutter/material.dart';

/// Виджет для отображения кластера
class ClusterMarker extends StatelessWidget {
  const ClusterMarker({super.key, required this.markersLength});

  /// Количество маркеров, объединенных в кластер
  final int markersLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[200],
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue,
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          markersLength.toString(),
          style: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
