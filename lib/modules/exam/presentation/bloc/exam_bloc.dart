import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/models/user_answer_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_event.dart';
import 'package:learning_app/modules/exam/presentation/bloc/exam_state.dart';

class ExamBloc extends HydratedBloc<ExamEvent, ExamState> {
  final ExamRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  ExamBloc({required this.repository}) : super(const ExamState.initial()) {
    on<ExamEvent>((event, emit) async {
      if (event is GetExamQuestions) {
        emit(state.setState(isLoading: true));
        final rt = await Modular.get<AppRepository>().getQuesttionsByExamId(
          examId: event.examId,
        );

        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            emit(state.setState(questions: r, isLoading: false));
          },
        );
      } else if (event is AddUserAnswer) {
        final userAnswer = UserAnswerModel(
          answerOrderIndex: event.answerOrderIndex,
          examId: event.examId,
          questionOrderIndex: event.questionOrderIndex,
          isCorrect: event.isCorrect,
          shortAnswer: event.shortAnswer,
        );

        final currentUserAnswers = Map<int, UserAnswerModel>.from(
          state.userAnswers,
        );

        currentUserAnswers[event.questionOrderIndex] = userAnswer;

        emit(state.setState(userAnswers: currentUserAnswers));
        Utils.debugLog(currentUserAnswers);
      } else if (event is ChangeUserAnswer) {
        final userAnswer = UserAnswerModel(
          answerOrderIndex: event.answerOrderIndex,
          examId: event.examId,
          questionOrderIndex: event.questionOrderIndex,
          isCorrect: event.isCorrect,
          shortAnswer: event.shortAnswer,
        );

        final currentUserAnswers = Map<int, UserAnswerModel>.from(
          state.userAnswers,
        );

        currentUserAnswers[event.questionOrderIndex] = userAnswer;

        emit(state.setState(userAnswers: currentUserAnswers));
      } else if (event is ResetExamData) {
        emit(state.setState(questions: const [], userAnswers: const {}));
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
