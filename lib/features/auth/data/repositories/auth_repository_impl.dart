
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ribhi/core/errors/CustomExeptions.dart';
import 'package:ribhi/core/errors/Faliur.dart';
import 'package:ribhi/features/auth/data/datasource/authSerivce.dart';
import 'package:ribhi/features/auth/data/models/user_model.dart';
import 'package:ribhi/features/auth/domain/entities/user_entity.dart';
import 'package:ribhi/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({ required this.authService});
  
  Null get user => null;
  @override
  Future<Either<Faliur, UserEntity>> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      var user = await authService.createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel.fromfirebaseUser(user);
      UserEntity userEntity = userModel.toEntity();
      return right(userEntity);
    } on Customexeptions catch (e) {
      return left(Faliur(errmessage: e.message));
    }catch (e) {
return left(Faliur(errmessage: e.toString()));    }
  }
   @override
   Future<bool> isEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // Reload the user to get the latest data
    return user?.emailVerified ?? false; // Return true if email is verified, otherwise false
    }
  
  @override
  Future<Either<Faliur, UserEntity>> signInUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      var user = await authService.signInUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel.fromfirebaseUser(user);
      UserEntity userEntity = userModel.toEntity();
      return right(userEntity);
    } on Customexeptions catch (e) {
      return left(Faliur(errmessage: e.message));
    } catch (e) {
return left(Faliur(errmessage: e.toString()));    }
  }
  
  @override
  Future<void> signUp(UserEntity user, String password) {
    throw UnimplementedError();
  }
  
  
  }

    