import 'package:flutter/material.dart';
import 'package:the_cat_lords_map/design/images.dart';
import '../../constants/dimensions.dart';
import '../../constants/routes.dart';
import '../../design/colors.dart';
import '../../elements/app_hero.dart';
import '../../elements/email_input.dart';
import '../../elements/password_input.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/auth_service.dart';
import '../../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: mainBack, fit: BoxFit.cover)),
        child: Column(
          children: [
            const Spacer(),
            const AppHero(),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 42),
                  EmailInput(controller: _email),
                  const SizedBox(height: 12),
                  PasswordInput(controller: _password),
                  const SizedBox(height: 32),
                  Container(
                    height: 46,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                        left: marginLoginButtom, right: marginLoginButtom),
                    decoration: const BoxDecoration(
                      color: contrastBlue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().logIn(
                            email: email,
                            password: password,
                          );
                          final user = AuthService.firebase().currentUser;
                          if (user?.isEmailVerified ?? false) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              mapRoute,
                              (route) => false,
                            );
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              verifyEmailRoute,
                              (route) => false,
                            );
                          }
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            'Почта не найденна',
                          );
                        } on InvalidCredentialAuthException {
                          await showErrorDialog(
                            context,
                            'Не верные данные',
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Ошибка аутентификации',
                          );
                        }
                      },
                      child: const Text(
                        'Авторизоваться',
                        style: TextStyle(color: textColorLight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        passwordRecoveryRoute,
                      );
                    },
                    child: const Text(
                      'Забыли пароль? Восстановите тут!',
                      style: TextStyle(color: textColorDark),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Еще нет аккаутна? Зарегистрироваться',
                      style: TextStyle(color: textColorDark),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
