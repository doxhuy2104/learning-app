import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/course_model.dart';
import 'package:learning_app/core/models/exam_history_model.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';

final class ExamState extends Equatable {
  final List<CourseModel> exams;
  final List<QuestionModel> questions;
  final Map<int, UserAnswerModel> userAnswers;
  final List<ExamHistoryModel> examHistory;
  final bool isLoading;
  const ExamState._({
    this.exams = const [],
    this.questions = const [],
    this.examHistory = const [],
    this.userAnswers = const {},
    this.isLoading = false,
  });
  const ExamState.initial() : this._();
  ExamState setState({
    List<CourseModel>? exams,
    List<QuestionModel>? questions,

    List<ExamHistoryModel>? examHistory,
    Map<int, UserAnswerModel>? userAnswers,
    bool? isLoading,
  }) {
    return ExamState._(
      exams: exams ?? this.exams,
      questions: questions ?? this.questions,
      examHistory: examHistory ?? this.examHistory,
      userAnswers: userAnswers ?? this.userAnswers,
      isLoading: isLoading ?? this.isLoading,
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
      examHistory =
          (json['examHistory'] as List<dynamic>?)
              ?.map((e) => ExamHistoryModel.fromJson(e as Map<String, dynamic>))
              .whereType<ExamHistoryModel>()
              .toList() ??
          [],
      userAnswers = {},
      isLoading = false;

  Map<String, dynamic> toJson() => {
    'exams': exams.map((e) => e.toJson()).toList(),
    'examHistory': examHistory.map((e) => e.toJson()).toList(),
  };

  ExamState reset() {
    return ExamState._();
  }

  @override
  List<Object> get props => [
    exams.hashCode,
    examHistory.hashCode,
    questions.hashCode,
    userAnswers.hashCode,
    isLoading,
  ];
}
