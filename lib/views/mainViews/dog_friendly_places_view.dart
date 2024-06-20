import 'package:flutter/material.dart';
import 'package:the_cat_lords_map/constants/map_places.dart';

import '../../design/colors.dart';
import '../../design/images.dart';
import '../../services/database_service.dart';

class DogfriendlyPlacesView extends StatefulWidget {
  const DogfriendlyPlacesView({super.key});

  @override
  State<DogfriendlyPlacesView> createState() => DdogfriendlyPlaceViewsState();
}

class DdogfriendlyPlaceViewsState extends State<DogfriendlyPlacesView> {
  final DatabaseUserService _databaseService = DatabaseUserService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: back, fit: BoxFit.cover)),
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: points.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white, // Highlight if selected
                  child: ListTile(
                    title: Text(points[index].name),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
