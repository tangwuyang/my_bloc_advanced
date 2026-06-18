import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{

}

class TogglePasswordVisibility extends LoginEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class LoginFormSubmitted extends LoginEvent {
  final String username;
  final String password;

  LoginFormSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

enum LoginMethod{opt,password}