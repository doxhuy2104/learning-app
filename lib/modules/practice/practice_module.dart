import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/practice/data/datasources/practice_api.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';
import 'package:learning_app/modules/practice/general/practice_module_routes.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_bloc.dart';
import 'package:learning_app/modules/practice/presentation/pages/course_page.dart';
import 'package:learning_app/modules/practice/presentation/pages/course_questions_page.dart';
import 'package:learning_app/modules/practice/presentation/pages/subject_course_page.dart';

class PracticeModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => PracticeApi());
    i.addSingleton(() => PracticeRepository(api: Modular.get<PracticeApi>()));
    i.addSingleton(
      () => PracticeBloc(repository: Modular.get<PracticeRepository>()),
    );
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);

    r.child(PracticeModuleRoutes.course, child: (context) => CoursePage());
    r.child(
      PracticeModuleRoutes.subjectCourse,
      child: (context) => SubjectCoursePage(),
    );

    r.child(
      PracticeModuleRoutes.courseQuestions,
      child: (context) => CourseQuestionsPage(),
    );
  }
}
