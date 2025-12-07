import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/user_model.dart';

sealed class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class GetSubjects extends AccountEvent {}

class GetAccountInfo extends AccountEvent {}

class UpdateAccountInfo extends AccountEvent {
  final UserModel? user;

  const UpdateAccountInfo(this.user);

  @override
  List<Object> get props => [user ?? ''];
}
