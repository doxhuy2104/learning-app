import 'package:flutter_modular/flutter_modular.dart';
import 'package:learning_app/modules/exam/data/datasources/exam_api.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_bloc.dart';
import 'package:learning_app/modules/exam/presentation/pages/exam_history_page.dart';
import 'package:learning_app/modules/exam/presentation/pages/exam_questions_page.dart';
import 'package:learning_app/modules/exam/presentation/pages/exam_questions_result_page.dart';
import 'package:learning_app/modules/exam/presentation/pages/exam_result_page.dart';
import 'package:learning_app/modules/exam/presentation/pages/subject_exam_page.dart';

class ExamModule extends Module {
  @override
  void exportedBinds(Injector i) {
    super.exportedBinds(i);
    i.addSingleton(() => ExamApi());
    i.addSingleton(() => ExamRepository(api: Modular.get<ExamApi>()));
    i.addSingleton(() => ExamBloc(repository: Modular.get<ExamRepository>()));
  }

  @override
  void routes(RouteManager r) {
    super.routes(r);
    r.child(
      ExamModuleRoutes.subjectExam,
      child: (context) => SubjectExamPage(),
    );

    r.child(
      ExamModuleRoutes.examQuestions,
      child: (context) => ExamQuestionsPage(),
    );

    r.child(
      ExamModuleRoutes.examHistory,
      child: (context) => const ExamHistoryPage(),
    );

    r.child(ExamModuleRoutes.examResult, child: (context) => ExamResultPage());
    r.child(
      ExamModuleRoutes.examQuestionsResult,
      child: (context) => ExamQuestionsResultPage(),
    );
  }
}
