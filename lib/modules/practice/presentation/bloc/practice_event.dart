import 'package:equatable/equatable.dart';

sealed class PracticeEvent extends Equatable {
  const PracticeEvent();

  @override
  List<Object> get props => [];
}

class GetSubjects extends PracticeEvent {}

class GetCourseQuestions extends PracticeEvent {
  final int examId;

  const GetCourseQuestions({required this.examId});
}

class AddUserAnswer extends PracticeEvent {
  final int examId;
  final int questionOrderIndex;
  final int? answerOrderIndex;
  final bool? isCorrect;
  final String? shortAnswer;
  final String? trueFalseAnswer;
  const AddUserAnswer({
    required this.examId,
    this.answerOrderIndex,
    required this.questionOrderIndex,
    this.isCorrect,
    this.shortAnswer,
    this.trueFalseAnswer,
  });
}

class ChangeUserAnswer extends PracticeEvent {
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

class ResetCourseData extends PracticeEvent {}
