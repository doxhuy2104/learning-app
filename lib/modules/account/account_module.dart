import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/account/data/datasources/account_api.dart';
import 'package:learning_app/modules/account/data/repositories/account_repository.dart';
import 'package:learning_app/modules/account/general/account_module_routes.dart';
import 'package:learning_app/modules/account/presentation/bloc/account_bloc.dart';
import 'package:learning_app/modules/account/presentation/pages/account_info_page.dart';

class AccountModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => AccountApi());
    i.addSingleton(() => AccountRepository(api: Modular.get<AccountApi>()));
    i.addSingleton(
      () => AccountBloc(repository: Modular.get<AccountRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      AccountModuleRoutes.accountInfo,
      child: (context) => const AccountInfoPage(),
    );
  }
}
