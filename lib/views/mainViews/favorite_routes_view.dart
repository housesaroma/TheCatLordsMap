import 'package:flutter/material.dart';
import '../../constants/map_routes.dart';
import '../../design/colors.dart';
import '../../design/images.dart';

class FavoriteRoutesView extends StatefulWidget {
  final Function(int) onRouteSelected;
  const FavoriteRoutesView({super.key, required this.onRouteSelected});

  @override
  State<FavoriteRoutesView> createState() => _FavoriteRoutesViewState();
}

class _FavoriteRoutesViewState extends State<FavoriteRoutesView> {
  int? selectedRouteIndex; // Variable to store the index of the selected route

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
              itemCount: routes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: selectedRouteIndex == index
                      ? contrastBlue
                      : Colors.white, // Highlight if selected
                  child: ListTile(
                    title: Text(routes[index].name),
                    onTap: () {
                      setState(() {
                        selectedRouteIndex = index;
                        print(routes[index].points);
                      });
                      widget.onRouteSelected(index);
                    },
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
