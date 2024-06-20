import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String email;
  final String id;
  const AuthUser(this.isEmailVerified, this.email, this.id);

  factory AuthUser.fromFirebase(User user) {
    return AuthUser(
      user.emailVerified,
      user.email ?? 'Нет email',
      user.uid,
    );
  }
}
