import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/account/data/repositories/account_repository.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_event.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_state.dart';

class AccountBloc extends HydratedBloc<AccountEvent, AccountState> {
  final AccountRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  AccountBloc({required this.repository})
    : super(const AccountState.initial()) {
    on<AccountEvent>((event, emit) async {
      if (event is GetAccountInfo) {
        final rt = await repository.getAccountInfo();
        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            Utils.debugLogSuccess('Get account info success: $r');
            emit(state.setState(user: r));
          },
        );
      } else if (event is UpdateAccountInfo) {
        emit(state.setState(user: event.user));
      }
    });
  }

  @override
  AccountState? fromJson(Map<String, dynamic> json) {
    return AccountState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccountState state) {
    return state.toJson();
  }
}
