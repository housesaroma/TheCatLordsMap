import 'package:flutter/widgets.dart';

import '../constants/dimensions.dart';
import '../design/colors.dart';

class AppHero extends StatelessWidget {
  const AppHero({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Добро пожаловать WoofMaps",
      style: TextStyle(
        fontSize: fontSizeLoginHero,
        color: textColorDark,
        fontWeight: FontWeight.w200,
        fontFamily: 'Inter',
      ),
      textAlign: TextAlign.center,
    );
  }
}
