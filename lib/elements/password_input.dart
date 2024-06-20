// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../design/colors.dart';
import '../design/images.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordInput({
    Key? key,
    required this.controller,
    this.hintText = 'Введите свой пароль здесь',
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isPasswordInvisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      margin: const EdgeInsets.only(
          left: marginLoginButtom, right: marginLoginButtom),
      padding: const EdgeInsets.only(left: 10),
      decoration: const BoxDecoration(
        color: secondaryBlue,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          SizedBox(
            width: 24,
            height: 24,
            child: lockImage,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              style: const TextStyle(color: textColorLight),
              controller: widget.controller,
              obscureText: _isPasswordInvisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: textColorLight),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              _isPasswordInvisible ? Icons.visibility_off : Icons.visibility,
              color: iconColorLight,
            ),
            onPressed: () {
              setState(() {
                _isPasswordInvisible = !_isPasswordInvisible;
              });
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }
}
