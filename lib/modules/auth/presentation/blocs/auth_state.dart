
import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/user_model.dart';

final class AuthState extends Equatable {
  final UserModel? user;

  const AuthState._({this.user});

  @override
  List<Object?> get props => [user.hashCode];

  const AuthState.initial() : this._();

  AuthState setState({UserModel? user}) {
    return AuthState._(user: user ?? this.user);
  }

  AuthState.fromJson(Map<String, dynamic> json)
    : user = UserModel.fromJson(json['user']);

  Map<String, dynamic> toJson() => {'user': user?.toJson()};
}
