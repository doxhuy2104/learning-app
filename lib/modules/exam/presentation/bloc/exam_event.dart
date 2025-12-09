import 'package:equatable/equatable.dart';

sealed class ExamEvent extends Equatable {
  const ExamEvent();

  @override
  List<Object> get props => [];
}

class GetExams extends ExamEvent {}

class GetExamQuestions extends ExamEvent {
  final int examId;

  const GetExamQuestions({required this.examId});
}

class AddUserAnswer extends ExamEvent {
  final int examId;
  final int questionOrderIndex;
  final int? answerOrderIndex;
  final bool isCorrect;
  final String? shortAnswer;
  const AddUserAnswer({
    required this.examId,
    this.answerOrderIndex,
    required this.questionOrderIndex,
    required this.isCorrect,
    this.shortAnswer,
  });
}

class ChangeUserAnswer extends ExamEvent {
  final int examId;
  final int questionOrderIndex;
  final int? answerOrderIndex;
  final bool isCorrect;
  final String? shortAnswer;
  const ChangeUserAnswer({
    required this.examId,
    this.answerOrderIndex,
    required this.questionOrderIndex,
    required this.isCorrect,
    this.shortAnswer,
  });
}

class ResetExamData extends ExamEvent {}
