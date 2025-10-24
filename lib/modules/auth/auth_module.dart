import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/auth/data/datasources/auth_api.dart';
import 'package:learning_app/modules/auth/data/repositories/auth_repository.dart';
import 'package:learning_app/modules/auth/general/auth_module_routes.dart';
import 'package:learning_app/modules/auth/presentation/blocs/auth_bloc.dart';
import 'package:learning_app/modules/auth/presentation/pages/forgot_password_page.dart';
import 'package:learning_app/modules/auth/presentation/pages/sign_in_page.dart';
import 'package:learning_app/modules/auth/presentation/pages/sign_up_page.dart';

class AuthModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => AuthApi());
    i.addSingleton(() => AuthRepository(api: Modular.get<AuthApi>()));
    i.addSingleton(() => AuthBloc(repository: Modular.get<AuthRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(AuthModuleRoutes.signIn, child: (context) => SignInPage());
    r.child(AuthModuleRoutes.signUp, child: (context) => SignUpPage());
    r.child(
      AuthModuleRoutes.forgotPassword,
      child: (context) => ForgotPasswordPage(),
    );
  }
}
