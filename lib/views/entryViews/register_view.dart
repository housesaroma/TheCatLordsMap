import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cat_lords_map/elements/nickname_input.dart';
import 'package:the_cat_lords_map/utilities/storage.dart';

import '../../constants/routes.dart';
import '../../design/colors.dart';
import '../../constants/dimensions.dart';
import '../../design/images.dart';
import '../../elements/app_hero.dart';
import '../../elements/email_input.dart';
import '../../elements/password_input.dart';
import '../../models/user.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/auth_service.dart';
import '../../services/database_service.dart';
import '../../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _username;
  final DatabaseUserService _databaseService = DatabaseUserService();
  File? _profilePicture;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _profilePicture = File(returnedImage!.path);
    });
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
            const SizedBox(height: 22),
            Expanded(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImageFromGallery();
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: _profilePicture != null
                          ? Image.file(_profilePicture!).image
                          : null,
                      backgroundColor: contrastBlue,
                      child: _profilePicture == null ? avatar : null,
                    ),
                  ),
                ],
              ),
            ),
            Container(
                decoration: const BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(children: [
                  const SizedBox(height: 22),
                  NicknameInput(controller: _username),
                  const SizedBox(height: 12),
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
                          await AuthService.firebase().createUser(
                            email: email,
                            password: password,
                          );
                          AuthService.firebase().sendEmailVerification();

                          _databaseService
                              .addUser(MyUser(nickname: _username.text));

                          if (_profilePicture != null) {
                            bool success =
                                await uploadUserAvatar(_profilePicture!);
                          }

                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on WeekPasswordAuthException {
                          await showErrorDialog(
                            context,
                            'Слабый пароль',
                          );
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(
                            context,
                            'Email уже используется',
                          );
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            'Неверный адрес электронной почты',
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Не удалось зарегистрироваться',
                          );
                        }
                      },
                      child: const Text(
                        'Зарегистрироваться',
                        style: TextStyle(color: textColorLight),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Вы уже зарегистрированы? Войдите здесь!',
                      style: TextStyle(color: textColorDark),
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
