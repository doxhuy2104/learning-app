import 'package:flutter_modular/flutter_modular.dart';

class AccountModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    // i.addSingleton(() => AccountApi());
    // i.addSingleton(() => AccountRepository(api: Modular.get<AccountApi>()));
    // i.addSingleton(() => AccountBloc(repository: Modular.get<AccountRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    // r.child(HomeModuleRoutes.home, child: (context) => HomePage());
    // r.child(AccountModuleRoutes.signUp, child: (context) => SignUpPage());
    // r.child(
    //   AccountModuleRoutes.forgotPassword,
    //   child: (context) => ForgotPasswordPage(),
    // );
  }
}
