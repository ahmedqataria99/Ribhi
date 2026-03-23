
import 'package:bloc/bloc.dart';
import 'package:ribhi/features/auth/domain/entities/user_entity.dart';
import 'package:ribhi/features/auth/domain/repositories/auth_repository.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepository;

  SignupCubit(this.authRepository) : super(SignupInitial());

  Future<void> createUserWithEmailAndPassword({required String email, required String password}) async {
    emit(SignupInLoading());

    var result = await authRepository.createUserWithEmailAndPassword(email: email, password: password);
    result.fold(
      (faliur) => emit((SignupInFailure(errorMessage: faliur.errmessage))),
      
      (user) => emit(SignupSuccess(user: user)),
    );
  }


   
  }
