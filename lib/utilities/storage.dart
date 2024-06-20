import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_cat_lords_map/services/auth/auth_service.dart';

Future<bool> uploadFileForUser(File file) async {
  try {
    final userId = AuthService.firebase().currentUser!.id;
    final storageRef = FirebaseStorage.instance.ref();
    final fileName = file.path.split('/').last;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final uploadRef = storageRef.child('$userId/uploads/$timestamp-$fileName');
    await uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}

Future<bool> uploadUserAvatar(File file) async {
  try {
    final userId = AuthService.firebase().currentUser!.id;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadRef = storageRef.child('$userId/uploads/avatar');
    await uploadRef.putFile(file);
    return true;
  } catch (e) {
    print(e);
  }
  return false;
}

Future<List<Reference>?> getUserFiles() async {
  try {
    final userId = AuthService.firebase().currentUser!.id;
    final storageRef = FirebaseStorage.instance.ref();
    final filesRef = storageRef.child('$userId/uploads');
    final files = await filesRef.listAll();
    // Filter out the 'avatar' file
    final filteredFiles =
        files.items.where((item) => !item.name.endsWith('avatar')).toList();
    return filteredFiles;
  } catch (e) {
    print(e);
  }
  return null;
}

Future<Reference?> getUserIcon() async {
  try {
    final userId = AuthService.firebase().currentUser!.id;
    final storageRef = FirebaseStorage.instance.ref();
    final iconRef = storageRef.child('$userId/uploads/avatar');
    return iconRef;
  } catch (e) {
    print(e);
  }
  return null;
}
