
import 'package:dartz/dartz.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  
  Future<Either<Faliur, UserEntity>> createUserWithEmailAndPassword({required String email, required String password});
  Future<Either<Faliur, UserEntity>> signInUserWithEmailAndPassword({required String email, required String password});

  
  Future<void> signUp(UserEntity user, String password);

  Future<bool> isEmailVerified();
}



