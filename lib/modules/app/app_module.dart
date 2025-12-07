import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/app/data/datasources/app_api.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/app/general/app_module_routes.dart';
import 'package:learning_app/modules/app/presentation/bloc/app_bloc.dart';
import 'package:learning_app/modules/app/presentation/pages/exams_page.dart';
import 'package:learning_app/modules/app/presentation/pages/main_page.dart';
import 'package:learning_app/modules/app/presentation/pages/questions_page.dart';

class AppModule extends Module {
  @override
  // ignore: unnecessary_overrides
  void binds(Injector i) {
    super.binds(i);
  }

  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);

    i.addSingleton(() => AppApi());
    i.addSingleton(() => AppRepository(api: Modular.get<AppApi>()));
    i.addSingleton(() => AppBloc(repository: Modular.get<AppRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child(AppModuleRoutes.main, child: (context) => const MainPage());
    r.child(AppModuleRoutes.questions, child: (context) => const QuestionsPage());
    r.child(AppModuleRoutes.exams, child: (context) => const ExamsPage());


  }
}
