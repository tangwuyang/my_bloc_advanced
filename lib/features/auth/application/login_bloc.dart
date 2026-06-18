import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_advanced/features/auth/application/login_event.dart';
import 'package:my_bloc_advanced/features/auth/application/login_state.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  LoginBloc():super(const LoginInitialState()){
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
    });
  }

  FutureOr<void> _onSubmit(LoginFormSubmitted event, Emitter<LoginState> emit) {
    emit(
      LoginLoadingState(
        username: event.username,
        loginMethod: state.loginMethod,
        passwordVisible: state.passwordVisible,
      ),
    );
  }
}

