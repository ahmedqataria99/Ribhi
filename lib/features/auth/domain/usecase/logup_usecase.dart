
import 'package:ribhi/features/auth/domain/entities/user_entity.dart';
import 'package:ribhi/features/auth/domain/repositories/auth_repository.dart';


class SignUpUseCase {

  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<void> call(String email, String password) {

    return repository.signUp(email as UserEntity, password);

  }
}
  