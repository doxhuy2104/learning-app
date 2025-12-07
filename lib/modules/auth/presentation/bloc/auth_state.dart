import 'package:equatable/equatable.dart';

final class AuthState extends Equatable {
  final String? email;
  final String? accessToken;

  const AuthState._({this.email, this.accessToken});

  @override
  List<Object?> get props => [email, accessToken];

  const AuthState.initial() : this._();
  AuthState reset() {
    return const AuthState._();
  }

  AuthState setState({String? email, String? accessToken}) {
    return AuthState._(
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  AuthState.fromJson(Map<String, dynamic> json)
    : email = json['email'],
      accessToken = json['accessToken'];

  Map<String, dynamic> toJson() => {'email': email, 'accessToken': accessToken};
}
