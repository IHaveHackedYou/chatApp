// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  String? email;
  String? uid;
  User? user;
  bool emptyUser;

  AppUser({
    required this.email,
    required this.uid,
    this.user,
    required this.emptyUser,
  });

  AppUser copyWith({
    String? email,
    String? uid,
    User? user,
    bool? emptyUser,
  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      user: user ?? this.user,
      emptyUser: emptyUser ?? this.emptyUser,
    );
  }

  @override
  String toString() {
    return 'AppUser(email: $email, uid: $uid, user: $user, emptyUser: $emptyUser)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.uid == uid &&
        other.user == user &&
        other.emptyUser == emptyUser;
  }

  @override
  int get hashCode {
    return email.hashCode ^ uid.hashCode ^ user.hashCode ^ emptyUser.hashCode;
  }

  //! Firebase user doesn't get stored
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
      'emptyUser': emptyUser,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      email: map['email'] != null ? map['email'] as String : null,
      uid: map['uid'] != null ? map['uid'] as String : null,
      emptyUser: map['emptyUser'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) => AppUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
