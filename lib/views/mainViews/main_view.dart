import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:the_cat_lords_map/design/colors.dart';
import 'package:the_cat_lords_map/views/mainViews/dog_friendly_places_view.dart';
import 'package:the_cat_lords_map/views/mainViews/favorite_routes_view.dart';
import 'package:the_cat_lords_map/views/mainViews/profile_view.dart';
import 'package:the_cat_lords_map/views/mainViews/routes_view.dart';

import '../../constants/routes.dart';
import '../../design/images.dart';
import '../../enums/menu_action.dart';
import '../../enums/page_title.dart';
import '../../services/auth/auth_service.dart';
import '../../utilities/dialog_helpers.dart';
import '../../constants/map_routes.dart';
import 'map_view.dart';

class MainView extends StatefulWidget {
  const MainView({
    super.key,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

String getTitle(PageTitle title) {
  switch (title) {
    case PageTitle.map:
      return 'Карта';
    case PageTitle.favorite:
      return 'Сохранённые маршруты';
    case PageTitle.addRoute:
      return 'Добавить маршрут';
    case PageTitle.messages:
      return 'Dogfriendly места';
    case PageTitle.profile:
      return 'Профиль';
    default:
      return 'Главный экран';
  }
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getTitle(PageTitle.values[currentIndex]),
          style: const TextStyle(color: contrastBlue),
        ),
        backgroundColor: secondaryBlue,
        centerTitle: true,
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Выйти'),
                )
              ];
            },
          )
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            selectedItemColor: primaryBlue,
            backgroundColor: secondaryBlue,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: home,
                  ),
                ),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: route,
                  ),
                ),
                label: 'Favorite',
              ),
              const BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: map,
                  ),
                ),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: profile,
                  ),
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 -
                45, // adjust the left position
            child: InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 2; // navigate to the desired page
                });
              },
              child: SizedBox(
                width: 90, // adjust the width
                height: 90, // adjust the height
                child: nose, // your middle icon
              ),
            ),
          ),
        ],
      ),
    );
  }

  void handleRouteSelection(int index) {
    setState(() {
      pages[0] = MapView(
        mapPoints: routes[index].points,
        initialCenter: routes[index].points.isNotEmpty
            ? routes[index].points.first
            : const LatLng(56.816783, 60.598461),
      );
    });
  }

  late final pages = [
    MapView(
      mapPoints: routes[0].points,
      initialCenter: routes[0].points.isNotEmpty
          ? routes[0].points.first
          : const LatLng(56.816783, 60.598461),
    ),
    FavoriteRoutesView(onRouteSelected: handleRouteSelection),
    const RoutesView(),
    const DogfriendlyPlacesView(),
    const ProfileView(),
  ];
}
