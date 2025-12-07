import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/user_model.dart';
import 'package:learning_app/core/utils/utils.dart';

final class AccountState extends Equatable {
  final UserModel? user;

  const AccountState._({this.user});

  @override
  List<Object?> get props => [user.hashCode];

  const AccountState.initial() : this._();
  AccountState setState({UserModel? user}) {
    Utils.debugLog(user);
    return AccountState._(user: user ?? this.user);
  }

  AccountState.fromJson(Map<String, dynamic> json)
    : user = UserModel.fromJson(json['user']);

  Map<String, dynamic> toJson() => {'user': user?.toJson()};
}
