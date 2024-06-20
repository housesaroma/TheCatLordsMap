import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../constants/map_routes.dart'; // Assuming this is where `routes` and `MapRoute` are defined
import '../../design/colors.dart';
import '../../design/images.dart';

class RoutesView extends StatefulWidget {
  const RoutesView({super.key});

  @override
  State<RoutesView> createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  List<Widget> coordinateFields = [];
  TextEditingController routeNameController = TextEditingController();
  TextEditingController startPointController = TextEditingController();
  TextEditingController endPointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    coordinateFields
        .add(buildCoordinateField('Введите название:', routeNameController));
    coordinateFields.add(buildCoordinateField(
        'Введите начальные координаты:', startPointController));
    coordinateFields.add(buildCoordinateField(
        'Введите конечные координаты:', endPointController));
  }

  LatLng parseCoordinates(String input) {
    var parts = input.split(',');
    return LatLng(double.parse(parts[0].trim()), double.parse(parts[1].trim()));
  }

  void createRoute() {
    String name = routeNameController.text;
    if (name.isEmpty) {
      showSnackBar('Должны быть заполнены все поля');
      return;
    }

    List<LatLng> points = [];
    try {
      for (int i = 1; i < coordinateFields.length; i++) {
        var textField = coordinateFields[i] as CoordinateTextField;
        if (textField.controller.text.isEmpty) {
          showSnackBar('Должны быть заполнены все поля');
          return;
        }
        points.add(parseCoordinates(textField.controller.text));
      }
    } catch (e) {
      showSnackBar('Некорректный ввод');
      return;
    }

    MapRoute newRoute = MapRoute(name, points);
    routes.add(newRoute);
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildCoordinateField(String hintText, TextEditingController controller,
      {bool canDelete = false}) {
    return CoordinateTextField(
      hintText: hintText,
      controller: controller,
      canDelete: canDelete,
      onDelete: () => setState(() {
        coordinateFields.removeWhere((element) =>
            (element as CoordinateTextField).controller == controller);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(image: back, fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Создать новый маршрут',
                      style: TextStyle(color: textColorDark),
                    ),
                    const SizedBox(height: 10),
                    for (int i = 0; i < coordinateFields.length; i++) ...[
                      coordinateFields[i],
                      if (i < coordinateFields.length - 1)
                        const SizedBox(height: 22),
                    ],
                    const SizedBox(height: 22),
                    TextButton(
                      onPressed: createRoute,
                      child: const Text(
                        'Создать',
                        style: TextStyle(color: textColorDark),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (coordinateFields.length < 6) {
            setState(() {
              coordinateFields.insert(
                  coordinateFields.length - 1,
                  buildCoordinateField('Введите промежуточные координаты:',
                      TextEditingController(),
                      canDelete: true));
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Вы добавили максимальное количество точек'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        backgroundColor: secondaryBlue,
        child: const Icon(Icons.add, color: contrastBlue),
      ),
    );
  }
}

class CoordinateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool canDelete;
  final VoidCallback onDelete;

  const CoordinateTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.canDelete = false,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintStyle: const TextStyle(color: textColorDark),
              filled: true,
              fillColor: primaryBlue,
            ),
          ),
        ),
        if (canDelete)
          IconButton(
            icon: const Icon(Icons.delete, color: contrastBlue),
            onPressed: onDelete,
          ),
      ],
    );
  }
}
