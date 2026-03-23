import 'package:bloc/bloc.dart';
import 'package:ribhi/features/auth/domain/usecase/logup_usecase.dart';
import 'package:ribhi/features/auth/presentation/bloc/signupSTATE.dart';
import 'package:ribhi/features/auth/presentation/bloc/signupevent.dart';



class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final SignUpUseCase signUpUseCase;

  SignUpBloc(this.signUpUseCase) : super(SignUpInitial()) {

    on<SignUpSubmitted>((event, emit) async {

      emit(SignUpLoading());

      try {

        await signUpUseCase(
          event.email,
          event.password,
        );

        emit(SignUpSuccess());

      } catch (e) {

        emit(SignUpError(e.toString()));

      }

    });

  }
}