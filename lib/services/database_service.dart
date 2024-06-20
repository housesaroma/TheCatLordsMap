// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import '../models/user.dart';
import 'auth/auth_service.dart';

const String USER_COLLECTION_REF = "users";
const String POINTS_COLLECTION_REF = "dogfriendlyPlaces";

class DatabaseUserService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;
  late final CollectionReference _pointsRef;

  DatabaseUserService() {
    _usersRef =
        _firestore.collection(USER_COLLECTION_REF).withConverter<MyUser>(
              fromFirestore: (snapshot, _) => MyUser.fromJson(snapshot.data()!),
              toFirestore: (user, _) => user.toJson(),
            );
    _pointsRef =
        _firestore.collection(POINTS_COLLECTION_REF).withConverter<LatLng>(
              fromFirestore: (snapshot, _) => LatLng.fromJson(snapshot.data()!),
              toFirestore: (point, _) => point.toJson(),
            );
  }
  Stream<QuerySnapshot> getPoints() {
    return _pointsRef.snapshots();
  }

  Stream<QuerySnapshot> getUsers() {
    return _usersRef.snapshots();
  }

  void addUser(MyUser user) async {
    var id = AuthService.firebase().currentUser!.id;
    _usersRef.doc(id).set(user);
  }

  // Future<MyUser?> readUser(String userId) async {
  //   var snapshot = await _usersRef.doc(userId).get();
  //   if (snapshot.exists) {
  //     return MyUser.fromJson(snapshot.data() as Map<String, Object?>);
  //   } else {
  //     return null;
  //   }
  // }

  void updateUser(String userId, MyUser user) {
    _usersRef.doc(userId).update(user.toJson());
  }

  void deleteUser(String userId) {
    _usersRef.doc(userId).delete();
  }
}
