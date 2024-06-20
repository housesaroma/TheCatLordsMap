import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../design/colors.dart';
import '../../constants/dimensions.dart';
import '../../services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Подтвердите почту',
          style: TextStyle(color: textColorDark),
        ),
        backgroundColor: primaryBlue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryBlue,
              secondaryBlue,
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10), // Add padding around the text
              decoration: BoxDecoration(
                border: Border.all(
                    color: contrastBlue), // Add border with the specified color
                borderRadius: BorderRadius.circular(
                    10), // Optional: to make the borders rounded
              ),
              child: const Text(
                "Мы отправили вам подтверждение по электронной почте. Пожалуйста, откройте его, чтобы подтвердить свою учетную запись.",
                textAlign: TextAlign.justify,
                style: TextStyle(color: textColorDark, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: contrastBlue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Если вы еще не получили электронное письмо с подтверждением, нажмите на кнопку ниже.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: textColorDark, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                          await AuthService.firebase().sendEmailVerification();
                        },
                        child: const Text('Отправить подтверждение по почте',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textColorDark,
                            ))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
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
                    await AuthService.firebase().logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  },
                  child: const Text('Перезапуск',
                      style: TextStyle(color: textColorDark))),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
