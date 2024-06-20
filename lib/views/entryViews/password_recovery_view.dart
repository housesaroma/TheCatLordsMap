import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:the_cat_lords_map/services/auth/auth_exceptions.dart';
import '../../constants/dimensions.dart';
import '../../design/colors.dart';
import '../../design/images.dart';
import '../../elements/email_input.dart';
import '../../services/auth/auth_service.dart';
import '../../utilities/show_error_dialog.dart';

class PasswordRecoveryView extends StatefulWidget {
  const PasswordRecoveryView({super.key});

  @override
  State<PasswordRecoveryView> createState() => _PasswordRecoveryViewState();
}

class _PasswordRecoveryViewState extends State<PasswordRecoveryView> {
  late final TextEditingController _email;

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Восстановление пароля',
          style: TextStyle(color: textColorDark),
        ),
        backgroundColor: primaryBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: back, fit: BoxFit.cover)),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(child: dog),
            const SizedBox(height: 40),
            Container(
              decoration: const BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  EmailInput(controller: _email),
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
                        try {
                          await AuthService.firebase()
                              .sendPasswordResetEmail(email: email);
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Почта не найденна',
                          );
                        }
                      },
                      child: const Text(
                        'Сбросить пароль',
                        style: TextStyle(color: textColorLight),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
