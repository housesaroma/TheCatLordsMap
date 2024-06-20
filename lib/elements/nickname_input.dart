import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../design/colors.dart';

class NicknameInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const NicknameInput({
    Key? key,
    required this.controller,
    this.hintText = 'Введите свой ник здесь',
  }) : super(key: key);

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
          const SizedBox(
            width: 24,
            height: 24,
            child: Icon(
              Icons.insert_emoticon,
              color: iconColorLight,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextField(
              style: const TextStyle(color: textColorLight),
              controller: controller,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: textColorLight),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
