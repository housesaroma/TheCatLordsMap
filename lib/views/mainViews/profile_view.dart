import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cat_lords_map/design/colors.dart';
import 'package:the_cat_lords_map/models/user.dart';
import 'package:the_cat_lords_map/services/auth/auth_service.dart';
import 'package:the_cat_lords_map/services/database_service.dart';
import 'package:the_cat_lords_map/utilities/storage.dart';

import '../../design/images.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final userCredentials;
  Reference? userIcon;
  final DatabaseUserService _databaseService = DatabaseUserService();
  @override
  void initState() {
    super.initState();
    userCredentials = AuthService.firebase().currentUser;
    getIcon();
    getUploadedFiles();
    showUploadedFiles();
    _databaseService.getPoints();
  }

  void getIcon() async {
    Reference? result = await getUserIcon();
    if (result != null) {
      setState(
        () {
          userIcon = result;
        },
      );
    }
  }

  void getUploadedFiles() async {
    List<Reference>? result = await getUserFiles();
    if (result != null) {
      setState(() {
        uploadFiles = result;
      });
    }
  }

  List<Reference> uploadFiles = [];

  Widget showUploadedFiles() {
    if (uploadFiles.isEmpty) {
      return const Center(
        child: Text('нет данных'),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Уменьшено количество столбцов
              crossAxisSpacing: 10, // Увеличенный горизонтальный отступ
              mainAxisSpacing: 10, // Увеличенный вертикальный отступ
            ),
            itemCount: uploadFiles.length,
            itemBuilder: (context, index) {
              Reference ref = uploadFiles[index];
              return FutureBuilder(
                future: ref.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        border: Border.all(color: contrastBlue),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.network(snapshot.data!, fit: BoxFit.cover),
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        ),
      ),
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
              const SizedBox(height: 20),
              buildUserIcon(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => changeNicknameDialog(context),
                child: showNickName(),
              ),
              const SizedBox(height: 20),
              showUploadedFiles(),
            ],
          ),
        ),
      ),
      floatingActionButton: uploadMediaButton(context),
    );
  }

  Widget buildUserIcon() {
    return FutureBuilder(
      future: userIcon?.getDownloadURL(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 50,
            backgroundImage: Image.network(snapshot.data!).image,
          );
        }
        return CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
        );
      },
    );
  }

  void changeNicknameDialog(BuildContext context) {
    TextEditingController nicknameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить ник'),
          content: TextField(
            controller: nicknameController,
            decoration: const InputDecoration(hintText: "Введите новый ник"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (nicknameController.text.isNotEmpty) {
                  _databaseService.updateUser(userCredentials.id,
                      MyUser(nickname: nicknameController.text));
                  getIcon(); // Refresh the icon to reflect any changes
                  showNickName(); // Update the display to show the new nickname
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget uploadMediaButton(BuildContext buildContext) {
    return FloatingActionButton(
      backgroundColor: secondaryBlue,
      onPressed: () async {
        final selectedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (selectedImage != null) {
          bool success = await uploadFileForUser(File(selectedImage.path));
          if (success) {
            getUploadedFiles();
          }
        }
      },
      child: const Icon(
        Icons.upload,
        color: contrastBlue,
      ),
    );
  }

  Widget showNickName() {
    return StreamBuilder(
      stream: _databaseService.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        List users = snapshot.data?.docs ?? [];
        bool nicknameFound = false;
        String? nickName = '';

        for (int i = 0; i < users.length; i++) {
          MyUser user = users[i].data();
          String userId = users[i].id;
          if (userId == userCredentials.id) {
            nickName = user.nickname;
            nicknameFound = true;
            break;
          }
        }

        if (nicknameFound) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: contrastBlue),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$nickName', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 5),
                const Icon(Icons.edit, size: 16),
              ],
            ),
          );
        } else {
          return const Text('Нет данных');
        }
      },
    );
  }
}
