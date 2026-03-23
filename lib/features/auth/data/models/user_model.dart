// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ribhi/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String uID;
  final String email;
  final String name;

  UserModel({required this.uID, required this.email, required this.name});

  factory UserModel.fromfirebaseUser(User user) {
    return UserModel(
      uID: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uID,
      'email': email,
      'name': name,
    };
  }
  UserEntity toEntity() {
    return UserEntity(
      uID: uID,
      email: email,
      name: name,
    );
  }


}