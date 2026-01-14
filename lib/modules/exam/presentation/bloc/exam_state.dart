import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';

final class ExamState extends Equatable {
  final List<CourseModel> exams;
  final List<QuestionModel> questions;
  final Map<int, UserAnswerModel> userAnswers;
  final List<ExamHistoryModel> examHistories;
  final bool isLoading;
  final ExamHistoryModel? examHistory;
  const ExamState._({
    this.exams = const [],
    this.questions = const [],
    this.examHistories = const [],
    this.userAnswers = const {},
    this.isLoading = false,
    this.examHistory,
  });
  const ExamState.initial() : this._();
  ExamState setState({
    List<CourseModel>? exams,
    List<QuestionModel>? questions,

    List<ExamHistoryModel>? examHistories,
    Map<int, UserAnswerModel>? userAnswers,
    bool? isLoading,
    ExamHistoryModel? examHistory,
  }) {
    return ExamState._(
      exams: exams ?? this.exams,
      questions: questions ?? this.questions,
      examHistories: examHistories ?? this.examHistories,
      userAnswers: userAnswers ?? this.userAnswers,
      isLoading: isLoading ?? this.isLoading,
      examHistory: examHistory ?? this.examHistory,
    );
  }

  ExamState.fromJson(Map<String, dynamic> json)
    : exams =
          (json['exams'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e as Map<String, dynamic>))
              .whereType<CourseModel>()
              .toList() ??
          [],
      questions =
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .whereType<QuestionModel>()
              .toList() ??
          [],
      examHistories =
          (json['examHistories'] as List<dynamic>?)
              ?.map((e) => ExamHistoryModel.fromJson(e as Map<String, dynamic>))
              .whereType<ExamHistoryModel>()
              .toList() ??
          [],
      userAnswers = {},
      isLoading = false,
      examHistory = ExamHistoryModel.fromJson(
        json['examHistory'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
    'exams': exams.map((e) => e.toJson()).toList(),
    'examHistories': examHistories.map((e) => e.toJson()).toList(),
    if (examHistory != null) 'examHistory': examHistory!.toJson(),
  };

  ExamState reset() {
    return ExamState._();
  }

  @override
  List<Object> get props => [
    exams.hashCode,
    examHistories.hashCode,
    questions.hashCode,
    userAnswers.hashCode,
    isLoading,
    examHistory.hashCode,
  ];
}
