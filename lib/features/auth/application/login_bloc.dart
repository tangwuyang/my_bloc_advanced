import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/core/result/result.dart';
import 'package:my_bloc_advanced/features/auth/application/login_event.dart';
import 'package:my_bloc_advanced/features/auth/application/login_state.dart';
import 'package:my_bloc_advanced/features/auth/application/usercases/authenticate_user_use_case.dart';

import '../domain/entities/auth_entity.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  final AuthenticateUserUseCase _authenticateUserUseCase;

  LoginBloc({required authenticateUserUseCase}): _authenticateUserUseCase = authenticateUserUseCase,super(const LoginInitialState()){
    on<LoginFormSubmitted>(_onSubmit);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event,Emitter<LoginState> emit){
    final v = !state.passwordVisible;
    final m = state.loginMethod;
    emit(switch(state){

      // TODO: Handle this case.
      LoginInitialState() => LoginInitialState(loginMethod: m,passwordVisible: v),
      // TODO: Handle this case.
      LoginLoadingState(:final username) => LoginLoadingState(username: username, loginMethod: m, passwordVisible: v),
      // TODO: Handle this case.
      LoginErrorState() => throw UnimplementedError(),
      // TODO: Handle this case.
      LoginLoadedState() => throw UnimplementedError(),
    });
  }

  Future<void> _onSubmit(LoginFormSubmitted event, Emitter<LoginState> emit) async {
    print('start login----------- ${event.username}');
    emit(
      LoginLoadingState(
        username: event.username,
        loginMethod: state.loginMethod,
        passwordVisible: state.passwordVisible,
      ),
    );

    final credentials = AuthCredentialsEntity(username: event.username, password: event.password);
    final tokenResult = await _authenticateUserUseCase(credentials);

    switch(tokenResult){

      case Success<AuthTokenEntity>():
        emit(
          LoginLoadedState(username: event.username, loginMethod: state.loginMethod, passwordVisible: state.passwordVisible),
        );;
      case Failure<AuthTokenEntity>():
        throw UnimplementedError();
    }
  }
}

