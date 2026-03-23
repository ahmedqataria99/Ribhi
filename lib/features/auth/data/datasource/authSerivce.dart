
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<User> createUserWithEmailAndPassword({required String email, required String password});
  Future<User> signInUserWithEmailAndPassword({required String email, required String password});
}

