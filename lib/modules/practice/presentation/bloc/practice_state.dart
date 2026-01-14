import 'package:equatable/equatable.dart';
import 'package:learning_app/core/models/question_model.dart';
import 'package:learning_app/core/models/subject_model.dart';
import 'package:learning_app/core/models/user_answer_model.dart';

final class PracticeState extends Equatable {
  final List<SubjectModel> subjects;
  final List<QuestionModel> questions;
  final Map<int, UserAnswerModel> userAnswers;
  final bool isLoading;

  const PracticeState._({
    this.subjects = const [],
    this.questions = const [],
    this.userAnswers = const {},
    this.isLoading = false,
  });

  const PracticeState.initial() : this._();

  PracticeState setState({
    List<SubjectModel>? subjects,
    List<QuestionModel>? questions,
    Map<int, UserAnswerModel>? userAnswers,
    bool? isLoading,
  }) {
    return PracticeState._(
      subjects: subjects ?? this.subjects,
      questions: questions ?? this.questions,
      userAnswers: userAnswers ?? this.userAnswers,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  PracticeState.fromJson(Map<String, dynamic> json)
    : subjects =
          (json['subjects'] as List<dynamic>?)
              ?.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
              .whereType<SubjectModel>()
              .toList() ??
          [],
      questions =
          (json['questions'] as List<dynamic>?)
              ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
              .whereType<QuestionModel>()
              .toList() ??
          [],
      userAnswers = {},
      isLoading = false;

  Map<String, dynamic> toJson() => {
    'subjects': subjects.map((e) => e.toJson()).toList(),
    'questions': questions.map((e) => e.toJson()).toList(),
  };

  PracticeState reset() {
    return PracticeState._(subjects: subjects);
  }

  @override
  List<Object> get props => [
    subjects.hashCode,
    questions.hashCode,
    userAnswers.hashCode,
    isLoading,
  ];
}
