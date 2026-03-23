import 'dart:developer';
import 'package:ribhi/features/auth/data/datasource/authSerivce.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService extends AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  @override
Future<User> createUserWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    // 🔥 أهم سطر (ده كان ناقصك)
    await user.sendEmailVerification();

    return user;

  } on FirebaseAuthException catch (e) {
    log('Create user error', error: e);

    if (e.code == 'weak-password') {
      throw CustomExceptions(message: 'The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      throw CustomExceptions(message: 'The account already exists for that email.');
    } else {
      throw CustomExceptions(message: 'Authentication failed: ${e.message}');
    }

  } catch (e) {
    throw CustomExceptions(message: 'Something went wrong. Please try again.');
  }
}
  @override
 Future<User> signInUserWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    // 👇 check هنا قبل ما ترجع
    if (!user.emailVerified) {
      throw CustomExceptions(
        message: "Please verify your email first",
      );
    }

    return user;

  } on FirebaseAuthException catch (e) {
    log('Sign in user error', error: e);

    if (e.code == 'user-not-found') {
      throw CustomExceptions(message: 'No user found for that email.');
    } else if (e.code == 'wrong-password') {
      throw CustomExceptions(message: 'Wrong password provided.');
    } else {
      throw CustomExceptions(message: 'Sign in failed: ${e.message}');
    }

  } catch (e) {
    throw CustomExceptions(
      message: 'An error occurred while signing in.',
    );
  }
}}

class CustomExceptions {
  final String message;

  CustomExceptions({required this.message});
}
