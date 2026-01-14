import 'package:flutter_modular/flutter_modular.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:learning_app/core/components/app_indicator.dart';
import 'package:learning_app/core/constants/app_routes.dart';
import 'package:learning_app/core/helpers/navigation_helper.dart';
import 'package:learning_app/core/helpers/shared_preference_helper.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';
import 'package:learning_app/core/utils/utils.dart';
import 'package:learning_app/modules/app/data/repositories/app_repository.dart';
import 'package:learning_app/modules/exam/data/repositories/exam_repository.dart';
import 'package:learning_app/modules/exam/general/exam_module_routes.dart';
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
      } else if (event is GetHistories) {
        final rt = await repository.getHistories();
        rt.fold(
          (l) {
            Utils.debugLog(l.reason);
          },
          (r) {
            emit(state.setState(examHistories: r['data']));
          },
        );
      } else if (event is GetHistory) {
        emit(state.setState(isLoading: true));
        final rt = await repository.getHistory(
          historyId: event.historyId,
          examId: event.examId,
        );
        rt.fold(
          (l) {
            Utils.debugLog(l.reason);
          },
          (r) {
            emit(
              state.setState(
                questions: r['questions'],
                userAnswers: r['userAnswers'],
                isLoading: false
              ),
            );
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
      } else if (event is SubmitExam) {
        double totalScore = 0.0;
        List<UserAnswerModel> answers = [];
        final questions = state.questions;
        final userAnswers = state.userAnswers;

        for (final question in questions) {
          final qIndex = question.orderIndex ?? 0;
          final ua = userAnswers[qIndex];
          if (ua == null) {
            // Skip unanswered questions – do not submit
            continue;
          }
          double questionScore = 0.0;

          if (question.type == 'choice') {
            // Single choice 1 correct -> 0.25
            if (ua.answerOrderIndex != null &&
                (question.answers ?? []).any(
                  (a) =>
                      a.orderIndex == ua.answerOrderIndex &&
                      a.isCorrect == true,
                )) {
              questionScore = 0.25;
            }
          } else if (question.type == 'true_false') {
            // 4 statements, score by count correct
            if (ua.trueFalseAnswer != null) {
              final correctString = (question.answers ?? [])
                  .map((a) => (a.isCorrect ?? false) ? 'T' : 'F')
                  .join();
              final userString = ua.trueFalseAnswer!;
              int correctCount = 0;
              for (
                var i = 0;
                i < correctString.length && i < userString.length;
                i++
              ) {
                if (userString[i] == correctString[i]) {
                  correctCount++;
                }
              }
              switch (correctCount) {
                case 1:
                  questionScore = 0.1;
                  break;
                case 2:
                  questionScore = 0.25;
                  break;
                case 3:
                  questionScore = 0.5;
                  break;
                case 4:
                  questionScore = 1.0;
                  break;
                default:
                  questionScore = 0.0;
              }
            }
          } else if (question.type == 'short_answer') {
            if (ua.shortAnswer != null && question.shortAnswer != null) {
              final userInput = ua.shortAnswer!.trim().toLowerCase();
              final correctAnswer = question.shortAnswer!.trim().toLowerCase();
              if (userInput == correctAnswer) {
                questionScore = 0.25;
              }
            }
          }

          totalScore += questionScore;
          // final uaWithScore = ua.copyWith(score: (questionScore * 100).round());
          answers.add(ua);
        }

        final history = ExamHistoryModel(
          answers: answers,
          examId: event.examId,
          score: totalScore,
          timeSpent: event.timeSpent,
          subjectId: event.subjectId
        );

        final rt = await repository.submitExam(history: history);
        rt.fold(
          (l) {
            Utils.debugLogError(l.reason);
          },
          (r) {
            Utils.debugLog(r);
            AppIndicator.hide();
            emit(state.setState(examHistory: r));

            NavigationHelper.replace(
              '${AppRoutes.moduleExam}${ExamModuleRoutes.examResult}',
            );
            // add(ResetExamData());
          },
        );
      } else if (event is ResetExamData) {
        emit(
          state.setState(
            questions: const [],
            userAnswers: const {},
            examHistory: null,
          ),
        );
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
