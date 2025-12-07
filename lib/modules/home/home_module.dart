import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/home/data/datasources/home_api.dart';
import 'package:learning_app/modules/home/data/repositories/home_repository.dart';
import 'package:learning_app/modules/home/general/home_module_routes.dart';
import 'package:learning_app/modules/home/presentation/bloc/home_bloc.dart';
import 'package:learning_app/modules/home/presentation/pages/home_page.dart';

class HomeModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => HomeApi());
    i.addSingleton(() => HomeRepository(api: Modular.get<HomeApi>()));
    i.addSingleton(() => HomeBloc(repository: Modular.get<HomeRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    // r.child(HomeModuleRoutes.signUp, child: (context) => SignUpPage());
    // r.child(
    //   HomeModuleRoutes.forgotPassword,
    //   child: (context) => ForgotPasswordPage(),
    // );
  }
}
