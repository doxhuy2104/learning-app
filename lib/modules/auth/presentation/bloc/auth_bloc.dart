import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/constants/app_stores.dart';
import 'package:learning_app/core/helpers/auth_helper.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/globals.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_bloc.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_event.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/auth/data/repositories/auth_repository.dart';
import 'package:learning_app/modules/auth/general/auth_module_routes.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_event.dart';
import 'package:learning_app/modules/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  AuthBloc({required this.repository}) : super(const AuthState.initial()) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInRequest) {
        // final rt = await repository.login(username: event.username);
        // rt.fold(
        //   (l) {
        //     Utils.debugLog(l.reason);
        //   },
        //   (r) {
        final rt = await repository.loginByIdToken(
          idToken: event.idToken,
          type: event.type,
        );

        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            Utils.debugLogSuccess('Login success user:$r');
            Globals.globalAccessToken = r?.accessToken;
            Globals.globalUserId = r?.userId.toString();
            sharedPreferenceHelper.set(
              key: AppStores.kAccessToken,
              value: r!.accessToken!,
            );
            sharedPreferenceHelper.set(
              key: AppStores.kUserId,
              value: r.userId.toString(),
            );

            if (event.type == "EMAIL") {
              emit(state.setState(email: r.email, accessToken: r.accessToken));
            } else {
              emit(state.setState(accessToken: r.accessToken));
            }

            // Get account info and save to AccountBloc
            final accountBloc = Modular.get<AccountBloc>();
            accountBloc.add(GetAccountInfo());

            AppIndicator.hide();

            NavigationHelper.reset(
              '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
            );
          },
        );
      } else if (event is SignUpRequest) {
        // final rt = await repository.login(username: event.username);
        // rt.fold(
        //   (l) {
        //     Utils.debugLog(l.reason);
        //   },
        //   (r) {
        final rt = await repository.signup(
          idToken: event.idToken,
          name: event.name,
        );

        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            Utils.debugLogSuccess('Signup success user:$r');
            Globals.globalAccessToken = r?.accessToken;
            Globals.globalUserId = r?.userId.toString();
            sharedPreferenceHelper.set(
              key: AppStores.kAccessToken,
              value: r!.accessToken!,
            );
            sharedPreferenceHelper.set(
              key: AppStores.kUserId,
              value: r.userId.toString(),
            );

            emit(state.setState(email: r.email, accessToken: r.accessToken));

            final accountBloc = Modular.get<AccountBloc>();
            accountBloc.add(GetAccountInfo());

            NavigationHelper.reset(
              '${AppRoutes.moduleApp}${AppModuleRoutes.main}',
            );
          },
        );
      } else if (event is SignOutRequest) {
        void forceLogout() {
          Globals.globalAccessToken = null;
          Globals.globalUserId = null;
          Globals.globalUserUUID = null;
          sharedPreferenceHelper.remove(key: AppStores.kAccessToken);
          sharedPreferenceHelper.remove(key: AppStores.kUserId);
          sharedPreferenceHelper.remove(key: AppStores.kUserUUID);
          emit(state.reset());

          final accountBloc = Modular.get<AccountBloc>();
          accountBloc.add(UpdateAccountInfo(null));

          AuthHelper.signOut()
              .then((value) {
                Utils.debugLogSuccess('FB Logout success');
              })
              .catchError((error) {
                Utils.debugLogError('FB Logout error: $error');
              });

          NavigationHelper.reset(
            '${AppRoutes.moduleAuth}${AuthModuleRoutes.signIn}',
          );
        }

        // if (Globals.globalAccessToken != null || Globals.globalUserId != null) {

        // rt.fold(
        //   (l) {
        //     Utils.debugLogError(l.reason);
        //   },
        //   (r) {
        // Utils.debugLogSuccess('Logout request success');
        forceLogout();
        // },
        // );
        // }
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
