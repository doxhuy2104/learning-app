import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamBloc extends HydratedBloc<ExamEvent, ExamState> {
  final ExamRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  ExamBloc({required this.repository}) : super(const ExamState.initial()) {
    on<ExamEvent>((event, emit) async {
      if (event is GetExams) {
        // final rt = await repository.login(username: event.username);
        // rt.fold(
        //   (l) {
        //     Utils.debugLog(l.reason);
        //   },
        //   (r) {
        // final rt = await repository.getExams();

        // rt.fold(
        //   (l) {
        //     Utils.debugLogError(l.reason);
        //   },
        //   (r) {
        //     emit(state.setState(exams: r));
        //   },
        // );
      }
    });
  }

  @override
  ExamState? fromJson(Map<String, dynamic> json) {
    return ExamState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(ExamState state) {
    return state.toJson();
  }
}
