import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/constants/app_stores.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/models/user_model.dart';
import 'package:learning_app/core/utils/globals.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/auth/data/repositories/auth_repository.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_event.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  AuthBloc({required this.repository}) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      if (event is AuthLoginRequest) {
        final rt = await repository.login(username: event.username);
        rt.fold(
          (l) {
            Utils.debugLog(l.reason);
          },
          (r) {
            final user = UserModel.fromJson(r);
            Globals.globalAccessToken = user.accessToken;
            Globals.globalUserId = user.userId.toString();
            sharedPreferenceHelper.set(
              key: AppStores.kAccessToken,
              value: user.accessToken!,
            );
            sharedPreferenceHelper.set(
              key: AppStores.kUserId,
              value: user.userId.toString(),
            );
            Utils.debugLog(user);
            // WebsocketService.login();
          },
        );
      }
    });
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return state.toJson();
  }
}
