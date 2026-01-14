import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/models/user_answer_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/practice/data/repositories/practice_repository.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_event.dart';
import 'package:learning_app/modules/practice/presentation/bloc/practice_state.dart';

class PracticeBloc extends HydratedBloc<PracticeEvent, PracticeState> {
  final PracticeRepository repository;
  final sharedPreferenceHelper = Modular.get<SharedPreferenceHelper>();

  PracticeBloc({required this.repository})
    : super(const PracticeState.initial()) {
    on<PracticeEvent>((event, emit) async {
      if (event is GetSubjects && state.subjects.isEmpty) {
        final rt = await repository.getSubjects();

        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            emit(state.setState(subjects: r));
          },
        );
      } else if (event is GetCourseQuestions) {
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
        bool? isCorrect = event.isCorrect;

        // Tìm câu hỏi theo orderIndex
        final question = state.questions.firstWhere(
          (q) => q.orderIndex == event.questionOrderIndex,
          orElse: () => state.questions.first,
        );

        // Tính isCorrect cho short_answer
        if (event.isCorrect == null &&
            event.shortAnswer != null &&
            question.type == 'short_answer') {
          final userShortAnswer = event.shortAnswer?.trim().toLowerCase();

          // So sánh với shortAnswer từ question model
          if (question.shortAnswer != null) {
            final correctAnswer = question.shortAnswer!.trim().toLowerCase();
            isCorrect = userShortAnswer == correctAnswer;
          } else {
            isCorrect = false;
          }
        }

        // Tính isCorrect cho true_false
        if (event.isCorrect == null &&
            event.trueFalseAnswer != null &&
            question.type == 'true_false') {
          if (question.answers != null) {
            // Tạo chuỗi đáp án đúng
            final correctString = question.answers!
                .map((a) => (a.isCorrect ?? false) ? 'T' : 'F')
                .join();

            final userString = event.trueFalseAnswer!;

            // Kiểm tra xem có đủ 4 câu trả lời không
            if (correctString.length == 4 && userString.length == 4) {
              int correctCount = 0;
              for (var i = 0; i < 4; i++) {
                if (userString[i] == correctString[i]) {
                  correctCount++;
                }
              }

              // Cả 4 đều đúng -> true
              if (correctCount == 4) {
                isCorrect = true;
              }
              // Cả 4 đều sai -> false
              else if (correctCount == 0) {
                isCorrect = false;
              }
              // Còn lại -> null
              else {
                isCorrect = null;
              }
            }
          }
        }
        final userAnswer = UserAnswerModel(
          answerOrderIndex: event.answerOrderIndex,
          questionOrderIndex: event.questionOrderIndex,
          isCorrect: event.isCorrect ?? isCorrect,
          shortAnswer: event.shortAnswer,
          trueFalseAnswer: event.trueFalseAnswer,
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
          questionOrderIndex: event.questionOrderIndex,
          isCorrect: event.isCorrect,
          shortAnswer: event.shortAnswer,
        );

        final currentUserAnswers = Map<int, UserAnswerModel>.from(
          state.userAnswers,
        );

        currentUserAnswers[event.questionOrderIndex] = userAnswer;

        emit(state.setState(userAnswers: currentUserAnswers));
      } else if (event is ResetCourseData) {
        emit(state.setState(questions: const [], userAnswers: const {}));
      }
    });
  }

  @override
  PracticeState? fromJson(Map<String, dynamic> json) {
    return PracticeState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(PracticeState state) {
    return state.toJson();
  }
}
