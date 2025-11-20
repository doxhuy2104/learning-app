import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequest extends AuthEvent {
  final String idToken;
  final String? type;

  const SignInRequest({required this.idToken, this.type});
}

class SignUpRequest extends AuthEvent {
  final String idToken;
  final String name;

  const SignUpRequest({required this.idToken, required this.name});
}

class SignOutRequest extends AuthEvent {
  const SignOutRequest();
}
