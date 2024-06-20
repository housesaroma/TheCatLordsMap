import 'package:flutter/material.dart';
import 'package:the_cat_lords_map/design/colors.dart';
import 'package:the_cat_lords_map/views/entryViews/password_recovery_view.dart';

import 'constants/routes.dart';
import 'services/auth/auth_service.dart';
import 'views/entryViews/login_view.dart';
import 'views/entryViews/register_view.dart';
import 'views/mainViews/main_view.dart';
import 'views/entryViews/verify_email_view.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore.instance.settings =
  //     const Settings(persistenceEnabled: true);
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: contrastColorLightMaterial,
        primaryColor: contrastBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: contrastColorLightMaterial,
        ).copyWith(
          secondary: contrastBlue,
        ),
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        mapRoute: (context) => const MainView(),
        passwordRecoveryRoute: (context) => const PasswordRecoveryView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
      debugShowCheckedModeBanner: false,
    ),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const MainView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
