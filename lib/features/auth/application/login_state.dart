import 'package:equatable/equatable.dart';
import 'package:my_bloc_advanced/features/auth/application/login_event.dart';

import '../../../core/errors/app_error_code.dart';

sealed class LoginState extends Equatable{
  final LoginMethod loginMethod;
  final bool passwordVisible;

  const LoginState({this.loginMethod = LoginMethod.password, this.passwordVisible = false});
}

final class LoginInitialState extends LoginState{
 const LoginInitialState({super.loginMethod,super.passwordVisible});

  @override
  // TODO: implement props
  List<Object?> get props => [loginMethod,passwordVisible];
}

final class LoginLoadingState extends LoginState{
  final String? username;

  LoginLoadingState({this.username,super.loginMethod,super.passwordVisible});

  @override
  // TODO: implement props
  List<Object?> get props => [username,loginMethod,passwordVisible];

}

final class LoginLoadedState extends LoginState {
  const LoginLoadedState({this.username, super.loginMethod, super.passwordVisible});

  final String? username;

  @override
  List<Object?> get props => [username, loginMethod, passwordVisible];
}

final class LoginErrorState extends LoginState {
  const LoginErrorState({required this.errorCode, this.message, super.loginMethod, super.passwordVisible});

  /// Translated by the UI via `errorCode.resolve(context)`. See
  /// `lib/shared/l10n/app_error_code_l10n.dart`.
  final AppErrorCode errorCode;

  /// Optional developer-facing detail (e.g. raw exception text). Never
  /// shown to end users — the UI always shows the translated [errorCode].
  final String? message;

  @override
  List<Object?> get props => [errorCode, message, loginMethod, passwordVisible];
}
